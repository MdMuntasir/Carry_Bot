#include <ArduinoJson.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h> 
#include <ESP32Servo.h>
#include <HX711.h>

#define distanceTrig 33
#define distanceEcho 35
#define depthTrig 32
#define depthEcho 34
#define leftPin 14
#define rightPin 12
#define servoPin 13
#define dt 25
#define sck 26

#define motor1A 23  // Motor 1 forward
#define motor1B 22  // Motor 1 backward
#define motor2A 4  // Motor 2 forward
#define motor2B 15  // Motor 2 backward
#define motor3A 21  // Motor 3 forward
#define motor3B 19  // Motor 3 backward
#define motor4A 18  // Motor 4 forward
#define motor4B 5  // Motor 4 



int highSpeed = 200;  
int lowSpeed = 100;  

const int PWM_FREQ = 1000;  // PWM frequency in Hz
const int PWM_RESOLUTION = 8;



HX711 scale;
Servo servo;


BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define PASSKEY 123456
bool deviceConnected = false;

bool left = false;
bool right = false;
bool objectDetected = false;
int servoPastVal = 0;
int servoAngle = 90;

bool manualControl = false;









// Control the car's motors

void stopMotors() {
  ledcWrite(motor1A, 0); ledcWrite(motor1B, 0);
  ledcWrite(motor2A, 0); ledcWrite(motor2B, 0);
  ledcWrite(motor3A, 0); ledcWrite(motor3B, 0);
  ledcWrite(motor4A, 0); ledcWrite(motor4B, 0);
}

void setMotor(int fwdChannel, int bwdChannel, int speed, bool direction) {
  if (speed == 0) {
      ledcWrite(fwdChannel, 0);
      ledcWrite(bwdChannel, 0);
  } else if (direction) {
      ledcWrite(fwdChannel, speed);
      ledcWrite(bwdChannel, 0);
  } else {
      ledcWrite(fwdChannel, 0);
      ledcWrite(bwdChannel, speed);
  }
}


void stopCar(int time){
  delay(time);
  stopMotors();
}


void moveCar(String command) {
  command.trim();
  command.toLowerCase();
  Serial.print("Command: "); Serial.println(command);
  stopMotors();

  if (command == "front") {
      setMotor(motor1A, motor1B, highSpeed, true);
      setMotor(motor2A, motor2B, highSpeed, true);
      setMotor(motor3A, motor3B, highSpeed, true);
      setMotor(motor4A, motor4B, highSpeed, true);
      Serial.println("Moving forward");
  }
  else if (command == "back") {
      setMotor(motor1A, motor1B, highSpeed, false);
      setMotor(motor2A, motor2B, highSpeed, false);
      setMotor(motor3A, motor3B, highSpeed, false);
      setMotor(motor4A, motor4B, highSpeed, false);
      Serial.println("Moving backward");
  }
  else if (command == "right") {
      setMotor(motor1A, motor1B, highSpeed, true);
      setMotor(motor2A, motor2B, highSpeed, false);
      setMotor(motor3A, motor3B, highSpeed, true);
      setMotor(motor4A, motor4B, highSpeed, false);
      Serial.println("Turning right");
  }
  else if (command == "left") {
      setMotor(motor1A, motor1B, highSpeed, false);
      setMotor(motor2A, motor2B, highSpeed, true);
      setMotor(motor3A, motor3B, highSpeed, false);
      setMotor(motor4A, motor4B, highSpeed, true);
      Serial.println("Turning left");
  }
  else if (command == "fl") {
      setMotor(motor1A, motor1B, 0, false);      // Stop
      setMotor(motor2A, motor2B, highSpeed, true);  // Front-right forward
      setMotor(motor3A, motor3B, 0, false);      // Stop
      setMotor(motor4A, motor4B, highSpeed, true);  // Rear-right forward
      Serial.println("Front-right diagonal");
  }
  else if (command == "fr") {
      setMotor(motor1A, motor1B, highSpeed, true);  // Front-left forward
      setMotor(motor2A, motor2B, 0, false);      // Stop
      setMotor(motor3A, motor3B, highSpeed, true);  // Rear-left forward
      setMotor(motor4A, motor4B, 0, false);      // Stop
      Serial.println("Front-left diagonal");
  }
  else if (command == "bl") {
      setMotor(motor1A, motor1B, 0, false);      // Stop
      setMotor(motor2A, motor2B, highSpeed, false);      // Stop
      setMotor(motor3A, motor3B, 0, false);      // Stop
      setMotor(motor4A, motor4B, highSpeed, false); // Rear-right backward
      Serial.println("Back-right reverse");
  }
  else if (command == "br") {
      setMotor(motor1A, motor1B, highSpeed, false);      // Stop
      setMotor(motor2A, motor2B, 0, false);      // Stop
      setMotor(motor3A, motor3B, highSpeed, false); // Rear-left backward
      setMotor(motor4A, motor4B, 0, false);      // Stop
      Serial.println("Back-left reverse");
  }
  else if (command == "stop"){
    stopCar(50);
  }
  else {
      stopMotors();
      Serial.println("❌ Invalid command - Car stopped");
  }

  
}



