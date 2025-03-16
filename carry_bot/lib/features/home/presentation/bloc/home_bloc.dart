import 'dart:async';

import 'package:carry_bot/core/common/client/client_connect.dart';
import 'package:carry_bot/features/home/presentation/bloc/home_event.dart';
import 'package:carry_bot/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BLEService bleService;
  HomeBloc({
    required this.bleService,
  }) : super(HomeInitialState()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeClickedDeviceEvent>(homeClickedDeviceEvent);
    on<HomeScannedDevicesEvent>(homeScannedDevicesEvent);
  }

  FutureOr<void> homeInitialEvent(
    HomeInitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeScanningDevices());

    await for (BluetoothAdapterState state in FlutterBluePlus.adapterState) {
      if (state == BluetoothAdapterState.off) {
        emit(HomeNoBluetoothConnection());
      } else if (state == BluetoothAdapterState.on) {

        await bleService.startScanning();

        emit(HomeScannedDevices());

      }
    }
  }

  FutureOr<void> homeClickedDeviceEvent(
    HomeClickedDeviceEvent event,
    Emitter<HomeState> emit,
  ) async {
    if(event.device.platformName == "Carry Bot"){
      bool connected = await bleService.connectToDevice(event.device);
      connected
          ? emit(HomeDeviceConnected(event.device))
          : emit(HomeDeviceConnectionFailed("Couldn't connect to device"));
    }
    else{
      emit(HomeDeviceConnectionFailed("This device is not a robot"));
    }
  }



  FutureOr<void> homeScannedDevicesEvent(
      HomeScannedDevicesEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeScannedDevices());
  }
}
