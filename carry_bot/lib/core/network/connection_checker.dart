import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
  Future<bool> get isBleConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection internetConnection;
  ConnectionCheckerImpl(this.internetConnection);

  @override
  Future<bool> get isConnected async => internetConnection.hasInternetAccess;

  @override
  Future<bool> get isBleConnected async => FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on;
}