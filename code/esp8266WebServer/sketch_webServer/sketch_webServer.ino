/**
Simple web server

credits:
WiFiWebServer usage: https://github.com/khoih-prog/WiFiWebServer/tree/master
Preferences usage: https://github.com/vshymanskyy/Preferences
*/
#include <ESPmDNS.h>
#include <Preferences.h>
#include <WiFi.h>
#include <WebServer.h>
#include <AccelStepper.h>
#include <MultiStepper.h>
#include <ESP32Servo.h>
#define MotorInterfaceType 1

//blue led port
#define LED_BLUE 16

//max size of the string containing the coordinates
#define COORDSTRINGSIZE 15

//server hostname (without the .local)
const char* hostname = "plottercontroller";

//storage of wifi credentials
const char* appNamespace = "web-server";
Preferences preferences;

//motors parameters: DO NOT USE 25 & 26 pins
AccelStepper X(MotorInterfaceType, 0, 4); //16: step, 17: direction
AccelStepper Y(MotorInterfaceType, 32, 33); //32: step, 33: direction
MultiStepper XY;
#define MOTOR_MAX_SPEED 300.0
const int MAX_X = 850;
const int MAX_Y = 530;
const int MOVE_OUT_X = 0;
const int MOVE_OUT_Y = 0;

//servo parameters
const int SERVO_PIN = 18;
const int UP_ANGLE = 90;
const int PRESS_ANGLE = 190;
const int SERVO_SHORT_DELAY = 300; //in ms
const int SERVO_LONG_DELAY = 1500; //in ms
const int SERVO_DELAY = 300; //in ms (delay for the servo to go up)
Servo servo;

//pin for the plotter limit
const int LIMIT_PIN = 23;
const int POS_STEP = 5;
const int CALBRATION_DELAY = 200; //delay between x and y calibration in ms

//plotter position
int position[2] = {0, 0};

/*
Setup the servo
*/
void servoSetup() {
  servo.attach(SERVO_PIN);
  servo.write(UP_ANGLE);
}

/*
Setup the motors
*/
void motorsSetup() {
  X.setMaxSpeed(MOTOR_MAX_SPEED);
  Y.setMaxSpeed(MOTOR_MAX_SPEED);
  XY.addStepper(X);
  XY.addStepper(Y);
}

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


WebServer server(80);
const char* rootPath = "/";
const char* moveToPath = "/go-to";
const char* shortPressPath = "/short-press";
const char* longPressPath = "/long-press";
const char* moveOutPath = "/move-out";
const char* discoveryPath = "/discovery-hh";

/**
Setup the web server
*/
void webServerSetup() {
  server.enableCORS();
  server.on(F(rootPath), handleRoot);
  server.on(F(moveToPath), handleMoveTo);
  server.on(F(shortPressPath), handleShortPress);
  server.on(F(longPressPath), handleLongPress);
  server.on(F(moveOutPath), handleMoveOut);
  server.on(F(discoveryPath), handleDiscovery);
  server.onNotFound(handleNotFound);
  server.begin();
  Serial.println("Web server started");
}

/**
Calibrate the plotter origin
*/
void calibrate(){
  //getCoordinates(position);
  pinMode(LIMIT_PIN, INPUT_PULLUP);

  //x
  while(!digitalRead(LIMIT_PIN)){
    position[0] -= POS_STEP;
    goTo(position[0], position[1]);
  }
  Serial.println("X");
  while(digitalRead(LIMIT_PIN)){
    position[0] += POS_STEP;
    goTo(position[0], position[1]);
  }
  Serial.println("NX");
  delay(CALBRATION_DELAY);
  //y
  while(!digitalRead(LIMIT_PIN)){
    position[1] -= POS_STEP;
    goTo(position[0], position[1]);
  }
  Serial.println("Y");
  while(digitalRead(LIMIT_PIN)){
    position[1] += POS_STEP;
    goTo(position[0], position[1]);
  }
  Serial.println("NY");
  position[0] = 0;
  position[1] = 0;
  X.setCurrentPosition(0);
  Y.setCurrentPosition(0);
  //setCoordinates(position);
}

void setup() {
  Serial.begin(115200);
  Serial.println();
  delay(1000); //delay so that the first string is printed
  Serial.println("HELLO");
  pinMode(LED_BLUE, OUTPUT);
  motorsSetup();
  servoSetup();
  calibrate();
  wifiSetup();
  webServerSetup();
}

/*
Move the motors the the (x,y) position
*/
void goTo(int x, int y) {
  long pos[2] = {x,y};
  XY.moveTo(pos);
  XY.runSpeedToPosition();
  while(X.distanceToGo() != 0 || Y.distanceToGo() != 0){} //wait for the plotter to stop
}

/**
Get the coordinates of the plotter (from memory)
*/
/*void getCoordinates(int* result) {
  preferences.begin(appNamespace);
  result[0] = preferences.getInt("x", 0);
  result[1] = preferences.getInt("y", 0);
  preferences.end();
}*/

/**
Set the coordinates of the plotter (to memory)
*/
/*void setCoordinates(int* coordinates){
  preferences.begin(appNamespace);
  preferences.putInt("x", coordinates[0]);
  preferences.putInt("y", coordinates[1]);
  preferences.end();
}*/

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
    //int coordinates[2] = {0, 0};
    //getCoordinates(coordinates);
    char str[COORDSTRINGSIZE];
    coordinatesToString(position, str);
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
    if(coord[0] < 0) coord[0] = 0;
    if(coord[1] < 0) coord[1] = 0;
    if(coord[0] > MAX_X) coord[0] = MAX_X;
    if(coord[1] > MAX_Y) coord[1] = MAX_Y;
    //setCoordinates(coord);
    position[0] = coord[0];
    position[1] = coord[1];
    goTo(coord[0], coord[1]);
    Serial.println(coord[0]);
    Serial.println(coord[1]);
    server.send(200, F("text/plain"), "OK");
  }
  digitalWrite(LED_BLUE, LOW);
}

/**
Handle the web page at /discovery-hh
Returns device type (PLO) and the mac address
*/
void handleDiscovery() {
  if(isGet()){
    String message = String("PLO");
    message += ",";
    message += WiFi.macAddress();
    server.send(200, F("text/plain"), message.c_str());
  }
}

//move out of the remote
void handleMoveOut() {
  goTo(MOVE_OUT_X, MOVE_OUT_Y);
  int coord[2] = {MOVE_OUT_X, MOVE_OUT_Y};
  //setCoordinates(coord);
  position[0] = 0;
  position[1] = 0;
  server.send(200, F("text/plain"), "OK");
}

//execute short press
void handleShortPress() {
  servo.write(PRESS_ANGLE);
  delay(SERVO_SHORT_DELAY);
  servo.write(UP_ANGLE);
  delay(SERVO_DELAY);
  server.send(200, F("text/plain"), "OK");
}

//execute long press
void handleLongPress() {
  servo.write(PRESS_ANGLE);
  delay(SERVO_LONG_DELAY);
  servo.write(UP_ANGLE);
  delay(SERVO_DELAY);
  server.send(200, F("text/plain"), "OK");
}

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