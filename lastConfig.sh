ipAddressWorker=$1
ipAddressControl=$2

# Add hostname mappings
echo "worker.nl $ipAddressWorker\ncontrol.nl $ipAddressControl" > test.txt