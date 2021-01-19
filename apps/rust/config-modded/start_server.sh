#!/bin/bash
jizz=true
cd rust_modded
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/rust_modded/RustDedicated_Data/Plugins/x86_64
while ${jizz} = true; do
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
    -spawn.max_density 2 \
    -gather.rate dispenser * 1000 \
    -gather.rate pickup * 1000 \
    -gather.rate quarry * 1000 \
    -gather.rate survey *1000 \
    -dispenser.scale tree 1000 \
    -dispenser.scale ore 1000 \
    -dispenser.scale corpse 1000 \
    -logfile 2>&1 "$(date +"%Y_%m_%d_%I_%M_%p").log"
done
cd