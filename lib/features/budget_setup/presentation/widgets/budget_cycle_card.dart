import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/budget_cycle.dart';

/// One option on the "How would you like to budget?" screen.
class BudgetCycleCard extends StatelessWidget {
  const BudgetCycleCard({
    super.key,
    required this.cycle,
    required this.isSelected,
    required this.onTap,
  });

  final BudgetCycle cycle;
  final bool isSelected;
  final VoidCallback? onTap;

  IconData get _icon => switch (cycle) {
    BudgetCycle.monthly => Icons.calendar_month_rounded,
    BudgetCycle.fortnightly => Icons.date_range_rounded,
    BudgetCycle.weekly => Icons.view_week_rounded,
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
                      Text(cycle.label, style: AppTextStyles.titleMedium),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(cycle.description, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isSelected ? AppColors.matteRedLight : AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
