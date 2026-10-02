import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography scale. Display text uses Space Grotesk (geometric, a little
/// technical — fits a money app); body text uses Inter for readability.
abstract final class AppTextStyles {
  static TextStyle get _display => GoogleFonts.spaceGrotesk(color: AppColors.textPrimary);
  static TextStyle get _body => GoogleFonts.inter(color: AppColors.textPrimary);

  static TextStyle get displayLarge =>
      _display.copyWith(fontSize: 40, fontWeight: FontWeight.w700, height: 1.05, letterSpacing: -1.2);
  static TextStyle get headlineLarge =>
      _display.copyWith(fontSize: 30, fontWeight: FontWeight.w700, height: 1.15, letterSpacing: -0.6);
  static TextStyle get headlineMedium =>
      _display.copyWith(fontSize: 24, fontWeight: FontWeight.w600, height: 1.2, letterSpacing: -0.4);
  static TextStyle get titleLarge => _body.copyWith(fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle get titleMedium => _body.copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  static TextStyle get bodyLarge => _body.copyWith(fontSize: 16, height: 1.5);
  static TextStyle get bodyMedium =>
      _body.copyWith(fontSize: 14, height: 1.45, color: AppColors.textSecondary);
  static TextStyle get bodySmall =>
      _body.copyWith(fontSize: 12, height: 1.4, color: AppColors.textMuted);
  static TextStyle get label =>
      _body.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary);
  static TextStyle get button =>
      _body.copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.2);
  static TextStyle get overline => _body.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 2,
    color: AppColors.matteRedLight,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: button,
    labelMedium: label,
  );
}