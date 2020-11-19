# Enable AutoSnapshots and create some Backups

## ZFS can do Snapshots

Having multiple snapshots created, for example, every hours, once a day etc, brings the possibility to restore any container/vm to an old version of itself. 
During proxmox installation, you (hopefully) chose ZFS as your file system. This enables you to create/manage snapshots/backups in a very convinient way.

a good video is available [here](https://www.youtube.com/watch?v=fqxMH_os1zk).

## Install ZFS-Auto-Snapshot

Check the [github repository](https://github.com/zfsonlinux/zfs-auto-snapshot)

    wget https://github.com/zfsonlinux/zfs-auto-snapshot/archive/upstream/1.2.4.tar.gz
    tar -xzf 1.2.4.tar.gz
    cd zfs-auto-snapshot-upstream-1.2.4
    make install

## Install ZFS-Backup

    install https://github.com/adaugherity/zfs-backup/blob/master/zfs-backup.sh
    and set parameters in that ssh script, e.g. 
    "!/bin/sh 
    TAG="zfs-auto-snap_daily"
    PROP="zfs:backup"
    REMUSER="root"
    REMHOST="10.0.2.11" #the target system for your backups
    REMPOOL="rpool"
    
    run ./zfs-backup.sh -vn to see if it works

## Manual setup of Snapshots

You can create Snapshots of any container/VM by clicking on the Snapshot button inside an instance.

## Manual setup of Backups

You can create backup jobs in proxmox WebGui -> Datacenter -> Backup. You can backup to an SMB server. If you backup to the SMB Server on the same proxmox host (FileServer Instance), make sure you backup that FileServer to a seperate machine as well.


##todo: 
wenn es nicht existiert:  zfs send -R rpool/data/subvol-107-disk-0@zfs-auto-snap_daily-2020-10-30-1437 | ssh root@10.0.2.11 zfs recv -dvF rpool
zum aktualisieren:  zfs send -I zfs-auto-snap_daily-2020-10-30-1437 -R rpool/data/subvol-107-disk-0@zfs-auto-snap_daily-2020-10-30-1508 | ssh root@10.0.2.11 zfs recv -dvF rpool