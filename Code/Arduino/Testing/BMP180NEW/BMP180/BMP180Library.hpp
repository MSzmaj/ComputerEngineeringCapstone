#ifndef BMP180Library_hpp
#define BMP180Library_hpp

#include <stdio.h>
#include <String.h>

#endif /* BMP180Library_hpp */

//Debugging
#define verbose 0

//Registers
#define BMP180Address 0x77
#define ControlMeasureRegister 0xF4
#define TemperatureMeasureRegister 0x2E
#define PressureMeasureRegister 0x34
#define MSBRegister 0xF6
#define LSBRegister 0xF7
#define XLSBRegister 0xF8

//Over Sampling
#define UltraLowPowerSamplingSetting 0
#define StandardPowerSamplingSetting 1
#define HighPowerSamplingSetting 2
#define UltraHighPowerSamplingSetting 3

//External Variables
extern short AC1, AC2, AC3, BB1, BB2, MB, MC, MD;
extern unsigned short AC4, AC5, AC6;
extern long uncompensatedTemperature, uncompensatedPressure, X1, X2, B5, temperature, B6, X3, pressure;
extern unsigned long B3, B4, B7;

//Constants
const int sdaOutput = A4;
const int sclInput = A5;
const short overSamplingSetting = 0;

//Functions
int calibrateBMP180 (void);
short readShort (char MSBaddress, char LSBaddress);
unsigned short readUnsignedShort (char MSBaddress, char LSBaddress);
unsigned char readRegister (char address);
int writeToRegister (char address, char value);
long getUncompensatedTemperature (void);
long getTemperature (void);
long getUncompensatedPressure (void);
long getPressure (void);
int getUncompensatedPressureDelay (void);
String compiledBMP180Data (float temperature, float pressure);
