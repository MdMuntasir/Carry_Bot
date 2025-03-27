import 'package:flutter/cupertino.dart';

sealed class DeviceEvent {
  const DeviceEvent();
}

class DeviceInitialEvent extends DeviceEvent {
  final BuildContext context;
  const DeviceInitialEvent(this.context);
}

class DeviceModeSwitchEvent extends DeviceEvent {
  final bool isManual;
  const DeviceModeSwitchEvent(
    this.isManual,
  );
}

class DeviceSendMessageEvent extends DeviceEvent{
  final String message;
  const DeviceSendMessageEvent(this.message);
}

class DeviceDisconnectEvent extends DeviceEvent{}

