/// Model untuk post di Anonymous Community Forum.
/// Constraint: Hanya psikolog yang bisa menjawab pertanyaan.
class ForumPost {
  final String? id;
  final String userId;
  final String? title;
  final String content;
  final String category;
  final int answerCount;
  final DateTime createdAt;
  final List<ForumAnswer> answers;

  ForumPost({
    this.id,
    required this.userId,
    this.title,
    required this.content,
    this.category = 'General',
    this.answerCount = 0,
    required this.createdAt,
    this.answers = const [],
  });

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        'user_id': userId,
        'content': content,
        'category': category,
        'created_at': createdAt.toIso8601String(),
      };

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id']?.toString(),
      userId: json['user_id'] ?? '',
      title: json['title'],
      content: json['content'] ?? '',
      category: json['category'] ?? 'General',
      answerCount: json['forum_replies'] != null && json['forum_replies'] is List
          ? (json['forum_replies'] as List).length
          : 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return '${(diff.inDays / 7).floor()} minggu lalu';
  }
}

/// Jawaban dari psikolog untuk post di forum.
/// Hanya role psikolog yang bisa membuat ForumAnswer.
class ForumAnswer {
  final String? id;
  final String forumId;
  final String userId;
  final String content;
  final String psychologistName;
  final DateTime createdAt;

  ForumAnswer({
    this.id,
    required this.forumId,
    required this.userId,
    required this.content,
    this.psychologistName = 'Psikolog',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'forum_id': forumId,
        'user_id': userId,
        'content': content,
        'created_at': createdAt.toIso8601String(),
      };

  factory ForumAnswer.fromJson(Map<String, dynamic> json) {
    String pName = 'Psikolog';
    if (json['profiles'] != null && json['profiles']['nickname'] != null) {
      pName = json['profiles']['nickname'];
    }

    return ForumAnswer(
      id: json['id']?.toString(),
      forumId: json['forum_id']?.toString() ?? '',
      userId: json['user_id'] ?? '',
      content: json['content'] ?? '',
      psychologistName: pName,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return '${(diff.inDays / 7).floor()} minggu lalu';
  }
}
