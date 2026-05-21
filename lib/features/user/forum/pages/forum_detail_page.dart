import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/forum_provider.dart';
import '../../../../core/models/forum_post.dart';
import '../../../../core/utils/constant/app_colors.dart';

class ForumDetailPage extends StatefulWidget {
  final ForumPost post;

  const ForumDetailPage({super.key, required this.post});

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  List<ForumAnswer> _answers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnswers();
  }

  Future<void> _loadAnswers() async {
    if (widget.post.id == null) {
      setState(() => _isLoading = false);
      return;
    }
    final provider = Provider.of<ForumProvider>(context, listen: false);
    final answers = await provider.fetchAnswers(widget.post.id!);
    setState(() {
      _answers = answers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.netralLight,
      appBar: AppBar(
        backgroundColor: AppColors.netralLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textHeading),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Pertanyaan',
          style: TextStyle(
            color: AppColors.textHeading,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(
                          Icons.person_outline,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Anonim',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.post.timeAgo,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.post.title != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.post.title!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.post.content,
                    style: const TextStyle(
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),
                  if (widget.post.category != 'General') ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#${widget.post.category}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.favorite_border,
                          size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text('0', // Likes dihapus dari skema
                          style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(width: 16),
                      const Icon(Icons.psychology_rounded,
                          size: 18, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.post.answerCount} jawaban psikolog',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Answers Section
            Row(
              children: [
                const Icon(Icons.psychology_rounded,
                    color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Jawaban Psikolog',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (_answers.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(Icons.hourglass_empty_rounded,
                        size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada jawaban',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Psikolog akan segera menjawab pertanyaan ini',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...List.generate(_answers.length, (index) {
                final answer = _answers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary,
                            child: const Icon(
                              Icons.psychology_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  answer.psychologistName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  answer.timeAgo,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified,
                                    size: 14, color: AppColors.primary),
                                SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        answer.content,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 24),

            // Info banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.yellowLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.yellowNormal.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 20, color: AppColors.yellowDark),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Hanya psikolog terverifikasi yang dapat menjawab pertanyaan di forum ini.',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
