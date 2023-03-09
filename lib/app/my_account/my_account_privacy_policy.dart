import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vollgym/app/models/privacy_policy.dart';

const _tableHeader = TableRow(
  decoration: BoxDecoration(color: Color(0xffecebeb)),
  children: [
    TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: SizedBox(
        height: 60,
        child: Center(
          child: Text('Context', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    ),
    TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: SizedBox(
        height: 60,
        child: Center(
          child: Text('Types of Data', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    ),
    TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: SizedBox(
        height: 60,
        child: Center(
          child: Text('Primary Use of Data', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    ),
  ],
);

class MyAccountPrivacyPolicy extends StatelessWidget {
  const MyAccountPrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: _fetchPrivacyPolicy(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Table(
                children: const [
                  _tableHeader,
                ],
              );
            }

            return SingleChildScrollView(
              child: Table(
                children: [
                  _tableHeader,
                  ...List.generate(snapshot.data!.length, (i) {
                    final privacyPolicy = snapshot.data![i];

                    return TableRow(
                      decoration: (i + 1) % 2 == 0 ? const BoxDecoration(color: Color(0xffecebeb)) : null,
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(privacyPolicy.context),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(privacyPolicy.typesOfData),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(privacyPolicy.primaryUseOfData),
                            ),
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Stream<List<PrivacyPolicy>> _fetchPrivacyPolicy() {
    return FirebaseFirestore.instance.collection('privacyPolicy').snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs
          .map((doc) {
            final map = doc.data() as Map<String, dynamic>;
            return PrivacyPolicy.fromMapList(map['data']);
          })
          .expand((e) => e)
          .toList();
    });
  }
}
