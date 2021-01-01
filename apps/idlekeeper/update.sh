wget https://s3-us-west-2.amazonaws.com/suparious.com-git/suparious.com-master.zip && \
unzip suparious.com-master.zip && \
cd suparious.com-master/apps/idlekeeper/
cp config-ethash config
docker build . -t ml-model-render:latest
cd ~
rm -rf suparious*
exit


exit
screen
docker run --rm --gpus all ml-model-render:latest