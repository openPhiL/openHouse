## Setup of pfSense
We can now connect to the pfSense webinterface (http://10.0.0.1 ) from that virtual ubuntu Desktop from within the hypervisor's webinterface->Virtual Machines->Ubuntu. It will go to the setup wizard, if not, do that yourself using menu->setup wizard. Network related settings are already done and can be skipped/next, set timezone and password and so on. This will also initialize some firewall rules so that LAN can communicate to WAN. 

in the Menu->Services->DHCP Server, you can specifiy details on what IP-addresses are assigned. My subnet is 10.0.0.0, and I define a range 10.0.10.1 to 10.0.19.254 for DHCP clients. I will assign IP Addresses staticly as much as possible, for the rest, it will be 10.0.10-19 then..

## Manage IP-Addresses
My logic for IP address is like that:
    - 10.0.0.0/24 for all Server     
    - 10.0.1.0/24 for all Clients
    - 10.0.10.0/24 for all unassigned DHCP clients
    - 10.0.20.0/24 for all IoT devices
    - 10.1.0.0/24 for the direct VPN clients
    - 10.1.1.0/24 for the VPN tunnel
    - 10.1.2.0/24 for the indirect VPN clients

If you assign static IP addresses directly within the instances (openhab etc), they will *not* be routed/reachable if you try it as a VPN client (took me 2 days to figure that one out). So we manage and assign the IPs using pfSense centrally:
- menu->status->dhcp leases: the little white plus box on the right gives you the option to use a static IP for the chosen instance(mac-address). 
    - 10.0.0.1 is reserved and used for pfSense
    - 10.0.0.2 will be the Hypervisor
    - 10.0.0.3 will be OpenHAB
    - 10.0.1.1 will be Ubuntu