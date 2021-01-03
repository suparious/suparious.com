#!/bin/bash
screen -X -S main quit
cd ~ && rm -rf idlekeeper*
wget https://s3-us-west-2.amazonaws.com/suparious.com/idlekeeper.zip && \
unzip idlekeeper.zip && \
cd idlekeeper/

chmod +x base-image/build.sh && \
chmod +x build.sh && \
./build.sh

cd ~
rm -rf idlekeeper*
exit
