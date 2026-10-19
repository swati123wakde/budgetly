import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/dollar_logo.dart';

/// Hero for the payday questions: a tilted calendar page with the brand
/// "$" coin resting on it. Built from widgets, no image assets.
class PaydayIllustration extends StatelessWidget {
  const PaydayIllustration({super.key, required this.label});

  /// Short text on the calendar's header strip, e.g. "PAYDAY".
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 170,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 170,
            height: 170,
            decoration: const BoxDecoration(color: AppColors.matteRedTint, shape: BoxShape.circle),
          ),
          Transform.rotate(angle: -0.08, child: _CalendarPage(label: label)),
          const Positioned(right: 4, bottom: 6, child: DollarLogo(size: 62, glow: 0.6)),
        ],
      ),
    );
  }
}

class _CalendarPage extends StatelessWidget {
  const _CalendarPage({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 128,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderStrong),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 24, offset: Offset(0, 12))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 30,
            color: AppColors.matteRed,
            alignment: Alignment.center,
            child: Text(label, style: AppTextStyles.overline.copyWith(color: AppColors.onRed)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: GridView.count(
                crossAxisCount: 5,
                mainAxisSpacing: 7,
                crossAxisSpacing: 7,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(15, (i) {
                  final isPayday = i == 7;
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: isPayday ? AppColors.matteRed : AppColors.surfaceHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
