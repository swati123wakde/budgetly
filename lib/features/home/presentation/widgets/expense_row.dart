import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../budget_setup/domain/entities/transaction_category.dart';
import '../../../budget_setup/presentation/widgets/category_icon.dart';

/// Category icon, name (+ optional subtitle) and amount, separated by dividers
/// in a list. Used on home (per category) and in "All expenses" (per item).
class ExpenseRow extends StatelessWidget {
  const ExpenseRow({
    super.key,
    required this.category,
    required this.amount,
    this.subtitle,
  });

  final TransactionCategory category;
  final double amount;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
      child: Row(
        children: [
          CategoryIcon(category: category),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name, style: AppTextStyles.titleMedium),
                if (subtitle != null) Text(subtitle!, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(CurrencyFormatter.format(amount), style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}
