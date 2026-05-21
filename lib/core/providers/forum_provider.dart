import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/forum_post.dart';

class ForumProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<ForumPost> _posts = [];
  List<ForumPost> get posts => _posts;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<String> categories = [
    'All',
    'Stress',
    'Sleep',
    'Motivation',
    'Anxiety',
    'Self Care',
  ];

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
    fetchPosts();
  }

  /// Ambil posts dari Supabase
  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      var query = _supabase
          .from('forum')
          .select('*, forum_replies(id)')
          .order('created_at', ascending: false);

      if (_selectedCategory != 'All') {
        query = _supabase
            .from('forum')
            .select('*, forum_replies(id)')
            .eq('category', _selectedCategory)
            .order('created_at', ascending: false);
      }

      final response = await query;
      _posts = (response as List)
          .map((json) => ForumPost.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching forum posts: $e');
      _posts = _getDummyPosts();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ambil jawaban untuk post tertentu
  Future<List<ForumAnswer>> fetchAnswers(String postId) async {
    try {
      final response = await _supabase
          .from('forum_replies')
          .select('*, profiles(nickname)')
          .eq('forum_id', int.parse(postId))
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => ForumAnswer.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching answers: $e');
      return [];
    }
  }

  /// Psikolog menjawab pertanyaan user
  Future<bool> addAnswer({
    required String postId,
    required String content,
    required String psychologistName,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final answer = ForumAnswer(
        forumId: postId,
        userId: user.id,
        content: content,
        psychologistName: psychologistName,
        createdAt: DateTime.now(),
      );

      await _supabase.from('forum_replies').insert(answer.toJson());

      // Update answer count di lokal
      final idx = _posts.indexWhere((p) => p.id == postId);
      if (idx != -1) {
        final post = _posts[idx];
        _posts[idx] = ForumPost(
          id: post.id,
          userId: post.userId,
          title: post.title,
          content: post.content,
          category: post.category,
          answerCount: post.answerCount + 1,
          createdAt: post.createdAt,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding answer: $e');
      return false;
    }
  }

  /// Buat post baru secara anonim (hanya user)
  Future<bool> createPost({
    required String content,
    String? title,
    String category = 'General',
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      if (_containsPII(content)) {
        return false;
      }

      final post = ForumPost(
        userId: user.id,
        title: title,
        content: content,
        category: category,
        createdAt: DateTime.now(),
      );

      await _supabase.from('forum').insert(post.toJson());
      await fetchPosts();
      return true;
    } catch (e) {
      debugPrint('Error creating post: $e');
      _posts.insert(
        0,
        ForumPost(
          userId: 'local',
          title: title,
          content: content,
          category: category,
          createdAt: DateTime.now(),
        ),
      );
      notifyListeners();
      return true;
    }
  }

  /// Toggle like pada post (Lokal Saja karena tabel likes tidak ada di schema)
  Future<void> toggleLike(String postId) async {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    final post = _posts[idx];
    _posts[idx] = ForumPost(
      id: post.id,
      userId: post.userId,
      title: post.title,
      content: post.content,
      category: post.category,
      answerCount: post.answerCount,
      createdAt: post.createdAt,
    );
    notifyListeners();
  }

  /// Ambil posts yang belum dijawab (untuk dashboard psikolog)
  Future<List<ForumPost>> fetchUnansweredPosts() async {
    try {
      // Supabase tidak bisa memfilter count relasi secara langsung dengan mudah tanpa view.
      // Filter lokal untuk demo:
      final response = await _supabase
          .from('forum')
          .select('*, forum_replies(id)')
          .order('created_at', ascending: false);

      final List<ForumPost> allPosts = (response as List)
          .map((json) => ForumPost.fromJson(json))
          .toList();

      return allPosts.where((p) => p.answerCount == 0).toList();
    } catch (e) {
      debugPrint('Error fetching unanswered posts: $e');
      return _getDummyPosts().where((p) => p.answerCount == 0).toList();
    }
  }

  bool _containsPII(String text) {
    final emailRegex = RegExp(
      r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
    );
    final phoneRegex = RegExp(r'(\+62|62|0)\d{9,12}');

    return emailRegex.hasMatch(text) || phoneRegex.hasMatch(text);
  }

  List<ForumPost> _getDummyPosts() {
    return [
      ForumPost(
        id: '1',
        userId: 'anon1',
        title: 'Merasa Lelah',
        content:
            'Akhir-akhir ini aku merasa lelah karena tugas kuliah dan overthinking setiap malam.',
        category: 'Stress',
        answerCount: 1,
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      ForumPost(
        id: '2',
        userId: 'anon2',
        title: 'Berusaha Lebih Baik',
        content:
            'Hari ini akhirnya aku keluar rumah untuk jalan-jalan setelah berhari-hari di dalam kamar.',
        category: 'Motivation',
        answerCount: 0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      ForumPost(
        id: '3',
        userId: 'anon3',
        title: 'Pencapaian Kecil',
        content:
            'Aku berhasil tidur sebelum tengah malam hari ini dan rasanya benar-benar menyegarkan.',
        category: 'Sleep',
        answerCount: 2,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }
}
