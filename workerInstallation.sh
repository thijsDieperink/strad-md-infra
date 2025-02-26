#ipAddress=${1}

echo "Lets install the worker node itself"

# Install branectl 
echo "install branectl"
sudo curl -Lo /usr/local/bin/branectl https://github.com/epi-project/brane/releases/latest/download/branectl-linux-x86_64
sudo chmod +x /usr/local/bin/branectl
git clone https://github.com/epi-project/brane
sleep 5
cd brane

# Brane worker stuff
echo "create brane worker files"
branectl generate backend -f -p ./config/backend.yml local
branectl generate proxy -f -p ./config/proxy.yml
#secrets stuff
branectl generate policy_db -f -p ./policies.db
# add ip address
#branectl generate node -f -H worker.nl:{ipAddress} worker worker.nl workerNode

#echo "create certificate"

# Make the images for the worker
echo "make the necessary images"
#make central-images PROFILE=release