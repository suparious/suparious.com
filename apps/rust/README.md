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
    htop \
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
steamcmd +login anonymous +force_install_dir ~/ +app_update 258550 +quit
steamcmd +login anonymous +force_install_dir ~/ +app_update 258550 validate +quit
```

### OPTIONAL - Modded Install *ONLY* (Oxide)

By doing this part, your server will be listed as `Modded` instead of `community`.

In this example, RustDedicated is installed in `~/`, so we will put Oxide files there too.

```bash
# As the game server user
cd ~/
wget https://umod.org/games/rust/download/develop -O Oxide.Rust.zip
unzip -o Oxide.Rust.zip
rm Oxide.Rust.zip
wget https://umod.org/extensions/discord/download -O ~/RustDedicated_Data/Managed/Oxide.Ext.Discord.dll
wget http://playrust.io/latest -O ~/RustDedicated_Data/Managed/Oxide.Ext.RustIO.dll

wget https://suparious.com/apps/rust/release-1.0.0.zip
unzip release-1.0.0.zip
rsync -rv suparious.com-master/apps/rust/config-modded/oxide/ oxide
rsync -rv suparious.com-master/apps/rust/config-modded/server/rust/cfg/ server/rust/cfg
rsync -rv suparious.com-master/apps/rust/config-modded/start.sh start.sh
rm -rf suparious.com-*
rm release*
```

## Start the server

Starting the server for the first time helps generate the server data so we can validate our plugins. Once the server is fully started and working, use `ctrl + c` and wait for it to shutdown gracefully.

```bash
chmod +x start.sh
./start.sh
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

### User and Group Permissions

```
ownerid 76561198024774727 "Suparious"
ownerid 76561198206550912 "ThePastaMasta"
server.writecfg

oxide.show groups
oxide.show perms

oxide.group add GM
oxide.group add dev
oxide.group parent admin default
oxide.group parent GM admin
oxide.group parent dev default

oxide.usergroup add suparious admin
oxide.usergroup add ThePastaMasta GM
oxide.usergroup add SmokeQC dev
oxide.usergroup remove suparious default
oxide.usergroup remove ThePastaMasta default
oxide.usergroup remove SmokeQc default

oxide.grant group default removertool.normal
oxide.grant group default instantcraft.use
oxide.grant group default quicksmelt.use
oxide.grant group default recyclerspeed.use
oxide.grant group default bgrade.all
oxide.grant group default fuelgauge.allow
oxide.grant group default pets.bear
oxide.grant group default pets.boar
oxide.grant group default pets.chicken
oxide.grant group default pets.horse
oxide.grant group default pets.stag
oxide.grant group default pets.wolf
oxide.grant group default skins.use
oxide.grant group default trade.use
oxide.grant group default trade.accept

oxide.grant group default nteleportation.home - /home, /sethome, /removehome
oxide.grant group default nteleportation.deletehome - /home delete & /deletehome
oxide.grant group default nteleportation.homehomes - /home homes & /homehomes
oxide.grant group default nteleportation.importhomes - teleport.importhomes
oxide.grant group default nteleportation.radiushome - /home radius & /radiushome
oxide.grant group default nteleportation.tpb - /tpb
oxide.grant group default nteleportation.tpr - /tpr
oxide.grant group default nteleportation.tphome - /home tp and /tphome
oxide.grant group default nteleportation.tptown - /town
oxide.grant group default nteleportation.tpoutpost - /outpost
oxide.grant group default nteleportation.tpbandit - /bandit
oxide.grant group default nteleportation.tpn - /tpn
oxide.grant group default nteleportation.tpl - /tpl
oxide.grant group default nteleportation.tpremove - /tpremove
oxide.grant group default nteleportation.tpsave - /tpsave
oxide.grant group default nteleportation.wipehomes - /wipehomes
oxide.grant group default nteleportation.crafthome - allow craft during home tp
oxide.grant group default nteleportation.crafttown - allow craft during town tp
oxide.grant group default nteleportation.craftoutpost - allow craft during outpost tp
oxide.grant group default nteleportation.craftbandit - allow craft during bandit tp
oxide.grant group default nteleportation.crafttpr - allow craft during tpr tp
oxide.grant group default bank.use
oxide.grant group default whoknocks.message
oxide.grant group default whoknocks.knock
oxide.grant group default signartist.url
oxide.grant group default signartist.text
oxide.grant group default signartist.restore


oxide.grant group default signartist.raw
oxide.grant group default signartist.restoreall

oxide.grant group admin skins.admin
oxide.grant group admin kits.admin
oxide.grant group admin adminpanel.allowed
oxide.grant group admin removertool.admin
oxide.grant group admin removertool.all
oxide.grant group admin guardedcrate.use
oxide.grant group admin copypaste.copy
oxide.grant group admin copypaste.list
oxide.grant group admin copypaste.paste
oxide.grant group admin copypaste.paste
oxide.grant group admin copypaste.undo
oxide.grant group admin nteleportation.tp
oxide.grant group admin nteleportation.tpt
oxide.grant group admin nteleportation.tpconsole
oxide.grant group admin spawnmodularcar.spawn.4
oxide.grant group admin spawnmodularcar.engineparts.tier3
oxide.grant group admin spawnmodularcar.presets
oxide.grant group admin spawnmodularcar.presets.load
oxide.grant group admin spawnmodularcar.presets.common
oxide.grant group admin spawnmodularcar.presets.common.manage
oxide.grant group admin spawnmodularcar.givecar
oxide.grant group admin spawnmodularcar.fix
oxide.grant group admin spawnmodularcar.fetch
oxide.grant group admin spawnmodularcar.despawn
oxide.grant group admin spawnmodularcar.autofuel
oxide.grant group admin spawnmodularcar.autocodelock
oxide.grant group admin spawnmodularcar.autokeylock
oxide.grant group admin spawnmodularcar.autofilltankers
oxide.grant group admin spawnmodularcar.autostartengine
oxide.grant group admin whoknocks.admin
oxide.grant group admin signartist.ignoreowner
oxide.grant group admin signartist.ignorecd
oxide.grant group admin npcvendingmapmarker.admin

oxide.grant group dev skins.admin

server.writecfg
```

#### Give items

```
inventory.give “short name” “amount”
inventory.giveto “player name” “short name” “amount”
```

#### References

* https://www.corrosionhour.com/umod-permissions-guide/
* https://www.gameserverkings.com/knowledge-base/rust/oxide-permissions-101/
* https://www.corrosionhour.com/rust-item-list/
* https://rust.fandom.com/wiki/Server_Commands
* http://oxidemod.org/threads/updating-adding-without-restarting-server.28250/
* https://www.corrosionhour.com/rust-give-command/


### Maps

```
size: 6000
seed: 7880972
```
