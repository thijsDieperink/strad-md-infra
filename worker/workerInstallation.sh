#!/bin/bash

ipAddress=$1

echo "Lets install the worker node itself"

git clone https://github.com/epi-project/brane
cd brane

# Brane worker stuff
echo "--------------Create brane worker files--------------"
branectl generate backend -f -p ./config/backend.yml local
branectl generate proxy -f -p ./config/proxy.yml
branectl generate policy_secret -f -p ./config/policy_deliberation_secret.json
branectl generate policy_secret -f -p ./config/policy_expert_secret.json
branectl generate policy_db -f -p ./policies.db
branectl generate node -f -H worker.nl:$ipAddress worker worker.nl worker

# Generate certificate
echo "--------------Create certificate--------------"
branectl generate certs server worker -H $ipAddress -f -p config/certs
cd config/certs
branectl generate certs client worker -H worker.nl -f -p ./client-certs

cd ..
cd ..
# Make the images for the worker
echo "--------------Make the necessary worker images--------------"
make worker-images PROFILE=release