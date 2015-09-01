# iOS-bluetooth-data-collection

###A cloud based Internet of Things (IoT) for collecting ultrasonic sensory data



#####There are three primary components to this architecture:
#####- [Microcontroller code](https://github.com/ritwikbiswas1/iOS-bluetooth-data-collection/blob/master/README.md#microcontroller---arduino-uno-atmega328p)
#####- [iOS Application](https://github.com/ritwikbiswas1/iOS-bluetooth-data-collection/blob/master/README.md#ios-application---objective-c)
#####- [Server script](https://github.com/ritwikbiswas1/iOS-bluetooth-data-collection/blob/master/README.md#server-script---python)



___
###Microcontroller - Arduino Uno (ATmega328P)

A [Bluetooth Low Energy (BLE) shield](http://redbearlab.com/bleshield/) is mounted to the Arduino which allows a low level communication protocol between the Arduino and the iOS app. Also connected to the Arduino is three [ultra sound sensors](http://www.maxbotix.com/documents/LV-MaxSonar-EZ_Datasheet.pdf) and an [accelerometer and gyroscope](http://playground.arduino.cc/Main/MPU-6050). 

The following peripheral code is executed from the Arduino during data collection: https://codebender.cc/sketch:142102

Communication between the BLE shield and the iOS Application is formatted in a three byte protocol: [X][Y][Z]

[X] -> Serves as an identifier to notify the client what the nature of the data is

[Y] -> Raw Data

[Z] -> Raw Data

The following table is to identify which [X] bytes correspond to which types of data:

`Note: Data that was larger than 8 bits had to be packed into multiple bytes and sent seperately to be interpreted by the iOS application`

|[X] Byte       | ID            |
| ------------- |:-------------:|
| 0x0B      | ultra_sound_sensor_1 |
| 0x0C      | ultra_sound_sensor_2 |
| 0x0D      | ultra_sound_sensor_3 |
| 0x0E      | time_pack_1 |
| 0x0F      | time_pack_2 |
| 0x1A      | iteration_pack_1 |
| 0x1B      | iteration_pack_2 |
| 0x1C      | yaw_integer |
| 0x1D      | pitch_integer |
| 0x1E      | roll_integer |
| 0x01F      | accel_x_integer |
| 0x10      | accel_y_integer |
| 0x11      | accel_z_integer |
| 0x12      | yaw_sign, yaw_float |
| 0x13      | pitch_sign, pitch_float |
| 0x14      | roll_sign, roll_float |
| 0x15      | accel_x_sign, accel_x_float |
| 0x16      | accel_y_sign, accel_y_float |
| 0x17      | accel_z_sign, accel_z_float |
___
###iOS Application - Objective C

The iOS Application is written in Objective-C using Core Bluetooth framework for basic central/peripheral architecture. Data is recieved via the above mentioned BLE protocol. Necessary data is unpacked and displayed on the iOS interface. All relevant sensory data is then repacked and sent to a [firebase](https://www.firebase.com) database in the cloud to be accessed by any client devices or server scripts.

The firebase framework is installed in the basic project directory allowing for basic url endpoint access/updating. An example upload to the firebase database:

```objective-c
Firebase *sensor1 = [[Firebase alloc] initWithUrl:@"https://sbid.firebaseio.com/raw_data/us_data_1"];
Sensor_Value = (data[i+1] | data[i+2]<<8);
[sensor1 setValue: Sensor_Value];
```
The BLE low level data protocol is included in a framework provided by the creators of the BLE Shield (Redbear). When prompted by the user, the application constantly searches for an access point (shield) and attempts to connect to it. After connection is established the two way data stream is initiated between the mobile device and the BLE shield

[Official Apple Core Bluetooth Documentation](https://developer.apple.com/library/mac/documentation/CoreBluetooth/Reference/CoreBluetooth_Framework/)
___
###Server Script - Python

The python script uses a firebase library called [python-firebase](https://pypi.python.org/pypi/python-firebase/1.2). It accessed the database and takes the packed sensory data and writes it to a .txt file. The output of the file follows the following format:

`Iteration, Server Timestamp, Arduino Timestamp, Ultra Sound 1, Ultra Sound 2, Ultra Sound 3, Yaw, Pitch, Roll, Acceleration_x, Acceleration_y, Acceleration_z`

This data is ready to be processed after it is collected, or the necessary algorithms can be implemented in the script itself for realtime analysis.
