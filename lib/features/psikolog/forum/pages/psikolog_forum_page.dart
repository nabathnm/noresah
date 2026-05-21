import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/forum_provider.dart';
import '../../../../core/models/forum_post.dart';
import '../../../../core/utils/constant/app_colors.dart';

class PsikologForumPage extends StatefulWidget {
  const PsikologForumPage({super.key});

  @override
  State<PsikologForumPage> createState() => _PsikologForumPageState();
}

class _PsikologForumPageState extends State<PsikologForumPage> {
  List<ForumPost> _unansweredPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPosts());
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    final provider = Provider.of<ForumProvider>(context, listen: false);
    await provider.fetchPosts();
    final unanswered = await provider.fetchUnansweredPosts();
    if (mounted) {
      setState(() {
        _unansweredPosts = unanswered;
        _isLoading = false;
      });
    }
  }

  void _showAnswerDialog(ForumPost post) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
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
                  'Jawab Pertanyaan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading,
                  ),
                ),
                const SizedBox(height: 8),

                // Preview pertanyaan
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.netralLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    post.content,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Tulis jawaban profesional Anda...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: AppColors.netralLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final content = controller.text.trim();
                      if (content.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Jawaban tidak boleh kosong'),
                          ),
                        );
                        return;
                      }

                      final provider =
                          Provider.of<ForumProvider>(ctx, listen: false);
                      final success = await provider.addAnswer(
                        postId: post.id!,
                        content: content,
                        psychologistName: 'Psikolog LKM UB',
                      );

                      if (success && ctx.mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Jawaban berhasil dikirim! ✅'),
                            backgroundColor: AppColors.greenNormal,
                          ),
                        );
                        _loadPosts();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Kirim Jawaban',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
  }

  @override
  Widget build(BuildContext context) {
    final forumProvider = context.watch<ForumProvider>();
    final allPosts = forumProvider.posts;

    return Scaffold(
      backgroundColor: AppColors.netralLight,
      appBar: AppBar(
        backgroundColor: AppColors.netralLight,
        elevation: 0,
        title: const Text(
          'Forum Q&A',
          style: TextStyle(
            color: AppColors.textHeading,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadPosts,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textHeading),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  // Tabs
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      tabs: [
                        Tab(
                          text: 'Belum Dijawab (${_unansweredPosts.length})',
                        ),
                        Tab(text: 'Semua (${allPosts.length})'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: TabBarView(
                      children: [
                        // Unanswered
                        _unansweredPosts.isEmpty
                            ? _buildEmptyState('Semua pertanyaan sudah dijawab! 🎉')
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _unansweredPosts.length,
                                itemBuilder: (context, index) {
                                  return _PostCard(
                                    post: _unansweredPosts[index],
                                    onAnswer: () =>
                                        _showAnswerDialog(_unansweredPosts[index]),
                                  );
                                },
                              ),

                        // All
                        allPosts.isEmpty
                            ? _buildEmptyState('Belum ada pertanyaan')
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: allPosts.length,
                                itemBuilder: (context, index) {
                                  return _PostCard(
                                    post: allPosts[index],
                                    onAnswer: allPosts[index].answerCount == 0
                                        ? () =>
                                            _showAnswerDialog(allPosts[index])
                                        : null,
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final ForumPost post;
  final VoidCallback? onAnswer;

  const _PostCard({required this.post, this.onAnswer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.person_outline, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Anonim',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      post.timeAgo,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: post.answerCount > 0
                      ? AppColors.greenLight
                      : AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  post.answerCount > 0 ? 'Dijawab' : 'Belum dijawab',
                  style: TextStyle(
                    color: post.answerCount > 0
                        ? AppColors.greenNormal
                        : AppColors.secondaryNormal,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            post.content,
            style: const TextStyle(height: 1.5, fontSize: 14),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (onAnswer != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onAnswer,
                icon: const Icon(Icons.reply_rounded, size: 18),
                label: const Text('Jawab Pertanyaan'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
