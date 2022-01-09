# HM10-and-IOS-Device
The purpose of this repository is to serve as an example for writing a SwiftUI IOS app for connecting to an HM-10 over Bluetooth Low Energy. The example provided also sends the IOS device's location over BLE to the HM-10, when the button is pressed. An example Arduino program is provided that allows the user to receive messages from the IOS device on the HM-10.

# Quick Start

To get started, you can simply open the Xcode project, and build like normal. You must run this on a real IOS device (not the simulator), because you need to use the built in bluetooth. You may run into warnings or errors based on project settings, but Xcode should tell you what needs to be resolved.

For using the provided arduino example with the HM-10, connect the HM-10 to the ground and 5V pins. For your TX (on the HM-10), connect to pin 2 on the arduino, and connect the RX pin of the HM-10 to pin 3 of the arduino. In the arduino program, the first message sent to the HM-10 sets the broadcasted name. Replace "ExampleName" with whatever you want the HM-10 to broadcast. Note, this can only be set when the HM-10 is not connected to a central device. For further info, consult the documentation of the HM-10.

If you built the Xcode project correctly, and have your HM-10 powered up, you should see this when you open the app:

<img src="https://github.com/jeremiahgivens/HM10-and-IOS-Device/blob/main/ExamplePhotos/BluetoothPositionAppScreenshot.jpeg" alt="drawing" width="300"/>

You should see the name of your HM-10 in list of HM-10's in Area. After hitting the connect button, you should be able to send your position by hitting the "Send Position" button at the bottom of the screen.

On the arduino side, make sure to have your serial window open. With the serial window open, you should see something similar to the below image every time you press the send image button.

![](https://github.com/jeremiahgivens/HM10-and-IOS-Device/blob/main/ExamplePhotos/ArduinoSerial.png?raw=true)

# Further Reading

The BLEManager class defined in the XCode project is derived from the [Ray Wenderlich Bluetooth Tutorial](https://www.raywenderlich.com/231-core-bluetooth-tutorial-for-ios-heart-rate-monitor).

The LocationFetcher class defined in the XCode project is derived from the [Hacking With Swift Tutorial](https://www.hackingwithswift.com/100/swiftui/78).

# Warnings

Some HM-10's have a built in level shifter to allow 5V logic, but the original HM-10's do not. Consult the documentation for your device.

Also, the Iphone is able to send BLE messages at a much faster rate than the HM-10 can recieve, and this may lead to some overflow errors. In my testing, I have found that I can safely send messages at a rate of one message every 75 milliseconds.

