#!/bin/bash

ipAddressWorker=$1
ipAddressControl=$2

# Run workerDependencies
sh worker/workerDependencies.sh

# Run workerInstallation
sh worker/workerInstallation.sh $ipAddressWorker

# Run last configurations
sh lastConfig.sh $ipAddressWorker $ipAddressControl