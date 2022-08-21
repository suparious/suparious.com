## AwesomeMiner discovery (get work)

```
GET
http://poseidon:1025/api/profitprofiles
http://poseidon:1025/api/onlineservices/stats?profile_id=21
```

### Notifications

`http://poseidon:1025/api/notifications`

```
Actions:
- ack_all: Acknowledge all notifications
- clear_all: Remove all notifications
```
#### Clear noticiations
```
POST 
http://poseidon:1025/api/notifications?action=clear_all
```

https://support.awesomeminer.com/support/solutions/articles/35000085916-awesome-miner-http-api


## Deploy hooks

```
https://hub.docker.com/r/ehazlett/conduit/
```