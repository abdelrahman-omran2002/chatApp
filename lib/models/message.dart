import 'package:chatapp/constants.dart';

class Message {
  final String message;
  final String id;

  Message({required this.message, required this.id});

  factory Message.fromJson(jsonData) {
    return Message(
      // لو الـ message مش موجودة حط نص فاضي بدل ما الأبلكيشن يكرش
      message: jsonData[kMessage],id: jsonData['id'],
    );
  }
}
