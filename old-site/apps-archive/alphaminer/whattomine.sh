#!/bin/bash
#
# requires:
#	- phantomjs	2.x	(http://phantomjs.org/)
#	- w3m		0.5.x

# configuration
BIN=/home/suparious/mine
AWESOME=macmini:1025/miners/29
CCMINER=/home/suparious/mine/ccminer-DumaxFR
CCMINERYES=/home/suparious/mine/ccminer-yesr16
CCMINERPHI=/home/suparious/mine/ccminer-DumaxFR
ZENEMY=/home/suparious/mine/z-enemy
EXCAVATOR=/usr/bin/excavator
DTSM=/home/suparious/mine/zminer

# output destinations
DUMP=/dev/shm/dump.html
OUT=/dev/shm/out
WTM=/dev/shm/whattomine

# sanitize output destinations
rm $DUMP
rm $OUT

# scrape AwesomeMiner while rendering the javascript
$BIN/phantomjs $BIN/save_page.js http://$AWESOME > $DUMP 

# strip out all the HTML
w3m -dump $DUMP | grep Prioritize -A 6 | grep -n Coin -A 3 > $OUT

# parse out relevant data from the dump
server_url=`grep "6-" $OUT | awk -F "-" '{print $2}'`
worker_name=`grep "7-" $OUT | awk -F ":" '{print $2}'`
pool_name=`grep "5-" $OUT | awk -F " " '{print $1}' | awk -F "-" '{print $2}'`
algo_name=`grep "5-" $OUT | awk -F " " '{print $2}' | tr A-Z a-z | sed -e 's/\[//' | sed -e 's/\]//'`
pass="c=BTC"

# make sure it worked

if [ -z "$worker_name" ]; then
  echo "Fuck! No workers found"
  exit 1
fi

case "$pool_name" in
  TheTechnicals)
	port=`echo $server_url | awk -F ":" '{print $2}'`
	case "$port" in
	  3636)
		algo_name=x16r
		pass="TECH,c=RVN"
		;;
	  3638)
		algo_name=x16r
		pass="TECH,c=XMN"
		;;
	  3640)
		algo_name=x16r
		pass="TECH,c=GRV"
		;;
	  3669)
		algo_name=x16s
		pass="TECH,c=PGN"
		;;
	  3665)
		algo_name=x16s
		pass="TECH,c=RABBIT"
		;;
	  3663)
		algo_name=x16s
		pass="TECH,c=REDN"
		;;
	  4553)
		algo_name=lyra2z
		pass="TECH,c=GIN"
		;;
	  4555)
		algo_name=lyra2z
		pass="TECH,c=MANO"
		;;
	  4559)
		algo_name=lyra2z
		pass="TECH,c=PYRO"
		;;
	  4540)
		algo_name=lyra2rev2
		pass="TECH,c=KREDS"
		pool_name=TT-KREDS
		;;
	  4538)
		algo_name=lyra2rev2
		pass="TECH,c=ABS"
		pool_name=TT-ABS
		;;
	  4533)
		algo_name=lyra2rev2
		pass="TECH,c=ORE"
		pool_name=TT-ORE
		;;
	  4535)
		algo_name=lyra2rev2
		pass="TECH,c=STAK"
		pool_name=TT-STAK
		;;
	  4545)
		algo_name=lyra2rev2
		pass="TECH,c=VTC"
		pool_name=TT-VTC
		;;
	  8332)
		algo_name=phi2
		pass="TECH,c=LUX"
		;;
	  4240)
		algo_name=neoscrypt
		pass="TECH,c=MBC"
		pool_name=TT-MBC
		;;
	esac
	;;
  *)
	;;
esac

# uncomment for debugging
#echo "Pool:$pool_name Algo:$algo_name URL:$server_url Worker:$worker_name"

# build the commandline string
case "$algo_name" in

  neoscrypt|lyra2rev2|lyra2v2)
	echo "Excavating $pool_name with $algo_name"
#	echo "$CCMINER -a $algo_name -o stratum+tcp://$server_url -u $worker_name -p $pass --api-allow=0/0 --api-remote" > $DUMP
	echo "$EXCAVATOR -c $BIN/excavator/$algo_name-$pool_name.json -i 10.2.5.36 -p 4028" > $DUMP
	;;

  x16r|x16s)
	echo "Running for $algo_name"
        echo "$ZENEMY -a $algo_name -o stratum+tcp://$server_url -u $worker_name -p $pass,d=64 --api-allow=0/0" > $DUMP
	;;

  aeriumx|aergo)
	echo "Running for $algo_name"
        echo "$ZENEMY -a aeriumx -o stratum+tcp://$server_url -u $worker_name -p $pass --api-allow=0/0" > $DUMP
	;;

  x17)
	echo "Running for $algo_name"
	echo "$ZENEMY -a $algo_name -o stratum+tcp://$server_url -u $worker_name -p $pass --api-allow=0/0" > $DUMP
	;;

  equihash)
	port=`echo $server_url | awk -F ":" '{print $2}'`
	server=`echo $server_url | awk -F ":" '{print $1}'`
	echo "running for $algo_name"
	if [ "$pool_name" = "NiceHash" ]; then
	  echo "$DTSM --server ssl://$server --port 3$port --user $worker_name" > $DUMP
	else
#	  echo "$CCMINER -a $algo_name -o stratum+tcp://$server_url -u $worker_name -p $pass --api-allow=0/0 --api-remote" > $DUMP
	  echo "$EXCAVATOR -c $BIN/excavator/$algo_name-$pool_name.json -i 10.2.5.36 -p 4028" > $DUMP
	fi
	;;

  lyra2z)
	echo "running for $algo_name"
	echo "$CCMINER -a $algo_name -o stratum+tcp://$server_url -u $worker_name -p $pass,d=18 -i 19 --api-allow=0/0 --api-remote"> $DUMP
	;;

  yescrypt|yescryptr16)
	echo "running for $algo_name"
	echo "$CCMINERYES -a $algo_name -o stratum+tcp://$server_url -u $worker_name -p $pass --api-bind 0.0.0.0:4038"> $DUMP
	;;

  skunkhash)
	echo "running for $algo_name"
	echo "$CCMINER -a skunk -o stratum+tcp://$server_url -u $worker_name -p $pass,d=0.6 --api-allow=0/0 --api-remote" > $DUMP
	;;

  allium|xevan|vit|tribus|timetravel|quark)
	echo "Suck my dick $algo_name, we're doing ravens!"
	echo "$ZENEMY -a x16r -o stratum+tcp://mine.subscriberpool.com:3636 -u RX5J87eCFkP1Dd7RZb7E7qotyYjfB2h573 -p TECH,c=RVN,d=64 --api-allow=0/0" > $DUMP
	;;

  hmq1725)
        echo "running for $algo_name"
        echo "$CCMINER -a $algo_name -o stratum+tcp://$server_url -u $worker_name -p $pass,d=6912 -i 21 --api-allow=0/0 --api-remote" > $DUMP
        ;;

  skein)
	echo "running for $algo_name"
	echo "$CCMINER -a $algo_name -o stratum+tcp://$server_url -u $worker_name -p $pass,d=6 -i 21 --api-allow=0/0 --api-remote" > $DUMP
	;;
  *)
	echo "running for $algo_name"
	echo "$CCMINER -a $algo_name -o stratum+tcp://$server_url -u $worker_name -p $pass --api-allow=0/0 --api-remote" > $DUMP
	;;

esac

cat $DUMP > $WTM
chmod +x $WTM
