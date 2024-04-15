/**
Put in the flash memory values needed for the web server:
- wifi credentials (ssid & password)
*/
#include <Preferences.h>

Preferences preferences;
const char* appNamespace = "web-server";
const char* ssid = "SPOT-iot";
const char* password = "";

void setup() {
    Serial.begin(115200);
    Serial.println();
    preferences.begin(appNamespace, false);
    preferences.clear();
    preferences.putString("ssid", ssid);
    preferences.putString("password", password);
    preferences.end();
    Serial.println("Wifi credentials saved");
}

void loop(){

}