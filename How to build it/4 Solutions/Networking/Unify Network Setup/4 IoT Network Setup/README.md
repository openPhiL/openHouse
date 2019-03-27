# Prepare IoT-Network in pfSense
IoT Devices should not have access to anything in the LAN and are in general not connected to the internet as well. Your Philips Hue Bridge for example is checking several times per minute back to the philips servers. We add a VLAN "IoT VLAN" for that purpose on the pfSense: ->menu->interfaces->assignment->VLAN using a number (e.g.20) and a Priority (0 = low Priority) on parent "LAN".

We then add this VLAN as an interface in the tab interface assignments and configure it to be enabled, name GuestVLAN and to use a static IP (172.16.0.1/22). 

FInally, we go to Menu->Services->DHCP-Server and choose the Tab IoTVLAN and enable a DHCP Server for the full availbale range. If we now connect anything to the VLAN 20, they will become IoTs. 

# Define IoT-Network in the unifi controller
Go to the admin interface of the unifi controller->settings-Wireless networks and create a new wireless network. in the details:
- enable it, 
- make it WPA personal, give a passcode 
- leave block Lan to WLAN Multicasts unchecked
- set the vlan to 20
- check hide SSID

# Define IoT Network
Go to the admin interface of the unifi controller->settings->Networks and create a IoT_VLAN. In the details:
- VLAN only
- VLAN 20
- Enable DHCP guarding 172.16.0.1


