## Usage
mkdir redis/
`docker stack deploy -c redis-stack.yml minerhub-cache`

### Building (optional)

`docker build -t bitnami/redis:latest 'https://github.com/bitnami/bitnami-docker-redis.git#master:5.0/debian-9'`

### Redis client CLI-only install

```bash
sudo apt install tcl build-essential
cd /tmp
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
```

#### Ninja binary into the system (BAD)
```bash
cp src/redis-cli /usr/local/bin/
chmod 755 /usr/local/bin/redis-cli
```

### References
[bitnami/redis documentation](https://hub.docker.com/r/bitnami/redis)

https://auth0.com/blog/introduction-to-redis-install-cli-commands-and-data-types/
https://redis.io/topics/rediscli
https://redis.io/commands
https://redis.io/topics/data-types-intro


https://tutorialedge.net/golang/go-redis-tutorial/
https://tutorialedge.net/golang/creating-restful-api-with-golang/
https://www.firehydrant.io/blog/developer-a-go-app-with-docker-compose/
https://www.callicoder.com/docker-compose-multi-container-orchestration-golang/
https://github.com/slartibaartfast/go-redis-compose

