
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Skeleton shown while categories load.
class CategoryListShimmer extends StatelessWidget {
  const CategoryListShimmer({super.key, this.count = 7});

  final int count;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: List.generate(
          count,
              (_) => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                ShimmerBox(width: 44, height: 44, radius: AppRadius.md),
                SizedBox(width: AppSpacing.md),
                ShimmerBox(width: 140, height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
