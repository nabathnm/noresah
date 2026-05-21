import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;


  /// Whether the current user has completed onboarding
  bool get isOnboardingCompleted => _profile?.isOnboardingCompleted ?? false;

  /// Current authenticated user's ID
  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  /// Fetch the profile for the currently authenticated user
  Future<void> fetchProfile() async {
    final userId = _currentUserId;
    if (userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _profileService.fetchProfile(userId);
    } catch (e) {
      _error = 'Error fetching profile: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update profile info (nickname, gender, birth_date)
  Future<void> updateProfileInfo({
    required String nickname,
    required String gender,
    required DateTime birthDate,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    await _profileService.updateProfileInfo(
      userId: userId,
      nickname: nickname,
      gender: gender,
      birthDate: birthDate,
    );

    // Update local state
    _profile = _profile?.copyWith(
      nickname: nickname,
      gender: gender,
      birthDate: birthDate,
    );
    notifyListeners();
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    final userId = _currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    await _profileService.completeOnboarding(userId);

    // Update local state
    _profile = _profile?.copyWith(isOnboardingCompleted: true);
    notifyListeners();
  }

  /// Clear profile data (e.g., on logout)
  void clear() {
    _profile = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
