# General discussion: Home Automation setup
There are multiple ways how to start a home automation project, this openHouse project is just one approach. I personally didn't start home automation that structured, I was more playing around until it got messy. I had a Raspberry Pi in the beginning. And then 2.. and then 5.. 

Now, builing a house automation from scratch, I want/need to focus on a more transparent and professional approach. I choose OpenHAB mostly because of my years of experience with it and the open Source approach with it's big community. 

OpenHAB can be installed in many ways on many different devices or operating systems. 
For this project, I had narrowd my choices down to 2 different plattforms/solutions:
## Solution 1: Everything is installed on Raspberry Pi(s).
You have a Raspberry Pi for each major service. For example, one Raspberry Pi using Openhabian, with Grafana, NodeRed, ChatBot etc. installed, and another Raspberry Pi with OpenVPN and PFSense. And then a windows machine running VisualCode and other tools to work on Openhabian and it's components (e.g. z-wave cloner). And maybe one for local GitLab to trace every change.
A regular job runs a DD command to clone the SD Card to a NAS and in case something breaks, a backup SD card is written with the latest backup or a backup Raspberry Pi is pulled out of the drawer and everything is back running again. 
Sidenote: I tried the amanda solution but really didn't like it, and for my scenario, I don't need to backup the configuration when I can backup the whole SD card. I also looked into outsourcing the SD card to the NAS to avoid SD Card issues, ( [Tutorial1](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/net_tutorial.md) ,
[Tutorial2](https://developer-blog.net/raspberry-pi-ueber-das-netzwerk-booten/) ), but that just shifts the problem from SD failure to NAS failure, which is rare yes, but has way more consequences and is not fixed in hours, and I have no experience in running an important system over a network with the possible downsides.

### Advantages: 
- Easy and cheap setup that can be replaced quickly because identical hardware is cheap.
### Disadvantages: 
- I read the SD-Cards are not that reliable, so that will happen more often that I like
- Performance is not the best, it"s a raspberry. 

## Solution 2: Everything is virtualized
8 years ago, I bought a celeron headless Celeron 1500U with 8Gb of ram and its running VMware hypervisor on it. 24/7 since then (on WD back 2,5" HDD!), besides some downtimes when I moved between cities or moved from the states back to Germany. I have instances running for Mail (Zimbra), Windows, I had a NAS, PFSense and OpenVPN Access server, and this was my play-area since I started with OpenHAB in 2013 or so. 
For the given scenario, I create an instance for each major service, like Openhab is one instance, PFsense is another etc. All services (expect the synology-NAS, which I love as it is) would be virtual running on that machine. The windows instance has Veeam running to backup all VMs regularily to the NAS. 
In case the VM breaks, I can start up any one of my computer (e.g. my old lenovo Thinkpad T410) and run all VMs from there using VMware Workstation. In case any Instance breaks (probably miss-configuration while playing), I can revert the changes using those backups or snapshots which I normally do before touching an instance. 

### Advantages: 
- Performance is great
- Realiable hardware
- Hardware can upgrade in the future without touching the software
- x86/x64 architecture vs ARM
### Disadvantages: 
- Expensive
- Single point of failure

## Conclusion
If you are running OH on a Raspberry Pi and have a second raspberry Pi in your drawer, and you develop and control the OpenHAB device from a dedicated laptop, than you have a decent concept from a backup and development perspective and you can react quickly in case something breaks.
If you change things, you would just try it out in the productive environment and if it didn't work out at the end, you will reverse to the last clone. Assuming Raspberry Pi 4 is backwards compatible, you can even upgrade on performance. 

For me, I will choose the virtual solution. In case software or hardware breaks, I can get back to a working system fast too. Additionally, I have big performance benefits over the raspberry Pi and from experience, those VMs do not fail me. With that many services on my network and in my basement to play with, I will have that VMware Server anyway and see no reason not to use that for the OpenHab work.