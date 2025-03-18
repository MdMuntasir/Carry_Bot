sealed class DeviceEvent {
  const DeviceEvent();
}

class DeviceInitialEvent extends DeviceEvent {}

class DeviceManualModeEvent extends DeviceEvent {
  final bool isManual;
  const DeviceManualModeEvent(
    this.isManual,
  );
}
