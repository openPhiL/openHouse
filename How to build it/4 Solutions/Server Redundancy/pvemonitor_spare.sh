#!/bin/bash
date=$(date '+%Y-%m-%d %H:%M:%S')
echo "$date pvemonitor_spare.sh started"


ping -c1 10.0.2.12 > /dev/null
if [ $? -eq 0 ]
  then
    echo "$date ping PVE2(10.0.2.12) available"
  else
    echo "$date PVE2(10.0.2.12) it not available"
    exit 0
fi

ping -c1 10.0.0.1 > /dev/null
if [ $? -eq 0 ]
  then
    echo "$date OPNSense(10.0.0.1) available"
  else
    echo "$date OPNSense(10.0.0.1) seems offline, will start spare"
    /usr/sbin/qm start 100
fi

ping -c1 10.0.1.2 > /dev/null
if [ $? -eq 0 ]
  then
    echo "$date OpenHAB(10.0.1.2) available "
  else
    echo "$date OpenHAB(10.0.1.2) seems offline, will start spare"
    /usr/sbin/pct start 101
fi

ping -c1 10.0.1.4 > /dev/null
if [ $? -eq 0 ]
  then
    echo "$date TIG(10.0.1.4) available"
  else
    echo "$date TIG(10.0.1.4) seems offline, will start spare"
    /usr/sbin/pct start 102
fi

ping -c1 10.0.1.5 > /dev/null
if [ $? -eq 0 ]
  then
    echo "$date Shinobi(10.0.1.5) available"
  else
    echo "$date Shinobi(10.0.1.5) seems offline, will start spare"
    /usr/sbin/pct start 103
fi

ping -c1 10.0.0.254 > /dev/null
if [ $? -eq 0 ]
  then
    echo "$date Unificontroller(10.0.0.254) available"
  else
    echo "$date UnifiController(10.0.0.254) seems offline, will start spare"
    /usr/sbin/pct start 104
fi

ping -c1 10.0.1.6 > /dev/null
if [ $? -eq 0 ]
  then
    echo "$date FileServer(10.0.1.6) available"
  else
    echo "$date FileServer(10.0.1.6) seems offline, will start spare"
    /usr/sbin/pct start 105
fi

ping -c1 10.0.1.7 > /dev/null
if [ $? -eq 0 ]
  then
    echo "$date Nextcloud(10.0.1.7) available"
  else
    echo "$date Nextcloud(10.0.1.7) seems offline, will start spare"
    /usr/sbin/pct start 106
fi



exit 0