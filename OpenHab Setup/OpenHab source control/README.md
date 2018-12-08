## push OpenHab Config to GitLab
Login to the GitLab Webinterface and change your password. Next, we create a menu->group (e.g. openHouse) to collect all things openHouse related. In there, we create a subgroup (e.g. OpenHAB) to collect all things OpenHAB related. In there, we create 2 projects:
* var_lib_openhab2 
* etc_openhab2
![GitLab Overview](https://raw.githubusercontent.com/openPhiL/openHouse/master/General_Setup/GitLab_Overview.png)

Next, we ssh into our OpenHAB server into those important config folders and sync them with our Git-Projects. 

    export GIT_SSL_NO_VERIFY=true  
    cd /etc/openhab2  
    git init
    git remote add origin https://10.0.0.4/openHouse/openHAB/etc_openhab2.git
    git add .
    git commit -m "Initial commit"
    git push -u origin master
    cd /var/lib/openhab2
    git init
    git remote add origin https://10.0.0.4/openHouse/openHAB/var_lib_openhab2.git
    git add .
    git commit -m "Initial commit"
    git push -u origin master