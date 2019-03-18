# Overview
I didn't want to go with a traditional 2-wire doorbell solution that rings a bell inside the house when you press a button outside of the house. I wanted to have mobile access to open the door as well as see who is rining. Additionally, I want to utilise the many speaks in the house to annouce guests, not just one door bell somewhere in the house.

## Doorbird Hardware
I found my hardware at [doorbird.com](https://wwwdoorbird.com). The video door system D202 has a nice design as it is build "into" the wall, not "onto" the wall. It is connected and powered with one PoE Ethernet cable. 

## Doorbird E/A Controller
This device opens the door. The door has standard electric strike, but instead of connecting the strike to the bell, the opener is connected to this E/A Controller that is controlled using ethernet commands (RESTful). 

# House installation
## Ethernet Doorbell
Instead of traditional 2-wire cables, I asked my electrician to put a Cat7E cable there. You can use a 2-wire cable using adapters like [this](https://amzn.to/2PFEBKg), it's just super expensive. 

## Eletric Strike
(TODO)

# Protection
## Surge protector
the Doorbird D202 is "outside" my house, but is physically connected via ethernet to my inhome network. I installed a [Surge Protector](https://amzn.to/2A0CWtE) to avoid physical damanges of my Hardware.  

## Firewall
The doorbird has it's own VLAN that is monitored by pfSense's IDS. (TODO)