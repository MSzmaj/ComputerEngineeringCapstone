#include <Arduino.h>

#include <stdio.h>
#include <Wire.h>
#include <math.h>
#include "BMP180Library.hpp"
#include "BMP180Debugging.hpp"

short AC1, AC2, AC3, AC4, AC5, AC6, VB1, VB2, MB, MC, MD;
short OverSamplingSetting;
int PressureMeasurementDelay;
long B3, B5, B6;
unsigned long B4, B7;

const int sdaOutput = A4;
const int sclInput = A5;

void setup() {
  int temperatureWaitTime, pressureWaitTime;
  double temperatureMeasurement, pressureMeasurement;
  unsigned char* temperatureData;
  long* pressureData;

  Serial.begin(9600);
  initialiseBMP180(StandardPowerSamplingSetting);
  debugCalibration();
}

void loop() {

}
