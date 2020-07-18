# Integration of Alexa

## Install the AmazonEchoControl Binding

I use the [AmazonEchoControl](https://www.openhab.org/addons/bindings/amazonechocontrol/#amazon-echo-control-binding) binding. It will use that API to control the echos. The documentation on openhab.org is complete.

### Speaking to Alexa

The binding can register what you have said to what device. With a setup like this, you can make Alexa respond to things you pretty simple. You would need to create custom routines using your alexa app to make alexa say "ok" when you say "rollladen" for example, to prevent alexa telling you it doesn't know what to do.

Items.file:

    String Livingroom_AmazonEcho_LastVoiceCommand "Last voice command" (G_Livingroom_AmazonEcho) {channel="amazonechocontrol:echo:account:DeviceID:lastVoiceCommand"}

    Switch Livingroom_EchoVoiceCommand_Rollershutter        "Rolladen"                          (G_Livingroom_VoiceCommands) {expire="1s, state=OFF"}
    Switch Livingroom_EchoVoiceCommand_RollershutterUP      "Rolladen hoch, auf, rauf, öffnen"  (G_Livingroom_VoiceCommands) {expire="1s, state=OFF"}
    Switch Livingroom_EchoVoiceCommand_RollershutterDOWN    "Rolladen runter, schließen, zu"    (G_Livingroom_VoiceCommands) {expire="1s, state=OFF"}

rules.file:

    rule "Livingroom: Alexa Integration"
    when
        Item Livingroom_AmazonEcho_LastVoiceCommand changed
    then
    switch (Livingroom_AmazonEcho_LastVoiceCommand.state){

        case 'rollladen':{
            Livingroom_EchoVoiceCommand_Rollershutter.sendCommand(ON)
        }

        case 'rollladen rauf',
        case 'rollladen auf',
        case 'rollladen öffnen',
        case 'rollladen hoch':{
            Livingroom_EchoVoiceCommand_RollershutterUP.sendCommand(ON)
        }
        case 'rollladen runter',
        case 'rollladen zu',
        case 'rollladen schließen':{
            Livingroom_EchoVoiceCommand_RollershutterDOWN.sendCommand(ON)
        }
    }
    end

    rule "Livingroom_VoiceControl: RollerShutter"
    when
        Item Livingroom_EchoVoiceCommand_Rollershutter received command ON
    then
        if ( (Livingroom_RollershutterCenter_Control.state as Number).intValue > 50 ){
            Livingroom_RollershutterCenter_Control.sendCommand("UP")
            Livingroom_RollershutterFront_Control.sendCommand("UP")
            Livingroom_RollershutterBack_Control.sendCommand("UP")
        }else{
            Livingroom_RollershutterCenter_Control.sendCommand("DOWN")
            Livingroom_RollershutterFront_Control.sendCommand("DOWN")
            Livingroom_RollershutterBack_Control.sendCommand("DOWN")
        }
    end

    rule "Livingroom_VoiceControl: RollerShutter hoch"
    when
        Item Livingroom_EchoVoiceCommand_RollershutterUP received command ON
    then
        Livingroom_RollershutterCenter_Control.sendCommand("UP")
        Livingroom_RollershutterFront_Control.sendCommand("UP")
        Livingroom_RollershutterBack_Control.sendCommand("UP")
    end

    rule "Livingroom_VoiceControl: RollerShutter runter"
    when
        Item Livingroom_EchoVoiceCommand_RollershutterDOWN received command ON
    then
        Livingroom_RollershutterCenter_Control.sendCommand("DOWN")
        Livingroom_RollershutterFront_Control.sendCommand("DOWN")
        Livingroom_RollershutterBack_Control.sendCommand("DOWN")

    end
