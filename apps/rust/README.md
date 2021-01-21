# Suparious Rust Server

 - no lag gameplay
 - rust-vanilla-us-east-1
 - 

## Debian Buster 10 Overview

 - Configure and update Debian base server
 - Install steamcmd and steam login
 - Install Rust server and test
 - Install linuxGSM and add rust
 - Import config backup, or create new config
 - Run rust using service manager
 - Backup working config
 - Monitor running games

## Install Pre-Requisites

### Configure Debian package manager

```bash
sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
sudo dpkg --add-architecture i386
sudo apt update
sudo apt -y dist-upgrade
```

### Configure server hostname

```bash
NEW_NAME="rust-west-mods"
echo ${NEW_NAME} | sudo tee /etc/hostname
echo "127.0.0.1    ${NEW_NAME}" | sudo tee -a /etc/hosts
echo "127.0.0.1    ${NEW_NAME}" | sudo tee -a /etc/cloud/templates/hosts.debian.tmpl
sudo hostnamectl set-hostname ${NEW_NAME}
```

The next time you log in, you will see the new hostname.

### Install base environment

```bash
sudo apt-get -y install \
    git \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg-agent \
    gnupg2 \
    software-properties-common \
    screen \
    lib32gcc1 \
    libsdl2-2.0-0:i386 \
    libsdl2* \
    lib32stdc++6 \
    unzip \
    binutils \
    rsync \
    bc \
    jq \
    tmux \
    netcat \
    lib32z1 \
    linux-headers-$(uname -r) \
    build-essential
# OPTIONAL - to help the server realize the updates and hostname change
sudo apt install -f
sudo apt autoremove
sudo apt clean
sudo apt autoclean
sudo reboot
```

## Install Steam Console Client

```bash
echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
sudo locale-gen
sudo apt -y install steamcmd
```

### Enable realtime player statistics

```bash
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt update && sudo apt install -y nodejs
sudo npm install gamedig -g
```

## Configure rust server pre-requisites

replace `modded` with a mame of your choice.

```bash
echo "export STEAMUSER=\"modded\"" >> ~/.bashrc
STEAMUSER="modded"
# sudo adduser modded --disabled-password --quiet
sudo adduser ${STEAMUSER} --disabled-password --quiet
sudo su - ${STEAMUSER}
```

You are now ready to use the game manager, without pre-requisite issues.


## Install rust server

Assuming you will only be running this one game on the server, install to your home `~/`.

```bash
# As the game server user
steamcmd +login anonymous +force_install_dir ~/ +app_update 258550 validate +quit
```

### OPTIONAL - Modded Install *ONLY* (Oxide)

By doing this part, your server will be listed as `Modded` instead of `community`.

In this example, RustDedicated is installed in `~/`, so we will put Oxide files there too.

```bash
# As the game server user
cd ~/
wget https://umod.org/games/rust/download -O Oxide.Rust.zip
unzip -o Oxide.Rust.zip
rm Oxide.Rust.zip
wget https://umod.org/extensions/discord/download -O ~/RustDedicated_Data/Managed/Oxide.Ext.Discord.dll
wget http://playrust.io/latest -O ~/RustDedicated_Data/Managed/Oxide.Ext.RustIO.dll

`TODO: wget https://suparious.com/apps/rust-nolag/release.zip`

unzip release.zip
rsync -rv suparious.com-master/apps/rust/config-modded/oxide oxide

rm -rf suparious.com-master
rm release.zip
```

## Optional Customizations and final notes

### Kits

```
/kit add autokit
/kit items authlevel 2 hide true

/kit add builder
/kit items max 3 cooldown 86400

/kit add scuba
/kit items max 5 cooldown 3600

/kit add vip1
/kit items max 2 permission vip

o.reload Kits
```

### Permissions

```
oxide.show groups
oxide.show perms

oxide.usergroup add suparious admin

oxide.grant group admin skins.admin
oxide.grant group admin kits.admin
oxide.grant group admin adminpanel.allowed
oxide.grant group admin removertool.admin
# https://www.gameserverkings.com/knowledge-base/rust/oxide-permissions-101/
```

### Maps

```
size: 6000
seed: 7880972
```
