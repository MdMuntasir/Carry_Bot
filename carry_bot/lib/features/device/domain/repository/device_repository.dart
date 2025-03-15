import 'package:carry_bot/core/connection%20state/data_state.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

abstract class DeviceRepository {
  Future<DataState> publish(
    MqttServerClient client,
    String topic,
    String message,
  );
  Future<DataState<String>> subscribe(
    MqttServerClient client,
    String topic,
  );

  Future<DataState> connectClient(
    String userName,
    String password,
    String clusterURL,
  );


}
