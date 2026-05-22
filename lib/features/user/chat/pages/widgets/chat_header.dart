import 'package:flutter/material.dart';
import 'header_icon_button.dart';
import '../chat_history_page.dart';

class ChatHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onEmergency;

  const ChatHeader({
    super.key,
    required this.onBack,
    required this.onEmergency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          HeaderIconButton(
            icon: Icons.chevron_left_rounded,
            onTap: onBack,
          ),
          const Expanded(
            child: Text(
              'UBMentalCareAI',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          HeaderIconButton(
            icon: Icons.history_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatHistoryPage()),
            ),
          ),
          const SizedBox(width: 8),
          HeaderIconButton(
            icon: Icons.emergency_rounded,
            onTap: onEmergency,
          ),
        ],
      ),
    );
  }
}