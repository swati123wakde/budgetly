part of 'payday_cubit.dart';

class PaydayState extends Equatable {
  const PaydayState({
    required this.cycle,
    required this.date,
    required this.weekday,
    this.isSubmitting = false,
    this.isCompleted = false,
    this.errorMessage,
  });

  final BudgetCycle cycle;

  /// Last payday (fortnightly).
  final DateTime date;

  /// Pay weekday, [DateTime.monday]..[DateTime.sunday] (weekly).
  final int weekday;

  final bool isSubmitting;

  /// One-shot: set once the plan is saved — the page opens the loader.
  final bool isCompleted;
  final String? errorMessage;

  PaydayState copyWith({
    DateTime? date,
    int? weekday,
    bool? isSubmitting,
    bool? isCompleted,
    String? errorMessage,
  }) {
    return PaydayState(
      cycle: cycle,
      date: date ?? this.date,
      weekday: weekday ?? this.weekday,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isCompleted: isCompleted ?? false,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [cycle, date, weekday, isSubmitting, isCompleted, errorMessage];
}
