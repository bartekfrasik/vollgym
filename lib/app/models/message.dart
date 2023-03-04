import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  const Message({
    required this.authorId,
    required this.message,
    required this.sendDate,
  });

  final String authorId;
  final String message;
  final DateTime sendDate;

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      authorId: map['authorId'],
      message: map['message'],
      sendDate: DateTime.fromMicrosecondsSinceEpoch(map['sendDate'].microsecondsSinceEpoch),
    );
  }

  static List<Message> fromListMap(List<dynamic> listMap) {
    return listMap.map((e) => Message.fromMap(e)).toList();
  }

  static Map<String, dynamic> toMap(Message message) {
    return {
      'authorId': message.authorId,
      'message': message.message,
      'sendDate': message.sendDate,
    };
  }

  static List<Map<String, dynamic>> toMapList(List<Message> messages) {
    return messages.map((e) => Message.toMap(e)).toList();
  }
}
