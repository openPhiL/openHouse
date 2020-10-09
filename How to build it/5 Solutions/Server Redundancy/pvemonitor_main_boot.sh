#!/bin/bash
date=$(date '+%Y-%m-%d %H:%M:%S')
echo "$date pvemonitor_main_boot.sh started"

echo "booting">/var/tmp/pve_main2spare_booting_status

ping -c1 10.0.2.11 > /dev/null
if [ $? -eq 0 ]
  then
    echo "ping PVE2(10.0.2.12) available"
    echo "spare has booted, will not start machines"
    exit 0
  else
    echo "PVE2(10.0.2.12) it not available, booting the machines"
fi
echo "booting OPNSense (100)"
/usr/sbin/qm start 100
sleep 60s

echo "booting TIG(102)"
/usr/sbin/pct start 102
sleep 30s

echo "booting UnifiController(104)"
/usr/sbin/pct start 104

echo "booting Shinobi (103)"
/usr/sbin/pct start 103

echo "booting FileServer(105)"
/usr/sbin/pct start 105

echo "booting Nextcloud(106)"
/usr/sbin/pct start 106

echo "booting OpenHab(101)"
/usr/sbin/pct start 101

echo "running">/var/tmp/pve_main2spare_booting_status

exit 0