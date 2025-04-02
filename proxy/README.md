# Proxy implementation

## Introduction
This readme gives an explanation about how to implement the proxy into the brane instance. By default the framework uses the control proxy for outgoing communication and doesn't use the worker proxy at all. If you want to use a proxy properly, you can choose between three scenarios, an internal brane proxy service, an external brane proxy node or an external other proxy. All of these scenarios are described below. 

## Scenario 1: internal brane proxy
This is the simplest scenario of the three. It uses the internal proxy service on both the nodes for all communication. Implementing this is frankly very simple:
1. Install a brane instance using the README.md in the main folder
2. Before you spin up the two nodes, replace the following files:
    - Worker | config/proxy.yml for the proxyWorker.yml file in this folder
    - Worker | docker-compose-worker.yml for the docker-compose-worker.yml file in this folder
    - Control | docker-compose-central.yml for the docker-compose-central.yml file in this folder
    - Control | config/proxy.yml for the proxyControl.yml file in this folder
    - Control | config/infra.yml for the infra.yml file in this folder
    - Worker | In the node.yml file, replace the url of the api to that of the proxy 50054 port
    - Make sure all changed files have their original brane name (eg. proxyControl.yml = proxy.yml)
3. Start both VMs with the original command, however, now add `-f docker-compose-worker/central.yml`, so 'worker' for the worker node and 'central' for the  control node
4. Run a hello_world workflow and investigate if communication goes through the brane-prx-worker service by checking the logs, `docker logs brane-prx-worker`
5. This is off course a priliminary test and to make sure that all communication flows via the proxy services, access to the ports need to be shut down

### Testing on VirtualBox VMs
To properly test the above proxy-to-proxy setup in the VBox control-worker system, we are going to shut down the ports of the VM. The only ports that we will leave open, are the two ports (50054 and 50055) for the proxy service.

Follow the next steps for both VMs:
1. Add the following line between curly brackets in the /etc/docker/daemon.json file | `“iptables”: false`
2. Allow ip forwarding | `sudo sysctl -w net.ipv4.ip_forward=1`
3. Define iptable rules |
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
7. Now we are ready to test the setup using a workflow. Run the *hello_world* workflow. If this works, congrats, you successfully installed a brane instance that communicates only via the proxy services
8. Ps: why is this all necessary? This is because docker overwrites ufw defined firewall rules. S0 you have to specifically say to docker that it shouldn't do that. But then you have to make sure forwarding happens from docker to the default network interface

## Scenario 2: external brane proxy
TBA

## Scenarion 3: external other proxy
TBA