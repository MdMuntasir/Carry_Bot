import 'package:mqtt_client/mqtt_server_client.dart';

sealed class ClientState{
  const ClientState();
}

class ClientConnected extends ClientState{
  final MqttServerClient client;
  const ClientConnected(this.client);
}

class ClientDisconnected extends ClientState{
  final String? message;
  const ClientDisconnected(this.message);
}