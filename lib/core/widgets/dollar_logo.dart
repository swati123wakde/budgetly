import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

/// Brand mark: a "$" inside a matte-red ring. Used on splash and welcome.
class DollarLogo extends StatelessWidget {
  const DollarLogo({super.key, this.size = 96, this.glow = 0});

  final double size;

  /// 0..1 — how strong the soft red glow behind the mark is.
  final double glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: AppColors.matteRed, width: size * 0.035),
        boxShadow: [
          if (glow > 0)
            BoxShadow(
              // color: AppColors.matteRed.withValues(alpha: 0.35 * glow),
              color: AppColors.matteRed.withOpacity(0.35 * glow),
              blurRadius: size * 0.6,
              spreadRadius: size * 0.05,
            ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        r'$',
        style: GoogleFonts.spaceGrotesk(
          fontSize: size * 0.55,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1,
        ),
      ),
    );
  }
}