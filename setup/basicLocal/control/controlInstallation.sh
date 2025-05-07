#!/bin/bash

echo "Lets install the control node itself"

# Brane control stuff
echo "--------------Create brane control files--------------"

branectl generate infra -f -p config/infra.yml branelocal:localhost
branectl generate proxy -f -p ./config/proxy.yml
branectl generate node -f -H localhost:127.0.0.1 central localhost

# Make the images for the control node
echo "--------------Make the necessary control images--------------"
make central-images PROFILE=release

# Copy certificate from worker
mkdir config/certs/workerlocal
cd ..
cp worker/config/certs/ca.pem control/config/certs/workerlocal

# Create hello world folder
cd ..
cp -r tutorials/hello_world localInstance/control
