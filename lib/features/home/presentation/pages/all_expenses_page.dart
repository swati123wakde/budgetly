import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/date_span.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';
import '../widgets/expense_row.dart';

/// Route arguments for [AllExpensesPage].
class AllExpensesArgs {
  const AllExpensesArgs({required this.title, required this.period, required this.expenses});

  final String title;
  final DateSpan period;

  /// Newest first.
  final List<NewTransaction> expenses;
}

/// Every expense in the period shown on home, grouped by day.
class AllExpensesPage extends StatelessWidget {
  const AllExpensesPage({super.key, required this.args});

  final AllExpensesArgs args;

  @override
  Widget build(BuildContext context) {
    final total = args.expenses.fold<double>(0, (sum, t) => sum + t.amount);

    // Group consecutive items by calendar day (list is already newest first).
    final groups = <DateTime, List<NewTransaction>>{};
    for (final t in args.expenses) {
      groups.putIfAbsent(dateOnly(t.date), () => []).add(t);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.allExpenses, style: AppTextStyles.titleLarge),
                        Text(
                          '${args.title} · ${DateFormatter.span(args.period)}',
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _TotalBar(total: total, count: args.expenses.length),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: args.expenses.isEmpty
                    ? const _EmptyView()
                    : ListView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  children: [
                    for (final entry in groups.entries) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xxs),
                        child: Text(
                          DateFormatter.weekdayDayMonthYear(entry.key).toUpperCase(),
                          style: AppTextStyles.overline.copyWith(color: AppColors.textMuted),
                        ),
                      ),
                      for (final t in entry.value) ...[
                        ExpenseRow(category: t.category, amount: t.amount),
                        const Divider(height: 1),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalBar extends StatelessWidget {
  const _TotalBar({required this.total, required this.count});

  final double total;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.totalSpent, style: AppTextStyles.bodySmall),
                const SizedBox(height: 2),
                Text(CurrencyFormatter.format(total), style: AppTextStyles.headlineMedium),
              ],
            ),
          ),
          Text(AppStrings.transactionCount(count), style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long_rounded, size: 40, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.noExpensesYet, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
