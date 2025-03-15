import 'package:flutter_blue_plus/flutter_blue_plus.dart';

sealed class HomeState{
  const HomeState();
}

sealed class HomeActionState extends HomeState{
  const HomeActionState();
}

class HomeInitialState extends HomeState{}

class HomeScanningDevices extends HomeState{}

class HomeScannedDevices extends HomeState{
  final List<ScanResult> devices;
  const HomeScannedDevices(this.devices);
}

class HomeScanFailedState extends HomeState{
  final String error;
  const HomeScanFailedState(this.error);
}

class HomeOnRefreshClicked extends HomeActionState{}

class HomeOnDeviceClicked extends HomeActionState{
  final BluetoothDevice device;
  const HomeOnDeviceClicked(this.device);
}