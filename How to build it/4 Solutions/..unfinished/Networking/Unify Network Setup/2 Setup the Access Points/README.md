## Placing the Access Points
(work in progress)

## Configuring the Access Points
With Accesspoints from Ubiquity, you can use the build in Frequency-Analyser to see what channels are crowded - and like in my case, find a solution with your neighours. 
![2.4Ghz Wlan](WLAN_24.JPG)
![5.0Ghz Wlan](WLAN_5.JPG)

I have read [here](https://community.ui.com/questions/Multiple-APs-should-use-different-channels-but-the-same-SSID/7c103b86-0b80-42b9-ba6f-588b784734d4) that it is recommended to not share the same channel when you share your SSID, therefore, I hopp back and forth each floor. 

I use low-power configuration (which is recommended to start with) and I have a narrow band on the 2.4Ghz Band because I don't need speed there, clean connectivity is more important. I need 2.4 because of my cheap IoT and other gimmic stuff.

For speed, I switch to the 5Ghz Band - where I have half and my neighbour has the other half. I use the 180Mhz spectrum and test it with [iperf3](https://github.com/esnet/iperf) and [fast.com](https://fast.com)