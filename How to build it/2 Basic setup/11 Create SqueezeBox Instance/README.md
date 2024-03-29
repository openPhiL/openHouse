# Install Squeezebox Instance

Squeezebox is a multimedia-server that can contain your audio as well as coordinates what sounds is played on what devices.

## Create Container

Click on CreateCT and choose the ressource as you please. Select Ubuntu as your template

![Wizard](2020-07-17-22-34-06.png)

I use those settings:

![Setup](2020-07-24-17-51-03.png)

### Add static IP to Proxmox

With the MAC address of your created Network, you can go to OPNSense WebGUI -> Services -> DHCPv4 and add an entry to assign a fixed IP address to this instance

### Update the container

Once we logged into the newly created Ubuntu container, update everything:

```bash
sudo apt-get update && sudo apt-get upgrade -y

```

### Add a user

if the username equals your windows user, you can ssh into the system more easy.

```bash
adduser phil
usermod -aG sudo phil
mkdir /home/phil/.ssh
chown phil:phil /home/phil/.ssh
```

### Add SSH keys

you don't need username and passwords to ssh into this server if a user exists with the same name as your windows user and if your ssh-id/key is known to the server. We can simply copy it using:

```bash

scp .ssh/id_rsa.pub root@<ip_of_instance>:~/.ssh/authorized_keys

```

## Prepare Squeezebox Instance

find the squeezebox install package (.deb) on google and copy the link.
ssh into the Squeezebox server and:

```bash
wget link
```

this will get you the "file".

make a snapshot/backup

```bash
sudo dpkg -i "file"
```

this will fail with dependencies. Note down those dependencies, in my case, those packages were missing:

now rollback and install those dependencies before installing logitech media server

```bash
apt install perl
apt install libio-socket-ssl-perl
```

and then :

```bash
sudo dpkg -i "file"
```

Next, we need to have some folders to play from:

```bash
sudo mkdir /media/music
sudo mkdir /media/playlists
sudo chmod 775 /media/*
```

The idea is to keep music in the NextCloud, so we mount the Nextcloud music folder to a local drive that Squeezebox can mount. In Proxmox, we have to load something that I don't understand, but its needed (as root)

```bash
    mknod -m 666 /dev/fuse c 10 229
```

and then, we can do

```bash
    sudo apt-get install davfs2
```

Answer with yes, or repeat with this:

```bash
    sudo dpkg-reconfigure davfs2 # interaktiv
    sudo chmod u+s /usr/sbin/mount.davfs # direkt
```

```bash
    sudo nano /etc/davfs2/secrets
    https://nextcloud/remote.php/webdav/Musik enteruser enterpasswort
```

now we need a little script to mount the nextcloud drive at boot. cannot use fstab because we need this mknod from above, so let's put everything in a script:

```bash
nano /usr/local/sbin/mount_webdav_nextcloud.sh
```

content:

```bash
#!/bin/bash
mknod -m 666 /dev/fuse c 10 229
echo y | mount -t davfs https://nextcloud/remote.php/webdav/Musik /media/music
```

and create the cron

```bash
sudo crontab -e

@reboot /usr/local/sbin/mount_webdav_nextcloud.sh
```

ps: you can transfer some audia files directly with the command

```bash
scp * phil@10.0.1.10:/media/music
```

and now your done. Go to url ( <http://10.0.1.10:9000/> ) and start setting it up
