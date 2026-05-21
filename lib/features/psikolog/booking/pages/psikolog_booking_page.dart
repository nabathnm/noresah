import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/booking_provider.dart';
import '../../../../core/models/booking.dart';
import '../../../../core/utils/constant/app_colors.dart';

class PsikologBookingPage extends StatefulWidget {
  const PsikologBookingPage({super.key});

  @override
  State<PsikologBookingPage> createState() => _PsikologBookingPageState();
}

class _PsikologBookingPageState extends State<PsikologBookingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false)
          .fetchPsychologistBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final bookings = bookingProvider.psychologistBookings;

    return Scaffold(
      backgroundColor: AppColors.netralLight,
      appBar: AppBar(
        backgroundColor: AppColors.netralLight,
        elevation: 0,
        title: const Text(
          'Pesanan Konsultasi',
          style: TextStyle(
            color: AppColors.textHeading,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                bookingProvider.fetchPsychologistBookings(),
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textHeading),
          ),
        ],
      ),
      body: bookingProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : bookings.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return _BookingManageCard(
                      booking: bookings[index],
                      onConfirm: bookings[index].status == BookingStatus.pending
                          ? () async {
                              if (bookings[index].id != null) {
                                final success = await bookingProvider
                                    .confirmBooking(bookings[index].id!);
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Booking berhasil dikonfirmasi! ✅'),
                                      backgroundColor: AppColors.greenNormal,
                                    ),
                                  );
                                }
                              }
                            }
                          : null,
                      onCancel: bookings[index].status == BookingStatus.pending
                          ? () async {
                              if (bookings[index].id != null) {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Text('Tolak Booking?'),
                                    content: const Text(
                                      'Apakah Anda yakin ingin menolak booking ini?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Tidak'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child: const Text(
                                          'Ya, Tolak',
                                          style: TextStyle(
                                              color: AppColors.redNormal),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed == true) {
                                  await bookingProvider
                                      .cancelBooking(bookings[index].id!);
                                }
                              }
                            }
                          : null,
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_rounded,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Belum ada pesanan konsultasi',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingManageCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const _BookingManageCard({
    required this.booking,
    this.onConfirm,
    this.onCancel,
  });

  Color _statusColor() {
    switch (booking.status) {
      case BookingStatus.pending:
        return AppColors.secondaryNormal;
      case BookingStatus.confirmed:
        return AppColors.primary;
      case BookingStatus.completed:
        return AppColors.greenNormal;
      case BookingStatus.cancelled:
        return AppColors.redNormal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryLight,
                child: const Icon(Icons.person_outline, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.userNickname ?? 'Mahasiswa UB',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        booking.status.label,
                        style: TextStyle(
                          color: _statusColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(
                icon: Icons.calendar_today_rounded,
                label:
                    '${booking.scheduledAt.day}/${booking.scheduledAt.month}/${booking.scheduledAt.year}',
              ),
              const SizedBox(width: 12),
              _InfoChip(
                icon: Icons.access_time_rounded,
                label:
                    '${booking.scheduledAt.hour.toString().padLeft(2, '0')}:${booking.scheduledAt.minute.toString().padLeft(2, '0')}',
              ),
            ],
          ),
          if (booking.notes != null && booking.notes!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.netralLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Catatan Pasien:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    booking.notes!,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (booking.status == BookingStatus.pending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.redNormal,
                      side: const BorderSide(color: AppColors.redNormal),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Tolak',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Konfirmasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
