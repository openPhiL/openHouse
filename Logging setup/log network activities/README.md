# Use ntopng and log to InfluxDB
ntopng: analyse traffic and store results  

## Create a influxDB database

ssh into 10.0.0.4

    influx
    CREATE DATABASE ntopng
    exit



## Install package ntopng
menu->Diagnostics->ntopng Settings: enable, set pw and define password. Add CIDR of local network (10.0.0.0/16).

go https://10.0.0.1:3000/ uname:admin pw: (youjustchose)

Switch the settings to our influxDB host (10.0.0.4:8086 using db: ntopng): 
https://www.ntop.org/ntopng/ntopng-and-time-series-from-rrd-to-influxdb-new-charts-with-time-shift/

## Add source to Grafana
Go to Grafana and add a data source, selecting influxDB:ntopng 

#  Extract raw Data via Telegraf
Different way, haven't checked that out yet.
https://sbaronda.com/2016/06/14/logging-pfsense-metrics-to-influxdb/

