## Create new server
Link to Extend a virtual partition: https://www.thomas-krenn.com/de/wiki/LVM_vergr%C3%B6%C3%9Fern


#Install influxDB and Grafana

## Install influxDB:


    curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -

    source /etc/lsb-release

    echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

    sudo apt-get update && sudo apt-get install influxdb

    sudo service influxdb start
    
    exit

## Install Grafana
    http://docs.grafana.org/installation/debian/












