import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import 'app_back_button.dart';

/// Onboarding header: back button, centred step dashes, optional trailing action.
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Semantics(
            label: 'Step $step of $totalSteps',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 1; i <= totalSteps; i++) ...[
                  if (i > 1) const SizedBox(width: 6),
                  AnimatedContainer(
                    duration: AppDurations.medium,
                    curve: Curves.easeOutCubic,
                    width: i == step ? 34 : 18,
                    height: 4,
                    decoration: BoxDecoration(
                      color: i == step
                          ? AppColors.matteRed
                          : i < step
                          ? AppColors.matteRedDark
                          : AppColors.surfaceHigh,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showBack) const Align(alignment: Alignment.centerLeft, child: AppBackButton()),
          if (trailing != null) Align(alignment: Alignment.centerRight, child: trailing),
        ],
      ),
    );
  }
}
