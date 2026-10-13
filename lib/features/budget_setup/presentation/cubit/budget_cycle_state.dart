part of 'budget_cycle_cubit.dart';

class BudgetCycleState extends Equatable {
  const BudgetCycleState({
    this.selected,
    this.isSubmitting = false,
    this.errorMessage,
    this.completedCycle,
  });

  final BudgetCycle? selected;
  final bool isSubmitting;
  final String? errorMessage;

  /// Set once the choice is saved — the page listens for this to navigate.
  final BudgetCycle? completedCycle;

  BudgetCycleState copyWith({
    BudgetCycle? selected,
    bool? isSubmitting,
    String? errorMessage,
    BudgetCycle? completedCycle,
  }) {
    return BudgetCycleState(
      selected: selected ?? this.selected,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      completedCycle: completedCycle,
    );
  }

  @override
  List<Object?> get props => [selected, isSubmitting, errorMessage, completedCycle];
}
