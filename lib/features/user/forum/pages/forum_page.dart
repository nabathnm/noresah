import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/forum_provider.dart';
import '../../../../core/models/forum_post.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ForumProvider>(context, listen: false);
      provider.fetchPosts();
    });
  }

  void _showCreatePostDialog() {
    final contentController = TextEditingController();
    String selectedMood = '🙂 Berusaha Lebih Baik';
    String selectedCategory = 'General';

    final moods = [
      '😔 Merasa Lelah',
      '🙂 Berusaha Lebih Baik',
      '😄 Pencapaian Kecil',
      '😐 Biasa Saja',
      '😢 Merasa Sedih',
      '💪 Merasa Kuat',
    ];

    final categories = ['General', 'Stress', 'Sleep', 'Motivation', 'Anxiety', 'Self Care'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Bagikan Perasaanmu 🌱',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Semua postingan bersifat anonim dan aman.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Mood selector
                    const Text(
                      'Bagaimana perasaanmu?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: moods.length,
                        itemBuilder: (context, index) {
                          final mood = moods[index];
                          final isSelected = selectedMood == mood;
                          return GestureDetector(
                            onTap: () =>
                                setModalState(() => selectedMood = mood),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF3D8BFF)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                mood,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category selector
                    const Text(
                      'Kategori',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = selectedCategory == cat;
                          return GestureDetector(
                            onTap: () =>
                                setModalState(() => selectedCategory = cat),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF3D8BFF)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Content input
                    TextField(
                      controller: contentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            'Ceritakan perasaanmu tanpa menyebutkan informasi pribadi...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // PII warning
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFF9E6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 16,
                            color: Color(0xffF2C94C),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Jangan cantumkan nama, email, atau nomor telepon.',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final content = contentController.text.trim();
                          if (content.isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text('Tuliskan perasaanmu terlebih dahulu'),
                              ),
                            );
                            return;
                          }

                          final forum =
                              Provider.of<ForumProvider>(ctx, listen: false);

                          // Cek PII
                          final emailRegex = RegExp(
                              r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
                          final phoneRegex = RegExp(r'(\+62|62|0)\d{9,12}');
                          if (emailRegex.hasMatch(content) ||
                              phoneRegex.hasMatch(content)) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    '⚠️ Jangan cantumkan informasi pribadi!'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          final success = await forum.createPost(
                            content: content,
                            mood: selectedMood,
                            category: selectedCategory,
                          );

                          if (success && ctx.mounted) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Postingan berhasil dibuat! 🌱'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D8BFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Bagikan Secara Anonim',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final forumProvider = context.watch<ForumProvider>();
    final posts = forumProvider.posts;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xffF5F7FB),
        elevation: 0,
        title: const Text(
          'Komunitas Anonim',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => forumProvider.fetchPosts(),
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3D8BFF),
        onPressed: _showCreatePostDialog,
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
                        'Ruang Aman Anonim 🌱',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        'Bagikan perasaanmu dengan aman dan dukung sesama secara positif.',
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: forumProvider.categories.length,
              itemBuilder: (context, index) {
                final cat = forumProvider.categories[index];
                final isSelected = forumProvider.selectedCategory == cat;
                return GestureDetector(
                  onTap: () => forumProvider.setCategory(cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Chip(
                      backgroundColor:
                          isSelected ? const Color(0xFF3D8BFF) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Forum Posts
          Expanded(
            child: forumProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : posts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.forum_outlined,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada postingan',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Jadilah yang pertama berbagi!',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => forumProvider.fetchPosts(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return _ForumPostCard(post: posts[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _ForumPostCard extends StatelessWidget {
  final ForumPost post;

  const _ForumPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Anonim',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.timeAgo,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              if (post.mood != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    post.mood!,
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
            post.content,
            style: const TextStyle(
              height: 1.5,
              fontSize: 15,
            ),
          ),

          if (post.category != 'General') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF4FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '#${post.category}',
                style: const TextStyle(
                  color: Color(0xFF3D8BFF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (post.id != null) {
                    Provider.of<ForumProvider>(context, listen: false)
                        .toggleLike(post.id!);
                  }
                },
                child: _ActionButton(
                  icon: Icons.favorite_border,
                  label: '${post.likes}',
                ),
              ),

              const SizedBox(width: 16),

              _ActionButton(
                icon: Icons.chat_bubble_outline,
                label: '${post.comments}',
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
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({
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