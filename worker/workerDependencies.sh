#!/bin/bash

echo "Installing dependencies for this node"
sudo apt update -y
sudo apt install -y gcc g++ cmake pkg-config curl wget
sudo snap install go --classic
sudo apt install -y openssl libssl-dev
wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo apt install -y sqlite3 libsqlite3-dev
sudo apt install -y python3
#curl --proto ‘=https’ --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#. ”$HOME/.cargo/env”

echo "Installing docker"
sudo aptget update 
sudo apt-get -y ca-certificates
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -0 /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
$ARCH=$(dpkg --print-architecture)
$UBUNTU_CODENAME=$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
$REPO_ENTRY="deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable"
echo "$REPO_ENTRY" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Activation docker"
sudo systemctl enable docker --now
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock

echo "Installing and creating buildx"
docker buildx install
sudo docker buildx create --use

# Install branectl
echo "install branectl"
git clone https://github.com/epi-project/brane
cd brane
make brane-ctl PROFILE=release
sudo cp target/release/branectl /usr/local/bin/branectl
sudo chmod +x /usr/local/bin/branectl