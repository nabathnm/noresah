import 'package:flutter/material.dart';
import 'chat_bubble.dart';
import 'typing_indicator.dart';

class ChatMessageList extends StatelessWidget {
  final ScrollController scrollController;
  final List<Map<String, dynamic>> messages;
  final bool isLoading;

  const ChatMessageList({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (isLoading && index == messages.length) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: TypingIndicator(),
          );
        }
        final message = messages[index];
        return ChatBubble(
          message: message['message'],
          isMe: message['isMe'],
        );
      },
    );
  }
}