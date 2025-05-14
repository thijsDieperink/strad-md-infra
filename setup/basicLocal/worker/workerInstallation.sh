#!/bin/bash

echo "Lets start the installation of the worker node"

# Brane worker stuff
echo "--------------Create brane worker files--------------"
branectl generate backend -f -p ./config/backend.yml local
branectl generate proxy -f -p ./config/proxy.yml
branectl generate policy_secret -f -p ./config/policy_deliberation_secret.json
branectl generate policy_secret -f -p ./config/policy_expert_secret.json
branectl generate policy_db -f -p ./policies.db
branectl generate node -f -H localhost:127.0.0.1 worker localhost worker

# Generate certificate
echo "--------------Create certificate--------------"
branectl generate certs -f -p ./config/certs server worker -H host.docker.internal

# Make the images for the worker
echo "--------------Make the necessary worker images--------------"
make worker-images PROFILE=release