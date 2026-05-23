/// Model untuk level klasifikasi distress/kecemasan user.
enum DistressLevel { aman, waspada, khawatir, kritis }

extension DistressLevelExtension on DistressLevel {
  String get label {
    switch (this) {
      case DistressLevel.aman:
        return 'Aman';
      case DistressLevel.waspada:
        return 'Waspada';
      case DistressLevel.khawatir:
        return 'Khawatir';
      case DistressLevel.kritis:
        return 'Kritis';
    }
  }

  String get emoji {
    switch (this) {
      case DistressLevel.aman:
        return '🟢';
      case DistressLevel.waspada:
        return '🟡';
      case DistressLevel.khawatir:
        return '🟠';
      case DistressLevel.kritis:
        return '🔴';
    }
  }

  String get description {
    switch (this) {
      case DistressLevel.aman:
        return 'Kamu terlihat cukup stabil. Tetap jaga kesehatan mentalmu!';
      case DistressLevel.waspada:
        return 'Ada tanda-tanda stres sedang. Pertimbangkan untuk bicara dengan seseorang.';
      case DistressLevel.khawatir:
        return 'Kamu mungkin membutuhkan bantuan profesional. Pertimbangkan konsultasi.';
      case DistressLevel.kritis:
        return 'Kondisimu membutuhkan perhatian segera. Hubungi layanan darurat.';
    }
  }

  int get numericValue {
    switch (this) {
      case DistressLevel.aman:
        return 1;
      case DistressLevel.waspada:
        return 2;
      case DistressLevel.khawatir:
        return 3;
      case DistressLevel.kritis:
        return 4;
    }
  }

  static DistressLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'aman':
      case 'rendah':
      case 'low':
        return DistressLevel.aman;
      case 'waspada':
      case 'sedang':
      case 'medium':
        return DistressLevel.waspada;
      case 'khawatir':
      case 'tinggi':
      case 'high':
        return DistressLevel.khawatir;
      case 'kritis':
      case 'critical':
        return DistressLevel.kritis;
      default:
        return DistressLevel.aman;
    }
  }

  static DistressLevel fromMoodScore(int score) {
    if (score <= -50) return DistressLevel.kritis;
    if (score <= -30) return DistressLevel.khawatir;
    if (score <= -10) return DistressLevel.waspada;
    return DistressLevel.aman;
  }
}

class DistressClassification {
  final String userId;
  final DistressLevel level;
  final String summary;
  final DateTime timestamp;
  final List<String> keywords;

  DistressClassification({
    required this.userId,
    required this.level,
    required this.summary,
    required this.timestamp,
    this.keywords = const [],
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'level': level.numericValue,
    'level_label': level.label,
    'summary': summary,
    'keywords': keywords,
    'created_at': timestamp.toIso8601String(),
  };

  factory DistressClassification.fromJson(Map<String, dynamic> json) {
    final levelValue = json['level'] as int? ?? 1;
    DistressLevel level;
    switch (levelValue) {
      case 1:
        level = DistressLevel.aman;
        break;
      case 2:
        level = DistressLevel.waspada;
        break;
      case 3:
        level = DistressLevel.khawatir;
        break;
      case 4:
        level = DistressLevel.kritis;
        break;
      default:
        level = DistressLevel.aman;
    }

    return DistressClassification(
      userId: json['user_id'] ?? '',
      level: level,
      summary: json['summary'] ?? '',
      timestamp: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      keywords: List<String>.from(json['keywords'] ?? []),
    );
  }
}
