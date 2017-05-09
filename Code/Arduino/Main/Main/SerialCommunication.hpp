#ifndef SerailCommunication_hpp
#define SerailCommunication_hpp

#include <stdio.h>
#include <WString.h>

#endif /* SerailCommunication_hpp */

//Given the return Arduino String from compileData(), Returns
//the checksum. Formula is hash = hash^string[i];
String createChecksum (String compiledData);
//Writes the given data to Serial.
//Format: @#[checksum]ADXL:X:,[x]Y:[y]:,Z:[z];BMP180:T[t],P[p];GPS:[nmeasentence, commadelimited]
int writeToSerial (SoftwareSerial &serial, String ADXL335, String BMP180, String GPS);

