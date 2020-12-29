## Ubuntu 20.04
sudo apt update
sudo apt-get install \
    git \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    gnupg2 \
    software-properties-common \
    screen \
    linux-headers-$(uname -r) \
    build-essential

# enable current user access
sudo usermod -aG docker ${USER}
#exit
#docker ps

# cuda toolkit
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda

reboot

# nvidia
#BASE_URL=https://us.download.nvidia.com/tesla
#DRIVER_VERSION=450.80.02
#curl -fSsl -O $BASE_URL/$DRIVER_VERSION/NVIDIA-Linux-x86_64-$DRIVER_VERSION.run
#sudo sh NVIDIA-Linux-x86_64-$DRIVER_VERSION.run

# docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install \
    docker-ce docker-ce-cli containerd.io

#sudo systemctl status docker

# nvidia-docker2
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
#curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
#curl -s -L https://nvidia.github.io/nvidia-docker/debian10/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install -y nvidia-docker2
#sudo ln -s /sbin/ldconfig /sbin/ldconfig.real
sudo systemctl stop docker
sudo systemctl start docker

# test
sudo docker run --rm --gpus all nvidia/cuda:11.2-base nvidia-smi

# build
wget https://s3-us-west-2.amazonaws.com/suparious.com-git/idlekeeper/suparious.com-master.zip
unzip suparious.com-master.zip
cd suparious.com-master/apps/idlekeeper/base
docker build . -t ds-cuda-base:latest
cd ../build
docker build . -t ml-model-render:latest

# run
screen
docker run --rm --gpus all ml-model-render

# troubleshooting
docker run --rm --gpus all -it --entrypoint bash ml-model-render
