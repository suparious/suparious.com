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

reboot

# docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install \
    docker-ce docker-ce-cli containerd.io

# enable current user access
sudo usermod -aG docker ${USER}
sudo su - ${USER}

# test docker
#sudo systemctl status docker
docker ps

# nvidia-docker2
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
#curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
#curl -s -L https://nvidia.github.io/nvidia-docker/debian10/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install -y nvidia-docker2
#sudo ln -s /sbin/ldconfig /sbin/ldconfig.real
sudo systemctl restart docker

# test
docker run --rm --gpus all nvidia/cuda:11.1-base nvidia-smi

# build
wget https://s3-us-west-2.amazonaws.com/suparious.com-git/suparious.com-master.zip && \
unzip suparious.com-master.zip && \
cd suparious.com-master/apps/idlekeeper/ && \
chmod +x base-image/build.sh && \
chmod +x build.sh && \
./build.sh

# clean-up
cd ~
rm -rf suparious.com-master*
exit

# run
screen
docker run --rm --gpus all ml-model-render

# troubleshooting
docker run --rm --gpus all -it --entrypoint bash ml-model-render
