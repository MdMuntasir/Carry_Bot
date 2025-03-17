import 'package:carry_bot/core/common/client/client_connect.dart';
import 'package:carry_bot/core/connection%20state/data_state.dart';

abstract class BleDeviceData {
  Future<void> listenMessage(
    Function(String)? onMessageReceived,
  );
  Future<DataState> sendMessage(String message);
}

class BleDeviceDataImpl implements BleDeviceData {
  final BLEService bleService;
  const BleDeviceDataImpl(this.bleService);

  @override
  Future<void> listenMessage(
    Function(String)? onMessageReceived,
  ) async {
    await bleService.enableNotifications();
    bleService.onMessageReceived = onMessageReceived;
  }

  @override
  Future<DataState> sendMessage(String message) async {
    bool state = await bleService.sendData(message);
    return state ? DataSuccess("Succeed") : DataFailed("Failed");
  }
}
