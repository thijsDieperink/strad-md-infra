ipAddress=$1

echo "Lets install the worker node itself"

# Install branectl 
echo "install branectl"
#sudo curl -Lo /usr/local/bin/branectl https://github.com/epi-project/brane/releases/latest/download/branectl-linux-x86_64
#sudo chmod +x /usr/local/bin/branectl
git clone https://github.com/epi-project/brane
cd brane
#make brane-ctl PROFILE=release
#sudo mv targets/release/branectl /usr/local/bin/branectl
#sudo chmod +x /usr/local/bin/branectl

# Brane worker stuff
echo "create brane worker files"
branectl generate backend -f -p ./config/backend.yml local
branectl generate proxy -f -p ./config/proxy.yml
branectl generate policy_secret -f -p ./config/policy_deliberation_secret.json
branectl generate policy_secret -f -p ./config/policy_expert_secret.json
branectl generate policy_db -f -p ./policies.db
branectl generate node -f -H worker.nl:$ipAddress worker worker.nl workerNode

# Generate certificate
echo "create certificate"
mkdir config/certs
cd config/certs
branectl generate certs client workerNode -H worker.nl -f -p ./client-certs

# Make the images for the worker
echo "make the necessary images"
make central-images PROFILE=release