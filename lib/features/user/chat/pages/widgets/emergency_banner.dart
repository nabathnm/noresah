import 'package:flutter/material.dart';
import 'package:noresah/core/utils/constant/app_colors.dart';

class EmergencyBanner extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const EmergencyBanner({
    super.key,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppColors.emergencyGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.emergency_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Butuh bantuan segera?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Hubungi 119 ext 8 atau klik di sini',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(Icons.close, color: Colors.white70, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}