// Object detection system
void sideDetector(){
  int leftSide = !digitalRead(leftPin);
  int rightSide = !digitalRead(rightPin);
  Serial.println(rightSide);

  if(leftSide && left == false){
    left = true;
  }
  else{
    if(left){
      left = false;
    }
  }
  if(rightSide && right == false){
      right = true;
  }
  else{
    if(right){
      right = false;
    }
  }

}



void objctDetector(float distance){
  sideDetector();

  Serial.print("Left: "); Serial.print(left);Serial.print(" | ");
  Serial.print("Right: "); Serial.print(right); Serial.print(" | ");
  Serial.println(distance);

  servoPastVal = servoAngle;
  if(left || right){
    if(left && !right && servoAngle<180){
      servo.write(servoAngle++);
    }
    else if(right && !left && servoAngle>0){
      servo.write(servoAngle--);
    }
    
  }
  else{
    if(servoAngle >= 0 && servoPastVal>servoAngle){
      servo.write(servoAngle--);
      }
    else if(servoAngle <= 180 && servoPastVal<servoAngle)
      servo.write(servoAngle++);
    else if(servoPastVal == 0 && servoAngle == 0)
      servo.write(servoAngle++);
    else if(servoPastVal == 180 && servoAngle == 180)
      servo.write(servoAngle--);
  }
  delay(10);
}





// Initialize Load Sensor

void loadSensorInit(){
  scale.begin(dt, sck);
  while(!scale.is_ready()){
    Serial.println("Waiting for HX711 to be ready...");
    delay(100);
  }
  scale.tare();

  // scale.set_scale(100);
}


// Initialize Servo Motor
void servoInit(){
  servo.attach(servoPin);
  servo.write(servoAngle);
}




void parseJson(String jsonString) {
  StaticJsonDocument<200> doc;

  DeserializationError error = deserializeJson(doc, jsonString);
  
  if (error) {
    Serial.print("JSON parsing failed: ");
    Serial.println(error.c_str());
    return;
  }

  const char* move = doc["move"];
  const char* mode = doc["mode"];
  if (move) {
    moveCar(move);
  } 
  
  else if(mode){
    manualControl = mode == "manual";
  }

  else {
    Serial.println("Invalid keys in JSON");
  }
}


// BLE Connection Setup

class MyCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value.length() > 0) {
      String jsonString = String(value.c_str());
      Serial.print("Received JSON: ");
      Serial.println(jsonString);

      parseJson(jsonString);
    }
  }
};


class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        deviceConnected = true;
        Serial.println("Device Connected!");
    }

    void onDisconnect(BLEServer* pServer) {
        deviceConnected = false;
        Serial.println("Device Disconnected!");
        BLEDevice::startAdvertising();  
    }
};



class ServerCallback: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      Serial.println(" - ServerCallback - onConnect");
    };


    void onDisconnect(BLEServer* pServer) {
      Serial.println(" - ServerCallback - onDisconnect");
    }
};


class SecurityCallback : public BLESecurityCallbacks {


  uint32_t onPassKeyRequest(){
    return 000000;
  }


  void onPassKeyNotify(uint32_t pass_key){}


  bool onConfirmPIN(uint32_t pass_key){
    vTaskDelay(5000);
    return true;
  }


  bool onSecurityRequest(){
    return true;
  }


  void onAuthenticationComplete(esp_ble_auth_cmpl_t cmpl){
    if(cmpl.success){
      Serial.println("   - SecurityCallback - Authentication Success");       
      deviceConnected = true;
    }else{
      Serial.println("   - SecurityCallback - Authentication Failure*");
      pServer->removePeerDevice(pServer->getConnId(), true);
      deviceConnected = false;
    }
    BLEDevice::startAdvertising();
  }
};


