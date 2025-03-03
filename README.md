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
    - Add the following to the end of the file: `$yourUsername ALL=(ALL) NOPASSWD:/path/to/myScript.sh`
    - Change *yourUsername* with the username you defined for the VM
    - Change */path/to/myScript.sh* to the path of the workerDependencies.sh script
5.	One dependency that I didn’t automate yet is rust, so install this manually: 
    - `curl –proto ‘=https’ –tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y`
    - `. “$HOME/.cargo/env”`
6.	Now install the worker dependencies: `sh workerDependencies.sh [ipAddressWorker]`
7.	Test docker | `docker run hello-world`
8.	If this and the workerDependencies.sh file runs without errors, you have properly installed all the necessary dependencies


## Preparing the control node
Stuff

## Last preparation, starting the nodes and testing
Stuff

## Starting with packages
Stuff

## Starting with packages
Stuff

## Starting with workflows
Stuff

## More advanced workflows
Stuff

## References
Stuff

## Contributing
Stuff

## Questions
For question, one of the developers.