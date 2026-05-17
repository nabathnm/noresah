import 'package:flutter/material.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> posts = [
      {
        'name': 'Anonymous',
        'time': '2 min ago',
        'mood': '😔 Feeling Tired',
        'content':
            'Lately I feel exhausted from college assignments and overthinking every night.',
        'likes': 24,
        'comments': 8,
      },
      {
        'name': 'Anonymous',
        'time': '12 min ago',
        'mood': '🙂 Trying Better',
        'content':
            'Today I finally went outside for a walk after staying indoors for days.',
        'likes': 41,
        'comments': 14,
      },
      {
        'name': 'Anonymous',
        'time': '1 hour ago',
        'mood': '😄 Small Achievement',
        'content':
            'I managed to sleep before midnight today and honestly it feels refreshing.',
        'likes': 63,
        'comments': 20,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xffF5F7FB),
        elevation: 0,
        title: const Text(
          'Community',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body: Column(
        children: [
          // Community Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff8E9EFF),
                  Color(0xff91EAE4),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Anonymous Safe Space 🌱',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        'Share your feelings safely and support others positively.',
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Category Chips
          SizedBox(
            height: 50,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: const [
                ForumChip(label: 'All'),
                ForumChip(label: 'Stress'),
                ForumChip(label: 'Sleep'),
                ForumChip(label: 'Motivation'),
                ForumChip(label: 'Anxiety'),
                ForumChip(label: 'Self Care'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Forum Posts
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xffDDE7FF),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  post['time'],
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                            child: Text(
                              post['mood'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Content
                      Text(
                        post['content'],
                        style: const TextStyle(
                          height: 1.5,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Actions
                      Row(
                        children: [
                          ActionButton(
                            icon: Icons.favorite_border,
                            label: '${post['likes']}',
                          ),

                          const SizedBox(width: 16),

                          ActionButton(
                            icon: Icons.chat_bubble_outline,
                            label: '${post['comments']}',
                          ),

                          const Spacer(),

                          const Icon(
                            Icons.bookmark_border,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ForumChip extends StatelessWidget {
  final String label;

  const ForumChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Chip(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        label: Text(label),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade700,
        ),

        const SizedBox(width: 6),

        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}