# Install Proxmox with USB

Proxmox is the main operation system of the host that runs all other server by sharing the own hardware virtualized. 

## Basic install

1) Download the latest and greated Proxmox ISO from [proxmox.com](https://www.proxmox.com/de/downloads/category/proxmox-virtual-environment)

2) Follow [Instructions](https://pve.proxmox.com/wiki/Prepare_Installation_Media) to create installation media

3) Stick that USB stick in the Proxmox Server and boot from it

4) During install, choose ZFS as a file system, I recommend at least Mirror to have redundancy in case one drive breaks.

5) choose your IP wisely (but you can change that later if you need)

## Enable updates

change the source list

    nano /etc/apt/sources.list

and add the following line:

    deb http://download.proxmox.com/debian buster pve-no-subscription

then change the enterprise.list

    nano /etc/apt/sources.list.d/pve-enterprise.list

and comment out the line:

    deb https://enterprise.proxmox.com/debian buster pve-enterprise

Now you can update:

    apt update && apt dist-upgrade -y
