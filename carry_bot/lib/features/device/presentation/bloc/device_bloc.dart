import 'package:flutter_bloc/flutter_bloc.dart';

import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent,DeviceState>{
  DeviceBloc():super(DeviceInitialState()){

  }
}