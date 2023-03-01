class ChatList {
  const ChatList({
    required this.coachId,
    required this.lastMessage,
    required this.lastMessageDate,
  });

  final String coachId;
  final String lastMessage;
  final DateTime lastMessageDate;

  ChatList copyWith({
    String? coachId,
    String? lastMessage,
    DateTime? lastMessageDate,
  }) {
    return ChatList(
      coachId: coachId ?? this.coachId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageDate: lastMessageDate ?? this.lastMessageDate,
    );
  }

  factory ChatList.fromMap(Map<String, dynamic> map) {
    return ChatList(
      coachId: map['coachId'],
      lastMessage: map['lastMessage'],
      lastMessageDate: DateTime.fromMicrosecondsSinceEpoch(map['lastMessageDate'].microsecondsSinceEpoch),
    );
  }

  static List<ChatList> fromListMap(List<dynamic> listMap) {
    return listMap.map((e) => ChatList.fromMap(e)).toList();
  }

  static Map<String, dynamic> toMap(ChatList chat) {
    return {
      'coachId': chat.coachId,
      'lastMessage': chat.lastMessage,
      'lastMessageDate': chat.lastMessageDate,
    };
  }

  static List<Map<String, dynamic>> toListMap(List<ChatList> listMap) {
    return listMap.map((e) => ChatList.toMap(e)).toList();
  }
}
