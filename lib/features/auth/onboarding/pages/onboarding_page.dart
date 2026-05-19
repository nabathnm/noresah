import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../user/widgets/navigation.dart';
import '../../../../core/utils/constant/app_colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final _nicknameController = TextEditingController();

  int _currentPage = 0;
  String? _selectedProblem;

  final List<String> _problemOptions = [
    'Mengurangi stress',
    'Overthinking',
    'Burnout',
    'Anxiety',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _submit() async {
    if (_nicknameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama panggilan tidak boleh kosong')),
      );
      return;
    }
    if (_selectedProblem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih masalah yang ingin kamu atasi')),
      );
      return;
    }

    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    try {
      await profileProvider.createProfile(
        nickname: _nicknameController.text.trim(),
        problemPreferences: _problemOptions.indexOf(_selectedProblem!) + 1,
        gender: true,
        birthDate: DateTime(2000),
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Navigation()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProfileProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (i) => setState(() => _currentPage = i),
        children: [
          _WelcomePage(onStart: _nextPage),
          _NicknamePage(
            controller: _nicknameController,
            onBack: _prevPage,
            onNext: () {
              if (_nicknameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nama panggilan tidak boleh kosong'),
                  ),
                );
                return;
              }
              _nextPage();
            },
          ),
          _ProblemPage(
            options: _problemOptions,
            selected: _selectedProblem,
            onSelect: (v) => setState(() => _selectedProblem = v),
            onBack: _prevPage,
            onSubmit: isLoading ? null : _submit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Page 1 — Welcome
// ─────────────────────────────────────────
class _WelcomePage extends StatelessWidget {
  final VoidCallback onStart;
  const _WelcomePage({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            // Top progress pill
            const _ProgressPill(filled: 1, total: 3),
            const Spacer(flex: 2),

            // Greeting
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: 'Hi 🌿\n'),
                  TextSpan(text: 'Senang kamu ada di sini.'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Mascot
            _MascotImage(variant: _MascotVariant.wave),

            const SizedBox(height: 32),

            // Subtitle
            const Text(
              'Kami akan menemanimu\nmenjaga kesehatan emosional\nsetiap hari 🌿',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.6,
              ),
            ),

            const Spacer(flex: 3),

            _PrimaryButton(label: 'Mulai Perjalanan', onTap: onStart),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Page 2 — Nickname
// ─────────────────────────────────────────
class _NicknamePage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onNext;
  const _NicknamePage({
    required this.controller,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _ProgressPill(filled: 2, total: 3),
            _BackButton(onTap: onBack),
            const Spacer(flex: 2),

            const Text(
              'Aku boleh memanggil\nkamu siapa?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 28),

            _MascotImage(variant: _MascotVariant.peace),

            const SizedBox(height: 36),

            // Input
            TextField(
              controller: controller,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'nama panggilan',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF3D8BFF)),
                ),
              ),
            ),

            const Spacer(flex: 3),

            _PrimaryButton(label: 'Mulai Perjalanan', onTap: onNext),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Page 3 — Problem Preference
// ─────────────────────────────────────────
class _ProblemPage extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onBack;
  final VoidCallback? onSubmit;
  final bool isLoading;

  const _ProblemPage({
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.onBack,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _ProgressPill(filled: 3, total: 3),
            _BackButton(onTap: onBack),
            const Spacer(flex: 1),

            const Text(
              'Apa yang membuat kamu\nmencoba aplikasi ini?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            _MascotImage(variant: _MascotVariant.search),

            const SizedBox(height: 24),

            // Option list
            ...options.map((opt) {
              final isSelected = selected == opt;
              return GestureDetector(
                onTap: () => onSelect(opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3D8BFF) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3D8BFF)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            }),

            const Spacer(flex: 1),

            _PrimaryButton(
              label: isLoading ? '' : 'Mulai Perjalanan',
              onTap: onSubmit,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Shared Widgets
// ─────────────────────────────────────────

class _ProgressPill extends StatelessWidget {
  final int filled;
  final int total;
  const _ProgressPill({required this.filled, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (i) {
          final active = i < filled;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 28 : 8,
            height: 6,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF3D8BFF) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(99),
            ),
          );
        }),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(top: 8, bottom: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF3D8BFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Widget? child;
  const _PrimaryButton({required this.label, this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 54,
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey.shade300 : const Color(0xFF3D8BFF),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child:
            child ??
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Mascot Placeholder
// ─────────────────────────────────────────
enum _MascotVariant { wave, peace, search }

class _MascotImage extends StatelessWidget {
  final _MascotVariant variant;
  const _MascotImage({required this.variant});

  String get _assetPath {
    switch (variant) {
      case _MascotVariant.wave:
        return 'assets/images/mascot_wave.png';
      case _MascotVariant.peace:
        return 'assets/images/mascot_peace.png';
      case _MascotVariant.search:
        return 'assets/images/mascot_search.png';
    }
  }

  IconData get _fallbackIcon {
    switch (variant) {
      case _MascotVariant.wave:
        return Icons.waving_hand_rounded;
      case _MascotVariant.peace:
        return Icons.sentiment_satisfied_alt_rounded;
      case _MascotVariant.search:
        return Icons.manage_search_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        _assetPath,
        height: 160,
        errorBuilder: (_, __, ___) => Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF4FF),
            shape: BoxShape.circle,
          ),
          child: Icon(_fallbackIcon, size: 60, color: const Color(0xFF3D8BFF)),
        ),
      ),
    );
  }
}
