#ifndef eeproLibrary_hpp
#define eeproLibrary_hpp

#include <stdio.h>
#include <EEPROM.h>
#include <WString.h>

#endif /* eeproLibrary_hpp */

enum sensorDataType { accelerometer, barometer, gps };

//Writes single value to address. Returns next address as an int.
int writeByte (int address, char value);
//Writes string to specific address determined by sensor data type.
//Returns 0 if successful.
//The EEPROM memory has a specified life of 100,000 write/erase cycles,
//so, we want to be as efficient in writing as possible.
//Takes 3.3ms to write one char to memory.
//Returns the last address written to.
int writeData (enum sensorDataType, char *data, int length);
//Writes the values given to the EEPROM.
int writeToEEPROM (String accelerometer, String barometer, String gps);
//Reads all values from EEPROM, returns String.
String readFromEEPROM (int verbose);

