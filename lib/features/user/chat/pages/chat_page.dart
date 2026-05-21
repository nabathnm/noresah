import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:noresah/core/utils/constant/app_colors.dart';
import 'package:noresah/core/models/distress_classification.dart';
import 'package:noresah/core/providers/classification_provider.dart';
import 'package:noresah/core/providers/chat_provider.dart';
import '../../emergency/pages/emergency_page.dart';
import '../service/chat_service.dart';
import 'chat_history_page.dart';

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
    // Add scroll listener to ChatProvider so it automatically scrolls on updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).addListener(_scrollToBottom);
      _scrollToBottom(); // scroll to bottom on entry if there is existing history
    });
  }

  @override
  void dispose() {
    try {
      Provider.of<ChatProvider>(context, listen: false).removeListener(_scrollToBottom);
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
    final classificationProvider = Provider.of<ClassificationProvider>(context, listen: false);

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
    final messages = chatProvider.messages;
    final isLoading = chatProvider.isLoading;
    final showEmergencyBanner = chatProvider.showEmergencyBanner;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  _HeaderIconButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.pop(context),
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
                  _HeaderIconButton(
                    icon: Icons.history_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChatHistoryPage()),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _HeaderIconButton(
                    icon: Icons.emergency_rounded,
                    onTap: _navigateToEmergency,
                  ),
                ],
              ),
            ),

            // ── Chat area + input ──
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Emergency Banner
                    if (showEmergencyBanner)
                      GestureDetector(
                        onTap: _navigateToEmergency,
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
                              const Icon(
                                Icons.emergency_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
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
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => chatProvider.hideEmergencyBanner(),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Message list
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                        itemCount: messages.length + (isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (isLoading && index == messages.length) {
                            return const Align(
                              alignment: Alignment.centerLeft,
                              child: _TypingIndicator(),
                            );
                          }
                          final message = messages[index];
                          final bool isMe = message['isMe'];
                          return _ChatBubble(
                            message: message['message'],
                            isMe: isMe,
                          );
                        },
                      ),
                    ),

                    // Quick actions
                    SizedBox(
                      height: 48,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        children: [
                          QuickActionChip(
                            label: 'Latihan Napas',
                            icon: Icons.air,
                            onTap: () {
                              _messageController.text =
                                  'Aku ingin melakukan latihan pernapasan.';
                              _sendMessage();
                            },
                          ),
                          QuickActionChip(
                            label: 'Grounding',
                            icon: Icons.self_improvement,
                            onTap: () {
                              _messageController.text =
                                  'Tolong bantu aku dengan teknik grounding.';
                              _sendMessage();
                            },
                          ),
                          QuickActionChip(
                            label: 'Tips Tidur',
                            icon: Icons.bedtime,
                            onTap: () {
                              _messageController.text =
                                  'Berikan aku tips untuk tidur lebih baik.';
                              _sendMessage();
                            },
                          ),
                          QuickActionChip(
                            label: 'Motivasi',
                            icon: Icons.favorite,
                            onTap: () {
                              _messageController.text =
                                  'Aku butuh motivasi hari ini.';
                              _sendMessage();
                            },
                          ),
                          QuickActionChip(
                            label: 'Darurat',
                            icon: Icons.emergency_rounded,
                            onTap: _navigateToEmergency,
                            isEmergency: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Input bar
                    SafeArea(
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
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: TextField(
                                  controller: _messageController,
                                  onSubmitted: (_) => _sendMessage(),
                                  style: const TextStyle(fontSize: 14),
                                  decoration: const InputDecoration(
                                    hintText: 'Ceritakan perasaanmu...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
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
                              onTap: isLoading ? null : _sendMessage,
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

  // ── Sub-widgets ──────────────────────────────────────────────

  class _HeaderIconButton extends StatelessWidget {
    final IconData icon;
    final VoidCallback onTap;

    const _HeaderIconButton({required this.icon, required this.onTap});

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      );
    }
  }

  class _ChatBubble extends StatelessWidget {
    final String message;
    final bool isMe;

    const _ChatBubble({required this.message, required this.isMe});

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              // Avatar ResahAI
              Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 8, top: 2),
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.68,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? AppColors.primary
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isMe ? 20 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 20),
                  ),
                ),
                child: MarkdownBody(
                  data: message,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    strong: TextStyle(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  class _TypingIndicator extends StatefulWidget {
    const _TypingIndicator();

    @override
    State<_TypingIndicator> createState() => _TypingIndicatorState();
  }

  class _TypingIndicatorState extends State<_TypingIndicator>
      with SingleTickerProviderStateMixin {
    late AnimationController _controller;

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900),
      )..repeat();
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      final offset = ((_controller.value * 3 - i) % 1.0).clamp(
                        0.0,
                        1.0,
                      );
                      final opacity = offset < 0.5
                          ? offset * 2
                          : (1.0 - offset) * 2;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.3 + opacity * 0.7),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  class QuickActionChip extends StatelessWidget {
    final String label;
    final IconData icon;
    final VoidCallback? onTap;
    final bool isEmergency;

    const QuickActionChip({
      super.key,
      required this.label,
      required this.icon,
      this.onTap,
      this.isEmergency = false,
    });

    @override
    Widget build(BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(right: 10),
        child: ActionChip(
          backgroundColor: isEmergency
              ? AppColors.redLight
              : AppColors.primaryLight,
          side: BorderSide(
            color: isEmergency
                ? AppColors.redNormal
                : AppColors.primaryLightHover,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          avatar: Icon(
            icon,
            size: 16,
            color: isEmergency
                ? AppColors.redNormal
                : AppColors.primary,
          ),
          label: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isEmergency
                  ? AppColors.redNormal
                  : AppColors.primary,
            ),
          ),
          onPressed: onTap ?? () {},
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    }
  }
