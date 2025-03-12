#!/bin/bash

ipAddressWorker=$1
ipAddressControl=$2

# Add hostname mappings
echo "$ipAddressWorker worker.nl\n$ipAddressControl control.nl" | sudo tee /etc/hosts