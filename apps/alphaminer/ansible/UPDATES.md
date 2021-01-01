```bash
# it is lazy security, to mount everything everywhere
sudo mkdir \
  /media/certs \
  /media/docker \
  /media/monitoring \
  /media/registry \
  /media/source \
  /media/Completed \
  /media/Shared \
  /media/temp
```



```text
sudo sed -i.bak '/10.2.5/d' /etc/hosts && \
sudo sed -i.bak '/poseidon/d' /etc/hosts && \
sudo sed -i.bak '/techfusion/d' /etc/hosts && \
cat /media/source/techfusion.ca/ansible/hosts | sudo tee -a /etc/hosts && \
cat -s /etc/hosts | sudo tee /etc/hosts && \
sudo sed -i.bak '/techfusion/d' /etc/fstab && \
sudo sed -i.bak '/media/d' /etc/fstab && \
cat -s /etc/fstab | sort | uniq | sudo tee /etc/fstab && \
cat /media/source/techfusion.ca/ansible/fstab | sudo tee -a /etc/fstab
```

```bash
# Automount like a boss
sudo umount /media/* && sudo mount -a
```

`friend "docker system prune -af"`

for shit in `docker service ls | awk {'print $2'} | grep mon_`;do docker service rm $shit; done