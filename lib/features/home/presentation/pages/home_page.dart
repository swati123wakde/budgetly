import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/date_span.dart';
import '../../../timeline/presentation/cubit/add_transaction_cubit.dart';
import '../../../timeline/presentation/cubit/timeline_cubit.dart';
import '../../../timeline/presentation/pages/add_transaction_page.dart';
import '../../../timeline/presentation/pages/timeline_tab.dart';
import '../../domain/entites/home_overview.dart';
import '../cubit/home_cubit.dart';
import '../widgets/challenge_card.dart';
import '../widgets/expense_row.dart';
import '../widgets/forecast_card.dart';
import '../widgets/home_header.dart';
import '../widgets/home_shimmer.dart';
import '../widgets/period_label.dart';
import '../widgets/range_calendar_dialog.dart';
import 'all_expenses_page.dart';

/// Main screen after onboarding: Home, Timeline (calendar) and two placeholder tabs.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  /// Lives as long as the home screen so the Timeline tab keeps its data.
  late final TimelineCubit _timelineCubit = sl<TimelineCubit>()..load();

  @override
  void dispose() {
    _timelineCubit.close();
    super.dispose();
  }

  /// Opens "Add transaction"; refreshes Home and Timeline once something is saved.
  Future<void> _addTransaction() async {
    final homeCubit = context.read<HomeCubit>();
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => sl<AddTransactionCubit>()..init(),
          child: const AddTransactionPage(),
        ),
      ),
    );
    if (saved == true) {
      await Future.wait([homeCubit.load(), _timelineCubit.load()]);
    }
  }

  static const _destinations = [
    (Icons.home_outlined, Icons.home_rounded, AppStrings.tabHome),
    (Icons.calendar_month_outlined, Icons.calendar_month_rounded, AppStrings.tabCalendar),
    (Icons.speed_outlined, Icons.speed_rounded, AppStrings.tabBudget),
    (Icons.bar_chart_outlined, Icons.bar_chart_rounded, AppStrings.tabReports),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _tab,
          children: [
            const _HomeTab(),
            BlocProvider.value(value: _timelineCubit, child: const TimelineTab()),
            for (final d in _destinations.skip(2)) _ComingSoonTab(icon: d.$2, title: d.$3),
          ],
        ),
      ),
      floatingActionButton: _tab <= 1 ? _AddButton(onPressed: _addTransaction) : null,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppColors.surface,
            surfaceTintColor: Colors.transparent,
            indicatorColor: AppColors.matteRedTint,
            height: 68,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            iconTheme: WidgetStateProperty.resolveWith(
                  (states) => IconThemeData(
                size: 26,
                color: states.contains(WidgetState.selected)
                    ? AppColors.matteRedLight
                    : AppColors.textMuted,
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _tab,
            onDestinationSelected: (i) => setState(() => _tab = i),
            destinations: [
              for (final d in _destinations)
                NavigationDestination(
                  icon: Icon(d.$1),
                  selectedIcon: Icon(d.$2),
                  label: d.$3,
                  tooltip: d.$3,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The "+" button on Home and Timeline — opens "Add transaction".
class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.matteRed,
      foregroundColor: AppColors.onRed,
      elevation: 0,
      disabledElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: const Icon(Icons.add_rounded, size: 30),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  Future<void> _pickRange(BuildContext context, DateSpan current) async {
    final cubit = context.read<HomeCubit>();
    final today = dateOnly(DateTime.now());
    final picked = await showRangeCalendarDialog(
      context: context,
      initialRange: current,
      firstDate: DateTime(today.year - 2),
      lastDate: DateTime(today.year + 1, 12, 31),
    );
    if (picked != null && picked != current) await cubit.selectRange(picked);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final overview = state.overview;

        if (overview == null) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: state.status == HomeStatus.failure
                ? _ErrorView(
              message: state.errorMessage ?? '',
              onRetry: context.read<HomeCubit>().load,
            )
                : const HomeShimmer(),
          );
        }

        return RefreshIndicator(
          color: AppColors.matteRed,
          backgroundColor: AppColors.surface,
          onRefresh: context.read<HomeCubit>().load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            // Bottom space keeps the last row clear of the + button.
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding, AppSpacing.md, AppSpacing.screenPadding, 110,
            ),
            children: [
              HomeHeader(
                title: periodTitle(overview),
                rangeText: DateFormatter.span(overview.period),
                onAvatarTap: () => Navigator.of(context).pushNamed(AppRoutes.profile),
                onRangeTap: () => _pickRange(context, overview.period),
              ),
              if (overview.isCustomRange)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: context.read<HomeCubit>().resetRange,
                    icon: const Icon(Icons.restart_alt_rounded, size: 18),
                    label: const Text(AppStrings.backToCurrentPeriod),
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              if (overview.hasAnyTransactions) ...[
                const ChallengeCard(),
                const SizedBox(height: AppSpacing.md),
              ],
              AnimatedOpacity(
                opacity: state.status == HomeStatus.loading ? 0.5 : 1,
                duration: AppDurations.fast,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ForecastCard(
                      forecast: overview.forecast,
                      expenses: overview.expenseTotal,
                      income: overview.incomeTotal,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _ExpensesSection(overview: overview),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExpensesSection extends StatelessWidget {
  const _ExpensesSection({required this.overview});

  final HomeOverview overview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(AppStrings.expenses, style: AppTextStyles.titleLarge),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.allExpenses,
                arguments: AllExpensesArgs(
                  title: periodTitle(overview),
                  period: overview.period,
                  expenses: overview.expenses,
                ),
              ),
              child: Text(
                AppStrings.viewAll,
                style: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
        const Divider(height: AppSpacing.md),
        if (overview.expensesByCategory.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Text(
              AppStrings.noExpensesYet,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          )
        else
          for (final c in overview.expensesByCategory) ...[
            ExpenseRow(
              category: c.category,
              amount: c.total,
              subtitle: AppStrings.transactionCount(c.count),
            ),
            const Divider(height: 1),
          ],
      ],
    );
  }
}

class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(icon, size: 34, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(AppStrings.comingSoon, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, color: AppColors.textMuted, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}