#!/bin/bash

ipAddress=$1

echo "Lets install the control node itself"

git clone https://github.com/epi-project/brane
cd brane

# Brane control stuff
echo "create brane control files"

branectl generate infra -f -p config/infra.yml workerNode:worker.nl
branectl generate proxy -f -p ./config/proxy.yml
branectl generate node -f -H control.nl:$ipAddress central control.nl

mkdir config/certs/workerNode

# Make the images for the control node
echo "make the necessary images"
make central-images PROFILE=release