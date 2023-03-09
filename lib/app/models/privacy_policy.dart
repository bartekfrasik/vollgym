class PrivacyPolicy {
  const PrivacyPolicy({
    required this.context,
    required this.primaryUseOfData,
    required this.typesOfData,
  });

  final String context;
  final String primaryUseOfData;
  final String typesOfData;

  factory PrivacyPolicy.fromMap(Map<String, dynamic> map) {
    return PrivacyPolicy(
      context: map['context'],
      primaryUseOfData: map['primaryUseOfData'],
      typesOfData: map['typesOfData'],
    );
  }

  static List<PrivacyPolicy> fromMapList(List<dynamic> mapList) {
    return mapList.map((e) => PrivacyPolicy.fromMap(e)).toList();
  }
}
