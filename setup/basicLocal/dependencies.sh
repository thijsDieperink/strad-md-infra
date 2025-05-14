#!/bin/sh

docker=$1

echo "Let's start the installation of all dependencies"

# General installations for MacOs
if [ "$(uname)" = "Darwin" ]; then
    echo "--------------Detected Darwin OS--------------"

    is_arm64() {
    [[ "$(uname -m)" == "arm64" ]]
    }

    if command -v brew >/dev/null 2>&1; then
        echo "-----------✅ Homebrew is already installed: $(brew --version | head -n 1)---------------"
    else
        echo "-----------🔧 Homebrew not found. Installing...----------------"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        echo "----------Adding homebrew to path---------------"
        if is_arm64; then
            BREW_PATH="/opt/homebrew/bin"
        else
            BREW_PATH="/usr/local/bin"
        fi

        # Add to shell config if not already present
        SHELL_CONFIG="$HOME/.zprofile"
        [[ -f "$HOME/.bash_profile" ]] && SHELL_CONFIG="$HOME/.bash_profile"
        [[ -f "$HOME/.zshrc" ]] && SHELL_CONFIG="$HOME/.zshrc"

        if ! grep -q "$BREW_PATH" "$SHELL_CONFIG"; then
            echo "export PATH=\"$BREW_PATH:\$PATH\"" >> "$SHELL_CONFIG"
            echo "✅ Added Homebrew to PATH in $SHELL_CONFIG"
        fi

        echo "----------⚠️ You may need to restart your terminal or run: source $SHELL_CONFIG and than run this script again----------"
        exit 0
        fi

    echo "--------------Installing general dependencies--------------"
    brew install go
    brew install make
    brew install curl
    brew install openssl
    brew install sqlite
    if command -v python3 &>/dev/null; then
        echo "--------------Python3 already installed--------------"
    else
        echo "--------------Installing Python3--------------"
        brew install python
    fi
    if [[ "$docker" != "no" ]]; then
        # Docker installation
        echo "--------------Installing docker--------------"
        brew install --cask docker
        echo "--------------Installing and creating buildx--------------"
        git clone https://github.com/docker/buildx.git
        cd buildx
        go build -o bin/buildx ./cmd/buildx
        mkdir -p ~/.docker/cli-plugins
        cp bin/buildx ~/.docker/cli-plugins/docker-buildx
        chmod +x ~/.docker/cli-plugins/docker-buildx
        docker buildx create --use
        cd ..
        rm -rf buildx
    fi
elif [ $(uname) = "Linux" ]; then
    echo "--------------Detected Linux distribution--------------"
    if grep -qi "ubuntu" /etc/os-release; then
        echo "--------------Detected Ubuntu OS--------------"

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

        if [ "$docker" != "no" ]; then
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
    else 
        echo "Detected unsupported Linux distribution OS"
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

sudo mkdir /usr/local/bin
# branectl
echo "---------Installing branectl-------"
make brane-ctl PROFILE=release
sudo cp target/release/branectl /usr/local/bin/branectl
sudo chmod +x /usr/local/bin/branectl
# brane cli
echo "---------Installing brane cli-------"
make brane-cli PROFILE=release
sudo cp target/release/brane /usr/local/bin/brane
sudo chmod +x /usr/local/bin/brane
# branelet
echo "---------Installing branelet-------"
cargo build --release --package brane-let
sudo cp target/release/branelet /usr/local/bin/branelet
sudo chmod +x /usr/local/bin/branelet