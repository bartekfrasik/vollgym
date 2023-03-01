import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vollgym/app/chat/chat_coaches_list.dart';

import 'package:vollgym/app/chat/widgets/chat_tile.dart';
import 'package:vollgym/app/models/chat_list.dart';
import 'package:vollgym/app/models/coach.dart';
import 'package:vollgym/app/utils/extensions.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Stream<List<ChatList>> _dataStream;
  List<Coach> _coaches = [];

  @override
  void initState() {
    super.initState();
    _dataStream = fetchAllChatList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Czat')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatCoachesList()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: StreamBuilder(
          stream: _dataStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data == null) {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _dataStream = fetchAllChatList();
                  });
                },
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Text(
                      'Obecnie nie rozmawiasz z żadnym trenerem. Wybierz + by stworzyć nową rozmowę'),
                ),
              );
            }

            return FutureBuilder(
              future: FirebaseFirestore.instance.collection('coaches').get(),
              builder: (_, asyncSnapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.data == null) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _dataStream = fetchAllChatList();
                      });
                    },
                    child: const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Text(
                          'Obecnie nie rozmawiasz z żadnym trenerem. Wybierz + by stworzyć nową rozmowę'),
                    ),
                  );
                }

                final chatList = snapshot.data!;
                if (asyncSnapshot.data != null) {
                  _coaches = asyncSnapshot.data!.docs
                      .map((QueryDocumentSnapshot querySnapshot) {
                    final map = querySnapshot.data() as Map<String, dynamic>;
                    map['id'] = querySnapshot.id;
                    return Coach.fromMap(map);
                  }).toList();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _dataStream = fetchAllChatList();
                    });
                  },
                  child: ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (_, i) {
                      final coach = _coaches.firstWhereOrNull(
                          (e) => e.id == chatList[i].coachId.trim());

                      if (coach == null) {
                        return const SizedBox.shrink();
                      }

                      return ChatTile(
                        coach: coach,
                        subtitle: chatList[i].lastMessage,
                        trailing:
                            '${chatList[i].lastMessageDate.day} ${chatList[i].lastMessageDate.month.toMonthNameShort}',
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Stream<List<ChatList>> fetchAllChatList() {
    return FirebaseFirestore.instance
        .collection('chatList')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      final list = snapshot.docs
          .map((doc) {
            if (FirebaseAuth.instance.currentUser?.uid == doc.id) {
              final map = doc.data() as Map<String, dynamic>;

              return map['chats'];
            }

            return {};
          })
          .expand((e) => e)
          .toList();

      return list.map((e) => ChatList.fromMap(e)).toList();
    });
  }
}
