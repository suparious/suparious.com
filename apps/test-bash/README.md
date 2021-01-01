
## This doesnt work....

### Build the image

`docker build -t test-bash .`

### Test the image

```bash
docker run -d -P --name test-bash test-bash
docker port test-bash 22
ssh root@haze -p 49154
```

### Push to the registry

 ```bash
docker tag test-bash:latest registry.techfusion.ca:5000/test-bash
docker tag test-bash:latest registry.techfusion.ca:5000/test-bash:latest
docker push registry.techfusion.ca:5000/test-bash
docker push registry.techfusion.ca:5000/test-bash:latest
docker rmi test-bash:latest
```

### Pull from the registry

```bash
docker login registry.techfusion.ca:5000
docker pull registry.techfusion.ca:5000/test-bash:latest
```

### Deploy as a service to the swarm

docker stack deploy -c docker-compose.yml techfusion

### Check the logs

docker service ps --no-trunc techfusion_bash