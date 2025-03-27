sealed class DeviceState {
  const DeviceState();
}


class DeviceInitialState extends DeviceState {}

class DeviceLoadingState extends DeviceState {}


class DeviceFailedState extends DeviceState {
  final String error;
  const DeviceFailedState(this.error);
}

class DeviceManualMode extends DeviceState {}

class DeviceAutoMode extends DeviceState {}

