# Remote Access

Let's create a VPN Server on the pfSense instance, so we can use any computer or mobile phone to access our home environment even if we are not home. This will also be helpful in the all-virtualized-setup-phase because you don't have to solely use this hypervisor's webinterface to access the different server/websites through the Ubuntu machine. 

Eventually, I have a redundant connection using a [direct connection method](../../direct%20method) with an [indirect connection method](../../indirect%20method) as a fallback. The fallback option comes in handy in cases where I cannot connect directly to my home network, due to network restrictions on the location where I am or to provider restrictions/natting (shared ipV4) or anything. It is slower though, hence: fallback...