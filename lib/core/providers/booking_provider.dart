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

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  final List<String> categories = [
    'All',
    'Stress',
    'Depression',
    'Anxiety',
    'Sleep',
    'Burnout',
  ];

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Psychologist> get filteredPsychologists {
    var result = _psychologists;

    if (_selectedCategory != 'All') {
      result = result
          .where((p) =>
              p.specialist.toLowerCase().contains(_selectedCategory.toLowerCase()))
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.specialist.toLowerCase().contains(_searchQuery.toLowerCase()))
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
          .from('psychologists')
          .select()
          .eq('is_available', true);

      _psychologists = (response as List)
          .map((json) => Psychologist.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching psychologists: $e');
      // Gunakan data dummy
      _psychologists = _getDummyPsychologists();
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
      // Simpan secara lokal
      _bookings.insert(
        0,
        Booking(
          userId: 'local',
          psychologistId: psychologist.id,
          psychologistName: psychologist.name,
          scheduledAt: scheduledAt,
          notes: notes,
          createdAt: DateTime.now(),
        ),
      );
      notifyListeners();
      return true;
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
          .select()
          .eq('user_id', user.id)
          .order('scheduled_at', ascending: false);

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

      final response = await _supabase
          .from('bookings')
          .select()
          .eq('psychologist_id', user.id)
          .order('scheduled_at', ascending: false);

      _psychologistBookings = (response as List)
          .map((json) => Booking.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching psychologist bookings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Psikolog mengkonfirmasi booking
  Future<bool> confirmBooking(String bookingId) async {
    try {
      await _supabase
          .from('bookings')
          .update({'status': 'confirmed'}).eq('id', bookingId);
      await fetchPsychologistBookings();
      return true;
    } catch (e) {
      debugPrint('Error confirming booking: $e');
      return false;
    }
  }

  /// Batalkan booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      await _supabase
          .from('bookings')
          .update({'status': 'cancelled'}).eq('id', bookingId);
      await fetchBookings();
      await fetchPsychologistBookings();
      return true;
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      return false;
    }
  }

  /// Hitung jumlah booking pending (untuk dashboard psikolog)
  int get pendingBookingsCount =>
      _psychologistBookings.where((b) => b.status == BookingStatus.pending).length;

  List<Psychologist> _getDummyPsychologists() {
    return [
      Psychologist(
        id: '1',
        name: 'Dr. Sarah Wijaya',
        specialist: 'Anxiety & Stress',
        experience: '6 Tahun Pengalaman',
        rating: 4.9,
        price: 'Rp120K/sesi',
      ),
      Psychologist(
        id: '2',
        name: 'Dr. Michael Adrian',
        specialist: 'Depression & Burnout',
        experience: '8 Tahun Pengalaman',
        rating: 4.8,
        price: 'Rp150K/sesi',
      ),
      Psychologist(
        id: '3',
        name: 'Dr. Olivia Chen',
        specialist: 'Sleep & Emotional Health',
        experience: '5 Tahun Pengalaman',
        rating: 4.9,
        price: 'Rp135K/sesi',
      ),
      Psychologist(
        id: '4',
        name: 'Dr. Ahmad Fauzi',
        specialist: 'Anxiety & Self-Esteem',
        experience: '7 Tahun Pengalaman',
        rating: 4.7,
        price: 'Rp125K/sesi',
      ),
    ];
  }
}
