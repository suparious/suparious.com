## Ubuntu 20.04 base image
sudo apt update

# Install pre-requisites
sudo apt-get -y install \
    git \
    unzip \
    wget \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    gnupg2 \
    software-properties-common \
    screen \
    linux-headers-$(uname -r) \
    build-essential

# Shell customizations
echo "rm -rf ~/.bash_history" >> .bashrc

# Nvidia cuda toolkit and GPU drivers
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda

# docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install \
    docker-ce docker-ce-cli containerd.io
    
