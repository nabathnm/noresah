import 'package:flutter/material.dart';

class PsychologistSchedulePage extends StatelessWidget {
  const PsychologistSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Halaman Jadwal Psikolog',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
