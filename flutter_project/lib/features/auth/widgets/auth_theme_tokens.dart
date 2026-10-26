import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class AuthThemeTokens {
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 20,
  );
  static const EdgeInsets panelPadding = EdgeInsets.fromLTRB(20, 20, 20, 18);

  static const BorderRadius panelRadius = BorderRadius.all(Radius.circular(26));
  static const BorderRadius fieldRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(999));

  static const Color glassSurface = Color(0x33111A35);
  static const Color glassField = Color(0x55101A36);
  static const Color fieldBorder = Color(0x557788A8);
  static const Color focusGlow = Color(0x88548CFF);
  static const Color success = Color(0xFF34D399);
  static const Color danger = Color(0xFFFF6B81);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6D4CFF), Color(0xFF3F87FF), Color(0xFF00D4FF)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x332A3558), Color(0x33273A60)],
  );

  static final List<BoxShadow> panelShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 28,
      offset: const Offset(0, 14),
    ),
    BoxShadow(
      color: AppColors.neonBlue.withOpacity(0.18),
      blurRadius: 28,
      spreadRadius: -8,
      offset: const Offset(0, 8),
    ),
  ];

  static TextStyle get displayTitle => GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: 28,
        height: 1.12,
      );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 16,
      );

  static TextStyle get body => GoogleFonts.inter(
        color: AppColors.textSecondary,
        fontSize: 13,
        height: 1.4,
      );

  static TextStyle get label => GoogleFonts.inter(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get buttonText => GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      );

  static bool reducedMotion(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    return (mediaQuery?.disableAnimations ?? false) ||
        (mediaQuery?.accessibleNavigation ?? false);
  }
}
