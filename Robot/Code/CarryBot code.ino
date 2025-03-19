#include <ArduinoJson.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>


#define distanceTrig 5
#define distanceEcho 18
#define depthTrig 19
#define depthEcho 21



BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define PASSKEY 123456
bool deviceConnected = false;


class MyCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value.length() > 0) {
      Serial.print("📩 Received: ");
      Serial.println(value.c_str()); // Print received data
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
  pCharacteristic->setCallbacks(new MyCallbacks());
  pService->start();


  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);
  BLEDevice::startAdvertising();


  bleSecurity();
}


void pinInit(){
  pinMode(distanceTrig, OUTPUT);
  pinMode(distanceEcho, INPUT);
  pinMode(depthTrig, OUTPUT);
  pinMode(depthEcho, INPUT);
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



const char* getSituation(int low, int high, float warn, int val){
    if (val < low || val > high) return "R";  // Red (Danger)
    if ((val > low && val < low + warn) || (val < high && val > high - warn)) return "Y";  // Yellow (Warning)
    return "G";  // Green (Safe)
}



void sensorJson(JsonObject sensor, const char* name, float value, const char* situation) {
    sensor["name"] = name;
    sensor["value"] = value;
    sensor["situation"] = situation;
}


void sendSensorData(){
  StaticJsonDocument<300> jsonArray;
    JsonArray data = jsonArray.createNestedArray("sensors");

    float distance = getDistance();

    
    JsonObject sensor1 = data.createNestedObject();
    sensorJson(sensor1, "Distance Sensor",distance,getSituation(10,50,1,distance));

    JsonObject sensor2 = data.createNestedObject(); // Here write code for depth sensor
    sensorJson(sensor2, "Depth Sensor",distance,getSituation(10,30,5,distance));

    JsonObject sensor3 = data.createNestedObject(); // Here write code for weight sensor
    sensorJson(sensor3, "Weight Sensor",distance,getSituation(500,5000,100,distance));

    char buffer[512];  
    serializeJson(jsonArray, buffer);

    Serial.print("📤 Sending JSON List: ");
    Serial.println(buffer);

    if (deviceConnected) {
        pCharacteristic->setValue(buffer);
        pCharacteristic->notify();
    }
}



void moveCar(const char* move){
  // Write this method where the method will recieve move as front, fr, right, br, back, bl, left, fl
}



void setup() {
  Serial.begin(115200);
  pinInit();
  bleInit();

}

void loop() {

    sendSensorData();

    delay(500);

}
