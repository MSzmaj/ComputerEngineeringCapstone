#include <stdio.h>
#include <math.h>
#include <Wire.h>
#include "BMP180Library.hpp"
#include "hardwareSerial.h"

void initialiseBMP180 (int overSampling) {
    Wire.begin();
    readInt(0xAA,AC1);
    readInt(0xAC,AC2);
    readInt(0xAE,AC3);
    readInt(0xB0,AC4);
    readInt(0xB2,AC5);
    readInt(0xB4,AC6);
    readInt(0xB6,VB1);
    readInt(0xB8,VB2);
    readInt(0xBA,MB);
    readInt(0xBC,MC);
    readInt(0xBE,MD);
    switch (overSampling) {
        case 0:
            OverSamplingSetting = UltraLowPowerSamplingSetting;
            PressureMeasurementDelay = 5;
            break;
        case 2:
            OverSamplingSetting = HighPowerSamplingSetting;
            PressureMeasurementDelay = 14;
            break;
        case 3:
            OverSamplingSetting = UltraHighPowerSamplingSetting;
            PressureMeasurementDelay = 26;
            break;
        default:
            OverSamplingSetting = StandardPowerSamplingSetting;
            PressureMeasurementDelay = 8;
            break;
    }
}

char readInt (char address, short &value) {
    unsigned char data[2];
    data[0] = address;
    if (readBytes(data, 2)) {
        value = (int16_t)((data[0]<<8)|data[1]);
        return(1);
    }
}

char readBytes (unsigned char *values, char length) {
    char x;
    int error;
    Wire.setClock(100000);
    Wire.beginTransmission(BMP180Address);
    Wire.write(values[0]);
    error = Wire.endTransmission();
    if (error == 0) {
        Wire.requestFrom(BMP180Address, length);
        while (Wire.available() != length);
        for (x = 0; x < length; x++) {
            values[x] = Wire.read();
        }
        return(1);
    }
    return(0);
}

char writeBytes (unsigned char *values, char length) {
    int error;
    Wire.setClock(100000);
    Wire.beginTransmission(BMP180Address);
    Wire.write(values, length);
    error = Wire.endTransmission();
    if (error == 0) {
        return(1);
    }
    return (0);
}

int getUncompensatedTemperature (void) {
    unsigned char data[2], result;
    data[0] = ControlMeasureRegister;
    data[1] = TemperatureMeasureRegister;
    result = writeBytes(data, 2);
    if (result) {
        return (TemperatureConversionTime);
    }
    return (0);
}

int getUncompensatedPressure (void) {
    unsigned char data[3], result;
    long UP;

    data[0] = ControlMeasureRegister;
    data[1] = PressureMeasureRegister + (OverSamplingSetting << 6);
    result = writeBytes(data, 3);
    if (result) {
        return (PressureMeasurementDelay);
    }
    return (0);
}

unsigned char* getTemperature (double &Temperature) {
    unsigned char data[2];
    long temperatureData[4];
    char result;
    long uncompensatedTemperature, X1, X2;

    data[0] = MSBRegister;

    result = readBytes(data, 2);
    uncompensatedTemperature = (data[0] << 8) + data[1];
    X1 = (uncompensatedTemperature - AC6) * AC5 / pow(2.0, 15.0);
    X2 = MC * pow(2.0, 11.0) / (X1 + MD);
    B5 = X1 + X2;
    Temperature = (B5 + 8) / pow(2.0, 4.0);
    Temperature = Temperature * 0.1;

    temperatureData[0] = uncompensatedTemperature;
    temperatureData[1] = X1;
    temperatureData[2] = X2;
    temperatureData[3] = B5;

    return data;
}

long* getPressure (double &Pressure) {
    uint32_t MSB, LSB, XLSB;
    unsigned char data[3];
    long pressureData[9];
    char result;
    long uncompensatedPressure, X1, X2, X3;
    data[0] = MSBRegister;
    result = readBytes(data, 3);
    MSB = data[0];
    LSB = data[1];
    XLSB = data[2];
    uncompensatedPressure = ((MSB << 16) + (LSB << 8) + XLSB) >> (8 - OverSamplingSetting);
    uncompensatedPressure = uncompensatedPressure;
    B6 = B5 - 4000;
    X1 = (VB2 * (B6 * B6 / pow(2.0, 12.0))) / pow(2.0, 11.0);
    X2 = AC2 * B6 / pow(2.0, 11.0);
    X3 = X1 + X2;
    B3 = (((AC1 * 4 + X3) << OverSamplingSetting) + 2) / 4;
    X1 = AC3 * B6 / pow(2.0, 13.0);
    X2 = (VB1 * (B6 * B6 / pow(2.0, 12.0))) / pow(2.0, 16.0);
    X3 = ((X1 + X2) + 2) / pow(2.0, 2.0);
    B4 = AC4 * (unsigned long) (X3 + 32768) / pow(2.0, 15.0);
    B7 = ((unsigned long) uncompensatedPressure - B3) * (50000 >> OverSamplingSetting);
    if (B7 < 0x80000000) {
        Pressure = (B7 * 2) / B4;
    } else {
        Pressure = (B7 / B4) * 2;
    }
    X1 = (Pressure / pow(2.0, 8.0)) * (Pressure / pow(2.0, 8.0));
    X1 = (X1 * 3038) / pow(2.0, 16);
    X2 = (-7357 * Pressure) / pow(2.0, 16.0);
    Pressure = Pressure + (X1 + X2 + 3791) / pow(2.0, 4.0);
    Pressure = Pressure * 3 / 1000;

    pressureData[0] = (uncompensatedPressure / 1000);
    pressureData[1] = X1;
    pressureData[2] = X2;
    pressureData[3] = X3;
    pressureData[4] = B3;
    pressureData[5] = B4;
    pressureData[6] = B5;
    pressureData[7] = B6;
    pressureData[8] = B7;

    return pressureData;
}

long calculateAltitude (double Pressure) {
    double pressure0 = 1013.25;
    double altitude;
    altitude = 44330 * (1 - pow((Pressure/pressure0), (1/5.255)));
    return altitude;
}
