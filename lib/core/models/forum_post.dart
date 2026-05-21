/// Model untuk post di Anonymous Community Forum.
/// Constraint: Hanya psikolog yang bisa menjawab pertanyaan.
class ForumPost {
  final String? id;
  final String userId;
  final String content;
  final String? mood;
  final String category;
  final int likes;
  final int answerCount;
  final DateTime createdAt;
  final List<ForumAnswer> answers;

  ForumPost({
    this.id,
    required this.userId,
    required this.content,
    this.mood,
    this.category = 'General',
    this.likes = 0,
    this.answerCount = 0,
    required this.createdAt,
    this.answers = const [],
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'content': content,
        'mood': mood,
        'category': category,
        'likes': likes,
        'answer_count': answerCount,
        'created_at': createdAt.toIso8601String(),
      };

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id']?.toString(),
      userId: json['user_id'] ?? '',
      content: json['content'] ?? '',
      mood: json['mood'],
      category: json['category'] ?? 'General',
      likes: json['likes'] ?? 0,
      answerCount: json['answer_count'] ?? json['comments'] ?? 0,
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
  final String postId;
  final String userId;
  final String content;
  final String psychologistName;
  final DateTime createdAt;

  ForumAnswer({
    this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.psychologistName,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'post_id': postId,
        'user_id': userId,
        'content': content,
        'psychologist_name': psychologistName,
        'created_at': createdAt.toIso8601String(),
      };

  factory ForumAnswer.fromJson(Map<String, dynamic> json) {
    return ForumAnswer(
      id: json['id']?.toString(),
      postId: json['post_id'] ?? '',
      userId: json['user_id'] ?? '',
      content: json['content'] ?? '',
      psychologistName: json['psychologist_name'] ?? 'Psikolog',
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
