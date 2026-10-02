import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Skeleton shown while tracking options load.
class TrackingOptionShimmer extends StatelessWidget {
  const TrackingOptionShimmer({super.key, this.count = 2});

  final int count;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: List.generate(
          count,
              (_) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md + 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.shimmerBase),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 48, height: 48, radius: AppRadius.md),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 150, height: 16),
                        SizedBox(height: AppSpacing.sm),
                        ShimmerBox(height: 12),
                        SizedBox(height: 6),
                        ShimmerBox(width: 180, height: 12),
                        SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            ShimmerBox(width: 70, height: 22, radius: AppRadius.pill),
                            SizedBox(width: AppSpacing.xs),
                            ShimmerBox(width: 90, height: 22, radius: AppRadius.pill),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  ShimmerBox(width: 22, height: 22, shape: BoxShape.circle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}