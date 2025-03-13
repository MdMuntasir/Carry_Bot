import 'dart:io';

import 'package:carry_bot/core/connection%20state/mqtt_state.dart';
import 'package:carry_bot/core/network/connection_checker.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../domain/repository/device_repository.dart';
import '../data source/remote_source.dart';

class DeviceRepositoryImplementation implements DeviceRepository {
  final MqttServerClient client;
  final RemoteDeviceData remoteDeviceData;
  final ConnectionChecker connectionChecker;
  Function(String)? onMessageReceived;

  DeviceRepositoryImplementation(
    this.client,
    this.remoteDeviceData,
    this.connectionChecker,
    this.onMessageReceived,
  );

  @override
  Future<MQTTState> publish(
    MqttServerClient client,
    String topic,
    String message,
  ) async {
    if (await connectionChecker.isConnected) {
      remoteDeviceData.publishData(client, topic, message);
      return MQTTSuccess("Published");
    }
    return MQTTFailed("No Internet Connection");
  }

  @override
  Future<MQTTState<String>> subscribe(
    MqttServerClient client,
    String topic,
  ) async {
    if (await connectionChecker.isConnected) {
      remoteDeviceData.subscribeData(client, topic, onMessageReceived,);
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
