class ExercisePerformed {
  const ExercisePerformed({
    required this.name,
    required this.link,
    required this.reps,
    required this.weight,
    required this.rest,
  });

  final String name;
  final String link;
  final String reps;
  final String weight;
  final String rest;

  factory ExercisePerformed.fromMap(Map<String, dynamic> map) {
    return ExercisePerformed(
      name: map['name'],
      link: map['link'],
      reps: map['reps'],
      weight: map['weight'],
      rest: map['rest'],
    );
  }

  static List<ExercisePerformed> fromMapList(List<dynamic> listMap) {
    return listMap.map((e) => ExercisePerformed.fromMap(e)).toList();
  }
}
