import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/dollar_logo.dart';
import '../../../get_started/domain/entities/tracking_option.dart';
import '../../domain/entites/budget_summary.dart';
import '../cubit/home_cubit.dart';
import '../widgets/home_shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.mode});

  /// Set when the user arrives from the "get started" flow.
  final TrackingMode? mode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.matteRed,
          backgroundColor: AppColors.surface,
          onRefresh: context.read<HomeCubit>().load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              Row(
                children: [
                  const DollarLogo(size: 40),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.homeGreeting, style: AppTextStyles.bodySmall),
                        Text(AppStrings.appName, style: AppTextStyles.titleLarge),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) => AnimatedSwitcher(
                  duration: AppDurations.medium,
                  child: switch (state) {
                    HomeLoading() => const HomeShimmer(),
                    HomeError(:final message) => Center(
                      child: Text(message, style: AppTextStyles.bodyMedium),
                    ),
                    HomeLoaded(:final summary) => _Content(summary: summary, mode: mode),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.summary, this.mode});

  final BudgetSummary summary;
  final TrackingMode? mode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BalanceCard(summary: summary, mode: mode),
        const SizedBox(height: AppSpacing.lg),
        Text('Recent activity', style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        ...summary.recent.map((t) => _TransactionTile(transaction: t)),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.summary, this.mode});

  final BudgetSummary summary;
  final TrackingMode? mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg - 4),
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
              Text(AppStrings.totalBalance, style: AppTextStyles.bodyMedium),
              const Spacer(),
              if (mode != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.matteRedTint,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    mode == TrackingMode.spendingOnly ? 'Spending' : 'Spending + accounts',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.matteRedLight),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(CurrencyFormatter.format(summary.balance), style: AppTextStyles.displayLarge),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: summary.spentRatio,
              minHeight: 8,
              backgroundColor: AppColors.surfaceHigh,
              color: AppColors.matteRed,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                '${CurrencyFormatter.format(summary.spent)} spent',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const Spacer(),
              Text(
                'of ${CurrencyFormatter.format(summary.monthlyBudget)}',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final Transaction transaction;

  IconData get _icon => switch (transaction.category) {
    'Food' => Icons.restaurant_rounded,
    'Transport' => Icons.directions_transit_rounded,
    'Income' => Icons.south_west_rounded,
    _ => Icons.receipt_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.amount > 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(_icon, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppTextStyles.titleMedium.copyWith(fontSize: 15)),
                Text(transaction.category, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(transaction.amount, showSign: true),
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 15,
              color: isIncome ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}