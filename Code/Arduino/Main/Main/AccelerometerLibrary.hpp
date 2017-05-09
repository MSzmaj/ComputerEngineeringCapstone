#ifndef AccelerometerLibrary_hpp
#define AccelerometerLibrary_hpp

#include <stdio.h>
#include <WString.h>

#endif /* AccelerometerLibrary_hpp */

//Returns the X value as a float.
int readAccelX (void);
//Returns the Y value as a float.
int readAccelY (void);
//Returns the Z value as a float.
int readAccelZ (void);
//Gets and returns X, Y, Z values as
//a string containing X, Y, Z values.
//Format "X:[x],Y:[y],Z[z];".
String getAccelerometerReading (void);

