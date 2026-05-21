import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/journal_provider.dart';
import '../../../../core/models/journal_entry.dart';
import '../../../../core/utils/constant/app_colors.dart';
import 'journal_editor_page.dart';

class JournalListPage extends StatefulWidget {
  const JournalListPage({super.key});

  @override
  State<JournalListPage> createState() => _JournalListPageState();
}

class _JournalListPageState extends State<JournalListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JournalProvider>(context, listen: false).fetchJournals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final journalProvider = context.watch<JournalProvider>();
    final journals = journalProvider.journals;

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
          'Jurnal Harian',
          style: TextStyle(
            color: AppColors.textHeading,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JournalEditorPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: journalProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : journals.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => journalProvider.fetchJournals(),
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: journals.length,
                    itemBuilder: (context, index) {
                      return _JournalCard(
                        journal: journals[index],
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  JournalEditorPage(journal: journals[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.book_rounded,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum ada jurnal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textHeading,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai tulis perasaanmu hari ini!',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  final JournalEntry journal;
  final VoidCallback onTap;

  const _JournalCard({required this.journal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        journal.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textHeading,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        journal.dateFormatted,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primary,
                  size: 16,
                ),
              ],
            ),
            if (journal.content.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                journal.contentPreview,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
