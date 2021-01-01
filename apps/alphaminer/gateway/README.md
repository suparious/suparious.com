apt install nginx
systemctl enable nginx
systemctl start nginx

```bash
#/etc/nginx/conf.d/10-gateway.conf
# Define which servers to include in the load balancing scheme.
# It's best to use the servers' private IPs for better performance and security.
# You can find the private IPs at your UpCloud control panel Network section.

upstream graphana {
    server blaze-1:3000 weight=3;
    server kolvicy-1:3000 weight=2;
    server hades-1:3000;
    server godberry-1:3000;
    server poseidon-1:3000;
}

 # This server accepts all traffic to port 80 and passes it to the upstream.
 # Notice that the upstream name and the proxy_pass need to match.

server {
    listen 80;
    server_name monitoring.techfusion.ca;
    location / {
        proxy_pass http://graphana;
    }
}
```

systemctl restart nginx


# Current hosts
10.2.5.129      kolvicy-1       
10.2.5.130      blaze-1         
10.2.5.205      godberry-1      
10.2.5.122      poseidon-1      
10.2.5.167      hades-1         
10.2.5.201	    haze

# Hosts from Haze
10.2.5.129      kolvicy
10.2.5.130      blaze
10.2.5.205      godberry
10.2.5.122      poseidon
10.2.5.167      hades

=======
curl ifconfig.me
curl icanhazip.com
curl ipecho.net/plain
curl ifconfig.co
===================

sudo apt-get install certbot python-certbot-nginx
#/etc/nginx/conf.d/20-swarm-registry.conf
# Define which servers to include in the load balancing scheme.
# It's best to use the servers' private IPs for better performance and security.
# You can find the private IPs at your UpCloud control panel Network section.

upstream registry {
    server blaze-1:5000 weight=2;
    server kolvicy-1:5000 weight=3;
    server hades-1:5000;
    server godberry-1:5000;
    server poseidon-1:5000;
}

sudo certbot --nginx

/etc/nginx/nginx.conf
  client_max_body_size 0;
  server_names_hash_bucket_size 64;


### Do a cert

## do this on the gateway, using certbot
```bash
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get install certbot python-certbot-nginx
sudo certbot --nginx
sudo certbot renew --dry-run
```