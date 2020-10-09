# Overview
(U)ninterruptible (p)ower (s)upply will keep your hardware safe from power outtages or surges. I went with [this one](https://amzn.to/2Pp9McD). The idea is to have all important devices plugged in there and in case your power goes down, all your plugged in components stay powered on for a couple more minutes. Either enough until power is back on or until everything has been shut down safely. 

This devices gives me 4 ports with backup power and 4 more with surge protection. 

    Battery Backup   |---|   Surge Protection
      Vmware Server  -- --   Philips Hue Bridge
       Synology NAS  -- --     Homematic CCU
        Switch 1     -- --        Modem 
        Switch 2     -- --      don't know yet...
                     |---|

# Connectivity
(work in progress):

either: [Synology is required as the APC UPS is connected via USB to a synology and that synology acts as a NUT-Server](https://www.synology.com/de-de/knowledgebase/DSM/help/DSM/AdminCenter/system_hardware_ups)

or: [pfSense is acting as the NUT server and Synology is listening](https://blog.bloy.at/?p=2394)

or: [extra VMware Instance running the NUT server.](http://rene.margar.fr/2012/05/client-nut-pour-esxi-5-0/#more-938)



# Installation of the PowerChuting Network software
(My UPS does not have an ethernet ready NIC, so I don't need that, but maybe you do:)

Download OVF here: https://www.apc.com/us/en/tools/download/

Once started, accept the license, create a user and define the root password before you continue.

You will be asked to visit the wizard-website. Do there and select single VM Host. When asked for a username and password, pause and visit the hypervisor's webinterface to create a user.
menu->Manage->security->roles->add role: "PowerChuting": follow [those instructions](https://www.schneider-electric.com/resources/sites/SCHNEIDER_ELECTRIC/content/live/FAQS/177000/FA177822/en_US/FA177822-PCNS_PermissionsVMware.pdf?_ga=2.34053605.553889525.1544020654-1110060220.1543756313)

menu->Host->action->permissions->add User: PowerChute with role "powerchuting" and a password. 
