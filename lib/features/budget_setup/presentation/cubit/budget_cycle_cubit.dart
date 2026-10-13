import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/budget_cycle.dart';
import '../../domain/usecases/save_budget_cycle.dart';

part 'budget_cycle_state.dart';

class BudgetCycleCubit extends Cubit<BudgetCycleState> {
  BudgetCycleCubit(this._saveBudgetCycle) : super(const BudgetCycleState());

  final SaveBudgetCycle _saveBudgetCycle;

  /// Tapping an option picks it and moves on straight away (no Continue button).
  Future<void> choose(BudgetCycle cycle) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(selected: cycle, isSubmitting: true));
    final result = await _saveBudgetCycle(cycle);
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(isSubmitting: false, errorMessage: failure.message)),
          (_) => emit(state.copyWith(isSubmitting: false, completedCycle: cycle)),
    );
  }
}
