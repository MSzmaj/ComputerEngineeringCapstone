#include <Wire.h>
#include <Arduino.h>
#include <math.h>
#include <String.h>
#include "BMP180Library.hpp"
#include "BMP180LibraryDebugging.hpp"

int calibrateBMP180 () {
    AC1 = readShort(0xAA, 0xAB);
    AC2 = readShort(0xAC, 0xAD);
    AC3 = readShort(0xAE, 0xAF);
    AC4 = readUnsignedShort(0xB0, 0xB1);
    AC5 = readUnsignedShort(0xB2, 0xB3);
    AC6 = readUnsignedShort(0xB4, 0xB5);
    BB1 = readShort(0xB6, 0xB7);
    BB2 = readShort(0xB8, 0xB9);
    MB = readShort(0xBA, 0xBB);
    MC = readShort(0xBC, 0xBD);
    MD = readShort(0xBE, 0xBF);
#if verbose
    debugCalibration();
#endif
    return 0;
}

short readShort (char MSBaddress, char LSBaddress) {
    short MSB;
    short LSB;
    MSB = (short)readRegister(MSBaddress) << 8;
    LSB = (short)readRegister(LSBaddress);
#if verbose
    Serial.print("MSB: "); Serial.print(MSB); Serial.print(" LSB: "); Serial.println(LSB);
#endif
    return MSB | LSB;
}

unsigned short readUnsignedShort (char MSBaddress, char LSBaddress) {
    unsigned short MSB;
    unsigned short LSB;
    MSB = (unsigned short)readRegister(MSBaddress) << 8;
    LSB = (unsigned short)readRegister(LSBaddress);
#if verbose
    Serial.print("MSB: "); Serial.print(MSB); Serial.print(" LSB: "); Serial.println(LSB);
#endif
    return MSB | LSB;
}

unsigned char readRegister (char address) {
    int error;
    unsigned char value;
    Wire.setClock(100000);
    Wire.beginTransmission(BMP180Address);
    Wire.write(address);
    error = Wire.endTransmission();
    if (error == 0) {
        Wire.requestFrom(BMP180Address, 1);
        value = Wire.read();
    }
    return value;
}

int writeToRegister (char address, char value) {
    int error;
    Wire.setClock(100000);
    Wire.beginTransmission(BMP180Address);
    Wire.write(address);
    Wire.write(value);
    error = Wire.endTransmission();
    return error;
}

long getUncompensatedTemperature () {
    int error;
    long MSB, LSB;
    error = writeToRegister(ControlMeasureRegister, TemperatureMeasureRegister);
    if (error != 0) return -1;
    delay(4500);
    MSB = readRegister(MSBRegister);
    LSB = readRegister(LSBRegister);
#if verbose
    Serial.print("MSB: "); Serial.println(MSB);
    Serial.print("LSB: "); Serial.println(LSB);
#endif
    return (long)((MSB << 8) + LSB);
}

long getUncompensatedPressure () {
    int error;
    long MSB, LSB, XLSB;
    error = writeToRegister(ControlMeasureRegister, PressureMeasureRegister + (overSamplingSetting << 6));
    if (error != 0) return -1;
    delay(getUncompensatedPressureDelay());
    MSB = readRegister(MSBRegister);
    LSB = readRegister(LSBRegister);
    XLSB = readRegister(XLSBRegister);
#if verbose
    Serial.print("MSB: "); Serial.println(MSB);
    Serial.print("LSB: "); Serial.println(LSB);
    Serial.print("XLSB: "); Serial.println(XLSB);
#endif
    return long(((MSB << 16) + (LSB << 8) + XLSB) >> (8 - overSamplingSetting));
}

long getTemperature (void) {
    long uncompensatedTemperature;
    uncompensatedTemperature = getUncompensatedTemperature();
    X1 = ((uncompensatedTemperature - AC6) * AC5 / pow(2, 15));
    X2 = ((MC * pow(2, 11)) / (X1 + MD));
    B5 = (X1 + X2);
#if verbose
    Serial.print("X1: "); Serial.println(X1);
    Serial.print("X2: "); Serial.println(X2);
    Serial.print("B5: "); Serial.println(B5);
#endif
    return ((B5 + 8) / pow(2, 4));
}

long getPressure () {
    long uncompensatedPressure, pressure;
    uncompensatedPressure = getUncompensatedPressure();
    B6 = (B5 - 4000);
#if verbose
    Serial.print("B6: "); Serial.println(B6);
#endif
    X1 = (BB2 * (B6 * (B6 / pow(2, 12)))/ pow(2, 11));
#if verbose
    Serial.print("X1: "); Serial.println(X1);
#endif
    X2 = (AC2 * B6 / pow(2, 11));
#if verbose
    Serial.print("X2: "); Serial.println(X2);
#endif
    X3 = (X1 + X2);
#if verbose
    Serial.print("X3: "); Serial.println(X3);
#endif
    B3 = (((((unsigned long)AC1 * 4 + X3) << overSamplingSetting) + 2) / 4);
#if verbose
    Serial.print("B3: "); Serial.println(B3);
#endif
    X1 = ((unsigned long)AC3 * B6 / pow(2, 13));
#if verbose
    Serial.print("X1: "); Serial.println(X1);
#endif
    X2 = ((BB1 * (B6 * B6 / pow(2, 12)) / pow(2, 16)));
#if verbose
    Serial.print("X2: "); Serial.println(X2);
#endif
    X3 = (((X1 + X2) + 2) / pow(2, 2));
#if verbose
    Serial.print("X3: "); Serial.println(X3);
#endif
    B4 = (AC4 * (unsigned long)(X3 + 32768) / pow(2,15));
#if verbose
    Serial.print("B4: "); Serial.println(B4);
#endif
    B7 = (((unsigned long)uncompensatedPressure - B3) * (50000 >> overSamplingSetting));
#if verbose
    Serial.print("B7: "); Serial.println(B7);
#endif
    if (B7 < 0x80000000) {
        pressure = ((B7 * 2) / B4);
    } else {
        pressure = ((B7 / B4) * 2);
    }
#if verbose
    Serial.print("P: "); Serial.println(pressure);
#endif
    X1 = ((pressure / pow(2, 8)) * (pressure / pow(2, 8)));
#if verbose
    Serial.print("X1: "); Serial.println(X1);
#endif
    X1 = ((X1 * 3038) / pow(2, 16));
#if verbose
    Serial.print("X1: "); Serial.println(X1);
#endif
    X2 = ((-7357 * pressure) / pow(2, 16));
#if verbose
    Serial.print("X2: "); Serial.println(X2);
#endif
    return (pressure + (X1 + X2 + 3791) / pow(2, 4));
}

int getUncompensatedPressureDelay () {
    switch (overSamplingSetting) {
        case UltraLowPowerSamplingSetting:
            return 5;
            break;
        case StandardPowerSamplingSetting:
            return 8;
            break;
        case HighPowerSamplingSetting:
            return 14;
            break;
        case UltraHighPowerSamplingSetting:
            return 26;
            break;
    }
    return 0;
}

String compiledBMP180Data (float temperature, float pressure) {
    String returnString = "T:";
    returnString += String(temperature);
    returnString += "C,";
    returnString += String(pressure);
    returnString += "kPa;";
    return returnString;
}
