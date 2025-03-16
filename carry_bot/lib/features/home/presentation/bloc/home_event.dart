import 'package:flutter_blue_plus/flutter_blue_plus.dart';

sealed class HomeEvent{
  const HomeEvent();
}

class HomeInitialEvent extends HomeEvent{

}

class HomeScannedDevicesEvent extends HomeEvent{
  final List<ScanResult> devices;
  const HomeScannedDevicesEvent(this.devices);
}

class HomeClickedDeviceEvent extends HomeEvent{
  final BluetoothDevice device;
  const HomeClickedDeviceEvent(this.device);
}


