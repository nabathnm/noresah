import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noresah/core/utils/constant/app_colors.dart';
import 'package:noresah/core/providers/classification_provider.dart';
import 'package:noresah/core/providers/chat_provider.dart';
import 'emergency_page.dart';
import 'widgets/chat_header.dart';
import 'widgets/emergency_banner.dart';
import 'widgets/chat_message_list.dart';
import 'widgets/chat_input_bar.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false)
          .addListener(_scrollToBottom);
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    try {
      Provider.of<ChatProvider>(context, listen: false)
          .removeListener(_scrollToBottom);
    } catch (_) {}
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final classificationProvider =
        Provider.of<ClassificationProvider>(context, listen: false);

    _messageController.clear();
    await chatProvider.sendMessage(message, classificationProvider);
  }

  void _navigateToEmergency() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EmergencyPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ChatHeader(
              onBack: () => Navigator.pop(context),
              onEmergency: _navigateToEmergency,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    if (chatProvider.showEmergencyBanner)
                      EmergencyBanner(
                        onTap: _navigateToEmergency,
                        onDismiss: chatProvider.hideEmergencyBanner,
                      ),
                    Expanded(
                      child: ChatMessageList(
                        scrollController: _scrollController,
                        messages: chatProvider.messages,
                        isLoading: chatProvider.isLoading,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ChatInputBar(
                      controller: _messageController,
                      isLoading: chatProvider.isLoading,
                      onSend: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}