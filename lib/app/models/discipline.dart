class Discipline {
  const Discipline({
    required this.id,
    required this.name,
    required this.photoUrl,
  });

  final String id;
  final String name;
  final String photoUrl;

  factory Discipline.fromMap(Map<String, dynamic> map) {
    return Discipline(
      id: map['id'],
      name: map['name'],
      photoUrl: map['photoUrl'],
    );
  }
}
