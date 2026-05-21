class ProblemPreferenceModel {
  final int id;
  final String name;

  const ProblemPreferenceModel({
    required this.id,
    required this.name,
  });

  factory ProblemPreferenceModel.fromJson(Map<String, dynamic> json) {
    return ProblemPreferenceModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
