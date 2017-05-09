#include <SoftwareSerial.h>
#include <WString.h>
#include <Arduino.h>
#include <stdlib.h>
#include "gpsLibrary.hpp"

int initialiseGPS (HardwareSerial *serial) {
    serial->begin(9600);
    serial->println(nmeaOutputRMCGGA);
    serial->println(nmeaUpdate);
    serial->println(antennaStatus);

    delay(1000);
    serial->println("$PMTK605*31");
    return 0;
}

boolean getGPSData (HardwareSerial *serial, String &nmea) {
    char c;

    if (!serial->available()) return false;
    c = (char)serial->read();
    if (c == '\n') {
        c = 0;
        nmea += c;
        return true;
    }
    nmea += c;
    return false;
}

