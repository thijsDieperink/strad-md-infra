# Proxy VirtualBox setup

## Introduction
This readme gives an explanation about how to use a proxy in the brane framework. By default the framework uses the control proxy for outgoing communication and doesn't use the worker proxy at all. If you want to use a proxy properly, you can choose between three scenarios, an internal brane proxy service, an external brane proxy node or an external other proxy. All of these scenarios are described in more detail below. 

## Scenario 1: internal brane proxy
This is the simplest scenario. It uses the internal proxy service on both nodes for all communication. Implementing this is frankly very simple:
1. Install a brane instance using the README.md in the main folder. However, before you spin up the nodes, read the steps that follow.
2. Replace the following files in the nodes with the files from the */internal* folder:
    - Worker | *config/proxy.yml* for the *proxyWorker.yml* file
    - Worker | *docker-compose-worker.yml* for the *docker-compose-worker.yml* file in this folder
    - Control | *docker-compose-central.yml* for the *docker-compose-central.yml* file in this folder
    - Control | *config/proxy.yml* for the *proxyControl.yml* file
    - Control | *config/infra.yml* for the *infra.yml* file
  - Worker | In the *node.yml* file, replace the url of the api to that of the proxy 50054 port
  - Make sure all changed files have their original brane name (eg. *proxyControl.yml* = *proxy.yml*)
3. Start both VMs with the original command, however, now add `-f docker-compose-worker/central.yml`, so 'worker' for the worker node and 'central' for the  control node
4. Run a hello_world workflow and investigate if communication goes through the brane-prx-worker service by checking the logs, `docker logs brane-prx-worker`
5. This is off course a priliminary test and to make sure that all communication flows via the proxy services, access to the ports needs to prohibited.

### Testing on VirtualBox VMs
To properly test the above proxy-to-proxy setup in the VBox control-worker system, we are going to prohibit access to the ports on the VMs. The only ports that we will leave open, are the two ports (50054 and 50055) for the proxy service.

Follow the next steps for both VMs:
1. Add the following line between curly brackets in the /etc/docker/daemon.json file | `“iptables”: false`
2. Allow ip forwarding | `sudo sysctl -w net.ipv4.ip_forward=1`
3. Define iptable rules |
   - For these steps you can also run | `sh iptablesRules.sh` and don't forget to change your ip
   - `sudo iptables -t nat -A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE`
   - `sudo iptables -A FORWARD -i docker0 -o eth0 -j ACCEPT`
   - `sudo iptables -A FORWARD -i eth0 -o docker0 -m state --state RELATED,ESTABLISHED -j ACCEPT`
4. Define ufw firewall rules |
   - `sudo ufw enable`
   - `sudo ufw default deny incoming`
   - `sudo ufw default allow outgoing`
   - `sudo ufw allow 50054/tcp`
   - `sudo ufw allow 50055/tcp`
   - `sudo ufw default allow FORWARD`
   - `sudo ufw reload`
5. Restart docker | `sudo systemctl restart docker`
6. You can test if everything works:
   - From the control node | `nc -zv worker.nl 50055`, run this command also for 50054 and 50053
   - Do this also the other way around, from worker node to control.nl
   - If all works well, 50055 and 50054 should me able to successfully connect and 50053 will time out
   - Just to be sure, you can run this command for random other ports to test if these ports are closed as well
   - This will only yield the above explained results if a brane instance is running
7. Now we are ready to test the setup using a workflow. Run the *hello_world* workflow. If this works, congrats, you successfully installed a brane instance that communicates only via the proxy services
8. Ps: why is this all necessary? This is because docker overwrites ufw defined firewall rules. So you have to specifically say to docker that it shouldn't do that. But then you have to make sure forwarding happens from docker to the default network interface

## Scenario 2: external brane proxy
The second scenario contains a separate proxy from the brane framework, called a proxy node. In this case we have a proxy service on the control node (same as in the previous scenario) and a separate proxy node on a separate VM for the worker. So traffic that wants to reach the worker node should pass the proxy node. 
In this system, there are two types of communication. Communication that is for the proxy node and traffic that is for one of the other nodes. The proxy will forward the latter.

Below, steps are defined to implement this scenario.
1. Create proxy node
   - Create a separate VM and run the worker node dependencies according to the steps described in the README of the basicLocal folder
   - Change the *docker-compose-proxy.yml* file for the one in the */external* folder
   - Create a */config* folder and add the *proxy.yml* file from the */external* folder
   - Spin up the proxy with command `branectl start proxy -f docker-compose-proxy.yml`
   - Make sure the container starts properly
   - Create a hostmapping for the proxy node in the */etc/hosts* file (use hostname proxy.nl)
2. Adjust worker node:
   - Change the following in the *node.yml* file:
     - Add the proxy hostname mapping
     - Remove/uncomment the reference to the *proxy.yml* file
     - Change the proxy node service to "!external" instead of "!private"
     - Remove all lines from the old proxy and add the following address: "http://proxy.nl:50050"
       - In this "proxy.nl" is the hostname of the proxy node
       - 50050 is the default port for communication with the proxy
   - Remove/uncomment the proxy container from the *docker-compose-worker.yml* file
   - Add the proxy hostname mapping to the */etc/hosts* file
   - Make sure that the reg and job services are reachable and the proxy node is reachable from the worker node
3. Adjust control node
   - Change the following in the *node.yml* file:
     - Add the proxy hostname mapping
   - Change the addresses in the *config/infra.yml* file to:
     - `delegate: https://proxy.nl:50051`
     - `registry: https:proxy.nl:50052`
   - Add the proxy hostname mapping to the */etc/hosts* file
   - Make sure the proxy node is reachable from the control node
4. Run a workflow
   - Run a hello_world workflow in the regular way. If this works, then you have succesfully created a control-proxy-worker system and all traffic nog flows via the proxy node 

## Scenarion 3: external other proxy
TBA