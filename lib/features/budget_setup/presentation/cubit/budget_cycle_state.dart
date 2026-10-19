part of 'budget_cycle_cubit.dart';

class BudgetCycleState extends Equatable {
  const BudgetCycleState({
    this.selected,
    this.isSubmitting = false,
    this.errorMessage,
    this.completedCycle,
    this.paydayCycle,
  });

  final BudgetCycle? selected;
  final bool isSubmitting;
  final String? errorMessage;

  /// Set once a monthly plan is saved — the page opens the setup loader.
  final BudgetCycle? completedCycle;

  /// Set for fortnightly / weekly — the page opens the payday question.
  final BudgetCycle? paydayCycle;

  /// One-shot fields (error, completedCycle, paydayCycle) reset unless passed.
  BudgetCycleState copyWith({
    BudgetCycle? selected,
    bool? isSubmitting,
    String? errorMessage,
    BudgetCycle? completedCycle,
    BudgetCycle? paydayCycle,
  }) {
    return BudgetCycleState(
      selected: selected ?? this.selected,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      completedCycle: completedCycle,
      paydayCycle: paydayCycle,
    );
  }

  @override
  List<Object?> get props => [selected, isSubmitting, errorMessage, completedCycle, paydayCycle];
}
