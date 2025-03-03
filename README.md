# strad-md-infra

## Introduction
Stuff

## Setting up the environment
1.	Download VirtualBox
    - Go to https://www.virtualbox.org/wiki/Downloads and download VirtualBox for your specific OS
    - Open the VirtualBox app
2.	Setup the control node VM:
    - Download the ubuntu ISO image from https://ubuntu.com/download/desktop
      - Check the installed file, it should end with amd64 for macOS intel
      - You have the option to choose the live-server and desktop image. The first is more lightweight, uses less disk space, but doesn’t include a GUI
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
    - Check IP address of [controlVM]: 
      - Run `ip a`
      - Find the IP under enp0s8 
      - Probably something like 192.168.56.5
      - This is now your [ipAddressControl]
    - Check IP address [ipAddressWorker] of the [workerVM]
      - Run `ip a`
      - Find the IP under enp0s8 
      - Probably something like 192.168.56.5
      - This is now your [ipAddressWorker]
    - Go to both VMs and run `ping -c 5 [ipAddressControl]` on the [workerVM] and `ping -c 5 [ipAddressWorker]` on the [controlVM]
    - Do this the other way around as well
    - If there is no package loss in both tests, it worked and the VMs can successfully communicate with each other
    - Your base environment is ready. Congrats!

## Preparing the worker node
1.	Before we can work with the brane framework, we need to install some dependencies. First open the [workerVM]
2.	To do this, we are going to use a sh file which I prepared that installs all the dependencies
3.	So, let’s download this code: `git clone https://github.com/thijsDieperink/strad-md-infra`
4.	Before you can run the files, you need your VM to allow this file to run sudo commands:
    - Run | `sudo vim /etc/sudoers`
    - Add the following line three times to the end of the file: `$yourUsername ALL=(ALL) NOPASSWD:/path/to/myScript.sh`
    - Change *yourUsername* with the username you defined for the VM
    - Change */path/to/myScript.sh* to the path of the *workerDependencies.sh* for the first line and *workerInstallation.sh* for the second line and *lastConfig.sh* for the third line
5.	One dependency that I didn’t automate yet is rust, so install this manually: 
    - Run | `curl –proto ‘=https’ –tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y`
    - Run | `. “$HOME/.cargo/env”`
6.  Also, the docker installation is not complete:
    - Go to the strad-md-folder
    - Run | `cat containerdConfig.json > sudo /etc/docker/daemon.json`
    - Run | `sudo systemctl restart docker`
7.	Now install the worker dependencies: `sh workerDependencies.sh [ipAddressWorker]`
8.	Test docker | `docker run hello-world`
9.	If this and the *workerDependencies.sh* file runs without errors, you have properly installed all the necessary dependencies
10. Now we are going to install the framework related dependencies
11. We are going to do this by running the *workerInstallation.sh* file, this file creates some brane specific configuration files, certifications and downloads the necessary images
12.	Run installation | `sh workerInstallation.sh`
13.	If this runs without errors, you successfully created your worker node

## Preparing the control node
1. Before we can work with the brane framework, we need to install some dependencies. First open the [controlVM]
2.	To do this, we are going to use a sh file which I prepared that installs all the dependencies
3.	So, let’s download this code: `git clone https://github.com/thijsDieperink/strad-md-infra`
4.	Before you can run the files, you need your VM to allow these files to run sudo commands:
    - Run | `sudo vim /etc/sudoers`
    - Add the following line three times to the end of the file: `$yourUsername ALL=(ALL) NOPASSWD:/path/to/myScript.sh`
    - Change *yourUsername* with the username you defined for the VM
    - Change */path/to/myScript.sh* to the path of the *controlDependencies.sh* for the first line, *controlInstallation.sh* for the second line and *lastConfig.sh* for the third line
5.	One dependency that I didn’t automate yet is rust, so install this manually: 
    - `curl –proto ‘=https’ –tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y`
    - `. “$HOME/.cargo/env”`
6.	Also, the docker installation is not complete:
    - Go to the strad-md-folder
    - Run | `cat containerdConfig.json > sudo /etc/docker/daemon.json`
    - Run | `sudo systemctl restart docker`
