import 'package:flutter/material.dart';
import 'package:vollgym/app/exercises/details/exercise_detail_tile.dart';
import 'package:vollgym/app/models/exercise.dart';
import 'package:vollgym/app/utils/extensions.dart';

class ExercisesDetailsPage extends StatelessWidget {
  const ExercisesDetailsPage({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${exercise.date.weekday.toDayNameShort}. ${exercise.date.month.toMonthNameShort} ${exercise.date.year.toString().substring(2)}')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            children: List.generate(exercise.exercisePerformed.length, (i) {
              return ExerciseDetailTile(
                index: i,
                name: exercise.exercisePerformed[i].name,
                link: exercise.exercisePerformed[i].link,
                isFirst: i == 0,
              );
            }),
          ),
        )),
      ),
    );
  }
}
