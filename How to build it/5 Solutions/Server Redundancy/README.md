# Create a spare Server for redundancy

## step 1: get proxmox up and running on the spare

- Install Promox on new system, name different (e.g. pve2 )
- Install all updates etc.
after this step, you have 2 proxmox server, a main with all the container/vms, and a spare, with no vms.

## step 2: make them friends

- share keys (ssh-copy-id)
- @main create snapshot of all the things with tool zfs-auto-snapshot
- @main send the latest snapshot manually to spare:
   zfs send -R rpool/data@moving | pv | ssh root@10.0.2.11 zfs recv -dvF rpool
- @main copy the container/VM config to spare:  
   scp /etc/pve/nodes/pve2/lxc/108.conf root@10.0.2.11:/etc/pve/nodes/pve1/lxc/108.conf

after this step, both machines have the same container/vms with the same data.

## step 3: keep them friends

    install https://github.com/adaugherity/zfs-backup/blob/master/zfs-backup.sh
    and set parameters in that ssh script, e.g.
    "!/bin/sh
    TAG="zfs-auto-snap_daily"
    PROP="zfs:backup"
    REMUSER="root"
    REMHOST="10.0.2.11"
    REMPOOL="rpool"

run ./zfs-backup.sh -vn to see if it works
Then, add the copy of container/VM configs from step 2 to the zfs-backup script, as well as the script itself, ( probably content of /usr/local/sbin ).
Additionally, we scp a status file to the spare, so it knows we are backing up (and will not shutdown or so)

at this step, everytime you run the zfs-backup, it will find the difference between the last snapshot at target and the last snapshot locally and will copy the difference to the spare, so that the spare is then again up-to-date.

## step 4: they should become available for each other when needed

The main should be able to boot the spare when needed.

### configure the spare

    nano /etc/systemd/system/wol.service

and paste:

    [Unit]
    Description=Configure Wake-up on LAN

    [Service]
    Type=oneshot
    ExecStart=/sbin/ethtool -s enp1s0 wol g

    [Install]
    WantedBy=basic.target

then reboot spare.

### configure the main

    apt install wakeonlan

now, add to the zfs-backup-script that the spare needs to be woken up first

    wakeonlan MACADDRESS 

and use the attached script (pvemonitor_main.sh) to wake up the spare if a machine is not available.

## step 5: controlled booting

I have 2 script (see attachments), one running on main, one on spare that start machines.

main is only booting up machines @boot time, but only if the spare is not running.
crontab is:
    @reboot /usr/local/sbin/pvemonitor_main_boot.sh>>/var/log/pvemonitor_main_boot.log

spare is checking every minute (based on cron) if a machine (somewhere, e.g. on main) is available. if not, it will boot that spare container.
crontab is: 

    */1 * * * * /usr/local/sbin/pvemonitor_spare.sh>>/var/log/pvemonitor.log

## step 6: controlled shutdown

I have a script (see attachment) that is running on the spare.
   pvemonitor_spare_shutdown.sh

it runs ever 20min between 3 and 6 in the morning with this cron

    */20 3-6 * * * /usr/local/sbin/pvemonitor_spare_shutdown.sh>>/var/log/pvemonitor.log
