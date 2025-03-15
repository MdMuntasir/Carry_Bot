import 'package:flutter_blue_plus/flutter_blue_plus.dart';

sealed class HomeState{
  const HomeState();
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