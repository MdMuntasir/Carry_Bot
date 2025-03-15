import 'package:carry_bot/core/connection%20state/data_state.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

abstract class RemoteDeviceData {
  DataState<String> mqttSubscribeData(
    MqttServerClient client,
    String topic,
    Function(String)? onMessageReceived,
  );
  void mqttPublishData(
    MqttServerClient client,
    String topic,
    String message,
  );

  DataState<String> bleSubscribeData(
    MqttServerClient client,
    Function(String)? onMessageReceived,
  );
  void blePublishData(
    MqttServerClient client,
    String message,
  );
}

class RemoteDeviceDataImpl implements RemoteDeviceData {
  @override
  void mqttPublishData(
    MqttServerClient client,
    String topic,
    String message,
  ) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  @override
  DataState<String> mqttSubscribeData(
    MqttServerClient client,
    String topic,
    Function(String)? onMessageReceived,
  ) {
    try {
      client.subscribe(topic, MqttQos.atMostOnce);

      String message = "";
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess = c[0].payload as MqttPublishMessage;
        message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        if (onMessageReceived != null) {
          onMessageReceived(message);
        }
      });
      return DataSuccess(message);
    } on Exception catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  void blePublishData(
    MqttServerClient client,
    String message,
  ) {
    // TODO: implement blePublishData
  }

  @override
  DataState<String> bleSubscribeData(
    MqttServerClient client,
    Function(String p1)? onMessageReceived,
  ) {
    // TODO: implement bleSubscribeData
    throw UnimplementedError();
  }
}
