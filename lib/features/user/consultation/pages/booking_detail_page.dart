import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/booking_provider.dart';
import '../../../../core/models/booking.dart';
import '../../../../core/utils/constant/app_colors.dart';

class BookingDetailPage extends StatefulWidget {
  final Psychologist psychologist;

  const BookingDetailPage({super.key, required this.psychologist});

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<TimeOfDay> _bookedSlots = [];
  bool _isLoadingSlots = false;
  final _notesController = TextEditingController();

  final List<TimeOfDay> _availableTimeSlots = [
    const TimeOfDay(hour: 8, minute: 0),
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 12, minute: 0),
    const TimeOfDay(hour: 13, minute: 0),
  ];

  late List<DateTime> _availableDates;

  @override
  void initState() {
    super.initState();
    _generateAvailableDates();
  }

  void _generateAvailableDates() {
    _availableDates = [];
    DateTime now = DateTime.now();
    // Start from tomorrow
    DateTime current = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    
    // Generate dates for the next 14 weekdays
    while (_availableDates.length < 14) {
      if (current.weekday >= DateTime.monday && current.weekday <= DateTime.friday) {
        _availableDates.add(current);
      }
      current = current.add(const Duration(days: 1));
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onDateSelected(DateTime date) async {
    setState(() {
      _selectedDate = date;
      _selectedTime = null; // Reset time when date changes
      _isLoadingSlots = true;
    });

    final provider = Provider.of<BookingProvider>(context, listen: false);
    final booked = await provider.fetchBookingsForPsychologist(widget.psychologist.id, date);
    
    if (mounted) {
      setState(() {
        _bookedSlots = booked;
        _isLoadingSlots = false;
      });
    }
  }

  bool _isSlotBooked(TimeOfDay slot) {
    return _bookedSlots.any((b) => b.hour == slot.hour && b.minute == slot.minute);
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'Sen';
      case 2: return 'Sel';
      case 3: return 'Rab';
      case 4: return 'Kam';
      case 5: return 'Jum';
      case 6: return 'Sab';
      case 7: return 'Min';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'Mei';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Agu';
      case 9: return 'Sep';
      case 10: return 'Okt';
      case 11: return 'Nov';
      case 12: return 'Des';
      default: return '';
    }
  }

  Future<void> _submitBooking() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih tanggal dan waktu terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final scheduledAt = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final provider = Provider.of<BookingProvider>(context, listen: false);
    final success = await provider.createBooking(
      psychologist: widget.psychologist,
      scheduledAt: scheduledAt,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    if (success && mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xff4CAF50).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xff4CAF50),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Booking Berhasil! 🎉',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Konsultasi dengan ${widget.psychologist.name} telah dijadwalkan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.psychologist;
    final isLoading = context.watch<BookingProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.netralLight,
      appBar: AppBar(
        backgroundColor: AppColors.netralLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Booking',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      doctor.name.isNotEmpty
                          ? doctor.name.split(' ').last[0]
                          : 'P',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    doctor.specialist,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    doctor.bio ?? doctor.experience,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Date Picker (Horizontal List)
            const Text(
              'Pilih Tanggal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _availableDates.length,
                itemBuilder: (context, index) {
                  final date = _availableDates[index];
                  final isSelected = _selectedDate == date;
                  return GestureDetector(
                    onTap: () => _onDateSelected(date),
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getWeekdayName(date.weekday),
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? Colors.white70 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            _getMonthName(date.month),
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white70 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Time Picker (Grid)
            const Text(
              'Pilih Waktu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_selectedDate == null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pilih tanggal terlebih dahulu untuk melihat jadwal yang tersedia.',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              )
            else if (_isLoadingSlots)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _availableTimeSlots.length,
                itemBuilder: (context, index) {
                  final slot = _availableTimeSlots[index];
                  final isBooked = _isSlotBooked(slot);
                  final isSelected = _selectedTime == slot;

                  return GestureDetector(
                    onTap: isBooked
                        ? null
                        : () {
                            setState(() => _selectedTime = slot);
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isBooked
                            ? Colors.grey.shade200
                            : isSelected
                                ? AppColors.primary
                                : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isBooked
                              ? Colors.grey.shade300
                              : isSelected
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${slot.hour.toString().padLeft(2, '0')}:${slot.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isBooked
                              ? Colors.grey.shade500
                              : isSelected
                                  ? Colors.white
                                  : AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            // Notes
            const Text(
              'Catatan (Opsional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ceritakan secara singkat keluhan kamu...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Konfirmasi Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
