import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:vollgym/app/chat/widgets/chat_tile.dart';
import 'package:vollgym/app/models/coach.dart';

class ChatCoachesList extends StatefulWidget {
  const ChatCoachesList({super.key});

  @override
  State<ChatCoachesList> createState() => _ChatCoachesListState();
}

class _ChatCoachesListState extends State<ChatCoachesList> {
  late Stream<List<Coach>> _dataStream;
  String _lastSectionChar = '';

  @override
  void initState() {
    super.initState();
    _dataStream = fetchAllCoaches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nowa rozmowa')),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 15),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return StreamBuilder(
              stream: _dataStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.data == null) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _dataStream = fetchAllCoaches();
                      });
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: const Center(
                          child: Text('Data not found'),
                        ),
                      ),
                    ),
                  );
                }

                final coaches = snapshot.data;
                coaches!.sort((a, b) => a.firstName.compareTo(b.firstName));

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _dataStream = fetchAllCoaches();
                    });
                  },
                  child: ListView.builder(
                    itemCount: coaches.length,
                    itemBuilder: (_, i) {
                      final firstNameLetter = coaches[i].getFirstNameLetter;
                      if (_lastSectionChar != firstNameLetter) {
                        _lastSectionChar = firstNameLetter;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(firstNameLetter,
                                  style: const TextStyle(fontSize: 18)),
                            ),
                            ChatTile(
                              coach: coaches[i],
                              onTap: () {},
                            ),
                          ],
                        );
                      }

                      return ChatTile(coach: coaches[i]);
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

  Stream<List<Coach>> fetchAllCoaches() {
    return FirebaseFirestore.instance
        .collection('coaches')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        final map = doc.data() as Map<String, dynamic>;
        map['id'] = doc.id;
        return Coach.fromMap(map);
      }).toList();
    });
  }
}
