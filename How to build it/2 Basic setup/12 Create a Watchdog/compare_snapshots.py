
import subprocess

## initialize SSH

## Connect to source

### preliminary checks
#### job already running
#### read list of 


i = 100
while i < 102:
 print("checking"+str(i))
 source = subprocess.run("ssh watchdog@10.0.2.12 zfs get written |grep subvol-"+str(i)+" |grep daily | tail -1 | awk '{print $1}'", shell=True, stdout=subprocess.PIPE, universal_newlines=True)
 print("source: "+str(source.stdout) )
 target = subprocess.run("ssh watchdog@10.0.2.11 zfs get written |grep subvol-"+str(i)+" |grep daily | tail -1 | awk '{print $1}'", shell=True, stdout=subprocess.PIPE, universal_newlines=True)
 print("target:"+str(target.stdout) )
 if ( target.stdout == source.stdout ):
  print("ok")
 else:
  print("not oK")
 i=i+1
