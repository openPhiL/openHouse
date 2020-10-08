# Update OpenHab

## Preparation

### compare versions

The current version is visible at the bottom of the main screen.
![Main Screen](2020-10-08-10-06-57.png)

The newest release available can be found on the [official website's download section](https://www.openhab.org/download/)

### Create a Backup

the current setup already makes backups every 15min - but I like to make one manual backup before starting the procedure.

Login to the proxmox Administration Monitor(http://proxmox), select the OpenHab Instance -> Backup -> Backup now.
(if you receive an error, you might have to many backups at the target. delete an old one).

## Run Update command

ssh into the openhab console [ssh://openhab](ssh://openhab) and run the command 

    sudo openhabian-config 

you might be asked to update Openhabian itself, do that to the "stable" version.

then select Upgrade System
