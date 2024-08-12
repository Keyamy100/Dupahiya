#include <WaspFrame.h> 
char WaspmoteID[] = "node_01";

  
void setup()
{
 
  USB.OFF();  
  USB.println(F("Start"));
  frame.setID(WaspmoteID);
}

void loop()
{
  frame.createFrame(BINARY);
  frame.addSensor(SENSOR_STR, "this_is_a_string");
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());
  frame.showFrame();

  delay(5000);
}
