import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/date_span.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/step_header.dart';
import '../../domain/entities/budget_cycle.dart';
import '../cubit/payday_cubit.dart';
import '../widgets/payday_illustration.dart';

/// Step 3 for fortnightly and weekly budgets.
/// Fortnightly: "When did you last get paid?" → date picker.
/// Weekly: "Which day do you usually get paid?" → weekday list.
class PaydayPage extends StatelessWidget {
  const PaydayPage({super.key});

  Future<void> _pickDate(BuildContext context) async {
    final cubit = context.read<PaydayCubit>();
    final today = dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: cubit.state.date,
      firstDate: addDays(today, -365),
      lastDate: addDays(today, 30),
      helpText: AppStrings.paydayPickerHelp,
    );
    if (picked != null) cubit.setDate(picked);
  }

  Future<void> _pickWeekday(BuildContext context) async {
    final cubit = context.read<PaydayCubit>();
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => _WeekdaySheet(selected: cubit.state.weekday),
    );
    if (picked != null) cubit.setWeekday(picked);
  }

  @override
  Widget build(BuildContext context) {
    final isWeekly = context.read<PaydayCubit>().state.cycle == BudgetCycle.weekly;

    return BlocListener<PaydayCubit, PaydayState>(
      listenWhen: (p, c) => p.isCompleted != c.isCompleted || p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.isCompleted) {
          Navigator.of(context).pushNamed(AppRoutes.budgetSetupLoading, arguments: state.cycle);
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.md),
                const StepHeader(step: 3, totalSteps: 4),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Column(
                      children: [
                        const PaydayIllustration(label: AppStrings.paydayLabel),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          isWeekly ? AppStrings.weeklyPaydayTitle : AppStrings.fortnightlyPaydayTitle,
                          style: AppTextStyles.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          isWeekly
                              ? AppStrings.weeklyPaydaySubtitle
                              : AppStrings.fortnightlyPaydaySubtitle,
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        BlocBuilder<PaydayCubit, PaydayState>(
                          buildWhen: (p, c) => p.date != c.date || p.weekday != c.weekday,
                          builder: (context, state) => _ValueChip(
                            value: isWeekly
                                ? DateFormatter.weekdayName(state.weekday)
                                : DateFormatter.weekdayDayMonthYear(state.date),
                            onTap: () => isWeekly ? _pickWeekday(context) : _pickDate(context),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<PaydayCubit, PaydayState>(
                          buildWhen: (p, c) => p.weekday != c.weekday,
                          builder: (context, state) => Text(
                            isWeekly
                                ? AppStrings.weeklyPaydayNote(DateFormatter.weekdayName(state.weekday))
                                : AppStrings.fortnightlyPaydayNote,
                            style: AppTextStyles.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocSelector<PaydayCubit, PaydayState, bool>(
                  selector: (s) => s.isSubmitting,
                  builder: (context, submitting) => PrimaryButton(
                    label: AppStrings.continueText,
                    isLoading: submitting,
                    onPressed: context.read<PaydayCubit>().submit,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Large tappable pill showing the chosen date or weekday.
class _ValueChip extends StatelessWidget {
  const _ValueChip({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.borderStrong),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: AppTextStyles.headlineMedium),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.expand_more_rounded, color: AppColors.matteRedLight),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekdaySheet extends StatelessWidget {
  const _WeekdaySheet({required this.selected});
  final int selected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding, AppSpacing.xs, AppSpacing.screenPadding, AppSpacing.sm,
              ),
              child: Text(AppStrings.payWeekdaySheetTitle, style: AppTextStyles.titleLarge),
            ),
            for (var day = DateTime.monday; day <= DateTime.sunday; day++)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                title: Text(DateFormatter.weekdayName(day), style: AppTextStyles.titleMedium),
                trailing: day == selected
                    ? const Icon(Icons.check_rounded, color: AppColors.matteRedLight)
                    : null,
                onTap: () => Navigator.of(context).pop(day),
              ),
          ],
        ),
      ),
    );
  }
}
