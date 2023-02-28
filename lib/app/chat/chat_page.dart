import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vollgym/app/chat/chat_coaches_list.dart';

import 'package:vollgym/app/chat/widgets/chat_tile.dart';

import 'package:vollgym/app/models/coach.dart';
import 'package:vollgym/app/utils/extensions.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
      body: const Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Text(
            'Obecnie nie rozmawiasz z żadnym trenerem. Wybierz + by stworzyć nową rozmowę'),
      ),
    );
  }
}
