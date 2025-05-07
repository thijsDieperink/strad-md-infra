# Basic VirtualBox setup

## Introduction
TBA

## Implementation
TBA

### Setting up the environment
1.	Download VirtualBox
    - Go to https://www.virtualbox.org/wiki/Downloads and download VirtualBox for your specific OS
    - Open the VirtualBox app
2.	Setup the control node VM:
    - Download the ubuntu ISO image from https://ubuntu.com/download/desktop
      - Check the installed file, it should end with amd64 for macOS intel
      - You have the option to choose the live-server and desktop image. The first is more lightweight, uses less disk space, but doesn’t include a GUI and only pre-installs the necessary things to run
    - Go to VirtualBox and click the “New” button
    - Create a new ubuntu VM:
      - Define the name of your VM, in this document I will refer to this VM as [controlVM]
      - Search for and add the ISO images you just downloaded
      - Make sure the type and version are Linux and Ubuntu (64)
      - Under ‘Unattended Install’, add a user with password
      - Under ‘Hardware’, define the amount of memory and number of CPUs you want your VM to use
      - Under ‘Hard Disk’, define the amount of disk space you want to allocate to the VM
      - Finalise the VM creation
    - This will automatically start the VM, but stop it first (not only quit with saved state), there is something else to do first
    - Create a new NAT Network:
      - Go to "file", "tools" and Network Manager". Open the "NAT Networks" pane and click on "Create"
      - Define a name for your network, this is from now on [natNetwork]
      - Change the IPv4 Prefix to 192.168.56.0/24
      - Make sure that the "enable DHCP" box is active
    - Go to the settings of the VM and then to ‘Network’
    - Create two new adapters, one with ’NAT’ attached and one with ‘NAT Network’, attaching your newly created [natNetwork] and applying "Allow All" for the "Premiscuous mode"
    - Now start the VM and wait for the setup to complete
3.	Setup the worker node VM
    - Follow the exact same steps as in step 2. The only thing you need to change is the name, in this document I will refer to this VM as [workerVM]
4.	Testing setup
    - Now you created two VMs, it is time to test the connection. So, start both VMs
    - Install curl:
      - Run | `sudo apt update`
      - Run | `sudo apt install iputils-ping -y`
    - Check IP address [ipAddressControl] of [controlVM]: 
      - Run `ip a`
      - Find the IP under enp0s8 
      - Probably something like 192.168.56.5
      - This is now your [ipAddressControl]
    - Check IP address [ipAddressWorker] of the [workerVM]. Follow the same steps as above.
    - Test connection by running `ping -c 5 [ipAddressControl]` on the [workerVM] and `ping -c 5 [ipAddressWorker]` on the [controlVM]
    - If there is no packet loss in both tests, it worked and the VMs can successfully communicate with each other
    - Your base environment is ready. Congrats!

### Preparing the worker node
1.	Before we can work with the brane framework, we need to install some dependencies. First open the [workerVM]
2.  Remember that the fiels and commands you are going to run, require sudo. So, you will be prompted to supply your VMs password
3.	To install all necessary components, we are going to use some sh files which I prepared.
4.	So, let’s download the code: `git clone https://github.com/thijsDieperink/strad-md-infra` and `cd strad-md-infra`
5.  One dependency that I didn’t automate yet is rust, so install this manually: 
    - Run | `curl –proto ‘=https’ –tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y`
    - Run | `. “$HOME/.cargo/env”`
6.  Now, install the worker dependencies: `sh worker/workerDependencies.sh`
7.  Also, the docker installation is not complete:
    - Go to the strad-md-folder
    - Run | `cat containerdConfig.json > sudo /etc/docker/daemon.json`
    - Run | `sudo systemctl restart docker`
8.	Test docker | `docker run hello-world`
9.	If this and the *workerDependencies.sh* file runs without errors, you have properly installed all the necessary dependencies
10. Now we are going to install the framework related dependencies
11. We are going to do this by running the *workerInstallation.sh* file, this file creates some brane specific configuration files, certifications and downloads the necessary images
12.	Run installation | `sh worker/workerInstallation.sh [ipAddressWorker]`. Don't forget to add the worker's IP
13.	If this runs without errors, you successfully created your worker node

### Preparing the control node
1.  Before we can work with the brane framework, we need to install some dependencies. First open the [controlVM]
2.  Remember that the fiels and commands you are going to run, require sudo. So, you will be prompted to supply your VMs password
3.	To install all necessary components, we are going to use some sh files which I prepared.
4.	So, let’s download this code: `git clone https://github.com/thijsDieperink/strad-md-infra`
5.  One dependency that I didn’t automate yet is rust, so install this manually: 
    - `curl –proto ‘=https’ –tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y`
    - `. “$HOME/.cargo/env”`
6.  Now, install the control dependencies: `sh control/controlDependencies.sh`
7.	Also, the docker installation is not complete:
    - Go to the strad-md-folder
    - Run | `cat containerdConfig.json | sudo tee /etc/docker/daemon.json`
    - Run | `sudo systemctl restart docker`
