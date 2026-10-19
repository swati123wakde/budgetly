import '../../../../core/utils/date_formatter.dart';
import '../../../budget_setup/domain/entities/budget_cycle.dart';
import '../../domain/entites/home_overview.dart';

/// Title above the date range: "September", "This fortnight", "Custom range"…
String periodTitle(HomeOverview o) {
  if (o.period.isWholeMonth) return DateFormatter.monthName(o.period.start);
  if (o.isCustomRange) return 'Custom range';
  return switch (o.cycle) {
    BudgetCycle.monthly => DateFormatter.monthName(o.period.start),
    BudgetCycle.fortnightly => 'This fortnight',
    BudgetCycle.weekly => 'This week',
  };
}
