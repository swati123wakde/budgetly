import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/step_header.dart';
import '../../domain/entities/budget_cycle.dart';
import '../cubit/budget_cycle_cubit.dart';
import '../widgets/budget_cycle_card.dart';

/// Step 2: Monthly / Fortnightly / Weekly. Tapping an option saves it and
/// opens the setup loader.
class BudgetCyclePage extends StatelessWidget {
  const BudgetCyclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetCycleCubit, BudgetCycleState>(
      listenWhen: (prev, curr) =>
      prev.completedCycle != curr.completedCycle ||
          prev.paydayCycle != curr.paydayCycle ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.completedCycle != null) {
          // Monthly: straight to the setup loader.
          Navigator.of(context).pushNamed(AppRoutes.budgetSetupLoading, arguments: state.completedCycle);
        } else if (state.paydayCycle != null) {
          // Fortnightly / weekly: ask for the payday first.
          Navigator.of(context).pushNamed(AppRoutes.payday, arguments: state.paydayCycle);
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                const StepHeader(step: 2, totalSteps: 4),
                const SizedBox(height: AppSpacing.xl),
                Text(AppStrings.budgetCycleTitle, style: AppTextStyles.headlineLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(AppStrings.budgetCycleSubtitle, style: AppTextStyles.bodyMedium),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: BlocBuilder<BudgetCycleCubit, BudgetCycleState>(
                    builder: (context, state) => ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: BudgetCycle.values.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, i) {
                        final cycle = BudgetCycle.values[i];
                        return BudgetCycleCard(
                          cycle: cycle,
                          isSelected: state.selected == cycle,
                          onTap: state.isSubmitting
                              ? null
                              : () => context.read<BudgetCycleCubit>().choose(cycle),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
