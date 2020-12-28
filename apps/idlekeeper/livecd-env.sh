## exLight Debian
sudo ifconfig enp2s0f0 down
dpkg -i code_1.52.1-1608136922_amd64.deb
#main contrib non-free
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

# time for nvidia
cd ~/Downloads
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/450.80.02/NVIDIA-Linux-x86_64-450.80.02.run
chmod +x NVIDIA-Linux-x86_64-450.80.02.run
sudo sh NVIDIA-Linux-x86_64-450.80.02.run