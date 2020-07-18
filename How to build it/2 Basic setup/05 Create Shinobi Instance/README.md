# Install Shinobi Instance

Shinobi is a free Software to view and record IP Cameras with an API than can be used in various other applications (like Openhab)

## Create a new Container

Click on CreateCT and choose the ressource as you please.
Select Ubuntu as your template

![Wizard](2020-07-17-22-34-06.png)

I use those settings:

![Settings](2020-07-17-23-01-00.png)

### Add static IP to Proxmox

With the MAC address of your created Network, you can go to OPNSense WebGUI -> Services -> DHCPv4 and add an entry to assign a fixed IP address to this instance

### Update the container

Once we logged into the newly created Ubuntu container, update everything:

    update all packages with the command *sudo apt-get update && sudo apt-get upgrade -y* 

### Add a user

if the username equals your windows user, you can ssh into the system more easy.

    adduser phil
    usermod -aG sudo phil 
    mkdir /home/phil/.ssh

### Add SSH keys

you don't need username and passwords to ssh into this server if a user exists with the same name as your windows user and if your ssh-id/key is known to the server. We can simply copy it using:

    scp .ssh/id_rsa.pub root@<ip_of_instance>:~/.ssh/authorized_keys

## Install Shinobi

See Installation [here](https://shinobi.video/docs/start)

Shortcut:

    bash <(curl -s https://gitlab.com/Shinobi-Systems/Shinobi-Installer/raw/master/shinobi-install.sh)
