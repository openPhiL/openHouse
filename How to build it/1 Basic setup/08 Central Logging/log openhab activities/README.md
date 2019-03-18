# Log anything to InfluxDB
Openhab supports InfluxDB as a persistance service. We can store everything there and even backup IoT states from there.

## Create a influxDB database

ssh into 10.0.0.4

    influx
    create database openhab
    create user openhab with password 'openhab'
    grant all on openhab to openhab
    exit

## Create grafana source
In the grafana website (http://10.0.0.4:3000)->settings->data source->add data source

    name: openhab
    type: influxDB
    http: localhost:8086 (Server)
    Auth: none
    Database: openhab
    User: openhab password: openhab

and restart:

    systemctl restart influxdb.service

## Setup OpenHab to Log anything to InfluxDB
I use the PaperUI->AddOns->Persistence and "install" Influx DB.

ssh into the openhab commandline and change file 

    /etc/openhab2/services/influxdb.cfg

so it points to the InfluxDB server (10.0.0.4:8086) using username and password from above (openhab).

Then, create a file like this

    /etc/openhab2/persistence/influxdb.persist

with that content:

    Strategies {
        everyMinute : "0 * * * * ?"
        everyHour   : "0 0 * * * ?"
        everyDay    : "0 0 0 * * ?"
    }

    Items {
        * : strategy = everyChange, everyMinute, restoreOnStartup
    }

more information is available [here](https://www.openhab.org/docs/configuration/persistence.html#persistence-configuration)





