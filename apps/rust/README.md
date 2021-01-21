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

echo "rust-east" | sudo tee /etc/hostname
echo "127.0.0.1    rust-east" | sudo tee -a /etc/hosts
sudo hostnamectl set-hostname rust-east
# Log out and then log back in to realize the hostname change

# OPTIONAL
#sudo reboot
```

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
    bc \
    jq \
    tmux \
    netcat \
    lib32z1 \
    linux-headers-$(uname -r) \
    build-essential
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

### Clean-up the system

```bash
sudo apt install -f
sudo apt autoremove
sudo apt clean
sudo apt autoclean
```

## Configure rust server pre-requisites

replace `vanilla` with a mame of your choice.

```bash
echo "export STEAMUSER=\"vanilla\"" >> ~/.bashrc
STEAMUSER="vanilla"
# sudo adduser modded --disabled-password --quiet
sudo adduser ${STEAMUSER} --disabled-password --quiet
sudo su - ${STEAMUSER}
```

You are now ready to use the game manager, without pre-requisite issues.


## Install rust server

In this example, replace `rust_modded` with the folder you want.

```bash
# As the game server user
steamcmd +login anonymous +force_install_dir ~/rust_modded +app_update 258550 validate +quit
```

### OPTIONAL - Modded Install *ONLY* (Oxide)

By doing this part, your server will be listed as `Modded` instead of `community`.

In this example, replace `rust_modded` with the folder you had previously chosen, otherwise leave as the default.

```bash
# As the game server user
cd ~/rust_modded
wget https://umod.org/games/rust/download -O Oxide.Rust.zip
unzip -o Oxide.Rust.zip
rm Oxide.Rust.zip
# start the server, wait for it to fully load-up, then stop it gracefully, with 'Ctrl+C' only once.
./RustDedicated -batchmode -nographics \
    -server.ip 0.0.0.0 \
    -server.port 28015 \
    -rcon.ip 0.0.0.0 \
    -rcon.port 28016 \
    -rcon.web 1 \
    -rcon.password "NOFAGS" \
    -server.tickrate 30 \
    -server.level "Procedural Map" \
    -server.hostname "[West] Suparious|perfect mods|NoLag|AlphaTest" \
    -server.identity "suparious-rust-west-modded" \
    -server.url "https://suparious.com/" \
    -server.headerimage "http://suparious.com/images/suparious_logo.png" \
    -server.globalchat true \
    -falldamage.enabled true \
    -server.maxplayers 240 \
    -server.worldsize 4500 \
    -server.seed 280 \
    -server.saveinterval 900 \
    -server.itemdespawn 30 \
    -server.respawnresetrange 10 \
    -spawn.min_rate 1.7 ^ \
    -spawn.max_rate 2 \
    -spawn.min_density 1.7 ^ \
    -spawn.max_density 2
```


### Configure

```bash
# As the game server user
ln -s lgsm/config-lgsm/rustserver/_default.cfg _default.cfg
ln -s lgsm/config-lgsm/rustserver/common.cfg common.cfg
ln -s lgsm/config-lgsm/rustserver/rustserver.cfg rustserver.cfg
ln -s serverfiles/server/rustserver/cfg/server.cfg server.cfg
# copy config backups from s3
#TODO: aws s3 --sync s3://suparious-dev/servers/rust/rustserver.cfg lgsm/config-lgsm/rustserver/rustserver.cfg
```

### Start

```bash
# As the game server user

```

### Monitoring

```bash
# As the game server user
./rustserver console
./rustserver details
exit
```

### Restarting

```bash
# As the game server user
./rustserver restart
exit
```

## Server Mods

```bash
wget https://umod.org/extensions/discord/download -O ~/serverfiles/RustDedicated_Data/Managed/Oxide.Ext.Discord.dll
wget http://playrust.io/latest -O ~/serverfiles/RustDedicated_Data/Managed/Oxide.Ext.RustIO.dll
./rustserver restart
```


```bash
./rustserver mods-install
mkdir -p ~/serverfiles/server/rustserver/oxide/plugins
ln -s ~/serverfiles/server/rustserver/oxide/plugins plugins
cd ~/plugins

