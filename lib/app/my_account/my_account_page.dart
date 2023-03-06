import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vollgym/app/models/account.dart';
import 'package:vollgym/app/models/account_tile_data.dart';

import 'package:vollgym/app/my_account/widgets/account_category_items.dart';
import 'package:vollgym/app/widgets/rounded_button.dart';

final _profile = [
  AccountTileData(
    icon: Icons.model_training,
    title: 'Sprzęt',
    onPressed: () {},
  )
];

final _help = [
  AccountTileData(
    icon: Icons.info,
    title: 'Informacja o systemie',
    onPressed: () {},
  ),
  AccountTileData(
    icon: Icons.privacy_tip,
    title: 'Privacy Policy',
    onPressed: () {},
  ),
];

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konto')),
      body: StreamBuilder<Object>(
        stream: _fetchAccountData(),
        builder: (context, snapshot) {
          final account = snapshot.data as Account?;

          return Column(
            children: [
              MyAccountSection(account: account),
              Divider(
                height: 2,
                thickness: 1.2,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 20),
              AccountCategoryItems(title: 'Profil', items: _profile),
              const SizedBox(height: 10),
              AccountCategoryItems(title: 'Pomoc', items: _help),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundedButton(
                  text: 'Wyloguj',
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  Stream<Account> _fetchAccountData() {
    return FirebaseFirestore.instance
        .collection('accounts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> event) {
      final map = event.data() as Map<String, dynamic>;
      map['id'] = event.id;
      return Account.fromMap(map);
    });
  }
}

class MyAccountSection extends StatelessWidget {
  const MyAccountSection({super.key, required this.account});

  final Account? account;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: account != null && account!.isAvatarExists
                ? account!.getImage.image
                : const AssetImage('assets/avatar_default.png'),
            radius: 50.0,
          ),
          const SizedBox(width: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(account?.getFullName ?? '-'),
              const SizedBox(height: 10),
              Text(account?.email ?? '-'),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Text('Przejdź do szczegółów'),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
