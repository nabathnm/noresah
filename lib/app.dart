import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/profile_provider.dart';
import 'features/auth/onboarding/providers/onboarding_provider.dart';
import 'core/utils/widgets/auth_gate.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Noresah',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const AuthGate(),
      ),
    );
  }
}