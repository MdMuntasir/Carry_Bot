import 'dart:async';
import 'package:carry_bot/core/common/client/client_connect.dart';
import 'package:carry_bot/features/device/domain/usecase/listen_ble_usecase.dart';
import 'package:carry_bot/features/device/domain/usecase/sendMessage_ble_usecase.dart';
import 'package:carry_bot/injection_Container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final ListenBleUseCase listenBleUseCase;
  final SendBleMessageUseCase sendBleMessageUseCase;

  DeviceBloc({
    required this.listenBleUseCase,
    required this.sendBleMessageUseCase,
  }) : super(DeviceLoadingState()) {
    on<DeviceInitialEvent>(deviceInitialEvent);
    on<DeviceSendMessageEvent>(deviceSendMessageEvent);
    on<DeviceModeSwitchEvent>(deviceModeSwitchEvent);
    on<DeviceDisconnectEvent>(deviceDisconnectEvent);
  }

  FutureOr<void> deviceInitialEvent(
    DeviceInitialEvent event,
    Emitter<DeviceState> emit,
  ) async {
    emit(DeviceLoadingState());
    await listenBleUseCase.call(para: event.context);
    emit(DeviceInitialState());
  }

  FutureOr<void> deviceSendMessageEvent(
    DeviceSendMessageEvent event,
    Emitter<DeviceState> emit,
  ) async {
    await sendBleMessageUseCase.call(para: event.message);
  }

  FutureOr<void> deviceModeSwitchEvent(
    DeviceModeSwitchEvent event,
    Emitter<DeviceState> emit,
  ) async {
    event.isManual ? emit(DeviceManualMode()) : emit(DeviceAutoMode());
  }

  FutureOr<void> deviceDisconnectEvent(
      DeviceDisconnectEvent event,
      Emitter<DeviceState> emit,
      ) async {
    await serviceLocator<BLEService>().disconnectDevice();
  }
}