void bleSecurity(){
  esp_ble_auth_req_t auth_req = ESP_LE_AUTH_REQ_SC_MITM_BOND;
  esp_ble_io_cap_t iocap = ESP_IO_CAP_OUT;          
  uint8_t key_size = 16;     
  uint8_t init_key = ESP_BLE_ENC_KEY_MASK | ESP_BLE_ID_KEY_MASK;
  uint8_t rsp_key = ESP_BLE_ENC_KEY_MASK | ESP_BLE_ID_KEY_MASK;
  uint32_t passkey = PASSKEY;
  uint8_t auth_option = ESP_BLE_ONLY_ACCEPT_SPECIFIED_AUTH_DISABLE;
  esp_ble_gap_set_security_param(ESP_BLE_SM_SET_STATIC_PASSKEY, &passkey, sizeof(uint32_t));
  esp_ble_gap_set_security_param(ESP_BLE_SM_AUTHEN_REQ_MODE, &auth_req, sizeof(uint8_t));
  esp_ble_gap_set_security_param(ESP_BLE_SM_IOCAP_MODE, &iocap, sizeof(uint8_t));
  esp_ble_gap_set_security_param(ESP_BLE_SM_MAX_KEY_SIZE, &key_size, sizeof(uint8_t));
  esp_ble_gap_set_security_param(ESP_BLE_SM_ONLY_ACCEPT_SPECIFIED_SEC_AUTH, &auth_option, sizeof(uint8_t));
  esp_ble_gap_set_security_param(ESP_BLE_SM_SET_INIT_KEY, &init_key, sizeof(uint8_t));
  esp_ble_gap_set_security_param(ESP_BLE_SM_SET_RSP_KEY, &rsp_key, sizeof(uint8_t));
}


void bleInit(){
  BLEDevice::init("Carry Bot");
  BLEDevice::setEncryptionLevel(ESP_BLE_SEC_ENCRYPT);
  BLEDevice::setSecurityCallbacks(new SecurityCallback());


  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallback());


  BLEService *pService = pServer->createService(SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY 
                    );


  pCharacteristic->setAccessPermissions(ESP_GATT_PERM_READ_ENCRYPTED | ESP_GATT_PERM_WRITE_ENCRYPTED);
  pCharacteristic->addDescriptor(new BLE2902());
  pCharacteristic->setCallbacks(new MyCallbacks());
  pService->start();


  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);
  BLEDevice::startAdvertising();


  bleSecurity();
}







// Send data through BLE

const char* getSituation(int low, int high, float warn, int val){
    if (val < low || val > high) return "R";  // Red (Danger)
    if ((val > low && val < low + warn) || (val < high && val > high - warn)) return "Y";  // Yellow (Warning)
    return "G";  // Green (Safe)
}

void sensorJson(JsonObject sensor, const char* name, float value, const char* situation) {
    sensor["name"] = name;
    sensor["value"] = static_cast<float>(value);
    sensor["situation"] = situation;
}

float getDistance() {
    digitalWrite(distanceTrig, LOW);
    delayMicroseconds(2);
    digitalWrite(distanceTrig, HIGH);
    delayMicroseconds(10);
    digitalWrite(distanceTrig, LOW);

    long duration = pulseIn(distanceEcho, HIGH);
    float distance = duration * 0.034 / 2; 
    return distance;
}

float getDepth(){
    digitalWrite(depthTrig, LOW);
    delayMicroseconds(2);
    digitalWrite(depthTrig, HIGH);
    delayMicroseconds(10);
    digitalWrite(depthTrig, LOW);

    long duration = pulseIn(depthEcho, HIGH);
    float distance = duration * 0.034 / 2; // Convert to cm
    return distance;
}

float getWeight(){
  if (scale.is_ready()) {
    long reading = scale.get_units(3);
    return reading;
  } 
  else {
    return 0.0;
  }
}

void sendSensorData(){
  StaticJsonDocument<300> jsonArray;
    JsonArray data = jsonArray.createNestedArray("sensors");

    float distance = getDistance();
    float depth = getDepth();
    float weight =  getWeight();

    
    JsonObject sensor1 = data.createNestedObject();
    sensorJson(sensor1, "Distance Sensor",distance,getSituation(10,50,1,distance));

    JsonObject sensor2 = data.createNestedObject(); 
    sensorJson(sensor2, "Depth Sensor",depth,getSituation(10,30,5,depth));

    JsonObject sensor3 = data.createNestedObject(); 
    sensorJson(sensor3, "Weight Sensor",weight,getSituation(0,10000,500,weight));

    char buffer[512];  
    serializeJson(jsonArray, buffer);

    

    if (deviceConnected) {
        Serial.print("📤 Sending JSON List: ");
        Serial.println(buffer);

        pCharacteristic->setValue(buffer);
        pCharacteristic->notify();
    }
}





