import 'package:carry_bot/core/connection%20state/mqtt_state.dart';
import 'package:carry_bot/features/home/data/model/sensor_model.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

abstract class RemoteHomeData {
  MQTTState<String> subscribeData(
    MqttServerClient client,
    String topic,
    Function(String)? onMessageReceived,
  );
  void publishData(
    MqttServerClient client,
    String topic,
    String message,
  );
}

class RemoteHomeDataImpl implements RemoteHomeData {
  @override
  void publishData(
    MqttServerClient client,
    String topic,
    String message,
  ) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  @override
  MQTTState<String> subscribeData(
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
      return MQTTSuccess(message);
    } on Exception catch (e) {
      return MQTTFailed(e.toString());
    }
  }
}
