import 'dart:io';

import 'package:carry_bot/core/common/mqtt%20client/client_state.dart';
import 'package:carry_bot/core/connection%20state/mqtt_state.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../network/connection_checker.dart';

class MQTTClient{
  MqttServerClient? client;
  ConnectionChecker connectionChecker = ConnectionCheckerImpl(InternetConnection());

  Future<MQTTState<MqttServerClient>> connectClient(
      String userName,
      String password,
      String clusterURL,
      String name
      )async{
    if(await connectionChecker.isConnected){

      client = MqttServerClient.withPort(clusterURL, name, 8883);
      client?.secure = true;
      client?.securityContext = SecurityContext.defaultContext;
      client?.keepAlivePeriod = 20;

      try{
        await client?.connect(userName, password);
        return MQTTSuccess(client!);
      }
      on Exception catch(e){
        MQTTFailed(e.toString());
      }
    }
    return MQTTFailed("No Internet Connection");
  }

  ClientState getClient(){
    final mqttStatus = client?.connectionStatus;
    if(mqttStatus?.state == MqttConnectionState.connected){
      return ClientConnected(client!);
    }
    return ClientDisconnected(mqttStatus?.disconnectionOrigin.toString());
  }
}