MODS=(\
https://umod.org/plugins/Rustcord.cs
https://umod.org/plugins/NoGiveNotices.cs
https://umod.org/plugins/Welcomer.cs
https://umod.org/plugins/Inbound.cs
https://umod.org/plugins/NoDecay.cs
https://umod.org/plugins/Clans.cs
https://umod.org/plugins/Friends.cs
https://umod.org/plugins/BetterChat.cs
https://umod.org/plugins/Economics.cs
https://umod.org/plugins/StackSizeController.cs
https://umod.org/plugins/GatherManager.cs
https://umod.org/plugins/NTeleportation.cs
https://umod.org/plugins/QuickSmelt.cs
https://umod.org/plugins/Kits.cs
https://umod.org/plugins/FurnaceSplitter.cs
https://umod.org/plugins/RemoverTool.cs
https://umod.org/plugins/InfoPanel.cs
https://umod.org/plugins/DeathNotes.cs
https://umod.org/plugins/Backpacks.cs
https://umod.org/plugins/AdminPanel.cs
https://umod.org/plugins/BetterLoot.cs
https://umod.org/plugins/CraftMultiplier.cs
https://umod.org/plugins/CraftingController.cs
https://umod.org/plugins/InstantCraft.cs
https://umod.org/plugins/MagicCraft.cs
https://umod.org/plugins/ItemSkinRandomizer.cs
https://umod.org/plugins/ZLevelsRemastered.cs
https://umod.org/plugins/BGrade.cs
https://umod.org/plugins/Skins.cs
https://umod.org/plugins/AutoDoors.cs
https://umod.org/plugins/Trade.cs
https://umod.org/plugins/NoEscape.cs
https://umod.org/plugins/BuildingGrades.cs
https://umod.org/plugins/GUIShop.cs
https://umod.org/plugins/Bank.cs
https://umod.org/plugins/PathFinding.cs
https://umod.org/plugins/Waypoints.cs
https://umod.org/plugins/Recycle.cs
https://umod.org/plugins/Lottery.cs
https://umod.org/plugins/ServerRewards.cs
https://umod.org/plugins/ImageLibrary.cs
https://umod.org/plugins/WipePrize.cs
https://umod.org/plugins/FuelGauge.cs
https://umod.org/plugins/ServerRewards.cs
https://umod.org/plugins/PlaytimeTracker.cs
https://umod.org/plugins/HuntRPG.cs
https://umod.org/plugins/Pets.cs
https://umod.org/plugins/Quests.cs
https://umod.org/plugins/PlayerChallenges.cs
https://umod.org/plugins/HitIcon.cs
https://umod.org/plugins/TcMapMarkers.cs
https://umod.org/plugins/TurretManager.cs
https://umod.org/plugins/KillStreaks.cs
https://umod.org/plugins/RustIOClans.cs
https://umod.org/plugins/AutomaticAuthorization.cs
https://umod.org/plugins/OfflineDoors.cs
https://umod.org/plugins/LustyMap.cs
https://umod.org/plugins/RunningMan.cs
https://umod.org/plugins/Airstrike.cs
https://umod.org/plugins/Pets.cs
https://umod.org/plugins/HumanNPC.cs
https://umod.org/plugins/AutoLock.cs
https://umod.org/plugins/BaseRepair.cs
https://umod.org/plugins/CCTVUtilities.cs
https://umod.org/plugins/HelpText.cs
https://umod.org/plugins/Voter.cs
https://umod.org/plugins/HandyMan.cs
https://umod.org/plugins/VehicleLicence.cs
https://umod.org/plugins/RaidblockBuildingHealth.cs
https://umod.org/plugins/ScheduledSpawns.cs
https://umod.org/plugins/FastLoot.cs
https://umod.org/plugins/UpkeepDisplayFix.cs
https://umod.org/plugins/NPCVendingMapMarker.cs
https://umod.org/plugins/TcMapMarkers.cs
https://umod.org/plugins/MonumentsRecycler.cs
https://umod.org/plugins/VehicleDeployedLocks.cs
https://umod.org/plugins/VehicleVendorOptions.cs
https://umod.org/plugins/BombTrucks.cs\
)

for mod in ${MODS[@]}; do
    wget ${mod}
    sleep 4
done

./rustserver mods-update
```

# Updating

If you updated an addon and wish to reload it without restarting the server, you'll need to input it in an RCON tool. Once you've got it, run :

`oxide.reload PluginName`

 - [OxideMod Linux Tutorial](https://oxidemod.org/threads/setting-up-a-linux-server-with-lgsm.16528/)

 - [Linux Game Server Managers](https://linuxgsm.com/lgsm/rustserver/)

API Key
E646DF0C454DA3DF18E47280E11A42D8


## Kits

```
/kit add autokit
/kit items authlevel 2 hide true

/kit add builder
/kit items max 3 cooldown 86400

/kit add scuba
/kit items max 5 cooldown 3600

/kit add vip1
/kit items max 2 permission vip

```


```
o.reload Kits

oxide.show groups
oxide.show perms

oxide.usergroup add suparious admin

oxide.grant group admin skins.admin
oxide.grant group admin kits.admin
oxide.grant group admin adminpanel.allowed
oxide.grant group admin removertool.admin
# https://www.gameserverkings.com/knowledge-base/rust/oxide-permissions-101/
```


6000
7880972

gather.rate dispenser Wood 5
gather.rate dispenser Stones 4
gather.rate dispenser "Sulfur Ore" 5
gather.rate dispenser "Metal Ore" 5
gather.rate dispenser Cloth 10
gather.rate dispenser Scrap 10
gather.rate pickup wood 10
gather.rate pickup Stones 10
gather.rate pickup Cloth 10
#gather.rate pickup Scrap 10
#gather.rate pickup "Metal Pipe" 10
gather.rate pickup "Sulfur Ore" 10
gather.rate pickup "Metal Ore" 10
gather.rate quarry Stones 10
gather.rate survey "Sulfur Ore" 10

server.writecfg