# Builds like this:
`docker build -t docker-cryptodredge .`

docker tag docker-cryptodredge:latest registry.techfusion.ca:5000/docker-cryptodredge
docker tag docker-cryptodredge:latest registry.techfusion.ca:5000/docker-cryptodredge:latest

docker push registry.techfusion.ca:5000/docker-cryptodredge
docker push registry.techfusion.ca:5000/docker-cryptodredge:latest

# Runs something like this:
```bash
# Setting parameters
APP=docker-cryptodredge
BINARY=CryptoDredge
VERSION=0.22.0
CUDA=10.1
TASK=$BINARY
ALGO=neoscrypt
POOL=neoscrypt.mine.zergpool.com:4233
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