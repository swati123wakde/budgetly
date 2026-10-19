import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_span.dart';
import '../../domain/entities/budget_cycle.dart';
import '../../domain/entities/budget_plan.dart';
import '../../domain/usecases/save_budget_plan.dart';

part 'payday_state.dart';

/// Drives both payday questions:
/// fortnightly → "When did you last get paid?" (a date),
/// weekly → "Which day do you usually get paid?" (a weekday).
class PaydayCubit extends Cubit<PaydayState> {
  PaydayCubit(this._saveBudgetPlan, {required BudgetCycle cycle, DateTime? today})
      : super(PaydayState(
    cycle: cycle,
    date: dateOnly(today ?? DateTime.now()),
    weekday: (today ?? DateTime.now()).weekday,
  ));

  final SaveBudgetPlan _saveBudgetPlan;

  void setDate(DateTime date) => emit(state.copyWith(date: dateOnly(date)));

  void setWeekday(int weekday) => emit(state.copyWith(weekday: weekday));

  Future<void> submit() async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true));
    final plan = state.cycle == BudgetCycle.weekly
        ? BudgetPlan.weekly(state.weekday)
        : BudgetPlan.fortnightly(state.date);
    final result = await _saveBudgetPlan(plan);
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(isSubmitting: false, errorMessage: failure.message)),
          (_) => emit(state.copyWith(isSubmitting: false, isCompleted: true)),
    );
  }
}
