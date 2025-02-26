#!/bin/bash

echo "Installing dependencies"
sudo apt update -y
sudo apt install -y gcc g++ cmake pkg-config curl wget
#sudo snap install go --classic
#sudo apt install -y openssl libssl-dev
#wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
#sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.17_amd64
#sudo apt install -y sqlite3 libsqlite3-dev
#sudo apt install -y python3
#curl --proto ‘=https’ –tlsv1.2 -sSf https://sh.rustup.rs | sh
#. ”$HOME/.cargo/env”>
#sudo apt install -y docker.io docker-buildx
#sudo systemctl enable docker --now
#sudo systemctl start docker
#sudo chmod 666 /var/run/docker.sock
#docker buildx install
#sudo docker buildx create --use

# maybe add test for if docker or some other dependency is installed properly

