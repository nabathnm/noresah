import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/problem_preference_model.dart';
import '../../../../core/services/profile_service.dart';
import '../../../../core/services/problem_preference_service.dart';

class OnboardingProvider with ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final ProblemPreferenceService _prefService = ProblemPreferenceService();

  // ── Page state ──
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // ── Slide 2: Profile info ──
  String _nickname = '';
  String get nickname => _nickname;

  String? _gender;
  String? get gender => _gender;

  DateTime? _birthDate;
  DateTime? get birthDate => _birthDate;

  // ── Slide 3: Problem preferences ──
  List<ProblemPreferenceModel> _availablePreferences = [];
  List<ProblemPreferenceModel> get availablePreferences => _availablePreferences;

  final Set<int> _selectedPreferenceIds = {};
  Set<int> get selectedPreferenceIds => Set.unmodifiable(_selectedPreferenceIds);

  // ── Loading / Error ──
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _error;
  String? get error => _error;

  // ── Helpers ──
  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  // ── Page navigation ──
  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  // ── Slide 2 setters ──
  void setNickname(String value) {
    _nickname = value;
    // Don't notifyListeners for every keystroke — let TextField handle it
  }

  void setGender(String? value) {
    _gender = value;
    notifyListeners();
  }

  void setBirthDate(DateTime? value) {
    _birthDate = value;
    notifyListeners();
  }

  // ── Slide 3: Toggle preference ──
  void togglePreference(int preferenceId) {
    if (_selectedPreferenceIds.contains(preferenceId)) {
      _selectedPreferenceIds.remove(preferenceId);
    } else {
      _selectedPreferenceIds.add(preferenceId);
    }
    notifyListeners();
  }

  // ── Validation ──
  bool get isSlide2Valid =>
      _nickname.trim().isNotEmpty && _gender != null && _birthDate != null;

  bool get isSlide3Valid => _selectedPreferenceIds.isNotEmpty;

  // ── Load available preferences from Supabase ──
  Future<void> loadPreferences() async {
    debugPrint('[OnboardingProvider] loadPreferences() called');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _availablePreferences = await _prefService.fetchAllPreferences();
      debugPrint(
          '[OnboardingProvider] Loaded ${_availablePreferences.length} preferences');
      for (final pref in _availablePreferences) {
        debugPrint('  - id: ${pref.id}, name: ${pref.name}');
      }
    } catch (e, stackTrace) {
      _error = 'Gagal memuat data preferences: $e';
      debugPrint('[OnboardingProvider] ERROR: $_error');
      debugPrint('[OnboardingProvider] StackTrace: $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Save profile info (Slide 2 → Supabase) ──
  Future<bool> saveProfileInfo() async {
    final userId = _currentUserId;
    if (userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _profileService.updateProfileInfo(
        userId: userId,
        nickname: _nickname.trim(),
        gender: _gender!,
        birthDate: _birthDate!,
      );
      return true;
    } catch (e) {
      _error = 'Gagal menyimpan profil: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ── Save preferences + complete onboarding (Slide 3 → Supabase) ──
  Future<bool> savePreferencesAndComplete() async {
    final userId = _currentUserId;
    if (userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Save user problem preferences
      await _prefService.saveUserPreferences(
        userId: userId,
        preferenceIds: _selectedPreferenceIds.toList(),
      );

      // 2. Mark onboarding as completed
      await _profileService.completeOnboarding(userId);

      return true;
    } catch (e) {
      _error = 'Gagal menyimpan preferences: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ── Reset state ──
  void reset() {
    _currentPage = 0;
    _nickname = '';
    _gender = null;
    _birthDate = null;
    _availablePreferences = [];
    _selectedPreferenceIds.clear();
    _isLoading = false;
    _isSaving = false;
    _error = null;
    notifyListeners();
  }
}
