import 'package:carry_bot/core/connection%20state/mqtt_state.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

abstract class DeviceRepository {
  Future<MQTTState> publish(
    MqttServerClient client,
    String topic,
    String message,
  );
  Future<MQTTState<String>> subscribe(
    MqttServerClient client,
    String topic,
  );

  Future<MQTTState> connectClient(
    String userName,
    String password,
    String clusterURL,
  );


}
