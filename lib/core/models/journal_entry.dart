/// Model untuk entri jurnal harian pengguna.
class JournalEntry {
  final String? id;
  final String userId;
  final String title;
  final String content;
  final DateTime date;
  final DateTime createdAt;
  final DateTime? updatedAt;

  JournalEntry({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.date,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'title': title,
        'content': content,
        'date': date.toIso8601String().split('T')[0],
        'created_at': createdAt.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id']?.toString(),
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  JournalEntry copyWith({
    String? title,
    String? content,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id,
      userId: userId,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get dateFormatted {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String get contentPreview {
    if (content.length <= 80) return content;
    return '${content.substring(0, 80)}...';
  }
}
