## Backup and Restore Functions

Nearly done. Now Let's talk about backup and restore. We need some space somewhere to store the backup. I will use my (real, not virtual) Synology for that. There, I created a new shared folder named VMWare_Backups on a non-redundant volumne(I don't need backups of backups I say) and activated NFS access for the (WAN-side)IP of this virtual machine on the NFS-permissions tab.

Using the hypervisor's webinterface-Storage->create new data storage, I used those information to add the NAS-drive to the VMWare Server. PS: Do not use special characters nor spaces in the name of the Storage, even if you could.

Download and install [ghettoVCB](https://github.com/lamw/ghettoVCB) as explained in the GitHub Readme. Read the [Documentation](https://communities.vmware.com/docs/DOC-8760) because you have to change at least the file ghettovcb.sh parameter VM_BACKUP_VOLUME.
To connect to the servers's ssh interface, you have to enable it first: 

- webinterface->host->action->services->enable ssh 

Sidenote: I had to cp it to /vmfs/volumes/datastore1 first as it was read only within /opt/ghettovcb/bin directory. this way, I could download/change/upload it, avoiding that crappy VI editor. 

To do this automatically every night at 1:55, add this line to file "/var/spool/cron/crontab/root"

    55   1    *   *   *   /opt/ghettovcb/bin/ghettoVCB.sh -a -l /vmfs/volumes/SynologyNAS/backup.txt
(the cron job at night only works if that VM is turned on, duh).

This is also the way you "transfer" virtual instances from one machine to another. Once the development is completed and the hardware is available, I will backup to my NAS and restore them on that dedicated Server. We will also add a function in OpenHAB to create those backups on the press of a button. 