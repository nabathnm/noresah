import 'package:flutter/material.dart';
import 'package:noresah/core/utils/constant/app_colors.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => onSend(),
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Ceritakan perasaanmu...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: isLoading ? null : onSend,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}