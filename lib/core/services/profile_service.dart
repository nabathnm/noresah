import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Fetch the current user's profile
  Future<ProfileModel> fetchProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return ProfileModel.fromJson(response);
  }

  /// Update profile info (nickname, gender, birth_date)
  Future<void> updateProfileInfo({
    required String userId,
    required String nickname,
    required String gender,
    required DateTime birthDate,
  }) async {
    await _client.from('profiles').update({
      'nickname': nickname,
      'gender': gender,
      'birth_date': birthDate.toIso8601String().split('T').first,
    }).eq('id', userId);

    debugPrint('[ProfileService] Profile info updated for $userId');
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding(String userId) async {
    await _client.from('profiles').update({
      'is_onboarding_completed': true,
    }).eq('id', userId);

    debugPrint('[ProfileService] Onboarding completed for $userId');
  }
}
