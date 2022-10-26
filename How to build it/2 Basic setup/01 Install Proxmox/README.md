# Install Proxmox with USB

Proxmox is the main operation system of the host that runs all other server by sharing the own hardware virtualized.

## Basic install

1) Download the latest and greated Proxmox ISO from [proxmox.com](https://www.proxmox.com/de/downloads/category/proxmox-virtual-environment)

2) Follow [Instructions](https://pve.proxmox.com/wiki/Prepare_Installation_Media) to create installation media

3) Stick that USB stick in the Proxmox Server and boot from it

4) During install, choose ZFS as a file system, I recommend at least Mirror to have redundancy in case one drive breaks.

5) choose your IP wisely (but you can change that later if you need)

## Enable Networking
in my case, i have 2 NICs, one for LAN and one WAN. 
Per Default, only one is active. That is my LAN. 
To enable WAN, I added a new linux bridge (vmbr1) that I linked to the free NIC (e.g. enp2s0)

## Enable updates

The menu menu updates is to deactivate the enterprise-reposiory and add the no-subscription repository. then update. 

## Enable ZFS snapshots
install zfs-auto-snapshot

    https://github.com/zfsonlinux/zfs-auto-snapshot

that will place cron-files in the /etc/cron* directories . in there, you can define what you when you want to snap and how many you want to keep. 

