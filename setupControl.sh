#!/bin/bash

ipAddressWorker=$1
ipAddressControl=$2

# Run controlDependencies
sh control/controlDependencies.sh

# Run controlInstallation
sh control/controlInstallation.sh $ipAddressControl

# Run last configurations
sh lastConfig.sh $ipAddressWorker $ipAddressControl