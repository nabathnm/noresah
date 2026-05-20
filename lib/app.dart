import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/profile_provider.dart';
import 'core/providers/classification_provider.dart';
import 'core/providers/forum_provider.dart';
import 'core/providers/booking_provider.dart';
import 'features/auth/login/pages/login_page.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ClassificationProvider()),
        ChangeNotifierProvider(create: (_) => ForumProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UBMentalCare',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3D8BFF),
          ),
          fontFamily: 'Roboto',
        ),
        home: const LoginPage(), // atau cek session auth di sini
      ),
    );
  }
}