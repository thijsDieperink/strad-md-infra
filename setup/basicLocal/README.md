# Basic Local setup --> **not finished**

## Introduction
In this readme the implementation of the most basic setup will be explained. That is, a brane instance located on a laptop's host system with one worker and one control node. The "Implementation" section describes, in four steps, how to create this system for Mac (M & intel CPUs), Ubuntu and Windows (inder construction). Inclusion of other Linux-distributions will follow later. If you have a non-Ubuntu Linux distribution, check the dependencies.sh file in the folder to see which packages need to be installed.

## Implementation
Because both nodes will be created on the same machine, they will have the same hostname and ip address. This means that the local setup is slightly different than a real life brane instance, but the goal of this folder, is to allow for a more simple and faster-to-implement setup. 

### Setting up the environment
First we are going to create the environment in which we are going to work. Because I created an automation script, this will be very simple

1. Open a terminal/command prompt and go to the folder in which you would like to work
2. Download this repo's code | `git clone https://gitlab.op.umcutrecht.nl/PsyData/strad/strad-md-infra.git`
3. One dependency that I didn’t automate yet is rust, so install this manually: 
    - MacOS/Ubuntu| 
      - Run | `curl –proto ‘=https’ –tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y`
      - Run | `. “$HOME/.cargo/env”`
    - Windows | **TBA**
4. Installing dependencies:
   - ***Warning***: *running the following script will install docker. Because this is a relatively intensive applicaation you can skip its installation by providing the argument 'no' when running the command below. But keep in mind that docker is necessary for brane, so if you pass 'no', you should still install docker yourself*
   - Move to the *'strad-md-infra'* folder
   - MacOS/Ubuntu | `sh setup/basicLocal/dependencies.sh yes`
   - Windows | **TBA**
5. Now we have two folders that are exactly the same, but one is called *'worker'* and the other *'control'*. If you investigate the folder, there are a lot of files. Some of these are unnecessary and will not be used, however, for now we will leave them be
6. Besides these two folders, several dependencies are installed (if not already available), such as rust, go, possibly docker and some brane related binaries 
7. Test the installation:
   - MacOS/Ubuntu | `branectl --help`, `brane --help` and `branelet --help`
   - Windows | **TBA**
 - If this test worked properly, congrats, you are ready to implement your brane system

### Setting up the worker node
To implement the worker node, we are going to use a script that will automate the process
1. Move to the *'worker'* folder
2. Run the installation script:
   - MaxOS/Ubuntu | `sh workerInstallation.sh`
   - Windows | **TBA**
3. This script installs some brane related configuration files and images
4. Before we can start up the worker node, we need to modify some things:
   - Open the node.yml file and change the 'usecases: {}' line for the following block of code:
    `usecases:
       central:
         api: http://host.docker.internal:50055`
5. Now start up the worker:
   - MacOS/Ubuntu | `branectl start worker`
   - Windows | **TBA**
6. Make sure everything works by running | `docker ps` and check if all four containers (brane-job, brane-reg, brane-chk and brane-prx) are running

### Setting up the control node
To implement the control node, we are going to use a script that will automate the process
1. Move to the *'control'* folder
2. Run the installation script:
   - MacOS/Ubuntu | `sh controlInstallation.sh`
   - Windows | **TBA**
3. This script installs some brane related configuration files and images
4. Before we can start up the control node, we need to modify some things:
   - In the infra.yml file:
     - Change the delegate address to `http://host.docker.internal:50052`
     - Change the registry address to `https://host.docker.internal:50051`
   - In the node.yml file, change the ports for the services:
     - prx = 50054
     - api = 50055
     - drv = 50056
     - plr = 50057
     - Make sure all references to these ports are changed
5. Now start up the control node:
   - MacOS/Ubuntu | `branectl start control -f docker-compose-central.yml`
   - Windos | **TBA**
6. Make sure everything works by running | `docker ps` and check if all four containers (brane-drv, brane-api, brane-plr and brane-prx) are running
7. If you want to stop the instance:
   - MacOS/Ubuntu |
     - worker | `branectl stop`
     - control | `branectl stop -f docker-compose-central.yml`
   - Windows | **TBA**

### Testing setup --> **Windows TBA**
1. If all containers are running properly, you can test your local setup by running a hello_world workflow
2. Go to the control node folder and move to the *'hello_world'* folder
3. Define instance:
   - Add instance | `brane instance add http://localhost --name localInstance --api-port 50055`
   - Select instance | `brane instance select localInstance`
4. Build the package | `brane package build ./container.yml`
5. Test package | `brane package test hello_world`
6. Push package | `brane package push hello_world`
7. Run workflow | `brane workflow http://localhost ./workflow.bs --remote`
8. Congrats, you just ran your first workflow in your newly created local setup
9. This hello_world test was purely for making sure the setup works. If your goal is to dive deeper in the ML side of brane, then I suggest to go to the 'tutorials' folder of this repository
10. Here you can create your own hello_world code and investigate more complicated code examples
11. If you are intested in the brane infrastructural setup. You can move to a more complicated scenario. A detailed description of this is provided in the folder 'basicVBox' 