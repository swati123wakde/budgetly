import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'app_back_button.dart';

/// Onboarding header: back button, "STEP x OF y" overline and a thin progress bar.
class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.step,
    required this.totalSteps,
    this.showBack = true,
    this.trailing,
  });

  final int step;
  final int totalSteps;
  final bool showBack;

  /// Optional action on the far right, e.g. a "Skip" button.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          if (showBack) const AppBackButton(),
          const Spacer(),
          Text('STEP $step OF $totalSteps', style: AppTextStyles.overline),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 56,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: (step - 1) / totalSteps, end: step / totalSteps),
                duration: AppDurations.slow,
                curve: Curves.easeOutCubic,
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value,
                  minHeight: 4,
                  backgroundColor: AppColors.surfaceHigh,
                  color: AppColors.matteRed,
                ),
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.xs),
            trailing!,
          ],
        ],
      ),
    );
  }
}
