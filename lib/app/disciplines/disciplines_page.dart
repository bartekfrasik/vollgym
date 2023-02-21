import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vollgym/app/disciplines/discipline_tile.dart';
import 'package:vollgym/app/models/discipline.dart';

class DisciplinesPage extends StatefulWidget {
  const DisciplinesPage({super.key});

  @override
  State<DisciplinesPage> createState() => _DisciplinesPageState();
}

class _DisciplinesPageState extends State<DisciplinesPage> {
  late Stream<List<Discipline>> _dataStream;

  @override
  void initState() {
    super.initState();
    _dataStream = fetchAllDisciplines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Osiągnij swój sukces')),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                        _dataStream = fetchAllDisciplines();
                      });
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: const Center(
                          child: Text('Data not found'),
                        ),
                      ),
                    ),
                  );
                }

                final disciplines = snapshot.data;

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _dataStream = fetchAllDisciplines();
                    });
                  },
                  child: ListView.builder(
                    itemCount: disciplines!.length,
                    itemBuilder: (_, i) {
                      return DisciplineTile(
                        id: disciplines[i].id,
                        name: disciplines[i].name,
                        photoUrl: disciplines[i].photoUrl,
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

  Stream<List<Discipline>> fetchAllDisciplines() {
    return FirebaseFirestore.instance.collection('disciplines').snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        final map = doc.data() as Map<String, dynamic>;
        map['id'] = doc.id;
        return Discipline.fromMap(map);
      }).toList();
    });
  }
}
