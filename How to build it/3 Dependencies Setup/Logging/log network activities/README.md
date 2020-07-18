# Use ntopng and log to InfluxDB
ntopng: analyse traffic and store results  

## Create a influxDB database

ssh into 10.0.0.4

    influx
    create database ntopng
    create user ntopng with password 'ntopng'
    grant all on ntopng to ntopng
    exit

## Create grafana source
In the grafana website (http://10.0.0.4:3000)->settings->data source->add data source
    name: ntopng
    type: influxDB
    http: localhost:8086 (Server)
    Auth: none
    Database: ntopng
    User: ntopng password: ntopng

## Install pfSense package ntopng
in Pf'Sense menu->Package Manger install the package called ntopng. Then, menu->Diagnostics->ntopng Settings: enable, set pw and define password. Add CIDR of local network (10.0.0.0/16).

go https://10.0.0.1:3000/ uname:(admin) pw: (youjustchose)

Switch the settings to our influxDB host (10.0.0.4:8086 using db: ntopng) (and username/password from above)
https://www.ntop.org/ntopng/ntopng-and-time-series-from-rrd-to-influxdb-new-charts-with-time-shift/

#  Extract raw Data via Telegraf
!Different way, haven't checked that out yet.
https://sbaronda.com/2016/06/14/logging-pfsense-metrics-to-influxdb/

