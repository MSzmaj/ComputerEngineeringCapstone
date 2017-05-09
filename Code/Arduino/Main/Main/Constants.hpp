#ifndef Constants_h
#define Constants_h

#include <stdio.h>
#include "hardwareSerial.h"

#endif /* Constants_h */

//Pins
    //Digital
const int xPin = A2;
const int yPin = A1;
const int zPin = A0;
    //Serial
const byte rxPin = 6;
const byte txPin = 7;
    //I2C
const int sdaOutput = A4;
const int sclInput = A5;

//Accelerometer Calculation Constants
const int minG = 290;
const int maxG = 430;

//Over Sampling for BMP180
const short overSamplingSetting = 0;

//Delays
const int temperatureMeasurementDelay = 5;

