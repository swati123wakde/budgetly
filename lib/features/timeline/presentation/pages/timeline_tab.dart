import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/date_span.dart';
import '../../../../core/widgets/profile_avatar.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';
import '../../../budget_setup/presentation/widgets/category_icon.dart';
import '../cubit/timeline_cubit.dart';

const String _rupee = '₹';

/// Calendar tab: book balance, a "Pending" card and every transaction
/// grouped by day (Today, Yesterday, Sun 01 Nov 26, …).
class TimelineTab extends StatelessWidget {
  const TimelineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelineCubit, TimelineState>(
      builder: (context, state) {
        final groups = _groupByDay(state.transactions);

        return RefreshIndicator(
          color: AppColors.matteRed,
          backgroundColor: AppColors.surface,
          onRefresh: context.read<TimelineCubit>().load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 110), // clear of the + button
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding, AppSpacing.md, AppSpacing.screenPadding, 0,
                ),
                child: _TimelineHeader(),
              ),
              const SizedBox(height: AppSpacing.xl),
              _BookBalance(
                balance: state.balance,
                isLoading: state.status == TimelineStatus.loading && state.transactions.isEmpty,
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                ),
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: _PendingCard(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (state.status == TimelineStatus.failure)
                      _Message(text: state.errorMessage ?? '')
                    else if (state.status == TimelineStatus.loaded && groups.isEmpty)
                      const _Message(text: AppStrings.noTransactionsYet)
                    else
                      for (final group in groups) ...[
                        _DayHeader(label: _dayLabel(group.day)),
                        for (final t in group.items) _TransactionRow(transaction: t),
                      ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static List<_DayGroup> _groupByDay(List<NewTransaction> items) {
    final groups = <_DayGroup>[];
    for (final t in items) {
      final day = dateOnly(t.date);
      if (groups.isEmpty || groups.last.day != day) groups.add(_DayGroup(day));
      groups.last.items.add(t);
    }
    return groups;
  }

  static String _dayLabel(DateTime day) {
    final today = dateOnly(DateTime.now());
    if (day == today) return AppStrings.today;
    if (day == addDays(today, -1)) return AppStrings.yesterday;
    return DateFormatter.weekdayDayMonthYear(day);
  }
}

class _DayGroup {
  _DayGroup(this.day);
  final DateTime day;
  final List<NewTransaction> items = [];
}

class _TimelineHeader extends StatelessWidget {
  const _TimelineHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Semantics(
          button: true,
          label: 'Open profile',
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.profile),
            child: const ProfileAvatar(size: 52, showDot: true),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.timeline, style: AppTextStyles.titleLarge),
              const SizedBox(height: 2),
              Text(AppStrings.timelineBook, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        // Placeholder actions — shown for now, not wired up yet.
        const Icon(Icons.search_rounded, size: 30, color: AppColors.matteRedLight),
        const SizedBox(width: AppSpacing.md),
        const Icon(Icons.calendar_month_rounded, size: 30, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.md),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surfaceHigh, width: 5),
          ),
          child: const Icon(Icons.menu_book_rounded, size: 24, color: AppColors.matteRedLight),
        ),
      ],
    );
  }
}

class _BookBalance extends StatelessWidget {
  const _BookBalance({required this.balance, required this.isLoading});

  final double balance;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppStrings.bookBalance, style: AppTextStyles.bodyLarge),
        const SizedBox(height: AppSpacing.xxs),
        AnimatedOpacity(
          opacity: isLoading ? 0.4 : 1,
          duration: AppDurations.fast,
          child: Text(
            CurrencyFormatter.format(balance, symbol: _rupee),
            style: AppTextStyles.headlineLarge.copyWith(fontSize: 32),
          ),
        ),
      ],
    );
  }
}

/// Shown for now; pending (scheduled) transactions aren't built yet.
class _PendingCard extends StatelessWidget {
  const _PendingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md + 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Icons.hourglass_bottom_rounded, color: AppColors.matteRedLight),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(AppStrings.pending, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.matteRedTint,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.sm),
      child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction});

  final NewTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final note = t.note?.trim();
    final amountText = CurrencyFormatter.format(t.amount, symbol: _rupee, showSign: !t.isExpense);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderStrong)),
      ),
      child: Row(
        children: [
          CategoryIcon(category: t.category, size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.category.name, style: AppTextStyles.titleMedium.copyWith(fontSize: 17)),
                if (note != null && note.isNotEmpty)
                  Text(note, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            amountText,
            style: AppTextStyles.bodyLarge.copyWith(
              color: t.isExpense ? AppColors.textPrimary : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.xl),
      child: Text(text, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
    );
  }
}