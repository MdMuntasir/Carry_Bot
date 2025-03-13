import 'dart:io';

import 'package:carry_bot/core/connection%20state/mqtt_state.dart';
import 'package:carry_bot/core/network/connection_checker.dart';
import 'package:carry_bot/features/home/data/data%20source/remote_source.dart';
import 'package:carry_bot/features/home/data/model/sensor_model.dart';
import 'package:carry_bot/features/home/domain/repository/homeRepository.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomeRepositoryImplementation implements HomeRepository {
  final MqttServerClient client;
  final RemoteHomeData remoteHomeData;
  final ConnectionChecker connectionChecker;


  const HomeRepositoryImplementation(
    this.client,
    this.remoteHomeData,
    this.connectionChecker,
  );

  @override
  Future<MQTTState> publish(
    MqttServerClient client,
    String topic,
    String message,
  ) async {
    if (await connectionChecker.isConnected) {
      remoteHomeData.publishData(client, topic, message);
      return MQTTSuccess("Published");
    }
    return MQTTFailed("No Internet Connection");
  }

  @override
  Future<MQTTState<String>> subscribe(
    MqttServerClient client,
    String topic,
    Function(String)? onMessageReceived,
  ) async {
    if (await connectionChecker.isConnected) {
      remoteHomeData.subscribeData(client, topic, onMessageReceived);
      return MQTTSuccess("Subscribed");
    }
    return MQTTFailed("No Internet Connection");
  }

  @override
  Future<MQTTState> connectClient(
    String userName,
    String password,
    String clusterURL,
  ) async {
    if (await connectionChecker.isConnected) {
      client.secure = true;
      client.securityContext = SecurityContext.defaultContext;
      client.keepAlivePeriod = 20;

      try {
        await client.connect(userName, password);
      } on Exception catch (e) {
        MQTTFailed(e.toString());
      }
    }
    return MQTTFailed("No Internet Connection");
  }
}
