import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/problem_preference_model.dart';

class ProblemPreferenceService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Fetch all available problem preferences (master data)
  Future<List<ProblemPreferenceModel>> fetchAllPreferences() async {
    final response = await _client
        .from('problem_preferences')
        .select()
        .order('id', ascending: true);

    return (response as List)
        .map((json) => ProblemPreferenceModel.fromJson(json))
        .toList();
  }

  /// Fetch the current user's selected problem preference IDs
  Future<List<int>> fetchUserPreferenceIds(String userId) async {
    final response = await _client
        .from('user_problem_preferences')
        .select('problem_preference_id')
        .eq('user_id', userId);

    return (response as List)
        .map((row) => row['problem_preference_id'] as int)
        .toList();
  }

  /// Save user preferences (delete existing, then insert new ones).
  /// This ensures idempotency — safe to call multiple times.
  Future<void> saveUserPreferences({
    required String userId,
    required List<int> preferenceIds,
  }) async {
    // 1. Delete all existing preferences for this user
    await _client
        .from('user_problem_preferences')
        .delete()
        .eq('user_id', userId);

    // 2. Insert new preferences
    if (preferenceIds.isNotEmpty) {
      final rows = preferenceIds
          .map((prefId) => {
                'user_id': userId,
                'problem_preference_id': prefId,
              })
          .toList();

      await _client.from('user_problem_preferences').insert(rows);
    }

    debugPrint(
        '[ProblemPreferenceService] Saved ${preferenceIds.length} preferences for $userId');
  }
}