7.  Now install the control dependencies: `sh controlDependencies.sh`
8.  Test docker | `docker run hello-world`
9.	If this and the *controlDependencies.sh* file runs without errors, you have properly installed all the necessary depen1.dencies
10. Now we are going to install the framework related dependencies
11. We are going to do this by running the *controlInstallation.sh* file, this file creates some brane specific configuration files, certifications and downloads the necessary images
12.	Run installation | `sh controlInstallation.sh [ipAddressControl]`
13.	If this runs without errors, you can continue with the next step
14. Let's add the worker node's certificate to the control node:
    - We are going to use scp for this .......
    - Go to the control node
    - Make sure you are in the /strad-md-infra/brane folder
    - Make a folder | `mkdir config/certs/ubuntu`
    - Run | `cd config/certs/ubuntu`
    - Now go to the worker node
    - Run the scp command | `scp ./config/certs/ca.pem [username]@[hostnameControl>:/[path/to/config/certs/workerName]`
      - Example | `scp ./config/certs/ca.pem mdieperi@control.nl:/home/mdieperi/brane/config/certs/workerNode`
      - This will not use ssh keys, but will ask for the password of the user on the control node

## Last preparation, starting the nodes and testing
1.	Create hostmapping on VMs:
    - Run | `sh lastConfig.sh [ipAddressWorker] [ipAddressControl]`
2.	Define use-cases in node.yml files
    - Do the following on both VMs
    - Open the node.yml file
    - Add the hostname mappings of the control and worker node in the node.yml of both nodes
      - worker.nl: ‘[ipAddressWorker]’
      - control.nl: ‘[ipAddressControl]’ 
3.	Add a usecase in the worker node.yml:
    - Open the node.yml on the [workerVM]
    - Add the mapping of the control node api under the usecases option:
      - `Api: http://control.nl:50051`
4.	Now you are ready to start the nodes:
    - On the worker VM, run | `branectl start worker`
    - On the control VM, run | `branectl start central`
5.	Testing:
    - Are the containers running | `docker ps`
      - If they are not running properly | `docker logs [nameContainer]`
    - Ports:
      - Run | `apt update`
      - Run | `apt install netcat-traditional`
      - Run | `nc -zv [ipAddress] 50053`
      - Run the previous command also for the ports 50051 and 50052
      - Do the above steps also on the other VM
6.	If you do not encounter any errors while testing, you are ready to start working with the framework

## Starting with packages
1.	Before we can do anything with packages, we need to define a brane instance
    - Go to the control node and type `brane instance add control.nl –name demoInstance`
    - Then `brane instance list` to show if your instance is properly created
    - Select instance to work with | `brane instance select demoInstance`
2.	To give a feeling on how to work with packages, we will create the most basic package there is. Let’s make a hello world package:
    - It is a good practice to read carefully through the brane documentation regarding the ‘hello world’ package
    - It gives information how to write this package and use it locally and remotely
    - Use your newly created instance ‘demoInstance’ for this new package
3.	If this all works fine, then you are ready to run your first workflow, lets continue in the next section

## Starting with workflows
1.	In the previous section you already created, tested and ran your package remotely in the ‘repl’ mode. Now we are going to run this using a workflow
2.	Creating the Branescript file:
    - In the hello_world folder of your package, create a new file called ‘workflow.bs’
    - Add the following code:
        Import hello_world;
        #[on(“workerNode”)]
        {
            Println(hello_world())
        }
    - Don’t forget the proper indentation
    - The workerNode is the name of the worker node
3.	Running the workflow | `brane workflow run ./workflow.bs --remote`
4.	If a ‘Hello World!’ message is printed to the terminal, congrats, you ran your first workflow!

## More advanced workflows
1. Average workflow
    - For this example we are going to write a workflow that calculates an average from a list of numbers.
    - First we will create the datafile:
      - Go to the strad-md-infra folder
      - Run | `cp braneFiles/packages/average/data brane/average`
      - Build the data | `brane data build`
      - Push data to instance | <>
      - Check if the data is available on the instance | <>
    - Secondly, we will create and push a new package:
      - Create a new folder | `mkdir average`
      - Go into the folder | `cd average`
      - Create package files:
        - Go to the strad-md-infra folder
        - Run | `cp braneFiles/packages/average/average.py brane/average`
        - Run | `cp braneFilees/package/average/container.yml brane/average`
        - Go back to the average folder in the brane repo
        - Build package | `brane package build`
        - Test package locally | `brane package test`
        - Push package to instance | `brane package push`
        - Check if package is available on the instance | `brane package search`
      - Lastly, we will create and run the workflow:
        - Go to the strad-md-infra folder
        - Run | `cp braneFiles/packages/average/workflow.pbs brane/average`
      - Something important to note: this is only data from control node
2. Data from worker node
    - Until now, we only used data generated in the control node. In this example, we will do exactly the same as the previous example, but now we are going to use data from the worker node
3. Intermediate data
    - In this example we are going to investigate the concept of intermediate results
4. Basic ML process
5. More advanced ML process

## References
Stuff

## Contributing
Stuff

## Questions
For question, one of the developers.