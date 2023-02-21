import 'package:flutter/material.dart';
import 'package:vollgym/app/utils/extensions.dart';
import 'package:vollgym/app/models/exercise.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final date = exercise.date;
    var counter = 1;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              '${date.weekday.toDayNameShort}. ${date.month.toMonthNameShort} ${date.year.toString().substring(2)}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(exercise.title),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: exercise.exercisePerformed
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('${counter++}. ${e.name}'),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
