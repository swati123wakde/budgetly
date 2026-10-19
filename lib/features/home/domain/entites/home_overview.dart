import 'package:equatable/equatable.dart';

import '../../../../core/utils/date_span.dart';
import '../../../budget_setup/domain/entities/budget_cycle.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';
import '../../../budget_setup/domain/entities/transaction_category.dart';

/// Spending in one category over the shown period.
class CategoryTotal extends Equatable {
  const CategoryTotal({required this.category, required this.total, required this.count});

  final TransactionCategory category;
  final double total;
  final int count;

  @override
  List<Object?> get props => [category, total, count];
}

/// Everything the home screen shows for one period.
class HomeOverview extends Equatable {
  const HomeOverview({
    required this.period,
    required this.cycle,
    required this.isCustomRange,
    required this.expenses,
    required this.expensesByCategory,
    required this.expenseTotal,
    required this.incomeTotal,
    required this.hasAnyTransactions,
  });

  final DateSpan period;
  final BudgetCycle cycle;

  /// True when the user picked the range themselves instead of the budget cycle.
  final bool isCustomRange;

  /// Expenses in the period, newest first.
  final List<NewTransaction> expenses;

  /// Largest category first.
  final List<CategoryTotal> expensesByCategory;
  final double expenseTotal;
  final double incomeTotal;

  /// Whether the user has logged anything at all (drives the challenge card).
  final bool hasAnyTransactions;

  /// What's left after expenses: income minus expenses.
  double get forecast => incomeTotal - expenseTotal;

  @override
  List<Object?> get props => [
    period, cycle, isCustomRange, expenses, expensesByCategory,
    expenseTotal, incomeTotal, hasAnyTransactions,
  ];
}
