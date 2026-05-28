import 'package:flutter/material.dart';
import 'package:noresah/core/utils/constant/app_colors.dart';

class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  static const List<Map<String, dynamic>> _mockSessions = [
    {
      'id': '1',
      'title': 'Mengatasi Overthinking Kuliah',
      'date': 'Hari ini, 14:20',
      'lastMessage':
          'Terima kasih atas saran teknik grounding-nya, sangat membantu.',
      'level': 'Sedang',
      'messages': [
        {'isMe': true, 'text': 'Halo, aku lagi overthinking soal tugas akhir.'},
        {
          'isMe': false,
          'text':
              'Saya memahami perasaan cemasmu Kak. Overthinking tugas akhir memang melelahkan. Mari kita coba tenang sejenak dan gunakan teknik grounding 5-4-3-2-1.',
        },
        {
          'isMe': true,
          'text':
              'Terima kasih atas saran teknik grounding-nya, sangat membantu.',
        },
      ],
    },
    {
      'id': '2',
      'title': 'Kecemasan Menjelang Ujian UTS',
      'date': 'Kemarin, 09:15',
      'lastMessage': 'Aku akan mencoba bernapas perlahan saat ujian besok.',
      'level': 'Biasa',
      'messages': [
        {'isMe': true, 'text': 'Cemas banget besok mau UTS matematika.'},
        {
          'isMe': false,
          'text':
              'Wajar sekali jika merasa cemas menjelang UTS Kak. Ingat, cemas adalah sinyal tubuh bahwa hal ini penting bagimu. Cobalah menarik napas dalam 4 detik, tahan 4 detik, lalu embuskan 4 detik.',
        },
        {
          'isMe': true,
          'text': 'Aku akan mencoba bernapas perlahan saat ujian besok.',
        },
      ],
    },
    {
      'id': '3',
      'title': 'Burnout Tugas Organisasi',
      'date': '18 Mei 2026',
      'lastMessage': 'Aku akan istirahat dan menolak tugas tambahan sementara.',
      'level': 'Sedang',
      'messages': [
        {
          'isMe': true,
          'text':
              'Aku capek banget dengan tugas kepanitiaan kampus, rasanya burnout.',
        },
        {
          'isMe': false,
          'text':
              'Terima kasih sudah mau jujur tentang rasa lelahmu Kak. Burnout adalah tanda bahwa kamu butuh jeda. Cobalah bicarakan dengan panitia lain untuk delegasi tugas.',
        },
        {
          'isMe': true,
          'text': 'Aku akan istirahat dan menolak tugas tambahan sementara.',
        },
      ],
    },
  ];

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
          'Riwayat Chat AI',
          style: TextStyle(
            color: AppColors.textHeading,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockSessions.length,
        itemBuilder: (context, index) {
          final session = _mockSessions[index];
          return GestureDetector(
            onTap: () => _showSessionDetail(context, session),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                session['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.textHeading,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              session['date'],
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          session['lastMessage'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _getLevelColor(
                              session['level'],
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Kecemasan: ${session['level']}',
                            style: TextStyle(
                              color: _getLevelColor(session['level']),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'kritis':
        return AppColors.redDark;
      case 'tinggi':
        return AppColors.redNormal;
      case 'sedang':
        return AppColors.yellowNormal;
      default:
        return AppColors.greenNormal;
    }
  }

  void _showSessionDetail(BuildContext context, Map<String, dynamic> session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final messages = session['messages'] as List<Map<String, dynamic>>;
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Sheet Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        session['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textHeading,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer to balance close button
                  ],
                ),
              ),
              // Message list in details
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final bool isMe = msg['isMe'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppColors.primary
                                : AppColors.primaryLight,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(isMe ? 18 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 18),
                            ),
                          ),
                          child: Text(
                            msg['text'],
                            style: TextStyle(
                              color: isMe
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
