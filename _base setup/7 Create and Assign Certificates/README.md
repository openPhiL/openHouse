## Create Certificates
Having digital certificates enables secure communication between the devices as well as makes authentication easier. At the end, we will use it to communicate via https to our server and we will use certificates to authenticate on the VPN. I am going to use pfSense's build in certificate manager to manage those certificates. 

- In pfSense, go to menu->system->Certificate Manager->CAs and add a new one. Give it a descriptive Name (e.g. openHouse_CA) and define (or not, they are optional) the parameters.
- Download that certificate to your desktop and install it (right-click install) into the folder *trusted root CAs*.

### Certificate for pfSense
Go to menu->system->Certificate Manager->certificates and add a new one using method "create an internal certificate". I call it "OpenHouse_Pfsense_Website", it is type Server with the attribute *IP Address = 10.0.0.1*. 

Go to menu->system->Advanced and select that "OpenHouse_Pfsense_Website" certificate and save. Your browser will refresh and you have a trusted, secured connection to your pfSense Website.

### Certificate for VMware Hypervisors Webinterface
Go to the VMware Hypervisors Webinterface->manager->security->certificates and import a new certificate. Click on generate IP signing request and copy/paste that code into your pfsense' Certificate manager->add option: sign a CSR. Download the created cert, open with notepad and copy&paste that content back to the hypervisor's webinterface. 

### Certificate for OpenHab
Go to menu->system->Certificate Manager->certificates and add a new one using method "create an internal certificate". I call it "OpenHouse_OpenHab_Website", it is type Server with the attribute *IP Address = 10.0.0.3*. 

Copy the content of your key and cert (downloaded from the pfsense Cert Manager ) into the files /etc/ssl/certs folder, overwriting existing openhab.cert and openhab.key files. 