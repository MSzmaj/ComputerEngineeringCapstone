//
//  BMP180Debugging.cpp
//
//
//  Created by Michal Szmaj on 2017-01-22.
//
//

#include "BMP180Debugging.hpp"
#include "BMP180Library.hpp"
#include "hardwareSerial.h"

void debugCalibration () {
    Serial.print("AC1: ");
    Serial.print(AC1);
    Serial.print("\n");
    Serial.print("AC2: ");
    Serial.print(AC2);
    Serial.print("\n");
    Serial.print("AC3: ");
    Serial.print(AC3);
    Serial.print("\n");
    Serial.print("AC4: ");
    Serial.print(AC4);
    Serial.print("\n");
    Serial.print("AC5: ");
    Serial.print(AC5);
    Serial.print("\n");
    Serial.print("AC6: ");
    Serial.print(AC6);
    Serial.print("\n");
    Serial.print("VB1: ");
    Serial.print(VB1);
    Serial.print("\n");
    Serial.print("VB2: ");
    Serial.print(VB2);
    Serial.print("\n");
    Serial.print("MB: ");
    Serial.print(MB);
    Serial.print("\n");
    Serial.print("MC: ");
    Serial.print(MC);
    Serial.print("\n");
    Serial.print("MD: ");
    Serial.print(MD);
    Serial.print("\n");
    Serial.print("\n");
}

void debugTemperatureReadings (double temperatureMeasurement, unsigned char* temperatureData) {
    Serial.print("Temperature: ");
    Serial.print(temperatureMeasurement);
    Serial.print(" in degrees Celsius");
    Serial.print("\n");
    Serial.print("1: ");
    Serial.print(temperatureData[0]);
    Serial.print("\n");
    Serial.print("2: ");
    Serial.print(temperatureData[1]);
    Serial.print("\n");
    Serial.print("3: ");
    Serial.print(temperatureData[2]);
    Serial.print("\n");
    Serial.print("4: ");
    Serial.print(temperatureData[3]);
    Serial.print("\n");
}

void debugPressureReadings (double pressureMeasurement, long* pressureData) {
    Serial.print("Uncompensated Pressure: ");
    Serial.print(pressureData[0]);
    Serial.print("\n");
    Serial.print("Compensated Pressure: ");
    Serial.print(pressureMeasurement);
    Serial.print(" in kPa");
    Serial.print("\n");
    Serial.print("X1: ");
    Serial.print(pressureData[1]);
    Serial.print("\n");
    Serial.print("X2: ");
    Serial.print(pressureData[2]);
    Serial.print("\n");
    Serial.print("X3: ");
    Serial.print(pressureData[3]);
    Serial.print("\n");
    Serial.print("B3: ");
    Serial.print(pressureData[4]);
    Serial.print("\n");
    Serial.print("B4: ");
    Serial.print(pressureData[5]);
    Serial.print("\n");
    Serial.print("B5: ");
    Serial.print(pressureData[6]);
    Serial.print("\n");
    Serial.print("B6: ");
    Serial.print(pressureData[7]);
    Serial.print("\n");
    Serial.print("B7: ");
    Serial.print(pressureData[8]);
    Serial.print("\n");
}
