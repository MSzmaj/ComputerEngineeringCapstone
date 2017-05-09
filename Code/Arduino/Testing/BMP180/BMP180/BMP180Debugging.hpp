//
//  BMP180Debugging.hpp
//
//
//  Created by Michal Szmaj on 2017-01-22.
//
//

#ifndef BMP180Debugging_hpp
#define BMP180Debugging_hpp

#include <stdio.h>

#endif /* BMP180Debugging_hpp */

void debugCalibration (void);

void debugTemperatureReadings (double temperatureMeasurement, unsigned char* temperatureData);

void debugPressureReadings (double pressureMeasurement, long* pressureData);
