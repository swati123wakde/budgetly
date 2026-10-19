import 'package:budgetly/core/utils/date_span.dart';
import 'package:budgetly/features/budget_setup/domain/entities/budget_plan.dart';
import 'package:budgetly/features/budget_setup/domain/entities/new_transaction.dart';
import 'package:budgetly/features/budget_setup/domain/entities/transaction_category.dart';
import 'package:budgetly/features/home/domain/usecases/get_home_overview.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const housing = TransactionCategory(id: 'housing', name: 'Housing', iconKey: 'housing');
  const groceries = TransactionCategory(id: 'groceries', name: 'Groceries', iconKey: 'groceries');

  NewTransaction tx(TransactionType type, double amount, TransactionCategory c, DateTime d) =>
      NewTransaction(type: type, amount: amount, category: c, date: d);

  final all = [
    tx(TransactionType.expense, 5600, housing, DateTime(2026, 10, 2)),
    tx(TransactionType.expense, 40, groceries, DateTime(2026, 10, 9)),
    tx(TransactionType.expense, 60, groceries, DateTime(2026, 10, 12)),
    tx(TransactionType.income, 3000, housing, DateTime(2026, 10, 1)),
    tx(TransactionType.expense, 999, groceries, DateTime(2026, 9, 30)), // previous month
  ];

  test('monthly overview totals only the current month', () {
    final o = GetHomeOverview.build(
      BudgetPlan.monthly(),
      all,
      HomeOverviewParams(today: DateTime(2026, 10, 14)),
    );
    expect(o.period, DateSpan(DateTime(2026, 10, 1), DateTime(2026, 10, 31)));
    expect(o.expenseTotal, 5700);
    expect(o.incomeTotal, 3000);
    expect(o.forecast, -2700);
    expect(o.expensesByCategory.map((c) => (c.category.name, c.total, c.count)), [
      ('Housing', 5600.0, 1),
      ('Groceries', 100.0, 2),
    ]);
    expect(o.expenses.first.date, DateTime(2026, 10, 12)); // newest first
    expect(o.isCustomRange, isFalse);
    expect(o.hasAnyTransactions, isTrue);
  });

  test('a picked range overrides the budget period', () {
    final o = GetHomeOverview.build(
      BudgetPlan.monthly(),
      all,
      HomeOverviewParams(range: DateSpan(DateTime(2026, 9, 30), DateTime(2026, 10, 9))),
    );
    expect(o.isCustomRange, isTrue);
    expect(o.expenseTotal, 999 + 5600 + 40);
  });

  test('no transactions gives an empty overview', () {
    final o = GetHomeOverview.build(
      BudgetPlan.monthly(),
      const [],
      HomeOverviewParams(today: DateTime(2026, 10, 14)),
    );
    expect(o.expensesByCategory, isEmpty);
    expect(o.forecast, 0);
    expect(o.hasAnyTransactions, isFalse);
  });
}
