


import 'package:carry_bot/features/device/domain/entity/sensor_entity.dart';

class SensorModel extends SensorEntity {
  SensorModel({
    required super.name,
    required super.situation,
    required super.value,
  });

  factory SensorModel.fromJson(Map<String, dynamic> map) {
    return SensorModel(
      name: map["name"] ?? "",
      situation: map["situation"] ?? "",
      value: map["value"] != 0 ? map["value"] : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": name ?? "",
      "situation" : situation ?? "",
      "value": value ?? 0.0,
    };
  }
}