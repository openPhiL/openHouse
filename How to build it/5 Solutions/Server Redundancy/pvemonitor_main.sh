#!/bin/bash
date=$(date '+%Y-%m-%d %H:%M:%S')
echo "$date pvemonitor_main.sh started"

value=$(</var/tmp/pve_main2spare_booting_status)
if [[ $value == "booting" ]]
  then
     echo "$date: this system seems to be still booting, cancel observation"
     exit 4
fi

ping -c1 10.0.0.1 > /dev/null
if [ $? -eq 0 ]
  then
    echo "OPNSense(10.0.0.1) available"
  else
    echo "OPNSense(10.0.0.1) seems offline, will start spare"
    /usr/bin/wakeonlan 94:de:80:6e:8f:64
fi

ping -c1 10.0.1.2 > /dev/null
if [ $? -eq 0 ]
  then
    echo "OpenHAB(10.0.1.2) available "
  else
    echo "OpenHAB(10.0.1.2) seems offline, will start spare"
    /usr/bin/wakeonlan 94:de:80:6e:8f:64
fi

ping -c1 10.0.1.4 > /dev/null
if [ $? -eq 0 ]
  then
    echo "TIG(10.0.1.4) available"
  else
    echo "TIG(10.0.1.4) seems offline, will start spare"
    /usr/bin/wakeonlan 94:de:80:6e:8f:64
fi

ping -c1 10.0.1.5 > /dev/null
if [ $? -eq 0 ]
  then
    echo "Shinobi(10.0.1.5) available"
  else
    echo "Shinobi(10.0.1.5) seems offline, will start spare"
    /usr/bin/wakeonlan 94:de:80:6e:8f:64
fi

ping -c1 10.0.0.254 > /dev/null
if [ $? -eq 0 ]
  then
    echo "Unificontroller(10.0.0.254) available"
  else
    echo "UnifiController(10.0.0.254) seems offline, will start spare"
    /usr/bin/wakeonlan 94:de:80:6e:8f:64
fi

ping -c1 10.0.1.6 > /dev/null
if [ $? -eq 0 ]
  then
    echo "FileServer(10.0.1.6) available"
  else
    echo "FileServer(10.0.1.6) seems offline, will start spare"
    /usr/bin/wakeonlan 94:de:80:6e:8f:64
fi

ping -c1 10.0.1.7 > /dev/null
if [ $? -eq 0 ]
  then
    echo "Nextcloud(10.0.1.7) available"
  else
    echo "Nextcloud(10.0.1.7) seems offline, will start spare"
    /usr/bin/wakeonlan 94:de:80:6e:8f:64
fi



exit 0
