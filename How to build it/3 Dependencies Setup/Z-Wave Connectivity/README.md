# Add Z-wave connectivity to OpenHAB

## Hardware

I use the Z-Wave USB Stick from [AEOTEC](https://amzn.to/2UUN67n). It has a build in battery so you can run around the house to each device you may want to go, click on the stick (blue light appears), click on the button of the device(can vary by the device) you want to add to the stick and et voila, device is now "included". (Same process for exclude, you just press the button on the stick a little longer ).

So for starter, I add a couple of [motion sensors](https://amzn.to/2Sp0nYU) and [all plugs](https://amzn.to/2UUiFOI) from Fibaro to my network. I tried others, but I found those performed best.

## Connect Z-Wave USB Stick to OpenHab

Once plugged in, you can select the drive in the Vmware Esxi's hypervisor Webinterface/client. You need to pass it as a usb device to the Openhab instance. The Stick was detected as a SigmaDesignsModem.

SSH into your openhab Instance and type

    ls /dev

you should be able to find something like /dev/ttyACM0. if you unplug it, the entry will disappear, plug it in, it appears. That is your "port".

PS: There is another [method](https://community.openhab.org/t/share-z-wave-dongle-over-ip-usb-over-ip-using-ser2net-socat-guide/34895) where you do not connect the stick physically to the server but via a device like a raspberry PI connected via Lan/Wifi. Have not tried that (yet!)

### Static address for USB Stick

It can happen, that your /dev/ttyACM0 becomes a /dev/ttyACM1. To avoid that, we give this USB stick, defined by VendorID and ProductID, a fix static port.
This command will give you the VendorID and the ProductID of all the USB devices behind the selected Port (here: ttyACM0). One of them is the correct one, others are internal chips. Find the one with product and vendor id posted.

    udevadm info -a -p $(udevadm info -q path -n /dev/ttyACM0)

Use that information to create the file

    sudo nano /etc/udev/rules.d/01_Aeotec_Gen5_USB.rules

containing:

    SUBSYSTEM=="tty", ATTRS{idVendor}=="0658", ATTRS{idProduct}=="0200", SYMLINK+="ttyACM_Aeotec"

Rule-file is attached [here](01_Aeotec_Gen5_USB.rules) and more information are available [there](https://www.openhab.org/docs/administration/serial.html)

## Install Binding in OpenHAB

See the openhab [documentation](https://www.openhab.org/addons/bindings/zwave).

Install Binding with the Paper-UI: Addons->Bindings->Z-Wave

Setup the Controller with the Paper-UI: Configuration-> Plus (+) -> Z-Wave Controlller. You need to assign the right serial port that is linked to the USB Stick, a dropdown is available. Select the "port" you found out earlier. (You could disconnect and reconnect it again to see what changes or just try and error your way through)

You will see the Z-Wave Controller Status turns to "online" if you were right after a couple of seconds.

## Add FIbaro HomeCenter to OpenHAB

I had my issues with the Z-Wave USB Stick as it was not a stable solution. I went with a Fibaro Home Center Lite as a dedicated Controller and have a python script listening to that Gateway and posting changes via REST. Not a perfect solution, but a more stable one. The Python script is attached [here](FibaroHC2OpenHAB.py) and I placed in a folder I created for python scripts: {openhab-conf}/python

Additionally, create a service to have this script running in the background all the time. copy the attached file fibaro2Openhab.service to /lib/systemd/system/fibaro2openhab.service and run the command sudo systemctl enable fibaro2openhab.service

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
7. Dead nodes in your controller

Also nice to know:

- Fibaro devices have build in range tester (only when you have a Fibaro controller).
- you must not have unconfigured devices - they will mess with your system.
- a zwave devices repeats the message when no receive confirmation arrives, up to 3 times. then it dismisses that information.
- too much traffic can cause problems. Check your traffic with a sniffer [info1](https://forum.fibaro.com/topic/29923-tutorial-z-wave-diagnostics-with-pc-controller-and-zniffer/?tab=comments#comment-147847), [info2](https://forum.fibaro.com/files/file/184-z-wave-monitor/)
- be careful adding completely new stuff as they might mess up your stable environment. Analysing their behavior in a test environment is recommended.

## Backup of the Stick

If the stick breaks, you will lose control over your network. I therefore ought to get a backup stick that I can copy the backup to (clone it). The details are described in the manual of your stick, I have attached the manuals of my [AEOTEC](https://amzn.to/2UUN67n)-Stick.
