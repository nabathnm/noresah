/// Model untuk entri mood harian pengguna.
enum MoodType {
  sedih,
  biasa,
  senang,
  gembira,
  bahagia,
}

extension MoodTypeExtension on MoodType {
  String get label {
    switch (this) {
      case MoodType.sedih:
        return 'Sedih';
      case MoodType.biasa:
        return 'Biasa';
      case MoodType.senang:
        return 'Senang';
      case MoodType.gembira:
        return 'Gembira';
      case MoodType.bahagia:
        return 'Bahagia';
    }
  }

  String get emoji {
    switch (this) {
      case MoodType.sedih:
        return '😢';
      case MoodType.biasa:
        return '😐';
      case MoodType.senang:
        return '🙂';
      case MoodType.gembira:
        return '😄';
      case MoodType.bahagia:
        return '🥳';
    }
  }

  int get numericValue {
    switch (this) {
      case MoodType.sedih:
        return -3;
      case MoodType.biasa:
        return 0;
      case MoodType.senang:
        return 1;
      case MoodType.gembira:
        return 2;
      case MoodType.bahagia:
        return 3;
    }
  }

  static MoodType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'sedih':
        return MoodType.sedih;
      case 'biasa':
        return MoodType.biasa;
      case 'senang':
        return MoodType.senang;
      case 'gembira':
        return MoodType.gembira;
      case 'bahagia':
        return MoodType.bahagia;
      default:
        return MoodType.biasa;
    }
  }

  static MoodType fromNumeric(int value) {
    switch (value) {
      case -3:
        return MoodType.sedih;
      case 0:
        return MoodType.biasa;
      case 1:
        return MoodType.senang;
      case 2:
        return MoodType.gembira;
      case 3:
        return MoodType.bahagia;
      default:
        return MoodType.biasa;
    }
  }
}

class MoodEntry {
  final String? id;
  final String userId;
  final MoodType mood;
  final String? note;
  final DateTime date;
  final DateTime createdAt;

  MoodEntry({
    this.id,
    required this.userId,
    required this.mood,
    this.note,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'mood': mood.label,
        'mood_value': mood.numericValue,
        'note': note,
        'date': date.toIso8601String().split('T')[0],
        'created_at': createdAt.toIso8601String(),
      };

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id']?.toString(),
      userId: json['user_id'] ?? '',
      mood: MoodTypeExtension.fromString(json['mood'] ?? 'biasa'),
      note: json['note'] as String?,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
