class ExercisePerformed {
  const ExercisePerformed({
    required this.name,
    required this.link,
  });

  final String name;
  final String link;

  factory ExercisePerformed.fromMap(Map<String, dynamic> map) {
    return ExercisePerformed(
      name: map['name'],
      link: map['link'],
    );
  }

  static List<ExercisePerformed> fromMapList(List<dynamic> listMap) {
    return listMap.map((e) => ExercisePerformed.fromMap(e)).toList();
  }
}