8.  Test docker | `docker run hello-world`
9.	If this and the *controlDependencies.sh* file runs without errors, you have properly installed all the necessary dependencies
10. Now we are going to install the framework related dependencies
11. We are going to do this by running the *controlInstallation.sh* file, this file creates some brane specific configuration files, certifications and downloads the necessary images
12.	Run installation | `sh control/controlInstallation.sh [ipAddressControl]`. Don't forget to add the control's IP
13.	If this runs without errors, you can continue with the next step
14. Let's add the worker node's certificate to the control node:
    - We are going to use the secure copy paste (scp) command. You can find more info in the references
    - Go to the control node
    - Make sure you are in the */strad-md-infra/brane* folder
    - Make a folder | `mkdir config/certs/worker`
    - Move to the new folder | `cd config/certs/worker`
    - Now go to the worker node and make sure you are again in the */strad-md-infra/brane* folder
    - Run the scp command | `scp ./config/certs/ca.pem [username]@[hostnameControl]:/[path/to/config/certs/worker]`
      - Example | `scp ./config/certs/ca.pem mdieperi@control.nl:/home/mdieperi/strad-md-infra/brane/config/certs/worker`
      - This will not use ssh keys, but will go over the ssh channel and will ask for the password of the user on the control node
    - Go back to the control node and make sure that the ca.pem file is available in the */certs/client-certs/worker* folder

### Last preparation, starting the nodes and testing
1.	Create hostmapping on VMs:
    - Run | `sh lastConfig.sh [ipAddressWorker] [ipAddressControl]`
2.	Define hostname mappings in node.yml files
    - Do the following on both VMs
    - Open the node.yml file
    - Add the hostname mappings of the control and worker node in the node.yml of both nodes
      - worker.nl: ‘[ipAddressWorker]’
      - control.nl: ‘[ipAddressControl]’ 
3.	Add a usecase in the worker node.yml:
    - Open the node.yml on the [workerVM]
    - Add the mapping of the control node api under the usecases option:
        `central:`
          `Api: http://control.nl:50051`
4.  The last thing we need to do, is fix the docker installation. For some reason the nodes won't start without removing a docker specific file. For now, we will just do this, but I am working on another solution. So, run | `sudo rm -rf /etc/docker/daemon.json` and `sudo systemctl restart docker`
5.	Now you are ready to start the nodes:
    - On the worker VM, go tho the */strad-md-infra/brane* folder and run | `branectl start worker`
    - On the control VM, go tho the */strad-md-infra/brane* folder and run | `branectl start central`
6.  To make sure the checker service allows the workflow, we have to create a policy. For now we will create a policy that allows all workflows:
    - It is not necessary to understand the configuration of the policy file. For now it is important that it works
    - Open the [workerVM] and make sure you are located in the */strad-md-infra* folder
    - The tautology.json file is the policy definition and will be uploaded to the framework
    - Move tautology file | `mv tautology.json /brane`
    - Go to the brane folder | `cd brane`
    - Upload the policy | `branectl policies add ./tautology.json`
    - Activate the policy | `branectl policies list` and activate version 1
    - If you get a confirmation message, congrats, you created and activated your first policy
7.	Let's do some testing to make sure everything works properly:
    - Do the following on both VMs
    - Are the containers running | `docker ps`
      - On the worker node, four containers are important, *brane-reg-worker*, *brane-job-worker*, *brane-chk-worker* and *brane-prx-worker*
      - On the control node, four containers are important, *brane-drv*, *brane-api*, *brane-plr* and *brane-prx*
      - If a container is not running properly, run | `docker logs [nameContainer]` to view the logs
    - Ports open:
      - Update apt | `apt update`
      - Install netcat | `apt install netcat-traditional`
      - Run | `nc -zv [hostname] 50053`. Hostname in this command, is the hostname (e.g control.nl) from the other VM
        - If this gives a message "succeeded!", then all is well. If not, nothing is listening on that port and you should check the containers on the other VM
      - Run the previous command also for the ports 50051 and 50052 from the worker node and 50051 and 50053 from the control node
8.	If you do not encounter any errors while testing, you are ready to start working with the framework. Pfff finally, but also Whoepie!!

### Some last sort of good things to know
1. Stop an instance:
   - A brane instance is a combination of a worker and control node
   - When you finish working with brane, make sure to shut down the brane instance and the VM properly
   - Shut down brane instance from the */strad-md-infra/brane* folder | `branectl stop`
   - Shut down the VM by running `exit` and closing the window
2. Docker activation at startup:
   - When you start working with brane and open the VMs, you have to activate docker properly:
   - Activate docker | `sudo systemctl start docker`
   - Give proper permissions | `sudo chmod 666 /var/run/docker.socket`
   - Run | `docker ps` or `docker run hello-world` to test if this worked
