# Home Automation - Base setup
To get started, you don't need any money or hardware, except a computer with around 8GB Ram. We will build all instances and the network virtually within one Virtual Machine running on that PC.

We will install everything using VMwares "virtual player" and run a virtual server inside it. On this virtual server, we virtualize the network infrastructure using a virtual pfSense instance(does things like managing Certificates, DHCP, Firewall and OpenVPN etc.), we will also set up a virtual Desktop PC (as our development machine that we can connect to from any device we want ) and we will create a virtual OpenHab instance (the brain of the house). After all that is done we eventually backup all those server to a real NAS (not virtualized though) to eventually restore those backups on a dedicated hardware that is then running 24/7.

This documentation goes through the process of creating all software compontents that are needed to get started. It works best top to bottom and step by step and will take approx. 1-2 hours.


Once you made it though all the steps, you have "one" virtual machine that represents a big part of the software in your home automation scenario in your home network. If you feel it to be a "slower than expected" I too think so, remember, that are multiple virtual layers inside your regular windows OS. But once those VMs were uploaded to a dedicated VMware hypervisor hardware, it becomes very smooth and performant, I promise :)

But that was just the beginning, to warm up they say. After the base setup, you can choose (more or less) freely what features/components you want to add to your home network. If dependencies occure, I hope I will mention that. I guess a good starting point from here on are any of those options:




