import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/auth/login/pages/login_page.dart';
import '../../../features/auth/onboarding/pages/onboarding_page.dart';
import '../../../features/user/widgets/navigation.dart';
import '../../../features/psikolog/widgets/psikolog_navigation.dart';
import '../../providers/profile_provider.dart';

/// AuthGate decides which screen to show based on auth state + onboarding status.
///
/// Flow:
///   Not authenticated → LoginPage
///   Authenticated + onboarding incomplete → OnboardingPage
///   Authenticated + onboarding complete → Navigation (home)
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isCheckingProfile = true;

  @override
  void initState() {
    super.initState();
    _checkAuthAndProfile();
  }

  Future<void> _checkAuthAndProfile() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      // Not logged in
      if (mounted) {
        setState(() => _isCheckingProfile = false);
      }
      return;
    }

    // Fetch profile to check onboarding status
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    await profileProvider.fetchProfile();

    if (mounted) {
      setState(() => _isCheckingProfile = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    // Show loading while checking profile
    if (_isCheckingProfile && user != null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Not authenticated → Login
    if (user == null) {
      return const LoginPage();
    }

    // Check onboarding status
    final profileProvider = context.watch<ProfileProvider>();

    if (profileProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Route based on role first, especially for psychologist to skip onboarding
    final role = profileProvider.profile?.role ?? 'user';
    if (role == 'psychologist') {
      return const PsikologNavigation();
    }

    if (!profileProvider.isOnboardingCompleted) {
      return const OnboardingPage();
    }

    return const Navigation();
  }
}
