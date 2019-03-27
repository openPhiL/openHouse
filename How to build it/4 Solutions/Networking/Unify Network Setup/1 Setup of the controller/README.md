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

in my case, I had to manually do two more things (probably because of the timeout, I only have 512MB Ram):

Autostart the mongoDB service

    sudo systemctl enable mongod

Create a unifi unit override file /etc/systemd/system/unifi.service.d/override.conf

    [Service]
    TasksMax=2048


After a restart, I could reach the cockpit https://10.0.0.5:8443

## Initial setup
It's pretty forward, fill out what the wizard wants to know. 
You can already specify the settings for your wireless network, like SSID and password. skip the guest network, this is documented seperately. 

You can skip the cloud integration if you don't want to manage your devices using their cloud - which i choose not to. 

I then went to the settings :
- Site: set the SiteName and enabled remote logging to 10.0.0.4
- wireless Networks: edit the WLAN group (top right) and enable PMF.
- Admins: and created an account for me. 
- Controller: and set the hostname to unifi_controller

### Adding the devices
on the devices tab, you see all the unifi devices you have in your network that are factory-reset. 
I went over to the pfsense dhcp server and assigned a static IP address for the devices, 10.0.1.0/24, then restarted the AP (power-off/on-method).
Back to the Unify Controller, you can adopt them into your controller with a click on "adopt". 
Once adpted, click on that device for details and if possible, upgrade the firmware. 


## Create certificate
Using pfSense Webinterface->System->Cert Manager->Certificates->Add function, you can create a new server certificate for 10.0.0.5 (unifi_controller). Export the key and cert as well as the crt of the CA and copy them to the unifi_controller /usr/lib/unifi 

ssh into the unifi_controller and run:

    sudo -i
    cd /usr/lib/unifi

    cat unifi_controller.crt openhab.ca.crt > fullchain.crt

    openssl pkcs12 -export -inkey unifi_controller.key -in fullchain.crt -out cert.p12 -name unifi_controller -password pass:temppass

    keytool -importkeystore -deststorepass aircontrolenterprise -destkeypass aircontrolenterprise -destkeystore /var/lib/unifi/keystore -srckeystore cert.p12 -srcstoretype PKCS12 -srcstorepass temppass -alias unifi_controller -noprompt

    rm *.crt
    rm *.key
    rm *.p12

    shutdown -r now

