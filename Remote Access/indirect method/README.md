## Indirect Method: connect via a cloud instance 
As mentioned above, this is my fallback scenario because my ISP does not have any IPv4's left and shares one IPv4 Address to multiple customer -> no one can directly connect. I will therefore initiate a VPN connection "from" my home network to a cloud server that has a fix address. Any client's fallback option will be that cloud server that routes the traffic from authenticated client into the home network. 

              
I need a fixed IP-Address to where I can connect from anywhere. I rent the nano server at [myvirtualserver.com](https://www.myvirtualserver.com) for 15€/year. Once logged in to the cloud server's ssh console, I run "command apt-get install openvpn". Next, we need a server-config. Let's copy the one we just created using pfsense's menu->diagnostic->edit file to browse to /var/etc/openvpn. Let's copy the content of the conf file and the tls-auth file to our server. (I use the command line text editor nano - apt-get install nano, then sudo nano /etc/openvpn/MyVirtualServer_VPN_Server.conf or /etc/openvpn/MyVirtualServer_VPN_Server.tls-auth ). Additionally, create certificates to that server and copy the content of that also to the server (sudo nano /etc/openvpn/MyVirtualServer_VPN_Server.key and MyVirtualServer_VPN_Server.cert) and don't forget the cert of your CA (OpenHouseCA.cert).
Small adjustments are necessary. We don't have the same local database for the VPN users. I use this script to check the credentials, store in /etc/openvpn/MyVirtualServer_VPN_Server.sh and make it executable (chmod +x /etc/openvpn/MyVirtualServer_VPN_Server.sh)

    #!/bin/bash
    readarray -t lines < $1
    username=${lines[0]}
    password=${lines[1]}
    # Replace your own authentication mechanism here
    if [[ $username == "myusername" ]]; then
      if [[ $password == "mypassword" ]]; then
        echo "ok"
        exit 0
      fi
    fi
    if [[ $username == "myotherusername" ]]; then
      if [[ $password == "myotherpassword" ]]; then
        echo "ok"
        exit 0
      fi
    fi

    echo "not ok"
    exit 1
I agree, this can be improved (TODO).

    Your directory should looke like that:
    root@MyVirtualServer:/etc/openvpn# ls -l
    -rw-r--r-- 1 root root  431 Nov 18 10:53 MyVirtualServer_VPN_Server.dh2048
    -rw-r--r-- 1 root root 2097 Nov 18 10:48 MyVirtualServer_VPN_Server.crt
    -rw-r--r-- 1 root root 1201 Nov 18 13:53 MyVirtualServer_VPN_Server.conf
    -rw-r--r-- 1 root root 3323 Nov 18 10:48 MyVirtualServer_VPN_Server.key
    -rw-r--r-- 1 root root    0 Nov 18 13:46 MyVirtualServer_VPN_Server.log
    -rwxr-xr-x 1 root root  369 Nov 18 13:55 MyVirtualServer_VPN_Server.sh
    -rw-r--r-- 1 root root  653 Nov 18 10:48 MyVirtualServer_VPN_Server.tls-auth
    -rw-r--r-- 1 root root 1843 Nov 18 11:00 OpenHouseCA.crt
    -rw------- 1 root root 3706 Nov 18 15:00 vpn_server.log
and your server.conf would look like this:
    dev-type tun
    user nobody
    group nogroup
    script-security 3
    daemon
    keepalive 10 60
    ping-timer-rem
    persist-tun
    persist-key
    proto tcp4-server
    cipher AES-256-CBC
    auth SHA512
    local IP_ADDRESS_OF_YOUR_CLOUD_SERVER
    tls-server
    server 10.1.0.0 255.255.255.0
    username-as-common-name
    lport 443
    push "route 10.0.0.0 255.255.0.0"
    client-to-client
    duplicate-cn
    ca /etc/openvpn/MyVirtualServer_VPN_Server.ca 
    cert /etc/openvpn/MyVirtualServer_VPN_Server.crt 
    key /etc/openvpn/MyVirtualServer_VPN_Server.key 
    dh /etc/openvpn/MyVirtualServer_VPN_Server.dh2048
    tls-auth /etc/openvpn/MyVirtualServer_VPN_Server.tls-auth 0
    persist-remote-ip
    float
    topology subnet
    log vpn_server.log



At the end, we add our indirect method to our existing client-config file (right click on the task-bar icon of openVPN, change configuration and dublicate the line remote... using the fixed IP address of the cloud server.
We also remote the line verify-x509 because we have to different certificates. The client config looks similiar to this:

    dev tun
    persist-tun
    persist-key
    cipher AES-256-CBC
    auth SHA512
    tls-client
    client
    resolv-retry infinite
    remote 192.168.178.93 443 tcp-client
    remote IP_ADDRESS_OF_CLOUD_SERVER 443 tcp-client
    auth-user-pass
    pkcs12 pfSense-TCP4-443-phil.p12
    tls-auth pfSense-TCP4-443-phil-tls.key 1
    remote-cert-tls server

If we now shut down (or set a firewall rule or anything to prevent the first connection to succeed), it will automatically connect to the cloud server. We now have to link the cloud server to our home network, a connection that is initiated by the home network. 
We already have all certificates we need, we just need to link the 2 server. 