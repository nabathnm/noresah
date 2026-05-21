/// Model untuk level klasifikasi distress/kecemasan user.
enum DistressLevel { rendah, sedang, tinggi, kritis }

extension DistressLevelExtension on DistressLevel {
  String get label {
    switch (this) {
      case DistressLevel.rendah:
        return 'Aman';
      case DistressLevel.sedang:
        return 'Waspada';
      case DistressLevel.tinggi:
        return 'Khawatir';
      case DistressLevel.kritis:
        return 'Kritis';
    }
  }

  String get emoji {
    switch (this) {
      case DistressLevel.rendah:
        return '🟢';
      case DistressLevel.sedang:
        return '🟡';
      case DistressLevel.tinggi:
        return '🟠';
      case DistressLevel.kritis:
        return '🔴';
    }
  }

  String get description {
    switch (this) {
      case DistressLevel.rendah:
        return 'Kamu terlihat cukup stabil. Tetap jaga kesehatan mentalmu!';
      case DistressLevel.sedang:
        return 'Ada tanda-tanda stres sedang. Pertimbangkan untuk bicara dengan seseorang.';
      case DistressLevel.tinggi:
        return 'Kamu mungkin membutuhkan bantuan profesional. Pertimbangkan konsultasi.';
      case DistressLevel.kritis:
        return 'Kondisimu membutuhkan perhatian segera. Hubungi layanan darurat.';
    }
  }

  int get numericValue {
    switch (this) {
      case DistressLevel.rendah:
        return 1;
      case DistressLevel.sedang:
        return 2;
      case DistressLevel.tinggi:
        return 3;
      case DistressLevel.kritis:
        return 4;
    }
  }

  static DistressLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'aman':
      case 'low':
        return DistressLevel.rendah;
      case 'waspada':
      case 'medium':
        return DistressLevel.sedang;
      case 'khawatir':
      case 'high':
        return DistressLevel.tinggi;
      case 'kritis':
      case 'critical':
        return DistressLevel.kritis;
      default:
        return DistressLevel.rendah;
    }
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
        level = DistressLevel.rendah;
        break;
      case 2:
        level = DistressLevel.sedang;
        break;
      case 3:
        level = DistressLevel.tinggi;
        break;
      case 4:
        level = DistressLevel.kritis;
        break;
      default:
        level = DistressLevel.rendah;
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
