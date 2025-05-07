#!/bin/bash

docker=$1

echo "Let's start the installation of all dependencies"

# General installations for MacOs
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "--------------Installing general dependencies--------------"
    brew install go
    brew install openssl # didn't include libssl yet
    brew install sqlite
    if command -v python3 &>/dev/null; then
        echo "Python3 already installed"
        exit 0
    else
        echo "Installing Python3"
        brew install python
    exit 0
    fi
    if [[ "$docker" != "no" ]]; then
        # Docker installation
        echo "--------------Installing docker--------------"
        brew cast install docker
        echo "--------------Activating docker--------------"
        # to do - is this even necessary?
        echo "--------------Installing and creating buildx--------------"
        git clone https://github.com/docker/buildx.git
        cd buildx
        docker buildx install
        docker buildx create --use
        cd ..
        rm -rf buildx

        # to do: check if other dependencies are necessary
    fi
elif [[ grep -qi "ubuntu" /etc/os-release ]]; then
    echo "OS is Ubuntu"

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

    if [[ "$docker" != "no" ]]; then
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
    fi
fi

echo "---------Preparing environment-------"
mkdir localInstance
cd localInstance
git clone https://github.com/BraneFramework/brane worker
git clone https://github.com/BraneFramework/brane control
cd ..
cp setup/basicLocal/worker/workerInstallation.sh localInstance/worker
cp setup/basicLocal/control/controlInstallation.sh localInstance/control
cp setup/basicLocal/control/docker-compose-central.yml localInstance/control
cd localInstance/control

# branectl
make brane-ctl PROFILE=release
cp target/release/branectl /usr/local/bin/branectl
sudo chmod /usr/local/bin/branectl
# brane cli
make brane PROFILE=release
cp target/release/brane /usr/local/bin/brane
sudo chmod /usr/local/bin/brane
# branelet
cargo build --release --package brane-let
cp target/release/branelet /usr/local/bin/branelet
sudo chmod /usr/local/bin/branelet