# Proxy Self setup

## Introduction
Because the support for the brane proxy will stop somewhere in 2025, I've reverse enginered the brane proxy and wrote a new one using nginx and python fastapi. This readme gives a description of this proxy and explains how to use it in a brane instance.

## Funtionalities
There are two main parts that I want to descripe here, the https pass through and the dynamical route creation.
1. Https pass through:
   - The initial communication from the control node to the worker node is https
   - Two services on the nodes negotiate a tls session that gets terminated at the worker node
   - This means that the proxy should only pass through the https traffic
   - Because fastapi is a tls terminator and only can pass through plain http, I used nginx for this part of the logic 
2. Dynamical route creation:
   - The first communication from the worker to the control node happens via the fastapi part of the proxy
   - For this, a path 'outgoing/new' exist which the worker node can call
   - Upon calling, the proxy opens a new port, creates a route from the worker to the control node over this proxy port and returns the allocated proxy port to the worker node
   - The worker will now use this port and after the communication comlpetes, the proxy removes this route and closes the port
   - In this way, the communication from worker to control node is dynamically created when necessary and shut down when not in use. Improving security massively

## Implementation
To use this proxy in a brane instance, follow the following steps:
1. Create initial worker and control node
2. Create a proxy node:
   - Create a separate VM and run the worker node dependencies according to the steps described in the README of the basicLocal folder
   - Create a hostmapping for the proxy node in the */etc/hosts* file (use hostname proxy.nl)
   - Clone this repo | `git clone https://github.com/thijsDieperink/strad-md-infra`
   - Move to this folder | `cd strad-md-infra/setup/proxySelf`
   - Spin up the proxy | `docker compose up -d --build`
     - the `-d` flag allows docker to run in the background
     - the `--build` flag allows you to easily build after changes
   - Test if the proxy is available | `nc -zv proxy.nl 8080`
   - If this test is successful, then congrats, the proxy is running
3. Adjust worker node:
   - Change the following in the *node.yml* file:
     - Add the proxy hostname mapping
     - Remove/uncomment the reference to the *proxy.yml* file
     - Change the proxy node service to "!external" instead of "!private"
     - Remove all lines from the old proxy and add the following address: "http://proxy.nl:8080"
       - In this "proxy.nl" is the hostname of the proxy node
       - 8080 is the default port for communication with the proxy
   - Remove/uncomment the proxy container from the *docker-compose-worker.yml* file
   - Add the proxy hostname mapping to the */etc/hosts* file (use proxy.nl)
   - Make sure that the reg and job services are reachable and the proxy node is reachable from the worker node
4. Adjust control node:
   - Change the following in the *node.yml* file:
     - Add the proxy hostname mapping
   - Change the addresses in the *config/infra.yml* file to:
     - `delegate: https://proxy.nl:50051`
     - `registry: https:proxy.nl:50052`
   - Add the proxy hostname mapping to the */etc/hosts* file (use proxy.nl)
   - Make sure the proxy node is reachable from the control node
5. Run a workflow:
   - Run a hello_world workflow in the regular way. If this works, then you have succesfully created a control-proxy-worker system and all traffic nog flows via the proxy node 
