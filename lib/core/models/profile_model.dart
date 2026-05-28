class ProfileModel {
  final String id;
  final String? nickname;
  final String? gender;
  final DateTime? birthDate;
  final String? phoneNumber;
  final String role;
  final bool isOnboardingCompleted;
  final int moodScore;
  final int? aiDistressLevel;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    this.nickname,
    this.gender,
    this.birthDate,
    this.phoneNumber,
    required this.role,
    required this.isOnboardingCompleted,
    this.moodScore = 0,
    this.aiDistressLevel,
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
      phoneNumber: json['phone_number'] as String?,
      role: json['role'] as String? ?? 'user',
      isOnboardingCompleted:
          json['is_onboarding_completed'] as bool? ?? false,
      moodScore: json['mood_score'] as int? ?? 0,
      aiDistressLevel: _parseAiDistressLevel(json['distress_classifications']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  static int? _parseAiDistressLevel(dynamic classifications) {
    if (classifications == null) return null;
    if (classifications is List && classifications.isNotEmpty) {
      // Assuming it's ordered by created_at desc or we take the first one
      final first = classifications.first;
      if (first is Map<String, dynamic>) {
        return first['level'] as int?;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'gender': gender,
      'birth_date': birthDate?.toIso8601String().split('T').first,
      'phone_number': phoneNumber,
      'role': role,
      'is_onboarding_completed': isOnboardingCompleted,
      'mood_score': moodScore,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? nickname,
    String? gender,
    DateTime? birthDate,
    String? phoneNumber,
    String? role,
    bool? isOnboardingCompleted,
    int? moodScore,
    int? aiDistressLevel,
  }) {
    return ProfileModel(
      id: id,
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
      moodScore: moodScore ?? this.moodScore,
      aiDistressLevel: aiDistressLevel ?? this.aiDistressLevel,
      createdAt: createdAt,
    );
  }
}
