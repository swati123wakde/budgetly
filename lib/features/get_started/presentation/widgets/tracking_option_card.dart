import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/tracking_option.dart';

class TrackingOptionCard extends StatelessWidget {
  const TrackingOptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final TrackingOption option;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _icon => switch (option.mode) {
    TrackingMode.spendingOnly => Icons.receipt_long_rounded,
    TrackingMode.spendingAndAccounts => Icons.account_balance_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.matteRedTint : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isSelected ? AppColors.matteRed : AppColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md + 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: AppDurations.medium,
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.matteRed : AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(_icon, color: AppColors.textPrimary, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text(option.title, style: AppTextStyles.titleMedium)),
                          if (option.recommended) ...[
                            const SizedBox(width: AppSpacing.xs),
                            const _Tag(label: 'Popular'),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(option.description, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: option.highlights.map((h) => _Chip(label: h)).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _RadioDot(selected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.fast,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.matteRed : Colors.transparent,
        border: Border.all(color: selected ? AppColors.matteRed : AppColors.borderStrong, width: 1.5),
      ),
      child: selected ? const Icon(Icons.check_rounded, size: 14, color: AppColors.onRed) : null,
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.matteRed),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.matteRedLight)),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
    );
  }
}