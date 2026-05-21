import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatBubble extends StatelessWidget {
  final String text;

  const ChatBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: text,

      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(fontSize: 16, color: Colors.black),

        strong: const TextStyle(
          fontSize: 22, // lebih besar
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
