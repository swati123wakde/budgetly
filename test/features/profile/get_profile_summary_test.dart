import 'package:budgetly/features/budget_setup/domain/entities/new_transaction.dart';
import 'package:budgetly/features/budget_setup/domain/entities/transaction_category.dart';
import 'package:budgetly/features/profile/domain/usecases/get_profile_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const housing = TransactionCategory(id: 'housing', name: 'Housing', iconKey: 'housing');
  NewTransaction on(DateTime d) =>
      NewTransaction(type: TransactionType.expense, amount: 10, category: housing, date: d);

  // Wednesday 14 Oct 2026.
  final now = DateTime(2026, 10, 14, 18);

  test('a new user starts at level 1 with nothing logged', () {
    final s = GetProfileSummary.build(const [], now);
    expect(s.xp, 0);
    expect(s.level, 1);
    expect(s.levelName, 'Starter');
    expect(s.weeklyDaysLogged, 0);
    expect(s.streakDays, 0);
    expect(s.daysLeftInWeek, 5); // Wed, Thu, Fri, Sat, Sun
  });

  test('first transaction earns 45 XP and starts a 1-day streak', () {
    final s = GetProfileSummary.build([on(now)], now);
    expect(s.xp, 45);
    expect(s.levelEndXp, 80);
    expect(s.weeklyDaysLogged, 1);
    expect(s.streakDays, 1);
  });

  test('streak counts back from yesterday when nothing is logged today', () {
    final s = GetProfileSummary.build(
      [on(DateTime(2026, 10, 13)), on(DateTime(2026, 10, 12)), on(DateTime(2026, 10, 10))],
      now,
    );
    expect(s.streakDays, 2);
    expect(s.weeklyDaysLogged, 2); // Sat 10th is last week
  });

  test('enough XP moves to level 2', () {
    final s = GetProfileSummary.build(List.generate(5, (_) => on(now)), now); // 45 + 4×10
    expect(s.xp, 85);
    expect(s.level, 2);
    expect(s.levelName, 'Tracker');
    expect(s.nextLevelName, 'Planner');
  });
}
