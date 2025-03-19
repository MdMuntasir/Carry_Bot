import 'package:carry_bot/features/device/data/model/sensor_model.dart';

class SensorInformation {
  List<SensorModel> _sensors = [];
  Function(List<SensorModel>)? _onSensorsUpdated;

  void setInfo(List<SensorModel> sensorInfo) {
    _sensors = sensorInfo;
    _notifyListeners();
  }

  List<SensorModel> getInfo() {
    return _sensors;
  }

  void setListener(Function(List<SensorModel>) listener) {
    _onSensorsUpdated = listener;
  }

  void _notifyListeners() {
    if (_onSensorsUpdated != null) {
      _onSensorsUpdated!(_sensors);
    }
  }
}