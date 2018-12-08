## Create a virtual Instance for the controller
 I will create a new ubuntu live server instance with 1cpu, 512MB Ram and 8GB of space. 
- VMWare Hypervisor's Webinterface -> Virtual Machines->Create->new..
- Choose the ISO-File for the Ubuntu 18.04 live-server as the CDROM source and finish setup.
- Start the VM
- There is nothing to configure, just head through and wait for the install to be completed. 

On the pfSense Webinterface->menu->Status->DHCP Leases, I use the plus sign next to the IP address of the unifi_controller we just created and set a fixed new IP (10.0.0.5) together with some descriptions. 

Ssh into that server and run 

    *sudo apt-get update && apt-get dist-upgrade -y*

    sudo shutdown -r now
once you can connect to it again, follow [those instructions](https://community.ubnt.com/t5/UniFi-Wireless/UniFi-Installation-Scripts-UniFi-Easy-Update-Scripts-Ubuntu-18/td-p/2375150) with his script to install the controller. It will pause for about 5-10min somewhere in the script that made me nervous, but finished successfully. 

in my case, I had to manually do two more things:

Autostart the mongoDB service

    sudo systemctl enable mongod

Create a unifi unit override file /etc/systemd/system/unifi.service.d/override.conf

    [Service]
    TasksMax=2048


After a restart, I could reach the cockpit https://10.0.0.5:8443