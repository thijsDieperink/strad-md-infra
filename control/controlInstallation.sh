#!/bin/bash

ipAddress=$1

echo "Lets install the control node itself"
cd brane

# Brane control stuff
echo "--------------Create brane control files--------------"

branectl generate infra -f -p config/infra.yml worker:worker.nl
branectl generate proxy -f -p ./config/proxy.yml
branectl generate node -f -H control.nl:$ipAddress central control.nl

mkdir config/certs/workerNode

# Make the images for the control node
echo "--------------Make the necessary control images--------------"
make central-images PROFILE=release