## Hardware
I use the Z-Wave USB Stick from [AEOTEC](https://amzn.to/2UUN67n). It has a build in battery so you can run around the house to each device you may want to go, click on the stick (blue light appears), click on the button of the device(can vary by the device) you want to add to the stick and et voila, device is now "included". (Same process for exclude, you just press the button on the stick a little longer ). 

So for starter, I add a couple of [motion sensors](https://amzn.to/2Sp0nYU) and [all plugs](https://amzn.to/2UUiFOI) from Fibaro to my network. I tried others, but I found those performed best. 

## Connect Z-Wave USB Stick to OpenHab
Once plugged in, you can select the drive in the Vmware Esxi's hypervisor Webinterface/client. You need to pass it as a usb device to the Openhab instance. The Stick was detected as a SigmaDesignsModem. 

SSH into your openhab Instance and type "ls /dev", you should be able to find something like /dev/ttyACM0. if you unplug it, the entry will disappear, plug it in, it appears. That is your "port". 

PS: There is another method where you do not connect the stick physically to the server but via a raspberry connected via Lan/Wifi. 

## Install Binding in OpenHAB

See the openhab [documentation](https://www.openhab.org/addons/bindings/zwave).

Install Binding with the Paper-UI: Addons->Bindings->Z-Wave

Setup the Controller with the Paper-UI: Configuration-> Plus (+) -> Z-Wave Controlller. You need to assign the right serial port that is linked to the USB Stick, a dropdown is available. Select the "port" you found out earlier. (You could disconnect and reconnect it again to see what changes or just try and error your way through) 

You will see the Z-Wave Controller Status turns to "online" if you were right after a couple of seconds.


## Z-Wave Networking

### Z-Wave Network Topology
A good Article for understanding the Z-Wave Network can be found [here](https://www.vesternet.com/resources/technology-indepth/understanding-z-wave-networks/).


### Z-Wave Network Healing
A good article about Network healing is made by CHris Jackson from his OpenHab's Addon "HABmin" and can be found [here](https://github.com/cdjackson/HABmin/wiki/Z-Wave-Network-Healing)

### General tips
See this [blog](https://drzwave.blog/2017/01/20/seven-habits-of-highly-effective-z-wave-networks-for-consumers/) for a nice overview of how to care about your network. 
1. Minimize Polling
2. Have enough devices to create a mesh
3. Place the hub in a central location
4. Heal the Network
5. If a device doesn’t pair, first exclude it, then include it
6. Battery life and how to maximize it
7.  Dead nodes in your controller


## Backup of the Stick
If the stick breaks, you will lose control over your network. I therefore ought to get a backup stick that I can copy the backup to (clone it). The details are described in the manual of your stick, I have attached the manuals of my [AEOTEC](https://amzn.to/2UUN67n)-Stick.

