# Colorful backlit Wardrobe

## Hardware

### Build some wood

![Wardrobe](2020-08-24-23-55-45.png)

### Add some electronics

I used a WEMOS D1 mini for this project.

Sorry, forgot to make a nice picture before I put it on the wall:
![Wemos2RGBW](2020-08-24-23-52-13.png)
it should be something like:
![ArduinoScematics](2020-08-24-23-54-59.png)

## Software - 8266

### Flash ESPEasy to the 8266

First, connect the ESP8266 via USB. Then, download and start the flash-tool:[download here](https://github.com/letscontrolit/ESPEasy/releases)
and choose the firmware matching to your need, e.g. *normal_*4096.bin

You can then connect to a new WIFI-Access Point and start configuration

### Setup basic information

important values are:

- Wifi SSID and Password
- unit name (I prefer no number)
- Client IP block Level

### Enable MQTT

go to controllers and ADD the HomeAssistant(openHAB)MQTT controller:
![EasyESPMQTT1](2020-08-24-23-46-52.png)
![EasyESPMQTT2](2020-08-24-23-47-28.png)

### Enable NeoPixel

go to devices and Add the NeoPixelDevice, give it a name and assign the GPIO of the data cable as well as the amounts of leds you have.

![EasyESPDevice](2020-08-24-23-50-03.png)

## Software - OpenHAB

### Create a thing in OpenHab

Create a generic MQTT Thing with a color-channel:

![OpenhabThing](2020-08-24-23-39-21.png)
![OpenHabThingChannel](2020-08-25-00-16-34.png)

### Create an item in OpenHab

Create item for that channel:

![OpenHabItem](2020-08-24-23-41-13.png)

### Create a control in OpenHab

Create a sitemap with a control widget for that color-item:

![OpenHabSitemap](2020-08-24-23-41-52.png)

And now, everytime you change the value of the item, it will post the "NeoPixelAllHSV" command with added color,saturation,brightness values to the broker.

## Additional Informations

- EasyESP Neopixel code is available [here](https://github.com/letscontrolit/ESPEasy/blob/mega/src/_P038_NeoPixel.ino)
- EasyESP tutorial for working with rules is available [here](https://www.letscontrolit.com/wiki/index.php/Tutorial_Rules)
