#! /bin/bash
date=$(date '+%Y-%m-%d %H:%M:%S')
hostname=$(hostname)

container=()
for file in /etc/pve/nodes/$hostname/lxc/*
do
   if [[ $file =~ .*\/lxc\/(.*).conf ]]
    then
      container+=(${BASH_REMATCH[1]})
    else
     echo "$date failed tp read lxc folder for container"
     exit
   fi
done

vms=()
for file in /etc/pve/nodes/$hostname/qemu-server/*
do
   if [[ $file =~ .*\server\/(.*).conf ]]
    then
      vms+=(${BASH_REMATCH[1]})
    else
     echo "$date failed tp read qemu-server folder for vm's"
     exit
   fi
done



value=$(</var/tmp/pve_main2spare_backupscript_status)
if [[ $value == "running" ]]
  then
     echo "$date: backup seems to be still running, cancel shutdown"
     exit 4
fi


for i in "${container[@]}"
do
    output=$(/usr/sbin/pct status $i)
    if [[ $output == "status: stopped" ]]
       then
         echo "$i ab"
       else
         echo "$i an - fahre nicht runter"
         exit 0
    fi
done

for i in "${vms[@]}"
do
    output=$(/usr/sbin/qm status $i)
    if [[ $output == "status: stopped" ]]
       then
         echo "$i ab"
       else
         echo "$i an - fahre nicht runter"
         exit 0
    fi
done

/sbin/shutdown -h now
