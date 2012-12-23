#include <Servo.h>

Servo Lservo, Mservo, Rservo;

void setup(){
  Lservo.attach(9); // left
  Mservo.attach(8); // middle
  Rservo.attach(7); // right
 
  Serial.begin(19200); // 19200 is the rate of communication
  
  Serial.println("Rolling"); // some output for debug purposes.
 
}

void loop() {
  static int angle = 0; // value to be sent to the servos (0-180)
  
  if ( Serial.available()) {
    char ch = Serial.read(); // read in a character from the serial port and assign to ch
    switch(ch) { // switch based on the value of ch
      case '0'...'9': // if it's numeric
        angle = angle * 10 + ch - '0';
        break;
        
      case 'L': // left pixel
        Lservo.write(angle);
        angle = 0;
        break;
        
      case 'M': // middle pixel
        Mservo.write(angle);
        angle = 0;
        break;
        
      case 'R': // right pixel
        Rservo.write(angle);
        angle = 0;
        break;
    }
  }
}
