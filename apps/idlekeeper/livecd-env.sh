## exLight Debian
sudo ifconfig enp2s0f0 down
dpkg -i code_1.52.1-1608136922_amd64.deb
sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
sudo apt-get --allow-unauthenticated update
sudo apt install git
ssh-keygen -b 4096
cat /home/user/.ssh/id_rsa.pub
git clone git@github.com:suparious/suparious.com.git

# start
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    gnupg2 \
    software-properties-common

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo apt-get --allow-unauthenticated update
sudo apt-get --allow-unauthenticated install \
    docker-ce docker-ce-cli containerd.io

sudo systemctl status docker

# enable current user access
sudo usermod -aG docker ${USER}
id -nG
sudo su - ${USER}
id -nG
docker ps

# nvidia-docker
#distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
#   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
#   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/debian10/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo ln -s /sbin/ldconfig /sbin/ldconfig.real
sudo systemctl restart docker

# test
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
