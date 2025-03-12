#!/bin/bash

echo "Let's start the installation of all dependencies"

# General installations
echo "--------------Installing general dependencies--------------"
sudo apt update -y
sudo apt install -y gcc g++ cmake pkg-config curl wget openssh-server
sudo snap install go --classic
sudo apt install -y openssl libssl-dev
wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo apt install -y sqlite3 libsqlite3-dev
sudo apt install -y python3
sudo systemctl enable --now ssh

# Docker installation
echo "--------------Installing docker--------------"
sudo apt-get update 
sudo apt-get install -y ca-certificates
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
ARCH=$(dpkg --print-architecture)
UBUNTU_CODENAME=$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
REPO_ENTRY="deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable"
echo "$REPO_ENTRY" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "--------------Activating docker--------------"
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock

echo "--------------Installing and creating buildx--------------"
docker buildx install
sudo docker buildx create --use

# Branectl installation
echo "--------------Installing branectl--------------"
git clone https://github.com/epi-project/brane
cd brane
make brane-ctl PROFILE=release
sudo mv target/release/branectl /usr/local/bin/branectl
sudo chmod +x /usr/local/bin/branectl

# Branecli installation
echo "--------------Installing branecli--------------"
make brane-cli PROFILE=release
sudo mv target/release/brane /usr/local/bin/brane
sudo chmod +x /usr/local/bin/brane

# Branelet installation
echo "--------------Installing branelet--------------"
curl -L -o /usr/local/bin/branelet https://github.com/BraneFramework/brane/releases/download/v3.0.0/branelet-x86_64
sudo chmod +x /usr/local/bin/branelet