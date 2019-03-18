## Create OpenHAB Instance
Finally, we can add OpenHAB by creating a new Virtual Instance of Ubuntu Server(16.04) - we don't need the desktop version. Move the Iso to the Datastore as earlier and create a new instance with 2 core, 3048MB ram, 16GB HDD and one network adapter linked to LAN. The installation is very simple, I didn't define or changed anything, but there is a general [tutorial available](https://tutorials.ubuntu.com/tutorial/tutorial-install-ubuntu-server-1604#0). 

Once booted, I:
- update all packages with the command *sudo apt-get update && sudo apt-get upgrade -y* 
- install the SSH server using the command *sudo apt-get install openssh-server -y*. 
- follow [those steps](https://www.openhab.org/docs/installation/openhabian.html#manual-setup) to get openhabian installed
- use the commandline tool *sudo openhabian-config* to "Apply improvements"
- use the commandline tool *sudo openhabian-config* to install "OpenHab related" options and choose nginx as reverse proxy. I don't need user/pwd, but I want HTTPS by "IP". In my case, the "IP" that was assigned was the public one, which does not work for me. This is quickly changed in the file /etc/nginx/sites-enabled/openhab . Afterwards, restart the ngnix server using "sudo service nginx restart", and you can access openhab using http(s)://10.0.0.3 (without the port 8080)

### Autostart with Vmware Hypervisor
In the hypervisor's webinterface->Manage->Autostart, you can define that with the VMware Server, all instances will turn on automatically as well. Verify that they all start automatically when the host VM (esxi) starts. pfSense should boot first. 