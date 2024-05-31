# Motor controller software
This folder contains the code running on the ESP-32-C6 which controls the motors.

## Setup to work with the ESP32-C6

### Arduino IDE
You first have to flash the sketch_initMemory.ino with your wifi credentials in the code (only the first time), then you can flash the sketch_webServer.ino code which will connect to the wifi to control the motors.

At the beginning of the file you will find all the constants needed to change the behavior of the helping-hand: the motors max speed, calibration speed, the pins number on the board and others.

### Wiring
![wiring schema of the ESP32-C6](../../documentation/electric-schema/electric_schema.png)
Connect all the wiring according the the schema and then adjust the pins to your ESP board and in the program.