# Debian Buster GPU Docker Host configuration

## Installing NVIDIA support for Docker

### Install some packages

```bash
sudo dpkg --add-architecture i386
sudo apt-get update && sudo apt-get dist-upgrade -y
sudo apt install -y build-essential libc6:i386 git wget curl net-tools
```

### generate link from http://www.nvidia.com/Download/index.aspx

`wget http://us.download.nvidia.com/XFree86/Linux-x86_64/440.44/NVIDIA-Linux-x86_64-440.44.run`

### Disable the nouveau driver and reboot

```bash
sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo update-initramfs -u
sudo reboot
```

### Shutdown running X servers by changing to console mode
```
sudo telinit 3
```
### Running the installer script

Install the currently running kernel's headers

`sudo apt install linux-headers-$(uname -r)`

### install the core X server, for GPU clock and power management (nvidia-settings)

`sudo apt install pkg-config xorg libgtk-3-0`

#### Install for systems with Secure Boot disabled in UEFI BIOS, or if not using UEFI

`sudo bash NVIDIA-Linux-x86_64-440.44.run`

Choose "No" for signing the kernel module

#### Install for systems with Secure Boot enabled in UEFI BIOS.

`sudo bash NVIDIA-Linux-x86_64-440.44.run`

"Continue Installation" -> "Sign the kernel module" -> "Generate a new key pair" -> "No" (don't delete the key

Take note of the cert file name and path, ie: `/usr/share/nvidia/nvidia-modsign-crt-65E0FA91.der`.
press "OK"

Take note of the private key filename and path, ie: `/usr/share/nvidia/nvidia-modsign-key-65E0FA91.key`.
"Install signed kernel module" -> "OK" -> "Install and overwrite existing files" -> "Yes" -> "OK".

##### Import your new public cert to the trusted kernel keystore
```
sudo mokutil --import /usr/share/nvidia/nvidia-modsign-crt-65E0FA91.der
```

##### reboot and when promted by the UEFI BIOS to install the new key, chose "Yes" or "OK".
```
sudo reboot

```

## Testing the NVIDIA installation
### Run the NVIDIA SMI tool to query a list of available GPUs
```
nvidia-smi
```
#### the output should resemble the following:
```
Thu Jan 24 18:59:30 2019
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 415.13       Driver Version: 415.13       CUDA Version: 10.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 1080    Off  | 00000000:02:00.0 Off |                  N/A |
| 37%   26C    P8     9W / 180W |     40MiB /  8119MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
```

Notice how there is nothing running on X:
```
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+

```

### Configure some fake X screens

modify the example `xorg.conf` file to reflect your actual hardware. Specifically, the number of cards, and the PCI BUS IDs. Configuring more cards than you have installed does not seem to cause any problems, so using the example `xorg.conf` the way it is should work as long as the entries include the PCI BUS IDs of your cards.

modify the example `rc.local` file to reflect your desired power limit and default fan speed.

from your management host, or where you have this repo checked out:

```bash
scp rc.local <new_host>:~/
scp xorg.conf <new_host>:~/
```

### Make the core X server process run on boot

```bash
sudo rm /etc/rc.local && \
  sudo touch /etc/rc.local
cat rc.local | sudo tee -a /etc/rc.local
sudo chmod +x /etc/rc.local
```

#### Reboot and test

`sudo reboot`

wait a bit, then SSH back in and check if X is running on NVIDIA

`nvidia-smi`

```
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0       542      G   /usr/lib/xorg/Xorg                            22MiB |
+-----------------------------------------------------------------------------+
```
this means you have successfully setup the nvidia drivers and have them available to the system

### Enable fan speed control and overclocking

Use the `xorg.conf` that you have customized in the previous step

`cat xorg.conf | sudo tee -a /etc/X11/xorg.conf`

alternatively, you can generate a good starting `xorg.conf` using the following:

```bash
sudo rm rf /etc/X11/xorg.conf
sudo nvidia-xconfig --enable-all-gpus --cool-bits=28 --allow-empty-initial-configuration
```

#### Reboot and test

`nvidia-smi`

```
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0       542      G   /usr/lib/xorg/Xorg                            22MiB |
+-----------------------------------------------------------------------------+
```

this means you have not messed-up the xorg config and that X is still working, yay!

your GPU fans should also be running as what is specified in the `rc.local` file now.

## Install nvidia-docker

### Clone the repo

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
```

`sudo systemctl restart docker`

## Test GPU access from inside a container

`docker run --gpus all nvidia/cuda:9.0-base nvidia-smi`

You should see all your GPUs in the SMI output. This is from inside the docker container.

```
Unable to find image 'nvidia/cuda:9.0-base' locally
9.0-base: Pulling from nvidia/cuda
976a760c94fc: Pull complete
c58992f3c37b: Pull complete
0ca0e5e7f12e: Pull complete
f2a274cc00ca: Pull complete
708a53113e13: Pull complete
371ddc2ca87b: Pull complete
f81888eb6932: Pull complete
Digest: sha256:56bfa4e0b6d923bf47a71c91b4e00b62ea251a04425598d371a5807d6ac471cb
Status: Downloaded newer image for nvidia/cuda:9.0-base
Sun Dec 15 20:25:16 2019
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 440.44       Driver Version: 440.44       CUDA Version: 10.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 1080    On   | 00000000:01:00.0  On |                  N/A |
| 90%   27C    P8    14W / 200W |     25MiB /  8119MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
```

### Compatability update

```bash
echo "deb http://security.debian.org/debian-security stretch/updates main" | sudo tee -a /etc/apt/sources.list.d/old-stable.list
sudo apt update && sudo apt-get install libssl1.0.2 screen linux-headers-$(uname -r)
```

[Awesome Miner Linux](https://support.awesomeminer.com/support/solutions/articles/35000086210-remote-agent-for-linux)

```bash
sudo apt install bash screen libc-ares2
wget http://www.awesomeminer.com/download/setup/awesomeminer-remoteagent.tar.xz
tar xvJf awesomeminer-remoteagent.tar.xz
cd awesomeminer-remoteagent
sudo ./service-install.sh
./AwesomeMiner.RemoteAgent.Linux /setpassword=SomePassword123
sudo reboot
```

```bash
# autoclean dead screens
echo "*  *    * * *   root    screen -wipe" | sudo tee -a /etc/crontab
```
