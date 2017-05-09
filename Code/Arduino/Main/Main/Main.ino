//Libraries
#include <Arduino.h>
#include <stdio.h>
#include <SoftwareSerial.h>
#include <String.h>
#include "gpsLibrary.hpp"
#include "BMP180LibraryDebugging.hpp"
#include "AccelerometerLibrary.hpp"
#include "hardwareSerial.h"
#include "BMP180Library.hpp"
#include "Constants.hpp"
#include "eepromLibrary.hpp"
#include "SerialCommunication.hpp"

//Macros
#define verbose 0
#define gpsSetting 0

//Declarations
SoftwareSerial softwareSerial (rxPin, txPin);

//External Variables for BMP180
short AC1, AC2, AC3, BB1, BB2, MB, MC, MD;
unsigned short AC4, AC5, AC6;
long X1, X2, X3, B5, B6;
unsigned long B3, B4, B7;

//Globals
int gpsStatus;
boolean gpsReady;
long rawTemperature, rawPressure;
String accelerometerData, barometerData, gpsData, nmea = "";

//Timer
int timerCounter = -1;

//Main
void setup() {
    //Serial.begin(9600);
    softwareSerial.begin(9600);
    initialiseTimer();
    calibrateBMP180();
    initialiseGPS(&Serial);
}

//Loop
void loop() {
    accelerometerData = getAccelerometerReading();
    int bmpReady = getBMP180Readings(rawTemperature, rawPressure, timerCounter);
    if (bmpReady == 1) {
        barometerData = compiledBMP180Data(rawTemperature, rawPressure);
        bmpReady = rawTemperature = rawPressure = 0;
    }
    if (getGPSData(&Serial, nmea)) {
        writeToSerial(softwareSerial, accelerometerData, barometerData, nmea);
        nmea = "";
    }
}

void initialiseTimer () {
    noInterrupts();
    TCCR1A = 0;
    TCCR1B = 0;
    TCNT1 = 0;

    OCR1A = 62500;
    TCCR1B |= (1 << WGM12);
    TCCR1B |= (1 << CS12);
    TIMSK1 |= (1 << OCIE1A);
    interrupts();
}

ISR (TIMER1_COMPA_vect) {
  timerCounter++;
}

