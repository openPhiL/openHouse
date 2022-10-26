# Install Shinobi Instance

Shinobi is a free Software to view and record IP Cameras with an API than can be used in various other applications (like Openhab)

## Create a new Container

Click on CreateCT and choose the ressource as you please.
Select Ubuntu as your template 
and give it 2GB of Ram (we will reduce that later).

### Add static IP to Proxmox

With the MAC address of your created Network, you can go to OPNSense WebGUI -> Services -> DHCPv4 and add an entry to assign a fixed IP address to this instance.
Reboot.

### Update the container

Once we logged into the newly created Ubuntu container, update everything:

    update all packages with the command *sudo apt-get update && sudo apt-get upgrade -y* 

### Add a user

if the username equals your windows user, you can ssh into the system more easy.

    adduser phil
    usermod -aG sudo phil 
    mkdir /home/phil/.ssh
    chown phil:phil /home/phil/.ssh

### Add SSH keys

you don't need username and passwords to ssh into this server if a user exists with the same name as your windows user and if your ssh-id/key is known to the server. We can simply copy it using:

    scp .ssh/id_rsa.pub phil@<ip_of_instance>:~/.ssh/authorized_keys

## Add USB-Device to the Container

See this link [here](https://coldcorner.de/2018/07/12/proxmox-usb-passthrough-fuer-lxc-container-z-wave-uzb1/)

for me, this was on the proxmox cli:

    cd /etc/pve/nodes/pve2/lxc/
    nano 116.conf

pasted this:

    lxc.cgroup.devices.allow: c 189:* rwm
    lxc.mount.entry: /dev/bus/usb/001/005 dev/bus/usb/001/005 none bind,optional,create=file
    lxc.mount.entry: /dev/bus/usb/001/006 dev/bus/usb/001/006 none bind,optional,create=file
    lxc.cgroup.devices.allow: c 166:* rwm
    lxc.mount.entry: /dev/ttyACM0 dev/ttyACM0 none bind,optional,create=file
    lxc.mount.entry: /dev/ttyUSB0 dev/ttyUSB0 none bind,optional,create=file

and afterwards, executed:

    udevadm trigger
    
## Install the software

SSH into the container and install:

I choose this way: [manual](https://zwave-js.github.io/zwavejs2mqtt/#/getting-started/quick-start?id=nodejs-or-pkg-version)


sudo apt install curl unzip
mkdir zwavejs2mqtt
cd zwavejs2mqtt
# download latest version
curl -s https://api.github.com/repos/zwave-js/zwavejs2mqtt/releases/latest  \
| grep "browser_download_url.*zip" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -
unzip zwavejs2mqtt-v*.zip
./zwavejs2mqtt

"TODO: Add service to start with boot