import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/profile_provider.dart';
import 'features/auth/login/pages/login_page.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: const LoginPage(), // atau cek session auth di sini
      ),
    );
  }
}