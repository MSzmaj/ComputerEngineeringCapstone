#include "AccelerometerLibrary.hpp"
#include "hardwareSerial.h"
#include "Arduino.h"
#include "Constants.hpp"

int readAccelX (void) {
  int x = analogRead(xPin);
	x = map(x, minG, maxG, -90, 90);
  return x;
}

int readAccelY (void) {
  int y = analogRead(yPin);
	y = map(y, minG, maxG, -90, 90);
  return y;
}

int readAccelZ (void) {
  int z = analogRead(zPin);
	z = map(z, minG, maxG, -90, 90);
  return z;
}

String getAccelerometerReading (void) {
    String x = String(readAccelX());
    String y = String(readAccelY());
    String z = String(readAccelZ());
    return "X:" + x + ",Y:" + y + ",Z:" + z;
}

