import 'dart:convert';
import 'dart:io';

import 'package:carry_bot/core/common/widgets/floating_widget.dart';
import 'package:carry_bot/core/connection%20state/data_state.dart';
import 'package:carry_bot/core/global%20variables/sensor_data.dart';
import 'package:carry_bot/core/network/connection_checker.dart';
import 'package:carry_bot/features/device/data/data%20source/ble_source.dart';
import 'package:carry_bot/injection_Container.dart';

import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../../../core/common/model & entities/sensor_model.dart';
import '../../domain/repository/device_repository.dart';
import '../data source/remote_source.dart';

class DeviceRepositoryImplementation implements DeviceRepository {
  final MqttServerClient client;
  final RemoteDeviceData remoteDeviceData;
  final BleDeviceData bleDeviceData;
  final ConnectionChecker connectionChecker;

  DeviceRepositoryImplementation(
    this.client,
    this.remoteDeviceData,
    this.bleDeviceData,
    this.connectionChecker,
  );

  @override
  Future<DataState> publish(
    MqttServerClient client,
    String topic,
    String message,
  ) async {
    if (await connectionChecker.isConnected) {
      remoteDeviceData.mqttPublishData(client, topic, message);
      return DataSuccess("Published");
    }
    return DataFailed("No Internet Connection");
  }

  @override
  Future<DataState<String>> subscribe(
    MqttServerClient client,
    String topic,
    Function(String)? onMessageReceived,
  ) async {
    if (await connectionChecker.isConnected) {
      remoteDeviceData.mqttSubscribeData(
        client,
        topic,
        onMessageReceived,
      );
      return DataSuccess("Subscribed");
    }
    return DataFailed("No Internet Connection");
  }

  @override
  Future<DataState> connectClient(
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
        DataFailed(e.toString());
      }
    }
    return DataFailed("No Internet Connection");
  }

  @override
  Future<void> listenBle(
    BuildContext context,
  ) async {
    await bleDeviceData.listenMessage((message) {
      Map<String, dynamic> jsonData = jsonDecode(message);

      if (jsonData.containsKey("sensors")) {
        List<SensorModel> sensors = [];
        for (Map<String, dynamic> sensor in jsonData["sensors"]) {
          sensors.add(SensorModel.fromJson(sensor));
        }
        serviceLocator<SensorInformation>().setInfo(sensors);
      } else if (jsonData.containsKey("message")) {
        FloatingWidgetManager.showFloatingWidget(context, jsonData["message"]);
      }
    });
  }

  @override
  Future<DataState> sendMessageBle(
    String message,
  ) async {
    return await bleDeviceData.sendMessage(message);
  }
}
