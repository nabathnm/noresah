import 'package:flutter/material.dart';

class AppColors {
  // ── Brand Colors (sesuai skill file) ──
  static const Color primary = Color(0xFF273383);
  static const Color secondary = Color(0xFFFA6400);

  // ── Primary Variants ──
  static const Color primaryLight = Color(0xFFE8EAF6);
  static const Color primaryLightHover = Color(0xFFC5CAE9);
  static const Color primaryLightActive = Color(0xFF9FA8DA);
  static const Color primaryNormal = Color(0xFF273383);
  static const Color primaryNormalHover = Color(0xFF1F2A6B);
  static const Color primaryNormalActive = Color(0xFF273383);
  static const Color primaryDark = Color(0xFF1D2762);
  static const Color primaryDarkHover = Color(0xFF161E4E);
  static const Color primaryDarkActive = Color(0xFF10163B);
  static const Color primaryDarker = Color(0xFF0C112E);

  // ── Secondary Variants ──
  static const Color secondaryLight = Color(0xFFFFF3E0);
  static const Color secondaryLightHover = Color(0xFFFFE0B2);
  static const Color secondaryLightActive = Color(0xFFFFCC80);
  static const Color secondaryNormal = Color(0xFFFA6400);
  static const Color secondaryNormalHover = Color(0xFFE05A00);
  static const Color secondaryNormalActive = Color(0xFFC85000);
  static const Color secondaryDark = Color(0xFFBD4B00);
  static const Color secondaryDarkHover = Color(0xFF973C00);
  static const Color secondaryDarkActive = Color(0xFF712D00);
  static const Color secondaryDarker = Color(0xFF582300);

  // ── Navigation ──
  static const Color navigationNormal = Color(0xFFACB5CC);
  static const Color navigationActive = Color(0xFF273383);

  // ── Base Colors ──
  static const Color baseWhite = Colors.white;
  static const Color baseBlack = Colors.black;
  static const Color baseBackground = Color(0xFFF5F5F5);

  // ── Netral (sesuai skill file) ──
  static const Color netralDark = Color(0xFF1B263B);
  static const Color netralWhite = Color(0xFFFFFFFF);
  static const Color netralLight = Color(0xFFF5F5F5);

  // ── Text Colors ──
  static const Color textHeading = Color(0xFF1B263B);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF515151);
  static const Color textWhite = Colors.white;
  static const Color textHint = Color(0xFF9E9E9E);

  // ── Neutral ──
  static const Color neutralLight = Color(0xFFFDFDFD);
  static const Color neutralLightHover = Color(0xFFFBFBFB);
  static const Color neutralLightActive = Color(0xFFF7F7F7);
  static const Color neutralNormal = Color(0xFFE6E6E6);
  static const Color neutralNormalHover = Color(0xFFCFCFCF);
  static const Color neutralNormalActive = Color(0xFFB8B8B8);
  static const Color neutralDark = Color(0xFFADADAD);
  static const Color neutralDarkHover = Color(0xFF8A8A8A);
  static const Color neutralDarkActive = Color(0xFF676767);
  static const Color neutralDarker = Color(0xFF515151);

  // ── Green (Success) ──
  static const Color greenLight = Color(0xFFEAF2EF);
  static const Color greenNormal = Color(0xFF2E7D5B);
  static const Color greenDark = Color(0xFF235E44);

  // ── Yellow (Warning) ──
  static const Color yellowLight = Color(0xFFFFF9E6);
  static const Color yellowNormal = Color(0xFFF2C94C);
  static const Color yellowDark = Color(0xFFB69739);

  // ── Red (Danger/Emergency) ──
  static const Color redLight = Color(0xFFFFEBEB);
  static const Color redNormal = Color(0xFFFF6B6B);
  static const Color redDark = Color(0xFFC84545);

  // ── Gradient Presets ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF273383), Color(0xFF3D4FA7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFFA6400), Color(0xFFFF8A3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF273383), Color(0xFF3D4FA7), Color(0xFF5C6BC0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
