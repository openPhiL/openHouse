# Backup and Restore Functions

Nearly done. Now Let's talk about backup and restore. We need some space somewhere to store the backup. I will use my (real, not virtual) Synology for that. There, I created a new shared folder named "VMWare_Backups" on a non-redundant volumne(I don't need backups of backups I say) and activated NFS access by IP-address of this virtual machine on the NFS-permissions tab within the Synology. 

Using the hypervisor's webinterface->Storage->create new data storage, I used those information to add the NAS-drive to the VMWare Server, I called it "VMWare_Backups". PS: Do not use special characters nor spaces in the name of the Storage, even if you could...

## Backup using GhettoVCB
GhettoVCB is a powerfull script that runs on your VMWare Host. It will snapshot all(can be configured) Virtual machines and copy them to a location of your choosing. In my case, I want all VMs of that host to be copied to my NAS, every night. 

You find the script here: [ghettoVCB](https://github.com/lamw/ghettoVCB). You can either follow the description on the github page to "install" the tool, you can also follow this [Documentation](https://communities.vmware.com/docs/DOC-8760) to run it without installation or you can follow my steps: 

I downloaded the ghettoVCB script to my Desktop and modified that one line to have the script point to my data storage: 

    VM_BACKUP_VOLUME=/vmfs/volumes/VMWare_Backups
 
Then, I moved that script to the Synology Folder "VMWare_Backups".

To make a backup of all VMs to the NAS, you need to execute the script from your host using:

    ghettoVCB.sh -a -l /location_of_your_log/backup.txt

What the line that we add is doing is that it creates a periodic cronjob (here: every day at 1:55am ) that runs the ghettoVCB.sh script from the data storage.
- parameter -a will use "all VMS" 
- parameter -l will write the log to the added destination. 

PS: the file must be executeable (chmod +x ghettoVCB.sh)

### Install GhettoVCB Job on VMware ESXI 7
Next, I logged into my VMware Host via ssh. ( - webinterface->host->action->services->enable ssh  ). 

To run the script/backup every night at 1:55am, add this line to file "/var/spool/cron/crontab/root"

    55   1    *   *   *   /opt/ghettovcb/bin/ghettoVCB.sh -a -l /vmfs/volumes/SynologyNAS/backup.txt


### Install GhettoVCB Job on VMware ESXI 5.5
on VMware ESXI 5.5, changes to the crontab directly are not persistent through a reboot. So thankfully, [somebody](https://communities.vmware.com/thread/545078) figured that out. 
Log into the VMware Host via ssh. ( - vsphere-client->host->config->security profiles->settings->ssh->enable  ). We need to modify one file (local.sh) located at 

    /etc/rc.local.d/local.sh

it has to look something like this (beware of the line breaks!) :

    #!/bin/sh  
    # local configuration options  
    # Note: modify at your own risk!  If you do/use anything in this  
    # script that is not part of a stable API (relying on files to be in  
    # specific places, specific tools, specific output, etc) there is a  
    # possibility you will end up with a broken system after patching or  
    # upgrading.  Changes are not supported unless under direction of  
    # VMware support.  
    
    
    # Gets the cron service pid and kill it:  
    /bin/kill $(cat /var/run/crond.pid)  
    
    # Add 1!  lines to the crontab:  
    /bin/echo "55 1 * * * /vmfs/volumes/VMWare_Backups/ghettoVCB.sh -a -l /vmfs/volumes/VMWare_Backups/backup.txt" >> /var/spool/cron/crontabs/root  
  
    
    # Start the cron service again  
    /usr/lib/vmware/busybox/bin/busybox crond  
    
    exit 0  


This script will run with each start of the vmware host and adds a line to the file /var/spool/cron/crontabs/root. 

# Restore
This is also the way you "transfer" virtual instances from one machine to another. Once the development is completed and the hardware is available, I will backup to my NAS and restore them on that dedicated Server. We will also add a function in OpenHAB (later) to create those backups on the press of a button. 