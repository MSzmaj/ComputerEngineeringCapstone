const int xpin = A0;
const int ypin = A1;
const int zpin = A2;

void setup()
{
    Serial.begin(9600);
}

void loop()
{
    int xmin = 290;
    int xmax = 430;
    int x = analogRead(xpin);
    int y = analogRead(ypin);
    int z = analogRead(zpin);
    x = map(x,xmin,xmax,-90,90);
    y = map(y,xmin,xmax,-90,90);
    z = map(z,xmin,xmax,-90,90);
    Serial.print(x);
    Serial.print("\t");
    Serial.print(y);
    Serial.print("\t");
    Serial.print(z);
    Serial.print("\n");
    delay(10);
}
