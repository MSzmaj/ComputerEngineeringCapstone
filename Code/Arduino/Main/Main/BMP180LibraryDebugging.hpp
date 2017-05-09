#ifndef BMP180LibraryDebugging_hpp
#define BMP180LibraryDebugging_hpp

#include <stdio.h>

#endif /* BMP180LibraryDebugging_hpp */

//Prints to serial the values for calibration
void debugCalibration (void);
//Prints to serial the values read from sensor
void debugReadings (long UT, long UP, float T, float P);
