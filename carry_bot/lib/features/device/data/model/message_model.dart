import 'package:carry_bot/features/device/domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.message,
    required super.name,
  });

  factory MessageModel.fromJson(Map<String, dynamic> map) {
    return MessageModel(
      name: map["name"]??"",
      message: map["message"],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": name??"",
      "message" : message,
    };
  }
}
