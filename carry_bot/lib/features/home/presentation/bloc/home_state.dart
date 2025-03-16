import 'package:flutter_blue_plus/flutter_blue_plus.dart';

sealed class HomeState{
  const HomeState();
}

sealed class HomeActionState extends HomeState{
  const HomeActionState();
}

class HomeInitialState extends HomeState{}

class HomeScanningDevices extends HomeState{}

class HomeScannedDevices extends HomeState{}

class HomeScanFailedState extends HomeState{
  final String error;
  const HomeScanFailedState(this.error);
}


class HomeDeviceConnected extends HomeActionState{
  final BluetoothDevice device;
  const HomeDeviceConnected(this.device);
}

class HomeDeviceConnectionFailed extends HomeActionState{
  final String error;
  const HomeDeviceConnectionFailed(this.error);
}

class HomeNoBluetoothConnection extends HomeActionState{}