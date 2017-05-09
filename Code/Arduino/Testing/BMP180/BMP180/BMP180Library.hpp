//
//  BMP180Library.hpp
//
//
//  Created by Michal Szmaj on 2017-01-19.
//
//

#ifndef BMP180Library_hpp
#define BMP180Library_hpp

#include <stdio.h>

#endif /* BMP180Library_hpp */

//Registers
#define BMP180Address 0x77
#define ControlMeasureRegister 0xF4
#define TemperatureMeasureRegister 0x2E
#define PressureMeasureRegister 0x34
#define TemperatureConversionTime 5
#define MSBRegister 0xF6
#define LSBRegister 0xF7
#define XLSBRegister 0xF8

//Over Sampling
#define UltraLowPowerSamplingSetting 0
#define StandardPowerSamplingSetting 1
#define HighPowerSamplingSetting 2
#define UltraHighPowerSamplingSetting 3

//External Variables
extern short AC1, AC2, AC3, AC4, AC5, AC6, VB1, VB2, MB, MC, MD;
extern long B3, B5, B6;
extern unsigned long B4, B7;
extern short OverSamplingSetting;
extern int PressureMeasurementDelay;

void initialiseBMP180 (int overSampling);

char readInt (char address, short &value);

char readBytes (unsigned char *values, char length);

char writeBytes (unsigned char *values, char length);

int getUncompensatedTemperature (void);

int getUncompensatedPressure (void);

unsigned char* getTemperature (double &Temp);

long* getPressure (double &Pressure);

long calculateAltitude (double Pressure);
