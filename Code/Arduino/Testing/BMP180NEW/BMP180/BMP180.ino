#include <Arduino.h>
#include <stdio.h>
#include <Wire.h>
#include <math.h>
#include "BMP180Library.hpp"
#include "BMP180LibraryDebugging.hpp"

short AC1, AC2, AC3, BB1, BB2, MB, MC, MD;
unsigned short AC4, AC5, AC6;
long uncompensatedTemperature, uncompensatedPressure, X1, X2, B5, temperature, B6, X3, pressure;
unsigned long B3, B4, B7;
int uncompensatedPressureDelay;

void setup() {
    long uncompensatedTemperature, uncompensatedPressure;
    float temperature, pressure;

    Serial.begin(9600);
    Wire.begin();

    calibrateBMP180();

    temperature = getTemperature() / 10.0f;
    pressure = getPressure() / 1000.0f;
    Serial.println(compiledBMP180Data(temperature, pressure));

#if verbose
    debugReadings(uncompensatedTemperature, uncompensatedPressure, temperature, pressure);
#endif
}

void loop() {

}
