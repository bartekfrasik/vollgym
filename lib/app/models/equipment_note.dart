class EquipmentNote {
  const EquipmentNote({required this.id, required this.note});

  final String id;
  final String note;

  factory EquipmentNote.fromMap(Map<String, dynamic> map) {
    return EquipmentNote(
      id: map['id'],
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap({bool ignoreId = true}) {
    return {
      if (!ignoreId) 'id': id,
      'note': note,
    };
  }
}
