/// Model untuk post di Anonymous Community Forum.
class ForumPost {
  final String? id;
  final String userId;
  final String content;
  final String? mood;
  final String category;
  final int likes;
  final int comments;
  final DateTime createdAt;
  final List<ForumComment> commentList;

  ForumPost({
    this.id,
    required this.userId,
    required this.content,
    this.mood,
    this.category = 'General',
    this.likes = 0,
    this.comments = 0,
    required this.createdAt,
    this.commentList = const [],
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'content': content,
        'mood': mood,
        'category': category,
        'likes': likes,
        'comments': comments,
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
      comments: json['comments'] ?? 0,
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

class ForumComment {
  final String? id;
  final String postId;
  final String userId;
  final String content;
  final bool isExpert;
  final DateTime createdAt;

  ForumComment({
    this.id,
    required this.postId,
    required this.userId,
    required this.content,
    this.isExpert = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'post_id': postId,
        'user_id': userId,
        'content': content,
        'is_expert': isExpert,
        'created_at': createdAt.toIso8601String(),
      };

  factory ForumComment.fromJson(Map<String, dynamic> json) {
    return ForumComment(
      id: json['id']?.toString(),
      postId: json['post_id'] ?? '',
      userId: json['user_id'] ?? '',
      content: json['content'] ?? '',
      isExpert: json['is_expert'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
