import 'package:flutter/cupertino.dart';

sealed class DeviceEvent {
  const DeviceEvent();
}

class DeviceInitialEvent extends DeviceEvent {
  final BuildContext context;
  const DeviceInitialEvent(this.context);
}

class DeviceManualModeEvent extends DeviceEvent {
  final bool isManual;
  const DeviceManualModeEvent(
    this.isManual,
  );
}

