import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Round avatar with a matte-red ring. Optionally shows a small notification
/// dot (top right) or a level badge (bottom right).
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.size = 48, this.showDot = false, this.level});

  final double size;
  final bool showDot;
  final int? level;

  @override
  Widget build(BuildContext context) {
    final badge = size * 0.32;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceHigh,
              border: Border.all(color: AppColors.matteRed, width: size * 0.045),
            ),
            child: Icon(Icons.person_rounded, size: size * 0.58, color: AppColors.textSecondary),
          ),
          if (showDot)
            Positioned(
              top: size * 0.02,
              right: size * 0.02,
              child: Container(
                width: size * 0.22,
                height: size * 0.22,
                decoration: BoxDecoration(
                  color: AppColors.matteRedLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
              ),
            ),
          if (level != null)
            Positioned(
              right: -badge * 0.1,
              bottom: -badge * 0.1,
              child: Container(
                width: badge,
                height: badge,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.matteRed,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 3),
                ),
                child: Text(
                  '$level',
                  style: AppTextStyles.titleMedium.copyWith(fontSize: badge * 0.42, height: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
