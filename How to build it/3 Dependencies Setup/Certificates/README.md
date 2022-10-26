# Certificates

Having digital certificates enables secure communication between the devices as well as makes authentication easier. 
At the end, we will use it to communicate via https to our servers and we will use certificates to authenticate on the VPN. I am going to use Opnsense's build in certificate manager to manage those certificates.

A good documentation is available [here](https://docs.opnsense.org/manual/how-tos/self-signed-chain.html).

I use Opnsense to create the CA and the Intermediate for that CA. 

## How to implement them

### Proxmox
Create an "Server"-Certificate for the Proxmox Server. 
export the CA.cert, the Intermediate.cert and that Server Certificate as well as the server certificate private key. 
in Proxmox-Node-Certificates, press "upload a custom certificate" and copy&paste the Cert contents in the chain text box, starting with CA, then Intermediate, then Proxmox. Put the Key in the Key-Textbox. It will restart. 
If you broke it, delete the /etc/pve/local/pveproxy-ssl.pem file.

### for VMWare Hypervisor

Go to the VMware Hypervisors Webinterface->manager->security->certificates and import a new certificate. Click on generate IP signing request and copy/paste that code into your pfsense' Certificate manager->add option: sign a CSR. Download the created cert, open with notepad and copy&paste that content back to the hypervisor's webinterface.

### in OPNSense

Create an "Server"-Certificate for the OPNsense Server. 
in the Webgui -> System -> Settings -> Administration and selec that. 

### OPENHAB

Create an "Server"-Certificate for the openHAB Server. 
Copy the content of your key and cert (downloaded from the pfsense Cert Manager ) into the files /etc/ssl/certs folder, overwriting existing openhab.cert and openhab.key files.
Then, restart nginx using sudo systemctl restart nginx.service

### UnifiController


Create an "Server"-Certificate for the UnifiController.
Export the crt & key combination in .p12 format, set the passwort to "aircontrolenterprise" (which is the default of the initial UnifiController, yes, haha).
login root to Unifi Controller 

    mv /var/lib/unifi/keystore to /var/lib/unifi/keystore.backup

    keytool -importkeystore -destkeystore /var/lib/unifi/keystore -srckeystore UnifiController.p12 -srcstoretype PKCS12

when asked for password, use aircontrolenterprise. 

restart with service unifi restart

### Nextcloud

Copy the content of your key and cert (downloaded from the pfsense Cert Manager ) into the files /etc/ssl/certs folder. 
Then, add those 2 lines into /etc/nginx/conf.d/nextcloud.conf
![nextcloud.conf](2020-08-30-14-15-28.png)
Then, restart nginx using sudo systemctl restart nginx.service
