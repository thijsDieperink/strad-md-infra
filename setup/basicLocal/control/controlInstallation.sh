#!/bin/bash

echo "Lets install the control node itself"

# Brane control stuff
echo "--------------Create brane control files--------------"

branectl generate infra -f -p config/infra.yml worker:localhost
branectl generate proxy -f -p ./config/proxy.yml
branectl generate node -f -H localhost:127.0.0.1 central localhost

# Copy certificate from worker
mkdir config/certs/worker
cd ..
cp worker/config/certs/ca.pem control/config/certs/worker

# Copy hello world folder
cd ..
cp -r tutorials/hello_world localInstance/control
cd localInstance/control

# Make the images for the control node
echo "--------------Make the necessary control images--------------"
make central-images PROFILE=release

