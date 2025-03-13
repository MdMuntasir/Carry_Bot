import 'package:carry_bot/features/home/domain/entity/sensor_entity.dart';

class SensorModel extends SensorEntity {
  SensorModel({
    required super.depth,
    required super.distance,
    required super.weight,
  });

  factory SensorModel.fromJson(Map<String, dynamic> map) {
    return SensorModel(
      depth: map["depth"] ?? "",
      distance: map["distance"] ?? "",
      weight: map["weight"] ?? "",
    );
  }

  Map<String, dynamic> toJson(){
    return <String,dynamic>{
      "depth" : depth,
      "distance" : distance,
      "weight" : weight,
    };
  }
}
