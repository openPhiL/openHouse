## Direct method : connect to pfSense

First, we create 2 Certificates:
- OpenHouse_Pfsense_VPN_Server (Type Server)
- OpenHouse_Pfsense_VPN_Client_PhiL(type Client)

Second, we create a user in menu->system->user Manager->add. Set a name and assign the Certificate you just created. 

Third, we go menu->VPN-openVPN-Wizard and click our way to the guide. Let's go with the local database (for now) to store the users, then I choose my OpenHouseCA and choose the openHouse_pfSense_VPN_Server certificate. 
Here my details, feel free to read the details of the settings in the [manual](https://openvpn.net/community-resources/#articles). It did help me a lot.

![pfSense VPN Server Settings](openVPN_pfsense_Server.png)

- General Settings:
    - TCP port 443
- Cryptographic settings
    - dh:2048
    - encryption Alg.:AES-256-GCM
    - AuthDigest: SHA512
- Tunnel settings
    - tunnel network will be 10.1.0.0/24 (needs to be outside of your internal range).
    - redirect Gatway unchecked
    - local Networks 10.0.0.0/16, 10.1.1.0/24, 10.1.2.0/24
    - Compression: lz4-v2
    - TOS unchecked
    - Inter Client communication checked
    - dublicate Connections checked
- Client settings
    - Dynamic IP checked
    - topology subnet

On the final screens, I checked the option to create the firewall/pfsense Rules for me. In my scenario, I this super-virtualized scenario, I had to do one more step: by default, pfSense does not allow private IP-addresses to connect from the WAN side. But that is what we do here, we have a private network between the public internet and the virtual pfSense Gateway - menu->interfaces->wan and uncheck "Block private networks and loopback addresses".

Finally, we create a package for this PhiL so he can install it and connect remotely. Use the Menu->settings->package manager to install the package "openvpn-client-export". Then Menu->VPN->openVPN->export and scroll down to where you can see a list of users right below the search section and next to it, the install-files for their access into the network. Check the text on the screen if you cannot file it. I download the windows client, a self-extracting 7Zip-Exe and installed it on my computer (the real one that has VMware Player running). Running it will show a taskbar-icon that can "connect" you to your home network. Once connected, you should be able to reach all the webinterfaces for the previously installed instances, e.g. https://10.0.0.1. 
Hint: From now on, you don't need to work in the VMware Client-Stream-Window...

Once we export the virtual pfsense instance to the dedicated server that is connected directly to the internet, we can use that public IP-Address to reach our home network. For that, a DynDNS account is helpful. I have a dedicated documentation [here](../../../DynDNS%20setup). 