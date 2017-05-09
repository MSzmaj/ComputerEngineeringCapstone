#ifndef BMP180Library_hpp
#define BMP180Library_hpp

#include <stdio.h>
#include <String.h>

#endif /* BMP180Library_hpp */

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

//Functions
//Assigns the specific values for:
//AC1, AC2, AC3, BB1, BB2, MB, MC,
//MD, AC4, AC5, AC6.
int calibrateBMP180 (void);
//Depending on the given timer it will start or get
//temperature and pressure readings. Once read
//returns 1 if ready, 0 otherwise. Resets timer
//accordingly.
int getBMP180Readings (long &rawTemperature, long &rawPressure, int &timer);
//Given the address for MSB and LSB returns the value
//at the addresses -- OR'd together after shifting MSB left
//by eight -- as a short.
short readShort (char MSBaddress, char LSBaddress);
//Given the address for MSB and LSB returns the value
//at the addresses -- OR'd together after shifting MSB left
//by eight -- as an unsigned short.
unsigned short readUnsignedShort (char MSBaddress, char LSBaddress);
//Returns the value at the the provided address as an unsigned char.
unsigned char readRegister (char address);
//Writes the given value to the given address.
//Returns the error message provided by Wire.endTransmission.
int writeToRegister (char address, char value);
//Writes to the temperature register of the BMP180.
//Returns the error from the write.
int startTemperatureMeasurement (void);
//Returns the uncompensated temperature as a long
long getUncompensatedTemperature (void);
//Using the uncompensated temperature, calculates the actual temperature.
long getTemperature (void);
//Writes to the pressure register of the BMP180.
//Returns the error from the write.
int startPressureMeasurement (void);
//Returns the uncompensated pressure as a long
long getUncompensatedPressure (void);
//Using the uncompensated pressure, calculates the actual pressure.
long getPressure (void);
//Returns the delay for pressure measurement depending on the over-sampling setting.
int getUncompensatedPressureDelay (void);
//Returns an Arduino String with the provided data.
//Format is "T[temperature],P[pressure];".
String compiledBMP180Data (long temperature, long pressure);
