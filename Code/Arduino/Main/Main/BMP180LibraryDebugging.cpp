#include <Arduino.h>
#include "BMP180Library.hpp"

void debugCalibration (void) {
    Serial.print("AC1: "); Serial.println(AC1);
    Serial.print("AC2: "); Serial.println(AC2);
    Serial.print("AC3: "); Serial.println(AC3);
    Serial.print("AC4: "); Serial.println(AC4);
    Serial.print("AC5: "); Serial.println(AC5);
    Serial.print("AC6: "); Serial.println(AC6);
    Serial.print("B1: "); Serial.println(BB1);
    Serial.print("B2: "); Serial.println(BB2);
    Serial.print("MB: "); Serial.println(MB);
    Serial.print("MC: "); Serial.println(MC);
    Serial.print("MD: "); Serial.println(MD);
}

void debugReadings (long UT, long UP, float T, float P) {
    Serial.print("UT: "); Serial.println(UT);
    Serial.print("UP: "); Serial.println(UP);
    Serial.print("T: "); Serial.println(T);
    Serial.print("P: "); Serial.println(P);
}

