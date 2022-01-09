#include <SoftwareSerial.h>
SoftwareSerial mySerial(2,3); //Connect Tx and Rx from HM-10 to 2, and 3 on arduino nano/uno.
int num = 0; // To count through each byte in the array.
char bytes[8]; // Where we will store each individual byte before converting to our location struct.

struct Location{
  float lat; // 4 bytes on arduino uno/nano
  float lng; // 4 bytes on arduino uno/nano
};

Location loc;

void setup(){
  mySerial.begin(9600);
  Serial.begin(9600);
  mySerial.write("AT+NAME=ExampleName"); //Set the name you want to see on the HM-10
}
void loop(){
  if (mySerial.available()){
    bytes[num] = mySerial.read();
    if(num == 7){
      // Copy bytes from bytes into our location struct.
      memcpy(&loc, bytes, sizeof(bytes));
      Serial.print("Lat: ");
      Serial.print(loc.lat, 6);
      Serial.print(", Long: ");
      Serial.println(loc.lng, 6);
      //reset the counter
      num = 0;
      mySerial.write("Position Recieved");
    } else{
      num++;
    }
  }
}
