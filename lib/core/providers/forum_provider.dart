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
          .from('forum_posts')
          .select()
          .order('created_at', ascending: false);

      if (_selectedCategory != 'All') {
        query = _supabase
            .from('forum_posts')
            .select()
            .eq('category', _selectedCategory)
            .order('created_at', ascending: false);
      }

      final response = await query;
      _posts = (response as List)
          .map((json) => ForumPost.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching forum posts: $e');
      // Gunakan data dummy jika Supabase belum siap
      _posts = _getDummyPosts();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Buat post baru secara anonim
  Future<bool> createPost({
    required String content,
    String? mood,
    String category = 'General',
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // Cek PII sederhana
      if (_containsPII(content)) {
        return false;
      }

      final post = ForumPost(
        userId: user.id,
        content: content,
        mood: mood,
        category: category,
        createdAt: DateTime.now(),
      );

      await _supabase.from('forum_posts').insert(post.toJson());
      await fetchPosts();
      return true;
    } catch (e) {
      debugPrint('Error creating post: $e');
      // Tambah ke local jika Supabase gagal
      _posts.insert(
        0,
        ForumPost(
          userId: 'local',
          content: content,
          mood: mood,
          category: category,
          createdAt: DateTime.now(),
        ),
      );
      notifyListeners();
      return true;
    }
  }

  /// Toggle like pada post
  Future<void> toggleLike(String postId) async {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    try {
      final post = _posts[idx];
      final newLikes = post.likes + 1;
      await _supabase
          .from('forum_posts')
          .update({'likes': newLikes}).eq('id', postId);

      _posts[idx] = ForumPost(
        id: post.id,
        userId: post.userId,
        content: post.content,
        mood: post.mood,
        category: post.category,
        likes: newLikes,
        comments: post.comments,
        createdAt: post.createdAt,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling like: $e');
    }
  }

  /// Deteksi sederhana PII (nama, email, nomor telepon)
  bool _containsPII(String text) {
    final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final phoneRegex = RegExp(r'(\+62|62|0)\d{9,12}');

    return emailRegex.hasMatch(text) || phoneRegex.hasMatch(text);
  }

  List<ForumPost> _getDummyPosts() {
    return [
      ForumPost(
        id: '1',
        userId: 'anon1',
        content:
            'Akhir-akhir ini aku merasa lelah karena tugas kuliah dan overthinking setiap malam.',
        mood: '😔 Merasa Lelah',
        category: 'Stress',
        likes: 24,
        comments: 8,
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      ForumPost(
        id: '2',
        userId: 'anon2',
        content:
            'Hari ini akhirnya aku keluar rumah untuk jalan-jalan setelah berhari-hari di dalam kamar.',
        mood: '🙂 Berusaha Lebih Baik',
        category: 'Motivation',
        likes: 41,
        comments: 14,
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      ForumPost(
        id: '3',
        userId: 'anon3',
        content:
            'Aku berhasil tidur sebelum tengah malam hari ini dan rasanya benar-benar menyegarkan.',
        mood: '😄 Pencapaian Kecil',
        category: 'Sleep',
        likes: 63,
        comments: 20,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }
}
