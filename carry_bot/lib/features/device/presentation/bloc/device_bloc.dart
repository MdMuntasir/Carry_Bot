import 'dart:async';
import 'package:carry_bot/features/device/domain/usecase/listen_ble_usecase.dart';
import 'package:carry_bot/features/device/domain/usecase/sendMessage_ble_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final ListenBleUseCase listenBleUseCase;
  final SendBleMessageUseCase sendBleMessageUseCase;

  DeviceBloc({
    required this.listenBleUseCase,
    required this.sendBleMessageUseCase,
  }) : super(DeviceInitialState()) {
    on<DeviceInitialEvent>(deviceInitialEvent);
  }

  FutureOr<void> deviceInitialEvent(
    DeviceInitialEvent event,
    Emitter<DeviceState> emit,
  ) async {
    emit(DeviceLoadingState());
    await listenBleUseCase.call(para: event.context);
    emit(DeviceListeningState());
  }


}
