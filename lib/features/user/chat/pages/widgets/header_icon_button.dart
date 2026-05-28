import 'package:flutter/material.dart';



  class HeaderIconButton extends StatelessWidget {
    final IconData icon;
    final VoidCallback onTap;

    const HeaderIconButton({required this.icon, required this.onTap});

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      );
    }
  }