import 'package:flutter/material.dart';

class PsychologistHomePage extends StatelessWidget {
  const PsychologistHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Halaman Home Psikolog',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
