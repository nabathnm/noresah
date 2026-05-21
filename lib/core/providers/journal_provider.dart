import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/journal_entry.dart';

class JournalProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<JournalEntry> _journals = [];
  List<JournalEntry> get journals => _journals;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Ambil daftar jurnal (terbaru di atas)
  Future<void> fetchJournals() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('journals')
          .select()
          .eq('user_id', user.id)
          .order('date', ascending: false);

      _journals = (response as List)
          .map((json) => JournalEntry.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching journals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Buat jurnal baru
  Future<bool> createJournal({
    required String title,
    required String content,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final entry = JournalEntry(
        userId: user.id,
        title: title,
        content: content,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await _supabase.from('journals').insert(entry.toJson());
      await fetchJournals();
      return true;
    } catch (e) {
      debugPrint('Error creating journal: $e');
      // Simpan secara lokal
      _journals.insert(
        0,
        JournalEntry(
          userId: 'local',
          title: title,
          content: content,
          date: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );
      notifyListeners();
      return true;
    }
  }

  /// Update jurnal
  Future<bool> updateJournal({
    required String journalId,
    required String title,
    required String content,
  }) async {
    try {
      await _supabase.from('journals').update({
        'title': title,
        'content': content,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', journalId);

      await fetchJournals();
      return true;
    } catch (e) {
      debugPrint('Error updating journal: $e');
      return false;
    }
  }

  /// Hapus jurnal
  Future<bool> deleteJournal(String journalId) async {
    try {
      await _supabase.from('journals').delete().eq('id', journalId);
      _journals.removeWhere((j) => j.id == journalId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting journal: $e');
      return false;
    }
  }
}
