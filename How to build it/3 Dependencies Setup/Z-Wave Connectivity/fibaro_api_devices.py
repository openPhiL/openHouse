#!/usr/bin/python
#-*- coding:utf-8 -*-

import requests
import json
import argparse

parser = argparse.ArgumentParser(description='Arguments')
parser.add_argument('deviceID', help="deviceID")

args = parser.parse_args()

#args = parser.parse_args()
response = requests.get('http://172.16.10.11/api/devices/'+args.deviceID,
                        auth=requests.auth.HTTPBasicAuth(
                            'admin', 'admin'))

# Daten entschlüsseln und ausgeben
msg = json.loads(response.text)
#msg['content'] = json.loads(decodeMessage(msg['content']))
print(json.dumps(msg))