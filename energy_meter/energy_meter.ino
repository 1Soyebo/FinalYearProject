// EmonLibrary examples openenergymonitor.org, Licence GNU GPL V3
#include <ArduinoJson.h>
#include "EmonLib.h"                   // Include Emon Library
#include <SoftwareSerial.h>

#define ANALOG_IN_PIN A3

SoftwareSerial mySerial = SoftwareSerial(8,7);
EnergyMonitor emon1;                   // Create an instance

String apn = "web.gprs.mtnnigeria.net"; //APN
String apn_u = "";                     //APN-Username
String apn_p = "";                    //APN-Password
String url = "http://adafruitapi.herokuapp.com/api/post/";  //URL for HTTP-POST-REQUEST
String json;   //String for the json Paramter (e.g. jason)

double units = 10; // IN UNITS IN WH
int measurements = 60;
int numMeasurements = 0;
int kwmUsed = 0;
float kw = 0;
int instantaneousPower = 0;
float initial_current =0.0;
bool first_run = true;

// Floats for ADC voltage & Input voltage
float adc_voltage = 0.0;
float in_voltage = 0.0;
float ac_voltage = 0.0;

// Floats for resistor values in divider (in ohms)
float R1 = 30000.0;
float R2 = 7500.0; 

// Float for Reference Voltage
float ref_voltage = 5.0;

// Integer for ADC value
int adc_value = 0;
int samples = 0;

void setup()
{  
  Serial.begin(9600);
  mySerial.begin(9600); // the GPRS baud rate   
  emon1.current(0, 130.1);     
  delay(300);        
}

void loop()
{

  if (first_run){
    initial_current = emon1.calcIrms(1480);
  }

  first_run = false;

  double Irms = emon1.calcIrms(1480);  // Calculate Irms only
  Irms = Irms < initial_current ? 0 : Irms - initial_current;
  
  instantaneousPower = Irms*230.0;
  numMeasurements ++;
  
  kwmUsed = kwmUsed + instantaneousPower;
  
  adc_value = analogRead(ANALOG_IN_PIN);
  adc_voltage  = (adc_value * ref_voltage) / 1024.0; 
  in_voltage = adc_voltage / (R2/(R1+R2)); 
  ac_voltage = map(in_voltage, 0, 15.27, 0, 230);

  kw = Irms * ac_voltage;
  
  Serial.print("AC Voltage = ");
  Serial.print(ac_voltage, 2);
  Serial.print("AC Current = ");
  Serial.print(Irms, 2);
  Serial.print(" w = ");
  Serial.println(kw, 2);
  

  if (samples > 10){
      postToServer(ac_voltage, Irms, kw);
      samples++;
  }

  samples++;
}

void resetMeasures(){

  kwmUsed = 0;
  numMeasurements = 0;
  
  };

void postToServer(float voltage, float current, float power){
  mySerial.println("AT");
  runsl();//Print GSM Status an the Serial Output;
  delay(4000);
  mySerial.println("AT+CCLK?"); //CHECK STATUS OF RTC ONSTARTUP SYNCING
  runsl();
  delay(100);
  mySerial.println("AT+SAPBR=3,1,Contype,GPRS");
  runsl();
  delay(100);
  mySerial.println("AT+SAPBR=3,1,APN," + apn);
  runsl();
  delay(100);
  mySerial.println("AT+SAPBR =1,1");
  runsl();
  delay(100);
  mySerial.println("AT+SAPBR=2,1");
  runsl();
  delay(2000);
  mySerial.println("AT+HTTPINIT");
  runsl();
  delay(100);
  mySerial.println("AT+HTTPPARA=CID,1");
  runsl();
  delay(100);
  mySerial.println("AT+HTTPPARA=URL," + url);
  runsl();
  delay(100);
  mySerial.println("AT+HTTPPARA=CONTENT,application/json");
  runsl();
  delay(100);
  mySerial.println("AT+HTTPDATA=192,10000");
  runsl();
  delay(100);
  
  StaticJsonBuffer<200> jsonBuffer;
  JsonObject& root = jsonBuffer.createObject();
  
  root["power"] = power;
  root["current"] = current;
  root["voltage"] = voltage;
  
  String place_holder;
  root.printTo(place_holder);
  json = place_holder;
  mySerial.println(json);
  runsl();
  
  delay(10000);
  mySerial.println("AT+HTTPACTION=1");
  runsl();
  delay(5000);
  mySerial.println("AT+HTTPREAD");
  runsl();
  delay(100);
  mySerial.println("AT+HTTPTERM");
  runsl(); 
  delay(100); 
}

//Print GSM Status
void runsl() {
  while (mySerial.available()) {
    Serial.write(mySerial.read());
  }

}

//void ShowSerialData()
//{
//  while(gprsSerial.available()!=0)
//  Serial.println(gprsSerial.read());
//  delay(5000); 
//}
//  
