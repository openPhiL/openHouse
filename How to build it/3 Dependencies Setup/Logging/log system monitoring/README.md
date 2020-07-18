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
the Telegraf that is running on our TIG stack can be configured to access the Hypervisor. Setup is described [here](
https://github.com/influxdata/telegraf/tree/release-1.8/plugins/inputs/vsphere)


And those Dashboards:
- [VMware vSphere - Overview](https://grafana.com/grafana/dashboards/8159)
- [VMware vSphere - Hosts](https://grafana.com/grafana/dashboards/8165)
- [VMware vSphere - VMs](https://grafana.com/grafana/dashboards/8168)

## Connect Unifi
found that awesome [unifi-polling tool](https://github.com/davidnewhall/unifi-poller/wiki/Installation)

that goes along with those Dashboards:
- [UniFi-Poller: Client Insights](https://grafana.com/grafana/dashboards/10418)
- [UniFi-Poller: Network Sites](https://grafana.com/grafana/dashboards/10414)
- [UniFi-Poller: UAP Insights](https://grafana.com/grafana/dashboards/10415)
- [UniFi-Poller: USG Insights](https://grafana.com/grafana/dashboards/10416)
- [UniFi-Poller: USW Insights](https://grafana.com/grafana/dashboards/10417)

## Connect Synology Disk Station
this can be done via SNMP. 
## Connect a Windows PC
(TODO)

## Connect a Linux PC
Scenario: Install Telegraf with default plugins on that linux and submit all metrics to the influxDB server. 
### Install Telegraf
See the very good documentatoin on the [influx website](https://docs.influxdata.com/telegraf/v1.12/introduction/installation/)

    wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
    source /etc/lsb-release
    echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
    sudo apt-get update && sudo apt-get install telegraf
    sudo nano /etc/telegraf/telegraf.conf 

- find the \[\[outputs.influxdb\]\] and change the urls=" nearby to point to the InfluxDB server.
- find the \[\[inputs.net\]\] and uncomment it
- 

    sudo systemctl restart telegraf.service
    sudo systemctl status telegraf.service

That's it. 
