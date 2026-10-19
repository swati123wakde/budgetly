import 'package:equatable/equatable.dart';

import '../../../../core/utils/date_span.dart';
import 'budget_cycle.dart';

/// The user's budget cycle plus the date it is anchored to.
class BudgetPlan extends Equatable {
  BudgetPlan({required this.cycle, required DateTime anchor}) : anchor = dateOnly(anchor);

  /// Monthly budgets always run from the 1st to the last day of the month.
  factory BudgetPlan.monthly() => BudgetPlan(cycle: BudgetCycle.monthly, anchor: DateTime(2000));

  /// Fortnightly budgets repeat every 14 days from the last payday.
  factory BudgetPlan.fortnightly(DateTime lastPayday) =>
      BudgetPlan(cycle: BudgetCycle.fortnightly, anchor: lastPayday);

  /// Weekly budgets start on the pay weekday ([DateTime.monday]..[DateTime.sunday]).
  factory BudgetPlan.weekly(int payWeekday, {DateTime? today}) {
    final now = dateOnly(today ?? DateTime.now());
    final back = (now.weekday - payWeekday) % 7;
    return BudgetPlan(cycle: BudgetCycle.weekly, anchor: addDays(now, -back));
  }

  final BudgetCycle cycle;

  /// Monthly: unused. Fortnightly: a payday. Weekly: any date on the pay weekday.
  final DateTime anchor;

  /// The budget period that [date] falls in.
  DateSpan periodContaining(DateTime date) {
    final d = dateOnly(date);
    switch (cycle) {
      case BudgetCycle.monthly:
        return DateSpan(DateTime(d.year, d.month, 1), DateTime(d.year, d.month + 1, 0));
      case BudgetCycle.fortnightly:
      // Count whole calendar days in UTC so daylight saving can't shift the result.
        final diff = DateTime.utc(d.year, d.month, d.day)
            .difference(DateTime.utc(anchor.year, anchor.month, anchor.day))
            .inDays;
        final start = addDays(anchor, (diff / 14).floor() * 14);
        return DateSpan(start, addDays(start, 13));
      case BudgetCycle.weekly:
        final start = addDays(d, -((d.weekday - anchor.weekday) % 7));
        return DateSpan(start, addDays(start, 6));
    }
  }

  @override
  List<Object?> get props => [cycle, anchor];
}
