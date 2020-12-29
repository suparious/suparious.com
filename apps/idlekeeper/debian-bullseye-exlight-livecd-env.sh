## exLight Debian
sudo ifconfig enp2s0f0 down
sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
#sudo apt-get --allow-unauthenticated update
sudo apt-get update

# start
sudo apt-get install \
    git \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    gnupg2 \
    software-properties-common \
    screen

# Add persistent storage for docker
sudo mkdir /var/lib/docker
sudo mount /dev/sda1 /var/lib/docker
sudo ln -s /var/lib/docker/work /home/user/work

#sudo add-apt-repository \
#   "deb [arch=amd64] https://download.docker.com/linux/debian \
#   $(lsb_release -cs) \
#   stable"

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   buster \
   stable"

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo apt-get update
sudo apt-get install \
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

# test
sudo docker run --rm --gpus all nvidia/cuda:10.2-base nvidia-smi

# build
cd /home/user/work/suparious.com/apps/idlekeeper/base
docker build . -t ds-cuda-base:latest
cd ../build
docker build . -t ml-model-render:latest

# run
screen
docker run --rm --gpus all ml-model-render

# troubleshooting
docker run --rm --gpus all -it --entrypoint bash ml-model-render
