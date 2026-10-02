import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Hero illustration built from widgets (no image assets): two tilted cards
/// behind a balance card, plus a small "saved" chip.
class CardStackIllustration extends StatelessWidget {
  const CardStackIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      height: 230,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -0.16,
            child: const _Card(color: AppColors.surfaceElevated, offset: Offset(-18, -18)),
          ),
          Transform.rotate(
            angle: 0.08,
            child: const _Card(color: AppColors.matteRedDark, offset: Offset(14, -8)),
          ),
          const _BalanceCard(),
          Positioned(
            right: -6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.borderStrong),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.trending_up_rounded, size: 16, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text('+\$240 saved', style: AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.color, required this.offset});

  final Color color;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Container(
        width: 250,
        height: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 150,
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderStrong),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 30, offset: Offset(0, 16))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Monthly budget', style: AppTextStyles.bodySmall),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.matteRed, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(r'$2,480.00', style: AppTextStyles.headlineMedium),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: const LinearProgressIndicator(
              value: 0.62,
              minHeight: 6,
              backgroundColor: AppColors.surfaceHigh,
              color: AppColors.matteRed,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('62% spent · 12 days left', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}