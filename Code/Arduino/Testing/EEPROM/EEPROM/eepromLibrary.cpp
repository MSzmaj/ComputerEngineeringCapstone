#include <stdio.h>
#include <EEPROM.h>
#include <WString.h>
#include <Arduino.h>
#include "eepromLibrary.hpp"
#include "DataConversionLibrary.hpp"

int writeByte (int address, char value) {
    EEPROM.write(address, value);
    return address + 1;
}

int writeData (enum sensorDataType dataType, char *data, int length) {
    int address;
    char *dataPointer;

    switch (dataType) {
        case accelerometer:
            address = 0;
            break;
        case barometer:
            address = 20;
            break;
        case gps:
            address = 40;
            break;
    }

    for (dataPointer = data; *dataPointer != '\0'; dataPointer++) {
        address = writeByte(address, *dataPointer);
    }
    return address;
}

int writeToEEPROM (String accelerometerData, String barometerData, String gpsData) {
    char *gpsCharArray, *barometerCharArray, *accelerometerCharArray;

    accelerometerCharArray = convertStringToCharArray(accelerometerData);
    barometerCharArray = convertStringToCharArray(barometerData);
    gpsCharArray = convertStringToCharArray(gpsData);

    writeData(accelerometer, accelerometerCharArray, accelerometerData.length());
    writeData(barometer, barometerCharArray, barometerData.length());
    writeData(gps, gpsCharArray, gpsData.length());
    return 0;
}

String readFromEEPROM (int verbose) {
    String returnString = "SOF";
    for (int i = 0; i < 70; i++) {
        returnString += (byte)EEPROM.read(i);
    }
    returnString += "EOF";
    if (verbose) Serial.println(returnString);
    return returnString;
}
