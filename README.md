# iOS-bluetooth-data-collection

###A cloud based  architecture for collecting ultrasonic sensory data



#####There are three primary components to this architecture:
#####- Microcontroller code
#####- iOS code
#####- Server script



___
###Microcontroller - Arduino Uno (ATmega328P)

A [Bluetooth Low Energy (BLE) shield](https://www.google.com) is mounted to the Arduino which allows a low level communication protocol between the Arduino and the iOS app. Also connected to the Arduino is three [ultra sound sensors](https://www.google.com) and an [accelerometer and gyroscope](https://www.google.com). 

The following peripheral code is executed from the Arduino during data collection: https://codebender.cc/sketch:142102

Communication between the BLE shield and the iOS Application is formatted in a three byte protocol: [X][Y][Z]

[X] -> Serves as an identifier to notify the client what the nature of the data is

[Y] -> Raw Data

[Z] -> Raw Data

The following table is to identify which [X] bytes correspond to which types of data:

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

