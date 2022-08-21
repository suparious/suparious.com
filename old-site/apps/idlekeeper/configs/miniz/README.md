
## Configure
```bash
# Setting parameters
APP=docker-miniz
BINARY=miniZ
VERSION=1.5s
CUDA=10
TASK=$BINARY
ALGO=125_4
POOL=neoscrypt.mine.zergpool.com
PORT=2150
WALLET=LNm4bWDfqVgLNHpURXMD5oUN8YkCMoMb9K
WALLET_TYPE="c=LTC,mc=ZEL"
WORKER=$(hostname)
GPUS=all
```

## Clean
`docker container rm $TASK`

## Build
`docker build -t docker-miniz .`

```bash
  #-e DREDGE_VERSION=$VERSION \
  #-e CUDA_VERSION=$CUDA \
```

## Test
```bash
docker run \
  --gpus $GPUS \
  --name $TASK $APP \
  $BINARY --algo $ALGO --pers auto --server $POOL --port $PORT --user $WALLET --pass $WALLET_TYPE
```

## Push
```bash
docker tag docker-miniz:latest registry.techfusion.ca:5000/docker-miniz
docker tag docker-miniz:latest registry.techfusion.ca:5000/docker-miniz:latest
docker push registry.techfusion.ca:5000/docker-miniz
docker push registry.techfusion.ca:5000/docker-miniz:latest
```