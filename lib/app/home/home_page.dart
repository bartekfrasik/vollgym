import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vollgym/app/chat/chat_page.dart';
import 'package:vollgym/app/disciplines/disciplines_page.dart';
import 'package:vollgym/app/my_account/my_account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Builder(builder: (context) {
        if (currentIndex == 0) {
          return const DisciplinesPage();
        }
        if (currentIndex == 1) {
          return const ChatPage();
        }
        return const MyAccountPage();
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new_rounded),
            label: 'Dyscyplina',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: 'Czat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Moje konto',
          ),
        ],
      ),
    );
  }
}
