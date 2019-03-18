# Install influxDB and Grafana
All loggable data should end up centralized in a big database (Here: influxDB) which then can be analyzed using a graphical interface like Grafana. 

## Create a new virtual machine
I use another small Ubuntu-Live-Server Instance with 2GB Ram, 1CPU and 20GB Harddisk. I am going to use IP 10.0.0.4 . 

## Install influxDB:

    curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -

    source /etc/lsb-release

    echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

    sudo apt-get update && sudo apt-get install influxdb

    sudo service influxdb start
    
    exit

## Install Grafana
    http://docs.grafana.org/installation/debian/












