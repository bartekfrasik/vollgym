import 'package:vollgym/app/models/exercise_performed.dart';

class Exercise {
  const Exercise({
    required this.id,
    required this.disciplineId,
    required this.title,
    required this.date,
    required this.exercisePerformed,
  });

  final String id;
  final String disciplineId;
  final String title;
  final DateTime date;
  final List<ExercisePerformed> exercisePerformed;

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      disciplineId: map['disciplineId'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      exercisePerformed: ExercisePerformed.fromMapList(map['exercisesPerformed']),
    );
  }
}
