import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  Map<String, dynamic>? _profile;
  Map<String, dynamic>? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> createProfile({
    required String nickname,
    required int problemPreferences,
    required bool gender,
    required DateTime birthDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User tidak ditemukan');

      final profileData = {
        'id': user.id, // ← ganti 'user_id' → 'id'
        'nickname': nickname,
        'problem_preferences': problemPreferences,
        'gender': gender,
        'birth_date': birthDate.toIso8601String().split('T')[0],
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('profiles')
          .insert(profileData)
          .select()
          .single();
      _profile = response;
    } catch (e) {
      debugPrint('Error creating profile: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final response = await _supabase
            .from('profiles')
            .select()
            .eq('id', user.id) // ← ganti 'user_id' → 'id'
            .single();
        _profile = response;
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
