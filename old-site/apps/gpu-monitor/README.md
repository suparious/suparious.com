## Get power, as a stream
`nvidia-smi stats -i <device#> -d pwrDraw`

## Get power and clocks
`nvidia-smi --query-gpu=index,timestamp,power.draw,clocks.sm,clocks.mem,clocks.gr --format=csv -l 5`

## Grab all the data at once, as a stream
`nvidia-smi --query-gpu=timestamp,index,name,pci.bus_id,driver_version,pstate,pcie.link.gen.max,pcie.link.gen.current,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv -l 5`


## References
- [Useful GPU Queries](https://nvidia.custhelp.com/app/answers/detail/a_id/3751/~/useful-nvidia-smi-queries)

`watch -n 1 "ps -ef | grep -E 'nvidia-smi|nvidia-settings' | grep -v grep"`

`nvidia-settings -q fans | grep fan | awk -F "[()]" '{print $2}' | awk '{print $2}'`

`nvidia-settings -t -q "[fan:8]/GPUTargetFanSpeed"`


```bash
#GPU_ENABLED=(0 1 2 3 4 5)
POWER=200       # Power limit in Watts
MEM=1000         # Memory offset in MHz
GPU=120         # GPU offset in MHz
FAN=80          # Fan speed in %

# I'm too lazy to write a proper function for this
#set +e
#export DISPLAY=:0
ALL_GPUS=$(nvidia-smi | grep GeForce | awk -F " " '{ print $2 }' | tail -n 1)
(( ++ALL_GPUS ))
while (( --ALL_GPUS >= 0 )); do
  nvidia-settings -a "[gpu:$ALL_GPUS]/GPUGraphicsClockOffset[3]=$GPU" -a "[gpu:$ALL_GPUS]/GPUMemoryTransferRateOffset[3]=$MEM"
  nvidia-smi -i $ALL_GPUS -pl $POWER
  nvidia-settings -a "[gpu:$ALL_GPUS]/GPUFanControlState=1"
done
#set -e

# I'm too lazy to write a proper function for this
set +e
#ALL_FANS=$(nvidia-settings -q fans | head -n 2 | grep "Fans" | awk -F " " '{ print $1 }')
ALL_FANS=$(nvidia-settings -q fans | grep fan | awk -F "[()]" '{print $2}' | awk '{print $2}' | tail -n 1)
(( ++ALL_FANS ))
while (( --ALL_FANS >= 0 )); do
  nvidia-settings -a "[fan:$ALL_FANS]/GPUTargetFanSpeed=$FAN"
done
set -e
```

#### Further examples
`https://gist.github.com/squadbox/e5b5f7bcd86259d627ed`