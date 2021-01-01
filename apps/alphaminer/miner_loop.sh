#!/bin/bash

historic=

while :
  do
    current=`cat /dev/shm/whattomine`
    if [[ "$historic" = "$current" ]]; then
      echo "==> Steady as she goes!"
      wtm_pid=`ps -ef | grep -E "ccminer|excavator|z-enemy|zm" | grep -v grep | awk -F " " '{print $2}' | head -n 1`
      running=$wtm_pid
      if [ -z "$running" ]; then
        echo "Oh Fuck! Nothing is running"
        historic=FUCKED
      else
        sleep 10
      fi
        /bin/bash "/home/suparious/mine/whattomine.sh"
    else
      echo "==> Time for a change - $current"
      historic=`cat /dev/shm/whattomine`
      wtm_pid=`ps -ef | grep -E "ccminer|excavator|z-enemy|zm" | grep -v grep | awk -F " " '{print $2}' | head -n 1`
      kill $wtm_pid
      sleep 2
      /bin/bash "/dev/shm/whattomine" &
    fi
  done

