#include <Arduino.h>
#include <String.h>
#include "eepromLibrary.hpp"

String test = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
int address = 0;
int value;

void setup() {
    Serial.begin(9600);
    int length = static_cast<int>(test.length());
    writeData(accelerometer, convertString(test), length);
}

void loop() {
    value = EEPROM.read(address);
    Serial.write(value);
    address++;
    if (address == 52) {
        address = 0;
    }
    delay(100);
}

char* convertString (String string) {
    char *charString = new char[string.length() + 1];
    strcpy(charString, string.c_str());
    return charString;
}
