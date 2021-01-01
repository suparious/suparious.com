# Builds like this:
`docker build -t docker-ccminer .`
# Runs something like this:
`docker run --gpus all --name ccminer docker-ccminer ccminer -a skein -o stratum+tcp://skein.mine.zergpool.com:4933 -u LNm4bWDfqVgLNHpURXMD5oUN8YkCMoMb9K.blaze -p c=LTC`
