class ProfileModel {
  final String id;
  final String? nickname;
  final String? gender;
  final DateTime? birthDate;
  final String role;
  final bool isOnboardingCompleted;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    this.nickname,
    this.gender,
    this.birthDate,
    required this.role,
    required this.isOnboardingCompleted,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      nickname: json['nickname'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      role: json['role'] as String? ?? 'user',
      isOnboardingCompleted:
          json['is_onboarding_completed'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'gender': gender,
      'birth_date': birthDate?.toIso8601String().split('T').first,
      'role': role,
      'is_onboarding_completed': isOnboardingCompleted,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? nickname,
    String? gender,
    DateTime? birthDate,
    String? role,
    bool? isOnboardingCompleted,
  }) {
    return ProfileModel(
      id: id,
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      role: role ?? this.role,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
      createdAt: createdAt,
    );
  }
}
