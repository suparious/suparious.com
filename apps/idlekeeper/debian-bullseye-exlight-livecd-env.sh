## exLight Debian
sudo ifconfig enp2s0f0 down
sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
# fix debian-security repo
# bullseye-security/updates main contrib non-free
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

sudo mkdir work
sudo mount /dev/sda1 work
sudo chown user:user work
cd work
echo "DOCKER_OPTS=\"-g /home/user/work/docker\"" >> /etc/default/docker
sudo service docker stop
sudo mv /var/lib/docker /home/user/work/
sudo ln -s /home/user/work/docker /var/lib/docker
sudo service docker start

# test
sudo docker run --rm --gpus all nvidia/cuda:10.2-base nvidia-smi

# build
mkdir build && cd build
wget https://s3-us-west-2.amazonaws.com/suparious.com-git/idlekeeper/Dockerfile
wget https://s3-us-west-2.amazonaws.com/suparious.com-git/idlekeeper/cuda.repo
wget https://s3-us-west-2.amazonaws.com/suparious.com-git/idlekeeper/config
docker build . -t ml-model-render:latest

# run
screen
docker run --rm --gpus all ml-model-render
