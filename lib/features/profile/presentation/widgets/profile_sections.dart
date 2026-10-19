import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/profile_summary.dart';

/// "Upgrade to Pro" banner — display only for now.
class UpgradeCard extends StatelessWidget {
  const UpgradeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.matteRedTint,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.diamond_rounded, color: AppColors.matteRedLight),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(AppStrings.upgradeToPro, style: AppTextStyles.titleMedium)),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

/// "Level 1 · Starter", XP bar and next level.
class LevelProgress extends StatelessWidget {
  const LevelProgress({super.key, required this.summary});

  final ProfileSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              AppStrings.levelLabel(summary.level, summary.levelName),
              style: AppTextStyles.titleMedium,
            ),
            const Spacer(),
            Text(AppStrings.viewJourney, style: AppTextStyles.label),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: summary.levelProgress),
            duration: AppDurations.slow,
            curve: Curves.easeOutCubic,
            builder: (_, value, __) => LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: AppColors.surfaceHigh,
              color: AppColors.matteRed,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Text('${summary.xp} / ${summary.levelEndXp} XP', style: AppTextStyles.bodySmall),
            const Spacer(),
            if (summary.nextLevelName != null)
              Text(
                AppStrings.levelLabel(summary.level + 1, summary.nextLevelName!),
                style: AppTextStyles.bodySmall,
              ),
          ],
        ),
      ],
    );
  }
}

/// "Log a transaction on 3 separate days" with progress dots.
class WeeklyBonusCard extends StatelessWidget {
  const WeeklyBonusCard({super.key, required this.summary});

  final ProfileSummary summary;

  String get _status {
    if (summary.weeklyBonusComplete) return AppStrings.bonusComplete;
    if (summary.weeklyDaysLogged > 0) return AppStrings.bonusInProgress;
    return AppStrings.bonusNotStarted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md + 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(AppStrings.weeklyBonus, style: AppTextStyles.titleMedium),
              const Spacer(),
              Text(
                _status,
                style: AppTextStyles.label.copyWith(
                  color: summary.weeklyBonusComplete ? AppColors.success : AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.daysLeftThisWeek(summary.daysLeftInWeek), style: AppTextStyles.bodySmall),
          const SizedBox(height: AppSpacing.xxs),
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.weeklyBonusGoal(ProfileSummary.weeklyTarget),
                  style: AppTextStyles.bodyLarge,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              for (var i = 0; i < ProfileSummary.weeklyTarget; i++)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < summary.weeklyDaysLogged ? AppColors.matteRed : AppColors.surfaceHigh,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.weeklyBonusReward(ProfileSummary.weeklyBonusXp),
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Current daily streak.
class StreakCard extends StatelessWidget {
  const StreakCard({super.key, required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final active = days > 0;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 36,
            color: active ? AppColors.matteRedLight : AppColors.textMuted,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  active ? AppStrings.streakDays(days) : AppStrings.noStreak,
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  active ? AppStrings.streakKeepGoing : AppStrings.streakStart,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
