import logging
from logging.handlers import RotatingFileHandler
import json
from json.decoder import JSONDecodeError
import requests
from requests.adapters import HTTPAdapter
from requests.exceptions import RequestException
from requests.exceptions import ConnectionError
from requests.exceptions import Timeout
from requests.exceptions import HTTPError
import time

# create logger with 'spam_application'
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('fibaro2openhab')
logger.setLevel(logging.INFO)
# create file handler which logs even debug messages
fh = RotatingFileHandler('/var/log/openhab2/fibaro2openhab.log', mode='a', maxBytes=5*1024*1024, 
                                 backupCount=2, encoding=None, delay=0)
##fh = logging.FileHandler('fibaro2openhab.log')
fh.setLevel(logging.INFO)
# create console handler with a higher log level
ch = logging.StreamHandler()
ch.setLevel(logging.ERROR)
# create formatter and add it to the handlers
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter)
ch.setFormatter(formatter)
# add the handlers to the logger
logger.addHandler(fh)
logger.addHandler(ch)

 
logger.warning('Script is starting')

url = "http://172.16.10.11:80/api/refreshStates"
url_openhab = 'http://openhab2:8080/rest/items/' #openhbitem etc
logger.debug('setting http adapter to ' + url)
fibaroLite_adapter = HTTPAdapter(max_retries=3)
session = requests.Session()
session.mount(url, fibaroLite_adapter)


#get the last ID to be next in line with the fibaro script
while True:
    logger.debug('Retrieving last_id')
            
    try:
        last_response = session.get(url, auth=('admin', 'admin'), timeout=31)
        
        #get the last ID to be next in line with the fibaro script
        last_response_content = json.loads(last_response.text)
        last_call_id = last_response_content['last']
        logger.debug('Last ID received: ' + str(last_call_id))
        break
    except ( ConnectionError,  Timeout , JSONDecodeError ) as error:
        logger.error(error)
        logger.debug('Wait 5 sec')
        time.sleep(5)
        continue   


logger.warning('Script is initialized - starting the loop')

