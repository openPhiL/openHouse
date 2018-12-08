## Prepare Guest-Network in pfSense
Guests should not have access to anything in the LAN, but should be able to connect to the internet. We add a VLAN "Guest VLAN" for that purpose on the pfSense: ->menu->interfaces->assignment->VLAN using a number (e.g.10) and a Priority (0 = low Priority) on parent "LAN".

We then add this VLAN as an interface in the tab interface assignments and configure it to be enabled, name GuestVLAN and to use a static IP (192.168.0.1/20). 

FInally, we go to Menu->Services->DHCP-Server and choose the Tab GuestVLAN and enable a DHCP Server for the full availbale range. If we now connect anything to the VLAN 10, they will become guests. 

## Define Guest-Network in the unifi controller
(Work in Progress)