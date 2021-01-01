# Builds like this:
`docker build -t docker-trex .`

docker tag docker-trex:latest registry.techfusion.ca:5000/docker-trex
docker tag docker-trex:latest registry.techfusion.ca:5000/docker-trex:latest

docker push registry.techfusion.ca:5000/docker-trex
docker push registry.techfusion.ca:5000/docker-trex:latest

# Runs something like this:
```bash
# Setting parameters
APP=docker-trex
BINARY=t-rex
VERSION=0.14.6
CUDA=10.0
TASK=$BINARY
ALGO=honeycomb
POOL=honeycomb.mine.zergpool.com:3757
WALLET=LNm4bWDfqVgLNHpURXMD5oUN8YkCMoMb9K
WALLET_TYPE=LTC
WORKER=$(hostname)
GPUS=all

# Executing task
docker container rm $TASK

docker run \
  -e DREDGE_VERSION=$VERSION \
  -e CUDA_VERSION=$CUDA \
  --gpus $GPUS \
  --name $TASK $APP \
  $BINARY -a $ALGO -o stratum+tcp://$POOL -u $WALLET.$WORKER -p c=$WALLET_TYPE
```