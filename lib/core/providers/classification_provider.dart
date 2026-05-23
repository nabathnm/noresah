import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/distress_classification.dart';

class ClassificationProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  DistressLevel _currentLevel = DistressLevel.aman;
  DistressLevel get currentLevel => _currentLevel;

  List<DistressClassification> _history = [];
  List<DistressClassification> get history => _history;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void updateLevel(DistressLevel level) {
    _currentLevel = level;
    notifyListeners();
  }

  /// Simpan klasifikasi ke Supabase
  Future<void> saveClassification({
    required DistressLevel level,
    required String summary,
    List<String> keywords = const [],
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final classification = DistressClassification(
        userId: user.id,
        level: level,
        summary: summary,
        timestamp: DateTime.now(),
        keywords: keywords,
      );

      await _supabase
          .from('distress_classifications')
          .insert(classification.toJson());

      _currentLevel = level;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving classification: $e');
    }
  }

  /// Ambil riwayat klasifikasi dari Supabase
  Future<void> fetchHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('distress_classifications')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(20);

      _history = (response as List)
          .map((json) => DistressClassification.fromJson(json))
          .toList();

      if (_history.isNotEmpty) {
        _currentLevel = _history.first.level;
      }
    } catch (e) {
      debugPrint('Error fetching classification history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
