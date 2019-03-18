# Prepare Guest-Network in pfSense
Guests should not have access to anything in the LAN, but should be able to connect to the internet. We add a VLAN "Guest VLAN" for that purpose on the pfSense: ->menu->interfaces->assignment->VLAN using a number (e.g.10) and a Priority (0 = low Priority) on parent "LAN".

We then add this VLAN as an interface in the tab interface assignments and configure it to be enabled, name GuestVLAN and to use a static IP (192.168.0.1/20). 

FInally, we go to Menu->Services->DHCP-Server and choose the Tab GuestVLAN and enable a DHCP Server for the full availbale range. If we now connect anything to the VLAN 10, they will become guests. 

# Define Guest-Network in the unifi controller
Go to the admin interface of the unifi controller->settings-Wireless networks and create a new wireless network. in the details:
- enable it, 
- make it WPA personal, give a passcode (optional)
- leave block Lan to WLAN Multicasts unchecked - chromecast needs that
- set the vlan to 10
- check hide SSID




# Create Guest-Network-App in OpenHab
## create barcodes for wifi access
ssh into the openhab server and install the barcode generator

    sudo apt install qrencode -y

To generate a barcode that let devices directly use that as wireless network credetials, the string you need to encode is: 

    WIFI:T:WPA;S:mynetwork;P:mypass;;


Parameter and their Example	Description
- T: WPA	Authentication type; can be WEP or WPA, or 'nopass' for no password. Or, omit for no password.
- S: mynetwork	Network SSID. Required. Enclose in double quotes if it is an ASCII name, but could be interpreted as hex (i.e. "ABCD")
- P: mypass	Password, ignored if T is "nopass" (in which case it may be omitted). Enclose in double quotes if it is an ASCII name, but could be interpreted as hex (i.e. "ABCD")
- H: true	Optional. True if the network SSID is hidden.

.

    Order of fields does not matter. Special characters "", ";", "," and ":" should be escaped with a backslash ("") as in MECARD encoding. For example, if an SSID was literally "foo;bar\baz" (with double quotes part of the SSID name itself) then it would be encoded like: WIFI:S:\"foo\;bar\\baz\";;

so this statement would generate a picture to access your guest network and stores it to be accessed via http://10.0.0.3/statics/guestwifi_barcode.png


    qrencode "WIFI:S:theSSIDofGuest;T:WPA;P:YourPasscode;true;" -o /etc/openhab2/html/guestwifi_barcode.png