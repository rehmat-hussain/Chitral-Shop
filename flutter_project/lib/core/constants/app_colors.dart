import 'package:flutter/material.dart';

class AppColors {
  // Deep Backgrounds
  static const Color backgroundDeep = Color(0xFF070B19);
  static const Color backgroundNavy = Color(0xFF0D142E);
  static const Color surfaceGlass = Color(0x1AFFFFFF);
  static const Color surfaceCard = Color(0xFF131B3A);

  // Futuristic Neon & Gradients
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonBlue = Color(0xFF3B82F6);
  static const Color neonViolet = Color(0xFF8B5CF6);
  static const Color neonPurple = Color(0xFFA855F7);
  static const Color neonEmerald = Color(0xFF10B981);
  static const Color goldAccent = Color(0xFFFBBF24);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [neonCyan, neonBlue, neonViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardBorderGradient = LinearGradient(
    colors: [Color(0x6600F0FF), Color(0x228B5CF6), Color(0x05000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundFlowGradient = LinearGradient(
    colors: [backgroundDeep, backgroundNavy, Color(0xFF151838)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
