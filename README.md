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
    - Go to the settings of the VM and then to ‘Network’
    - Create two new adapters, one with’ NAT’ attached and one with ‘NAT Network’  where to create a new NAT network?
    - Now start the VM and wait for the setup to complete
3.	Setup the worker node VM
    - Follow the exact same steps as in step 2. The only thing you need to change, in this document I will refer to this VM as [workerVM]
4.	Testing setup
    - Now you created two VMs, it is time to test the connection. So, start both VMs
    - Install curl:
      - Run <sudo apt update>
      - Run <sudo apt install iputils-ping -y>
    - Check IP address [ipAddress] of [controlVM]: 
      - Run <ip addr show>
      - Find the IP under enp0s3 (or something similar) 
      - Probably something like 10.0.2.15
    - Go to the other VM and run <ping -c 5 [ipAddress]>
    - Do this the other way around as well
    - If there is no package loss in both tests, it worked and the VMs can successfully communicate with each other
    - Your base environment is ready. Congrats!


## Preparing the worker node
Stuff

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