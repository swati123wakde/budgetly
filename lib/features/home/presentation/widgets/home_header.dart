
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/profile_avatar.dart';

/// Avatar (→ profile), period title + range with a dropdown arrow (→ calendar),
/// and a pill of quick actions on the right (not wired up yet).
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.title,
    required this.rangeText,
    required this.onAvatarTap,
    required this.onRangeTap,
  });

  final String title;
  final String rangeText;
  final VoidCallback onAvatarTap;
  final VoidCallback onRangeTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Semantics(
          button: true,
          label: 'Open profile',
          child: GestureDetector(
            onTap: onAvatarTap,
            child: const ProfileAvatar(size: 52, showDot: true),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: InkWell(
            onTap: onRangeTap,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs, vertical: AppSpacing.xxs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          rangeText,
                          style: AppTextStyles.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        const _QuickActions(),
      ],
    );
  }
}

/// Placeholder actions — shown for now, not tappable yet.
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(color: AppColors.surfaceHigh, shape: BoxShape.circle),
            child: const Icon(Icons.sync_rounded, size: 20, color: AppColors.matteRedLight),
          ),
          const SizedBox(width: AppSpacing.xxs),
          const SizedBox(
            width: 30,
            height: 38,
            child: Icon(Icons.more_vert_rounded, size: 20, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
