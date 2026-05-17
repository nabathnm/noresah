import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {
        'isMe': false,
        'message':
            'Hi 👋 I’m your emotional support assistant. How are you feeling today?',
      },
      {
        'isMe': true,
        'message':
            'I feel overwhelmed lately because of assignments and lack of sleep.',
      },
      {
        'isMe': false,
        'message':
            'That sounds exhausting. Your recent sleep pattern also decreased this week. Maybe we can start with a short breathing exercise.',
      },
      {
        'isMe': true,
        'message': 'Okay, I think I need that.',
      },
      {
        'isMe': false,
        'message':
            'Great 🌱 Try inhaling slowly for 4 seconds, hold for 4 seconds, then exhale for 6 seconds.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xffF5F7FB),
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xffDDE7FF),
              child: Icon(
                Icons.psychology,
                color: Colors.black,
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MindCare AI',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'Active now',
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // AI Insight Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff8E9EFF),
                  Color(0xff91EAE4),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'AI detected increased stress and reduced sleep quality this week.',
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final bool isMe = message['isMe'];

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.black
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      message['message'],
                      style: TextStyle(
                        color:
                            isMe ? Colors.white : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick Actions
          SizedBox(
            height: 50,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                QuickActionChip(
                  label: 'Breathing',
                  icon: Icons.air,
                ),
                QuickActionChip(
                  label: 'Meditation',
                  icon: Icons.self_improvement,
                ),
                QuickActionChip(
                  label: 'Sleep Tips',
                  icon: Icons.bedtime,
                ),
                QuickActionChip(
                  label: 'Motivation',
                  icon: Icons.favorite,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Input Field
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Talk about your feelings...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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

  const QuickActionChip({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Chip(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        avatar: Icon(
          icon,
          size: 18,
        ),
        label: Text(label),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}