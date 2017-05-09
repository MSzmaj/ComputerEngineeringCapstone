#include <WString.h>
#include "gpsLibrary.hpp"

String nmea = "";

void setup() {
  initialiseGPS(&Serial);
}

void loop() {
  if (getGPSData(&Serial, nmea)) {
    Serial.print("GET: ");
    Serial.print(nmea);
    Serial.print("\n");
    nmea = "";
  }
}


