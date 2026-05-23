import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking.dart';

class BookingProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Booking> _bookings = [];
  List<Booking> get bookings => _bookings;

  List<Booking> _psychologistBookings = [];
  List<Booking> get psychologistBookings => _psychologistBookings;

  List<Psychologist> _psychologists = [];
  List<Psychologist> get psychologists => _psychologists;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Psychologist> get filteredPsychologists {
    var result = _psychologists;

    // Kategori tidak lagi memfilter psikolog karena semua psikolog bisa menangani semua genre.
    // Filter berdasarkan kategori dihilangkan atau tidak melakukan apapun.

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result
          .where(
            (p) =>
                p.name.toLowerCase().contains(query) ||
                (p.bio?.toLowerCase().contains(query) ?? false) ||
                p.experience.toLowerCase().contains(query),
          )
          .toList();
    }

    return result;
  }

  /// Ambil daftar psikolog
  Future<void> fetchPsychologists() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('psychologist_profiles')
          .select('*, profiles(nickname)');

      _psychologists = (response as List)
          .map((json) => Psychologist.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching psychologists: $e');
      _psychologists = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Buat booking baru
  Future<bool> createBooking({
    required Psychologist psychologist,
    required DateTime scheduledAt,
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final booking = Booking(
        userId: user.id,
        psychologistId: psychologist.id,
        psychologistName: psychologist.name,
        scheduledAt: scheduledAt,
        notes: notes,
        createdAt: DateTime.now(),
      );

      await _supabase.from('bookings').insert(booking.toJson());
      await fetchBookings();
      return true;
    } catch (e) {
      debugPrint('Error creating booking: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ambil daftar booking user
  Future<void> fetchBookings() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('bookings')
          .select(
            '*, profiles(nickname), psychologist_profiles(profiles(nickname))',
          )
          .eq('user_id', user.id)
          .order('booking_date', ascending: false)
          .order('start_time', ascending: false);

      _bookings = (response as List)
          .map((json) => Booking.fromJson(json))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
    }
  }

  /// Ambil daftar booking untuk psikolog (semua booking ke psikolog ini)
  Future<void> fetchPsychologistBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      // Lookup the psychologist's integer ID
      final psychProfile = await _supabase
          .from('psychologist_profiles')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (psychProfile == null) {
        _psychologistBookings = [];
        return;
      }
      final int psychId = psychProfile['id'] as int;

      final response = await _supabase
          .from('bookings')
          .select(
            '*, profiles(nickname), psychologist_profiles(profiles(nickname))',
          )
          .eq('psychologist_id', psychId)
          .order('booking_date', ascending: false)
          .order('start_time', ascending: false);

      _psychologistBookings = (response as List)
          .map((json) => Booking.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching psychologist bookings: $e');
      _psychologistBookings = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ambil jadwal booking yang sudah terisi untuk seorang psikolog pada tanggal tertentu
  Future<List<TimeOfDay>> fetchBookingsForPsychologist(
    int psychId,
    DateTime date,
  ) async {
    try {
      final dateString =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final response = await _supabase
          .from('bookings')
          .select('start_time')
          .eq('psychologist_id', psychId)
          .eq('booking_date', dateString)
          .not('status', 'eq', 'cancelled');

      final List<TimeOfDay> bookedSlots = [];
      for (var row in (response as List)) {
        if (row['start_time'] != null) {
          final timeParts = row['start_time'].toString().split(':');
          if (timeParts.length >= 2) {
            bookedSlots.add(
              TimeOfDay(
                hour: int.parse(timeParts[0]),
                minute: int.parse(timeParts[1]),
              ),
            );
          }
        }
      }
      return bookedSlots;
    } catch (e) {
      debugPrint('Error fetching psychologist slots: $e');
      return [];
    }
  }

  /// Psikolog mengkonfirmasi booking
  Future<bool> confirmBooking(int bookingId) async {
    try {
      await _supabase
          .from('bookings')
          .update({'status': 'confirmed'})
          .eq('id', bookingId);
      await fetchPsychologistBookings();
      return true;
    } catch (e) {
      debugPrint('Error confirming booking: $e');
      return false;
    }
  }

  /// Batalkan booking
  Future<bool> cancelBooking(int bookingId) async {
    try {
      await _supabase
          .from('bookings')
          .update({'status': 'cancelled'})
          .eq('id', bookingId);
      await fetchBookings();
      await fetchPsychologistBookings();
      return true;
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      return false;
    }
  }

  /// Hitung jumlah booking pending (untuk dashboard psikolog)
  int get pendingBookingsCount => _psychologistBookings
      .where((b) => b.status == BookingStatus.pending)
      .length;
}
