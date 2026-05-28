/// Model untuk booking konsultasi dengan psikolog.
enum BookingStatus { pending, confirmed, completed, cancelled }

extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Menunggu';
      case BookingStatus.confirmed:
        return 'Dikonfirmasi';
      case BookingStatus.completed:
        return 'Selesai';
      case BookingStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}

class Psychologist {
  final int id;
  final String name;
  final String experience;
  final double rating;
  final String? imageUrl;
  final bool isAvailable;
  final String? bio;

  Psychologist({
    required this.id,
    required this.name,
    required this.experience,
    required this.rating,
    this.imageUrl,
    this.isAvailable = true,
    this.bio,
  });

  factory Psychologist.fromJson(Map<String, dynamic> json) {
    final profiles = json['profiles'] as Map<String, dynamic>?;
    final name = profiles?['nickname'] ?? json['name'] ?? '';
    return Psychologist(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: name,
      experience: json['experience'] ?? '5 Tahun Pengalaman',
      rating: (json['rating'] ?? 4.8).toDouble(),
      imageUrl: json['image_url'],
      isAvailable: json['is_available'] ?? true,
      bio: json['bio'],
    );
  }
}

class Booking {
  final int? id;
  final String userId;
  final int psychologistId;
  final String psychologistName;
  final String? userNickname;
  final String? userEmail;
  final DateTime scheduledAt;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;

  Booking({
    this.id,
    required this.userId,
    required this.psychologistId,
    required this.psychologistName,
    this.userEmail,
    this.userNickname,
    required this.scheduledAt,
    this.status = BookingStatus.pending,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    final dateStr =
        '${scheduledAt.year}-${scheduledAt.month.toString().padLeft(2, '0')}-${scheduledAt.day.toString().padLeft(2, '0')}';
    final startTimeStr =
        '${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}:00';
    final endTime = scheduledAt.add(const Duration(hours: 1));
    final endTimeStr =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}:00';

    return {
      'user_id': userId,
      'psychologist_id': psychologistId,
      'booking_date': dateStr,
      'start_time': startTimeStr,
      'end_time': endTimeStr,
      'status': status.name,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    // 1. Resolve psychologist name from nested join:
    // psychologist_profiles -> profiles -> nickname
    final psychoProfile =
        json['psychologist_profiles'] as Map<String, dynamic>?;
    final psychoInnerProfile =
        psychoProfile?['profiles'] as Map<String, dynamic>?;
    final resolvedPsychologistName =
        psychoInnerProfile?['nickname'] ??
        json['psychologist_name'] ??
        'Psikolog';

    // 2. Resolve user/student nickname from join:
    // profiles -> nickname
    final userProfile = json['profiles'] as Map<String, dynamic>?;
    final resolvedUserNickname = userProfile?['nickname'] ?? 'Mahasiswa UB';

    // 3. Resolve scheduledAt from booking_date and start_time
    DateTime scheduledVal = DateTime.now();
    if (json['booking_date'] != null && json['start_time'] != null) {
      final dateStr = json['booking_date'] as String;
      final timeStr = json['start_time'] as String;
      scheduledVal = DateTime.tryParse('${dateStr}T$timeStr') ?? DateTime.now();
    } else if (json['scheduled_at'] != null) {
      scheduledVal =
          DateTime.tryParse(json['scheduled_at'] as String) ?? DateTime.now();
    }

    return Booking(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      userId: json['user_id'] ?? '',
      psychologistId: json['psychologist_id'] is int
          ? json['psychologist_id']
          : int.tryParse(json['psychologist_id']?.toString() ?? '') ?? 0,
      psychologistName: resolvedPsychologistName,
      userNickname: resolvedUserNickname,
      scheduledAt: scheduledVal,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? 'pending'),
        orElse: () => BookingStatus.pending,
      ),
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
