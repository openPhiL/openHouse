# Use syslog and telegraf and log to InfluxDB
syslog: is a service that can be used to receive system information from other hosts
telegraf: is a service that can transform information to innoDB-Format
InfluxDB: is our Log Server

## Install syslog
Syslog is probably already installed, otherwise try

    sudo apt-get install rsyslog


change the configuration file 

    sudo nano /etc/rsyslog.conf

enable the listener:

    # provides UDP syslog reception
    module(load="imudp")
    input(type="imudp" port="514")

than add those information at the bottom:

    # use asynchronous processing 
    $ActionQueueType LinkedList 
    # set file name, also enables disk mode 
    $ActionQueueFileName srvrfwd 
    #infinite retries on insert failure 
    $ActionResumeRetryCount -1 
    # save in-memory data if rsyslog shuts down 
    $ActionQueueSaveOnShutdown on 
    $ModLoad imudp #loads the udp module 
    #listen for messages on udp localhost:514 $UDPServerAddress localhost $UDPServerRun 514 *.* 
    @@(o)127.0.0.1:6514;RSYSLOG_SyslogProtocol23Format

then restart

    sudo systemctl restart rsyslog

## Install telegraf
We already have the influxdata apt-source installed, so we can simply:

    sudo apt-get install telegraf

and configure some plugins in this humangous config file:

    sudo nano /etc/telegraf/telegraf.conf

    [[inputs.internal]]

    [[inputs.syslog]]
    server = "tcp://localhost:6514"

and restart

    sudo systemctl restart telegraf

## Create grafana source
In the grafana website (http://10.0.0.4:3000)->settings->data source->add data source
    name: telegraf
    type: influxDB
    http: localhost:8086 (Server)
    Auth: none
    Database: telegraf
    User: telegraf password: telegraf


## Connect pfSense
in pfSense->menu->status->system log->settings, you can enable the remote logging and enter the ip address this 10.0.0.4.
I marked:

    System events
    DHCP Server events
    Captive Portal Events
    VPN Events
    Gateway Monitor Events
    Server load Balancer

## Connect Vmware
There are a couple of VMWare plugins, maybe I don't need to attach all instances individually but can do that using the vmware tools from the host directly.(TODO)


## Connect Synology Disk Station
(TODO)

## Connect a Windows PC
(TODO)

## Connect a Linux PC
(TODO)