void testMotors() {
    Serial.println("Testing Wheel 1 Forward");
    digitalWrite(motor1A, HIGH); digitalWrite(motor1B, LOW);
    delay(1000);
    stopMotors();
    delay(500);

    Serial.println("Testing Wheel 1 Backward");
    digitalWrite(motor1A, LOW); digitalWrite(motor1B, HIGH);
    delay(1000);
    stopMotors();
    delay(500);

    Serial.println("Testing Wheel 2 Forward");
    digitalWrite(motor2A, HIGH); digitalWrite(motor2B, LOW);
    delay(1000);
    stopMotors();
    delay(500);


    Serial.println("Testing Wheel 2 Backward");
    digitalWrite(motor2A, LOW); digitalWrite(motor2B, HIGH);
    delay(1000);
    stopMotors();
    delay(500);


    Serial.println("Testing Wheel 3 Forward");
    digitalWrite(motor3A, HIGH); digitalWrite(motor3B, LOW);
    delay(1000);
    stopMotors();
    delay(500);

    Serial.println("Testing Wheel 3 Backward");
    digitalWrite(motor3A, LOW); digitalWrite(motor3B, HIGH);
    delay(1000);
    stopMotors();
    delay(500);

    Serial.println("Testing Wheel 4 Forward");
    digitalWrite(motor4A, HIGH); digitalWrite(motor4B, LOW);
    delay(1000);
    stopMotors();
    delay(500);


    Serial.println("Testing Wheel 4 Backward");
    digitalWrite(motor4A, LOW); digitalWrite(motor4B, HIGH);
    delay(1000);
    stopMotors();
    delay(500);
  
}


void testMotorSpeed(int channel){
  Serial.print("Testing channel: ");Serial.println(channel);
    ledcWrite(channel, 200);  // Channel 0
    delay(2000);
    ledcWrite(channel, 0);
    delay(1000);

}




// Initialize pins

void pinInit(){
  //Distance measuring Sonar Sensor
  pinMode(distanceTrig, OUTPUT);
  pinMode(distanceEcho, INPUT);

  //Depth measuring Sonar Sensor
  pinMode(depthTrig, OUTPUT);
  pinMode(depthEcho, INPUT);

  //Both side IR Sensors
  pinMode(leftPin, INPUT_PULLUP);
  pinMode(rightPin, INPUT_PULLUP);

  //For Motors
  // Configure and attach PWM channels to pins
  ledcAttach(motor1A, PWM_FREQ, PWM_RESOLUTION);
  ledcAttach(motor1B, PWM_FREQ, PWM_RESOLUTION);
  ledcAttach(motor2A, PWM_FREQ, PWM_RESOLUTION); // 4
  ledcAttach(motor2B, PWM_FREQ, PWM_RESOLUTION); // 15
  ledcAttach(motor3A, PWM_FREQ, PWM_RESOLUTION); 
  ledcAttach(motor3B, PWM_FREQ, PWM_RESOLUTION);
  ledcAttach(motor4A, PWM_FREQ, PWM_RESOLUTION); // 18
  ledcAttach(motor4B, PWM_FREQ, PWM_RESOLUTION); // 5
  stopMotors();


}



void setup() {
  Serial.begin(115200);
  pinInit();
  bleInit();
  loadSensorInit();
  servoInit();
}

void loop() {

  //   if (scale.is_ready()) {
  //   long reading = scale.get_units(3);
  //   Serial.print("weight: ");
  //   Serial.println(reading);
  //   delay(10);
  // } 
  // else {
  //   Serial.println("HX711 not found.");
  // }
  // delay(100);
  // delay(2000);

  if (Serial.available()) {  
        String inputMessage = Serial.readString(); 
        // Serial.print("first part : ");
        Serial.println(inputMessage);
        // moveCar(inputMessage);
        servo.write(inputMessage.toInt());
        // testMotorSpeed(inputMessage.toInt());

        // StaticJsonDocument<200> jsonDoc;
        // jsonDoc["message"] = inputMessage;

        // // Convert JSON to string
        // String jsonString;
        // serializeJson(jsonDoc, jsonString);

        // // Send JSON over BLE if a device is connected
        // if (deviceConnected) {
        //     pCharacteristic->setValue(jsonString.c_str());  
        //     pCharacteristic->notify();  
        //     Serial.print("📤 Sent JSON via BLE: ");
        //     Serial.println(jsonString);
        // } else {
        //     Serial.println("⚠️ No BLE device connected.");
        // }
    }

    // sendSensorData();
    // delay(100);

    objctDetector(getDistance());
    // sideDetector();

    // moveCar("front");
    // delay(1000);

}
