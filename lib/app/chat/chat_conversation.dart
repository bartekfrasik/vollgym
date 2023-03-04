import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vollgym/app/chat/widgets/message_tile.dart';
import 'package:vollgym/app/models/chat_list.dart';
import 'package:vollgym/app/models/coach.dart';
import 'package:vollgym/app/models/message.dart';
import 'package:vollgym/app/utils/extensions.dart';

class ChatConversation extends StatefulWidget {
  const ChatConversation({
    super.key,
    required this.coach,
  });

  final Coach coach;

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  late Stream<List<Message>?> _dataStream;

  final _textMessage = TextEditingController();
  final _dateIndexMap = {};

  var docId = '';

  @override
  void initState() {
    super.initState();
    _dataStream = fetchAllChatConversations();
  }

  bool isNotSameDate(DateTime? firstDate, DateTime secondDate) =>
      firstDate?.year != secondDate.year && firstDate?.month != secondDate.month && firstDate?.day != secondDate.day;

  bool isSameDate(DateTime? firstDate, DateTime secondDate) =>
      firstDate?.year == secondDate.year && firstDate?.month == secondDate.month && firstDate?.day == secondDate.day;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.coach.getFullName)),
        body: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return StreamBuilder(
                stream: _dataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.active) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data ?? [];
                  messages.sort((a, b) => b.sendDate.compareTo(a.sendDate));

                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                _dataStream = fetchAllChatConversations();
                              });
                            },
                            child: ListView.builder(
                              itemCount: messages.length,
                              reverse: true,
                              itemBuilder: (_, i) {
                                final dateSection = _dateIndexMap['$i'];

                                if (dateSection == null) {
                                  return MessageTile(
                                    coach: widget.coach,
                                    message: messages[i],
                                  );
                                }

                                return Column(
                                  children: [
                                    Text(
                                      '${messages[i].sendDate.weekday.toDayNameFull}, ${messages[i].sendDate.day} ${messages[i].sendDate.month.toMonthNameShort} o ${messages[i].sendDate.hour.toString().length == 1 ? '0${messages[i].sendDate.hour}' : messages[i].sendDate.hour}:${messages[i].sendDate.minute.toString().length == 1 ? '0${messages[i].sendDate.minute}' : messages[i].sendDate.minute}',
                                    ),
                                    const SizedBox(height: 15),
                                    MessageTile(
                                      coach: widget.coach,
                                      message: messages[i],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        color: Colors.blue,
                        child: TextField(
                          controller: _textMessage,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Wiadomość tekstowa",
                            fillColor: Colors.white70,
                            suffixIcon: IconButton(
                              onPressed: () async {
                                if (_textMessage.text.isNotEmpty) {
                                  final currentMessages = List.of(messages);
                                  currentMessages.sort((a, b) => a.sendDate.compareTo(b.sendDate));
                                  final ref = FirebaseFirestore.instance
                                      .collection('chatConversations')
                                      .doc(FirebaseAuth.instance.currentUser!.uid);

                                  final currentDate = DateTime.now();
                                  currentMessages.add(
                                    Message(
                                      authorId: FirebaseAuth.instance.currentUser!.uid,
                                      message: _textMessage.text,
                                      sendDate: currentDate,
                                    ),
                                  );

                                  await ref.update({
                                    widget.coach.id.trim(): Message.toMapList(currentMessages),
                                  });

                                  await updateChatList(_textMessage.text, currentDate);

                                  _textMessage.clear();
                                }
                              },
                              icon: const Icon(Icons.arrow_forward_ios_sharp, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> updateChatList(String message, DateTime lastMessageDate) async {
    final ref = FirebaseFirestore.instance.collection('chatList').doc(FirebaseAuth.instance.currentUser!.uid);

    final chatData = await FirebaseFirestore.instance.collection('chatList').get();
    final chatList = chatData.docs
        .map((QueryDocumentSnapshot querySnapshot) {
          final map = querySnapshot.data() as Map<String, dynamic>;
          return ChatList.fromListMap(map['chats']);
        })
        .expand((e) => e)
        .toList();

    final index = chatList.indexWhere((e) => e.coachId == widget.coach.id);

    if (index >= 0) {
      chatList[index] = chatList[index].copyWith(lastMessage: message);
    } else {
      chatList.add(
        ChatList(
          coachId: widget.coach.id,
          lastMessage: message,
          lastMessageDate: lastMessageDate,
        ),
      );
    }

    ref.update({'chats': ChatList.toListMap(chatList)});
  }

  Stream<List<Message>?> fetchAllChatConversations() {
    return FirebaseFirestore.instance.collection('chatConversations').snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        var map = (doc.data() as Map<String, dynamic>);
        final coachId = widget.coach.id.trim();
        if (map.containsKey(coachId)) {
          docId = doc.id;

          final chatConversations = Message.fromListMap(map[coachId]);
          final newChatConversation = List.of(chatConversations)..sort((a, b) => b.sendDate.compareTo(a.sendDate));
          final uniqueDates = newChatConversation
              .map((e) => DateTime(e.sendDate.year, e.sendDate.month, e.sendDate.day))
              .toSet()
              .toList();

          for (final uniqueDate in uniqueDates) {
            final findMatchedDates =
                newChatConversation.where((e) => isSameDate(uniqueDate, e.sendDate)).map((e) => e.sendDate).toList();

            final findLowestDate = findMatchedDates
                .reduce((current, next) => (current.hour < next.hour && current.minute < next.minute) ? current : next);

            final indexOfLowestDate =
                newChatConversation.indexWhere((e) => e.sendDate.isAtSameMomentAs(findLowestDate));

            _dateIndexMap.addAll({'$indexOfLowestDate': findLowestDate});
          }

          return chatConversations;
        }
      }).toList();
    }).expand((e) => e);
  }
}
