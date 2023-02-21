import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vollgym/app/exercises/exercise_tile.dart';
import 'package:vollgym/app/models/exercise.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key, required this.disciplineName});

  final String disciplineName;

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  late Stream<List<Exercise>> _dataStream;

  @override
  void initState() {
    super.initState();
    _dataStream = fetchAllExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.disciplineName)),
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
                        _dataStream = fetchAllExercises();
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

                final exercises = snapshot.data;

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _dataStream = fetchAllExercises();
                    });
                  },
                  child: ListView.builder(
                    itemCount: exercises!.length,
                    shrinkWrap: true,
                    itemBuilder: (_, i) {
                      return ExerciseTile(exercise: exercises[i]);
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

  Stream<List<Exercise>> fetchAllExercises() {
    return FirebaseFirestore.instance.collection('exercises').snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        final map = doc.data() as Map<String, dynamic>;
        map['id'] = doc.id;
        return Exercise.fromMap(map);
      }).toList();
    });
  }
}
