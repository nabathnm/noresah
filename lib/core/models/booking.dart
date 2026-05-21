/// Model untuk booking konsultasi dengan psikolog.
enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

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
  final String id;
  final String name;
  final String specialist;
  final String experience;
  final double rating;
  final String price;
  final String? imageUrl;
  final bool isAvailable;

  Psychologist({
    required this.id,
    required this.name,
    required this.specialist,
    required this.experience,
    required this.rating,
    required this.price,
    this.imageUrl,
    this.isAvailable = true,
  });

  factory Psychologist.fromJson(Map<String, dynamic> json) {
    return Psychologist(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      specialist: json['specialist'] ?? '',
      experience: json['experience'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      price: json['price'] ?? '',
      imageUrl: json['image_url'],
      isAvailable: json['is_available'] ?? true,
    );
  }
}

class Booking {
  final String? id;
  final String userId;
  final String psychologistId;
  final String psychologistName;
  final DateTime scheduledAt;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;

  Booking({
    this.id,
    required this.userId,
    required this.psychologistId,
    required this.psychologistName,
    required this.scheduledAt,
    this.status = BookingStatus.pending,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'psychologist_id': psychologistId,
        'psychologist_name': psychologistName,
        'scheduled_at': scheduledAt.toIso8601String(),
        'status': status.name,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString(),
      userId: json['user_id'] ?? '',
      psychologistId: json['psychologist_id'] ?? '',
      psychologistName: json['psychologist_name'] ?? '',
      scheduledAt:
          DateTime.tryParse(json['scheduled_at'] ?? '') ?? DateTime.now(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? 'pending'),
        orElse: () => BookingStatus.pending,
      ),
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
