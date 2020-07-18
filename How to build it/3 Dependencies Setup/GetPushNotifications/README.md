# OpenHab Push Notifications

Install the Addon - Misc: CloudConnector [link](https://www.openhab.org/addons/integrations/openhabcloud/)

Register an Account on myhopenhab.org and create account-user

Install the APP on your phone and enter the username password from myopenhab.org-account-user

Try it with a simple rule

    rule "Detect Intruder"
    when
     Item ALARM changed to ON
    then
     sendBroadcastNotification("Warning, Intruder","ALARM","high")