while True:
    logger.debug('Wait for next Response ' + str(last_call_id))

    try:
        #make a call with that ID to fetch next change
        current_request = url + '?last=' + str(last_call_id)
        current_response = session.get( current_request , auth=('admin', 'admin'), timeout=31)
    except ( ConnectionError, Timeout,  HTTPError ) as errh:
        logger.error(errh)
        logger.debug('Wait 5 sec')
        time.sleep(5)
        continue
   

    if current_response:
        logger.debug('Response received! (' + str(last_call_id) + ')')
        change_counter = 0
    else:
        logger.error('Response not received! ')
        logger.debug('Wait 5 sec')
        time.sleep(5)
        continue

    try:
        current_response_content = json.loads(current_response.text)
    except JSONDecodeError as je:
        logger.error(je)   
        logger.debug('Wait 5 sec')
        time.sleep(5)
        continue 



    last_call_id = current_response_content['last']
    if current_response_content['changes']:
        logger.debug('Changes detected')
        for current_change in current_response_content['changes']:
            triggeringID = str(current_change['id'])
            openhabItem = None 
            action = None


            # PowerPlugs
            if 'power' in current_change :  
                logger.debug('change in power detected for ' + triggeringID )
                if triggeringID == '54' :
                    openhabItem = 'Kitchen_Outlet_Refrigerator_MeterWatts'
                    action = current_change['power']
                if triggeringID == '56' :
                    openhabItem = 'Kitchen_Outlet_Freezer_MeterWatts'
                    action = current_change['power']
                if triggeringID == '113' :
                    openhabItem = 'Kitchen_Outlet_Warmingblade_MeterWatts'
                    action = current_change['power']


            # MotionSensors
            if 'value' in current_change :  
                if 'lastBreached' in current_change:
                    continue
                logger.debug('change in motion detected for ' + triggeringID )    

                #Basement

                #UGFloor
                
                if triggeringID == '115' :
                    openhabItem = 'Ugfloor_SensorEntryDoor_Motion'
                    action = "ON" if str(current_change['value']) == 'true' else "OFF"
                if triggeringID == '116' :
                    openhabItem = 'Ugfloor_SensorEntryDoor_Temperature'
                    action = current_change['value']
                if triggeringID == '117' :
                    openhabItem = 'Ugfloor_SensorEntryDoor_Luminance'
                    action = current_change['value']

                if triggeringID == '60' :
                    openhabItem = 'Ugfloor_SensorBasementDoor_Motion'
                    action = "ON" if str(current_change['value']) == 'true' else "OFF"
                if triggeringID == '61' :
                    openhabItem = 'Ugfloor_SensorBasementDoor_Temperature'
                    action = current_change['value']
                if triggeringID == '62' :
                    openhabItem = 'Ugfloor_SensorBasementDoor_Luminance'
                    action = current_change['value']

                #WC
                if triggeringID == '5' :
                    openhabItem = 'Wc_Sensor_Motion'
                    action = "ON" if str(current_change['value']) == 'true' else "OFF"
                if triggeringID == '6' :
                    openhabItem = 'Wc_Sensor_Temperature'
                    action = current_change['value']
                if triggeringID == '7' :
                    openhabItem = 'Wc_Sensor_Luminance'
                    action = current_change['value']

                #Kitchen
                if triggeringID == '131' :
                    openhabItem = 'Kitchen_SensorWindow_Motion'
                    action = "ON" if str(current_change['value']) == 'true' else "OFF"
                if triggeringID == '132' :
                    openhabItem = 'Kitchen_SensorWindow_Temperature'
                    action = current_change['value']
                if triggeringID == '133' :
                    openhabItem = 'Kitchen_SensorWindow_Luminance'
                    action = current_change['value']

                if triggeringID == '137' :
                    openhabItem = 'Kitchen_SensorDoor_Motion'
                    action = "ON" if str(current_change['value']) == 'true' else "OFF"
                if triggeringID == '138' :
                    openhabItem = 'Kitchen_SensorDoor_Temperature'
                    action = current_change['value']
                if triggeringID == '139' :
                    openhabItem = 'Kitchen_SensorDoor_Luminance'
                    action = current_change['value']

                #Dining
                if triggeringID == '89' :
                    openhabItem = 'Dining_SensorWindow_Motion'
                    action = "ON" if str(current_change['value']) == 'true' else "OFF"
                if triggeringID == '90' :
                    openhabItem = 'Dining_SensorWindow_Temperature'
                    action = current_change['value']
                if triggeringID == '91' :
                    openhabItem = 'Dining_SensorWindow_Luminance'
                    action = current_change['value']

                #Bathroom
                if triggeringID == '26' :
                    openhabItem = 'Bathroom_SensorMirror_Motion'
                    action = "ON" if str(current_change['value']) == 'true' else "OFF"
                if triggeringID == '27' :
                    openhabItem = 'Bathroom_SensorMirror_Temperature'
                    action = current_change['value']
                if triggeringID == '28' :
                    openhabItem = 'Bathroom_SensorMirror_Luminance'
                    action = current_change['value']

                if triggeringID == '95' :
                    openhabItem = 'Bathroom_SensorDoor_Motion'
                    action = "ON" if str(current_change['value']) == 'true' else "OFF"
                if triggeringID == '96' :
                    openhabItem = 'Bathroom_SensorDoor_Temperature'
                    action = current_change['value']
                if triggeringID == '97' :
                    openhabItem = 'Bathroom_SensorDoor_Luminance'
                    action = current_change['value']

                #Masterbedroom
                if triggeringID == '11' :
                    openhabItem = 'Masterbedroom_SensorDoor_Motion'
                    action = "ON" if str(current_change['value']) == 'true' else "OFF"
                if triggeringID == '12' :
                    openhabItem = 'Masterbedroom_SensorDoor_Temperature'
                    action = current_change['value']
                if triggeringID == '13' :
                    openhabItem = 'Masterbedroom_SensorDoor_Luminance'
                    action = current_change['value']

                #LukasBedroom
                if triggeringID == '20' :
                    openhabItem = 'Lukasbedroom_Sensor_Motion'
                    action = "ON" if str(current_change['value']) == 'true' else "OFF"
                if triggeringID == '21' :
                    openhabItem = 'Lukasbedroom_Sensor_Temperature'
                    action = current_change['value']
                if triggeringID == '22' :
                    openhabItem = 'Lukasbedroom_Sensor_Luminance'
                    action = current_change['value']


                # Livingroom
                if triggeringID == '44' :
                    openhabItem = 'Livingroom_SensorDoor_Motion'
                    action = "ON" if str(current_change['value']) == 'true' else "OFF"
                if triggeringID == '45' :
                    openhabItem = 'Livingroom_SensorDoor_Temperature'
                    action = current_change['value']
                if triggeringID == '46' :
                    openhabItem = 'Livingroom_SensorDoor_Luminance'
                    action = current_change['value']

                
            if openhabItem is not None and action is not None:
                logger.info('openhabItem: ' + openhabItem + ' set to ' + action  )
                post_url = url_openhab + openhabItem
                post_action = action
                logger.debug("URL:"+str(post_url))
                logger.debug("BODY:"+str(post_action))
                change_counter = change_counter + 1
                logger.debug("Change_counter: " + str(change_counter))
                try: 
                   post_request = requests.post(url = post_url, data = post_action, verify=False) 
                except ( ConnectionError, Timeout, JSONDecodeError) as ce:
                    logger.error(ce)
            else:
                logger.warning("unkown change for "+str(triggeringID))
                logger.debug(current_response_content)


