import 'package:flutter/material.dart';

/// Single source of truth for every colour in the app.
/// Palette: near-black surfaces + a muted, matte red used sparingly as accent.
abstract final class AppColors {
  // Backgrounds & surfaces (darkest -> lightest)
  static const Color background = Color(0xFF0B0B0C);
  static const Color surface = Color(0xFF141416);
  static const Color surfaceElevated = Color(0xFF1C1C1F);
  static const Color surfaceHigh = Color(0xFF242428);
  static const Color border = Color(0xFF2A2A2E);
  static const Color borderStrong = Color(0xFF3A3A3F);

  // Matte red accent (low saturation, no neon)
  static const Color matteRed = Color(0xFFA8323A);
  static const Color matteRedDark = Color(0xFF7A2329);
  static const Color matteRedLight = Color(0xFFC24D54);
  static const Color matteRedTint = Color(0x1FA8323A); // ~12% red wash

  // Text
  static const Color textPrimary = Color(0xFFF2F2F3);
  static const Color textSecondary = Color(0xFF9A9AA1);
  static const Color textMuted = Color(0xFF5E5E65);
  static const Color onRed = Color(0xFFFFFFFF);

  // Feedback
  static const Color error = Color(0xFFD9534F);
  static const Color success = Color(0xFF4CAF7A);

  // Shimmer
  static const Color shimmerBase = Color(0xFF1A1A1D);
  static const Color shimmerHighlight = Color(0xFF2C2C31);
}