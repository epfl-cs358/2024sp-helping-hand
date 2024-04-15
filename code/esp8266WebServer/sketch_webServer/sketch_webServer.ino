/**
Simple web server

credits:
WiFiWebServer usage: https://github.com/khoih-prog/WiFiWebServer/tree/master
Preferences usage: https://github.com/vshymanskyy/Preferences
*/
#include <ESPmDNS.h>
#include <Preferences.h>
#include "defines.h"

//blue led port
#define LED_BLUE 16

//max size of the string containing the coordinates
#define COORDSTRINGSIZE 15

//server hostname (without the .local)
const char* hostname = "plottercontroller";

//storage of wifi credentials
const char* appNamespace = "web-server";
Preferences preferences;

/*
Setup the wifi connection
*/
void wifiSetup() {
  preferences.begin(appNamespace, true);
  String ssid = preferences.getString("ssid", "");
  String password = preferences.getString("password", "");
  preferences.end();
  Serial.print("ssid: ");
  Serial.println(ssid.c_str());
  Serial.print("password: ");
  Serial.println(password.c_str());
  WiFi.begin(ssid.c_str(), password.c_str());
  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED)
  {
    digitalWrite(LED_BLUE,HIGH);
    delay(500);
    digitalWrite(LED_BLUE,LOW);
    delay(500);
    Serial.print(".");
  }
  if (!MDNS.begin(hostname)) {   // Set the hostname to hostname + ".local"
    Serial.println("Error setting up the hostname (MDNS)!");
  } else {
    Serial.println();
  }
  Serial.print("Connected\nIP address: ");
  Serial.println(WiFi.localIP());
  Serial.print("Hostname: ");
  Serial.print(hostname);
  Serial.println(".local");
}


WiFiWebServer server(80);
const char* rootPath = "/";
const char* moveToPath = "/go-to";
const char* pressPath = "/press";
const char* moveOutPath = "/move-out";

/**
Setup the web server
*/
void webServerSetup() {
  server.on(F(rootPath), handleRoot);
  server.on(F(moveToPath), handleMoveTo);
  server.on(F(pressPath), handlePress);
  server.on(F(moveOutPath), handleMoveOut);
  server.onNotFound(handleNotFound);
  server.begin();
  Serial.println("Web server started");
}

void setup() {
  Serial.begin(115200);
  Serial.println();
  delay(1000); //delay so that the first string is printed
  pinMode(LED_BLUE, OUTPUT);
  wifiSetup();
  webServerSetup();
}

/**
Get the coordinates of the plotter (from memory)
*/
void getCoordinates(int* result) {
  preferences.begin(appNamespace);
  result[0] = preferences.getInt("x", 0);
  result[1] = preferences.getInt("y", 0);
  preferences.end();
}

/**
Set the coordinates of the plotter (to memory)
*/
void setCoordinates(int* coordinates){
  preferences.begin(appNamespace);
  preferences.putInt("x", coordinates[0]);
  preferences.putInt("y", coordinates[1]);
  preferences.end();
}

/**
convert coordinates to string
*/
void coordinatesToString(int* coordinates, char result[COORDSTRINGSIZE]){
  sprintf(result, "%d, %d", coordinates[0], coordinates[1]);
}

/**
Handle the web page at /
*/
void handleRoot() {
  digitalWrite(LED_BLUE, HIGH);
  if(isGet()){
    int coordinates[2] = {0, 0};
    getCoordinates(coordinates);
    char str[COORDSTRINGSIZE];
    coordinatesToString(coordinates, str);
    String message = String("hello world\n");
    message += str;
    server.send(200, F("text/plain"), message.c_str());
  }
  digitalWrite(LED_BLUE, LOW);
}

/**
Handle the web page at /move-to
*/
void handleMoveTo() {
  digitalWrite(LED_BLUE, HIGH);
  if(isGet()){
    int coord[2] = {0,0};
    coord[0] = atoi(server.arg("x").c_str());
    coord[1] = atoi(server.arg("y").c_str());
    setCoordinates(coord);
    server.send(200, F("text/plain"), "OK");
  }
  digitalWrite(LED_BLUE, LOW);
}

void handleMoveOut() {}
void handlePress() {}

void handleNotFound() {
  server.send(404, F("text/plain"), "404 not found");
}

/**
Check if it's a get request. Send back an error if not.
*/
bool isGet(){
  if(server.method() != HTTP_GET){
    server.send(405, F("text/plain"), F("Method not allowed"));
    return false;
  }
  return true;
}


void loop() {
  server.handleClient();
}
