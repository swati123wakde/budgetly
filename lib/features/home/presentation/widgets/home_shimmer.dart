import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Skeleton that mirrors the loaded home layout.
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(height: 170, radius: AppRadius.lg),
          const SizedBox(height: AppSpacing.lg),
          const ShimmerBox(width: 140, height: 18),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(
            4,
                (_) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  ShimmerBox(width: 44, height: 44, radius: AppRadius.md),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 120, height: 14),
                        SizedBox(height: 6),
                        ShimmerBox(width: 70, height: 12),
                      ],
                    ),
                  ),
                  ShimmerBox(width: 60, height: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}