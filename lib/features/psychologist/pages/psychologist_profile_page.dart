import 'package:flutter/material.dart';

class PsychologistProfilePage extends StatelessWidget {
  const PsychologistProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Halaman Profil Psikolog',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
