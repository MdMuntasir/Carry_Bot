import 'dart:async';
import 'package:carry_bot/features/device/domain/repository/device_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent,DeviceState>{
  final DeviceRepository deviceRepository;

  DeviceBloc({required this.deviceRepository,}):super(DeviceInitialState()){
    on<DeviceInitialEvent>(deviceInitialEvent);
  }

  FutureOr<void> deviceInitialEvent(DeviceInitialEvent event, Emitter<DeviceState> emit,) async{
    emit(DeviceLoadingState());
    await deviceRepository.listenBle(event.context);
    emit(DeviceListeningState());
  }
}