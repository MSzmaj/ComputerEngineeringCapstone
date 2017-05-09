#ifndef gpsLibrary_hpp
#define gpsLibrary_hpp

#include <SoftwareSerial.h>
#include <WString.h>
#include <Arduino.h>

#endif /* gpsLibrary_hpp */

#define nmeaLenth 120
#define nmeaOutputRMCONLY "$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29"
#define nmeaOutputRMCGGA "$PMTK314,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*28"
#define nmeaUpdate "$PMTK220,1000*1F"
#define antennaStatus "$PGCMD,33,1*6C"

//Initialises the GPS by writing the correct NMEA output sentences
//to the given hardware serial.
int initialiseGPS (HardwareSerial *serial);
//Sets the given NMEA string to the NMEA sentence provided by
//the GPS module. Returns true if the sentence is complete.
//Returns false if sentence is not complete. Used to determine
//if we can send the sentence to serial.
boolean getGPSData (HardwareSerial *serial, String &nmea);
