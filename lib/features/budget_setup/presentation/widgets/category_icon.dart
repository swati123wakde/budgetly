import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../domain/entities/transaction_category.dart';

/// Rounded-square icon tile for a category. Turns matte red when selected.
class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    super.key,
    required this.category,
    this.selected = false,
    this.size = 44,
  });

  final TransactionCategory category;
  final bool selected;
  final double size;

  static IconData iconFor(String key) => switch (key) {
    'dining' => Icons.restaurant_rounded,
    'entertainment' => Icons.confirmation_number_rounded,
    'groceries' => Icons.shopping_basket_rounded,
    'healthcare' => Icons.monitor_heart_rounded,
    'housing' => Icons.home_rounded,
    'transport' => Icons.directions_car_rounded,
    'utilities' => Icons.receipt_long_rounded,
    _ => Icons.sell_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.fast,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selected ? AppColors.matteRed : AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(
        iconFor(category.iconKey),
        size: size * 0.48,
        color: selected ? AppColors.onRed : AppColors.textSecondary,
      ),
    );
  }
}
