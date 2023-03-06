#include <Arduino.h>
#include <ESP8266WiFi.h>       //import for wifi functionality
#include <WebSocketsServer.h>  //import for websocket

#include <OneWire.h>
#include <DallasTemperature.h>
#include <bits/stdc++.h>

#define PIN 5 // pwm

const char *SSID = "ssid";      //Wifi SSID (Name)
const char *SSID_PASSWORD = "senha123";  //wifi password

String json;  //variable for json

char tstr[10];  //Character array for temperature
std::string curr;  //Character array for current

// GPIO where the DS18B20 is connected to
const int oneWireBus = 4;

// Setup a oneWire instance to communicate with any OneWire devices
OneWire oneWire(oneWireBus);

// Pass our oneWire reference to Dallas Temperature sensor
DallasTemperature sensors(&oneWire);

WebSocketsServer webSocket = WebSocketsServer(81);  //websocket init with port 81

void webSocketEvent(uint8_t num, WStype_t type, uint8_t *payload, size_t length) {
  //webscket event method
  std::string cmd = "";
  switch (type) {
    case WStype_DISCONNECTED:
      Serial.println("Websocket is disconnected");
      //case when Websocket is disconnected
      break;
    case WStype_CONNECTED:
      {
        //wcase when websocket is connected
        Serial.println("Websocket is connected");
        Serial.println(webSocket.remoteIP(num).toString());
        webSocket.sendTXT(num, "connected");
      }
      break;
    case WStype_TEXT:
      cmd = "";
      for (int i = 0; i < length; i++) {
        cmd = cmd + (char)payload[i];
      }  //merging payload to single string
      //Serial.println(cmd);

      if (cmd != "") {  //when command from app is "poweron"
          curr = cmd;
      }

      webSocket.sendTXT(num, ":success");
      //send response to mobile, if command is "poweron" then response will be "poweron:success"
      //this response can be used to track down the success of command in mobile app.
      break;
    case WStype_FRAGMENT_TEXT_START:
      break;
    case WStype_FRAGMENT_BIN_START:
      break;
    case WStype_BIN:
      hexdump(payload, length);
      break;
    default:
      break;
  }
}

String chr2str(char *chr) {  //function to convert characters to String
  String rval;
  for (int x = 0; x < strlen(chr); x++) {
    rval = rval + chr[x];
  }
  return rval;
}

void connectToWiFi(){
    Serial.println("===========================================================================");
    Serial.println("NODEMCU iniciado.");
    Serial.println("Testando conexao com rede: ");
    try{
      WiFi.begin(SSID, SSID_PASSWORD);
      while (WiFi.status() != WL_CONNECTED) {
        Serial.print("\tConectando a rede: '");
        Serial.print(SSID);
        Serial.print("' ...\n");
        delay(500);
      }
      Serial.println("-------------------------------------------------------------------------");
      Serial.print("NODEMCU conectado a rede : '");
      Serial.print(SSID);
      Serial.print("'.\n");
      Serial.print("\tEndereco de IP: ");
      Serial.print(WiFi.localIP());
      Serial.print("'.\n");
      Serial.println("===========================================================================");
    }catch(...){
      Serial.println("Erro: falha ao conectar a rede local. Verifique se os parâmetros SSID e SSID_PASSWORD estão corretos.");
    }
  }

void setup() {
  pinMode(PIN, OUTPUT);
  
  Serial.begin(9600);  //serial start

  connectToWiFi();

  Serial.println("Connecting to wifi");

  /*IPAddress apIP(192, 168, 253, 156);                          //Static IP for wifi gateway
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));  //set Static IP gateway on NodeMCU
  WiFi.softAP(ssid, pass);*/                                     //turn on WIFI

  curr = "0.0";
  webSocket.begin();                  //websocket Begin
  webSocket.onEvent(webSocketEvent);  //set Event for websocket
  Serial.println("Websocket is started");
}

void loop() {
  static int PWMValue = 0;

  PWMValue = std::stof(curr) * 175;
  
  /*if(sig == 0){
    PWMValue++;
    if(PWMValue >= 249){
      sig = 1;
    }
  }
  else{
    PWMValue--;
    if(PWMValue == 0){
      sig = 0;
    }
  }*/
  
  analogWrite(PIN, PWMValue); //entre 0 e 249, entre 0 e 2

  webSocket.loop();  //keep this line on loop method

  sensors.requestTemperatures();
  String temperatureC = String(sensors.getTempCByIndex(0));
  
  json = "{'temp':'" + temperatureC + "'}";
  //formulate JSON string format from characters (Converted to string using chr2str())
  Serial.println(std::stof(curr));
  webSocket.broadcastTXT(json);  //send JSON to mobile

  delay(1);
}