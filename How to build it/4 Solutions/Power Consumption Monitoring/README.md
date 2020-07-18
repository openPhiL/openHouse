# Power Consumption Monitoring

![Overview](2020-07-18-00-38-42.png)

## Connect USB Cable to OpenHab

Once plugged in, you can select the drive in the Vmware Esxi's hypervisor Webinterface/client. You need to pass it as a usb device to the Openhab instance. The Stick was detected as a Future Devices FT232R USB UART 

SSH into your openhab Instance and type 

    ls /dev

you should be able to find something like /dev/ttyUSB0. if you unplug it, the entry will disappear, plug it in, it appears. That is your "port". 

PS: There is another method where you do not connect the stick physically to the server but via a device like a raspberry PI connected via Lan/Wifi. 

### Static address for USB Stick

It can happen, that your /dev/ttyUSB0 becomes a /dev/ttyUSB1. To avoid that, we give this USB stick, defined by VendorID and ProductID, a fix static port.
This command will give you the VendorID and the ProductID of all the USB devices behind the selected Port (here: ttyUSB0). One of them is the correct one, others are internal chips. Find the one with product and vendor id posted.

    udevadm info -a -p $(udevadm info -q path -n /dev/ttyUSB0)

Look for the attributes idVendor and idProduct and use that information to create the file

    sudo nano /etc/udev/rules.d/02_WEIDMANN_IR_USB.rules

containing:

    SUBSYSTEM=="tty", ATTRS{idVendor}=="0658", ATTRS{idProduct}=="0200", SYMLINK+="ttyUSB0_WEIDMANN_IR"

You will need to add the port to openhab in file 

    /etc/default/openhab2

and add it to the line of EXTRA_JAVA_OPTS like this (no linebreaks):

    EXTRA_JAVA_OPTS="-Xms250m -Xmx350m -Dgnu.io.rxtx.SerialPorts=/dev/ttyUSB0:/dev/ttyS0:/dev/ttyS2:/dev/ttyACM_Aeotec:/dev/ttyAMA0:/dev/ttyUSB0_WEIDMANN_IP"  


## Install Binding in OpenHAB

See the openhab [documentation](https://www.openhab.org/addons/bindings/smartmeter/) for SmartMeter.

Install Binding with the Paper-UI: Addons->Bindings->SmartMeter

Setup the SmartMeter with the Paper-UI: Configuration-> Plus (+) -> SmartMeter. You need to assign the right serial port that is linked to the USB Stick, a dropdown is available. Select the "port" you found out earlier. (You could disconnect and reconnect it again to see what changes or just try and error your way through) 

You will see the Z-Wave Controller Status turns to "online" if you were right after a couple of seconds.

## Setup Grafana

a grafana.json file is attached to create the picture shown above
