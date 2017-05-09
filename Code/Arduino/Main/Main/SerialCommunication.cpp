#include <Arduino.h>
#include <WString.h>
#include <SoftwareSerial.h>
#include "SerialCommunication.hpp"

String createChecksum (String ADXL335, String BMP180, String GPS) {
    long hash = 0;
    String data = String("ADXL:" + ADXL335 + ";BMP180:" + BMP180 + ";GPS:" + GPS);
    for (int i = 0; i < data.length(); i++)
        hash++;
    return String(hash, HEX);
}

int writeToSerial (SoftwareSerial &serial, String ADXL335, String BMP180, String GPS) {
    String checkSum = createChecksum(ADXL335, BMP180, GPS);

    serial.print("@#" + checkSum);
    serial.print("ADXL:");
    serial.print(ADXL335);
    serial.print(";BMP180:" + BMP180);
    serial.print(";GPS:");
    serial.print(GPS);
    serial.print("\n");

    Serial.print("@#" + checkSum);
    Serial.print("ADXL:");
    Serial.print(ADXL335);
    Serial.print(";BMP180:" + BMP180);
    Serial.print(";GPS:");
    Serial.print(GPS);
    Serial.print("\n");
}
