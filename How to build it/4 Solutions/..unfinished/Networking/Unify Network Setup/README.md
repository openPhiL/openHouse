# Overview
I am using Ubiquiti Network Equipment as my Network hardware. In this section, I am collecting all the steps required to setup the network using those components and integrate that into OpenHab. 



# Hardware I recommend
Here are some components so you can get an idea. 

### Ubiquiti Unify Switches
Here are some switches. Be aware that fanless does not mean cool, you shouldn't hide them in a box without air. But the fanless ones are silent. the other ones not so much, but according to [this guy](https://youtu.be/Xgve6mVAD-U) you can make them pretty quite.
- [8 port Switch without PoE (fanless)](https://amzn.to/2Wtfyy4) 
- [8 port Switch with PoE (fanlesss)](https://amzn.to/2HKS6ZN) 
- [16 port Switch with PoE](https://amzn.to/2YuKWhp)
- [24 port Switch (rack) without PoE](https://amzn.to/2WmCSNI)
- [24 port Switch (rack) with PoE](https://amzn.to/2JHlTUU)

### Ubiquiti Unify Access Points
A complete overview of their access points is available [here](https://www.ui.com/unifi/unifi-ac/). 

The reason I went with the Nano HD and the In-Wall HD in my home was the feature to use encrypted management packages against wifi jamming, which is part of their wave2 (HD) portfolio. They support mutiple wlans and can be powered directly with PoE.
- [Ubiquiti UniFi AP AC Nano HD](https://amzn.to/2YrGy2A)
- [Ubiquiti UniFi HD In-Wall Access Point](https://www.notebooksbilliger.de/ubiquiti+unifi+hd+in+wall+access+point+uap+iw+hd)

### Ubiquiti Unify Controller
I am also not using the (hardware) Controller but instead build the controller software as a virtual instance.

- [Ubiquiti UniFi Cloud Key](https://amzn.to/2UfvCpy) <- optional, see section 1 "setup of the controller"

### Ubiquiti USG Router
I am not using the USG (Gateway) but instead I use pfSense as a virtual instance. 

- [Ubiquiti USG Netzwerk/Router](https://amzn.to/2JIJILX) <- optional, in my setup, this is handled within pfSense>



