- update the repo and re-run:

```bash

ADMIN_USER=admin \
ADMIN_PASSWORD=admin \
SLACK_URL=https://hooks.slack.com/services/TOKEN \
SLACK_CHANNEL=devops-alerts \
SLACK_USER=alertmanager \
docker stack deploy -c docker-compose.yml mon

```


for shit in `docker service ls | awk {'print $2'} | grep tfmon_`;do docker service rm $shit; done