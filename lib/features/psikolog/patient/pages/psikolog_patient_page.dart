import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/booking_provider.dart';
import '../../../../core/models/profile_model.dart';
import '../../../../core/models/distress_classification.dart';
import '../../../../core/utils/constant/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class PsikologPatientPage extends StatefulWidget {
  const PsikologPatientPage({super.key});

  @override
  State<PsikologPatientPage> createState() => _PsikologPatientPageState();
}

class _PsikologPatientPageState extends State<PsikologPatientPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      provider.fetchPsychologistPatients();
      provider.fetchAllCriticalPatients();
    });
  }

  Color _getLevelColor(DistressLevel level) {
    switch (level) {
      case DistressLevel.aman:
        return AppColors.greenNormal;
      case DistressLevel.waspada:
        return AppColors.yellowNormal;
      case DistressLevel.khawatir:
        return AppColors.redNormal;
      case DistressLevel.kritis:
        return AppColors.redDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final patients = provider.psychologistPatients;
    final criticalPatients = provider.allCriticalPatients;

    return Scaffold(
      backgroundColor: AppColors.netralLight,
      appBar: AppBar(
        backgroundColor: AppColors.netralLight,
        elevation: 0,
        title: const Text(
          'Daftar Pasien',
          style: TextStyle(
            color: AppColors.textHeading,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: provider.isLoading && patients.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await provider.fetchPsychologistPatients();
                await provider.fetchAllCriticalPatients();
              },
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (criticalPatients.isNotEmpty) ...[
                      const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.redNormal,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Perhatian Khusus',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textHeading,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...criticalPatients.map((p) => _buildPatientCard(p)),
                      const SizedBox(height: 24),
                    ],

                    const Text(
                      'Semua Pasien',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHeading,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (patients.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada pasien',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...patients.map((p) => _buildPatientCard(p)),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPatientCard(ProfileModel patient) {
    DistressLevel moodLevel = DistressLevelExtension.fromMoodScore(patient.moodScore);
    DistressLevel finalLevel = moodLevel;
    
    if (patient.aiDistressLevel != null) {
      DistressLevel aiLevel;
      switch (patient.aiDistressLevel) {
        case 1:
          aiLevel = DistressLevel.aman;
          break;
        case 2:
          aiLevel = DistressLevel.waspada;
          break;
        case 3:
          aiLevel = DistressLevel.khawatir;
          break;
        case 4:
          aiLevel = DistressLevel.kritis;
          break;
        default:
          aiLevel = DistressLevel.aman;
      }
      if (aiLevel.numericValue > moodLevel.numericValue) {
        finalLevel = aiLevel;
      }
    }
    
    final color = _getLevelColor(finalLevel);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(finalLevel.emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.nickname ?? 'Mahasiswa',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textHeading,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mood Score: ${patient.moodScore}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  finalLevel.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (finalLevel.numericValue >= 3) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final message = Uri.encodeComponent(
                      'Halo ${patient.nickname}, saya psikolog dari UBMentalCare. Saya melihat kondisi Anda sedang membutuhkan perhatian. Ada yang bisa saya bantu?',
                    );
                    final url = Uri.parse(
                      'https://wa.me/6285888121200?text=$message',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greenNormal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Hubungi WA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
