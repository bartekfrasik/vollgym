import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vollgym/app/models/equipment_note.dart';
import 'package:vollgym/app/widgets/rounded_button.dart';

class MyAccountEquipment extends StatefulWidget {
  const MyAccountEquipment({super.key});

  @override
  State<MyAccountEquipment> createState() => _MyAccountEquipmentState();
}

class _MyAccountEquipmentState extends State<MyAccountEquipment> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sprzęt')),
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
          stream: _fetchEquipmentNote(),
          builder: (context, snapshot) {
            controller.text = snapshot.data?.note ?? '';

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      expands: true,
                      maxLines: null,
                      decoration: const InputDecoration.collapsed(hintText: 'Dodaj notatki o sprzęcie'),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 15),
                  RoundedButton(
                    text: 'Dodaj sprzęt',
                    onPressed: () async {
                      final ref = FirebaseFirestore.instance
                          .collection('equipmentNotes')
                          .doc(FirebaseAuth.instance.currentUser!.uid);

                      await ref.update(
                        EquipmentNote(id: snapshot.data?.id ?? '', note: controller.text).toMap(),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  Stream<EquipmentNote> _fetchEquipmentNote() {
    return FirebaseFirestore.instance
        .collection('equipmentNotes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> event) {
      final map = event.data() as Map<String, dynamic>;
      map['id'] = event.id;
      return EquipmentNote.fromMap(map);
    });
  }
}
