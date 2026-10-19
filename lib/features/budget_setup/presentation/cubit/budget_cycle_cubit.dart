import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/budget_cycle.dart';
import '../../domain/entities/budget_plan.dart';
import '../../domain/usecases/save_budget_plan.dart';

part 'budget_cycle_state.dart';

class BudgetCycleCubit extends Cubit<BudgetCycleState> {
  BudgetCycleCubit(this._saveBudgetPlan) : super(const BudgetCycleState());

  final SaveBudgetPlan _saveBudgetPlan;

  /// Tapping an option moves on straight away (no Continue button).
  /// Monthly needs nothing else, so it is saved now. Fortnightly and weekly
  /// first ask for a payday.
  Future<void> choose(BudgetCycle cycle) async {
    if (state.isSubmitting) return;

    if (cycle != BudgetCycle.monthly) {
      // Two emits so re-tapping the same option after coming back still navigates.
      emit(state.copyWith(selected: cycle));
      emit(state.copyWith(selected: cycle, paydayCycle: cycle));
      return;
    }

    emit(state.copyWith(selected: cycle, isSubmitting: true));
    final result = await _saveBudgetPlan(BudgetPlan.monthly());
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(isSubmitting: false, errorMessage: failure.message)),
          (_) => emit(state.copyWith(isSubmitting: false, completedCycle: cycle)),
    );
  }
}
