import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/date_span.dart';
import '../../../../core/utils/result.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';
import '../entities/profile_summary.dart';
import '../repositories/profile_repository.dart';

class GetProfileSummary implements UseCase<ProfileSummary, NoParams> {
  const GetProfileSummary(this._repository);
  final ProfileRepository _repository;

  /// Level thresholds: (XP needed, name).
  static const levels = [
    (0, 'Starter'),
    (80, 'Tracker'),
    (200, 'Planner'),
    (400, 'Saver'),
    (700, 'Money Pro'),
  ];

  static const int firstTransactionXp = 45;
  static const int transactionXp = 10;

  @override
  Future<Result<ProfileSummary>> call(NoParams params) async {
    final result = await _repository.getTransactions();
    return switch (result) {
      Ok<List<NewTransaction>>(:final data) => Ok<ProfileSummary>(build(data, DateTime.now())),
      Err<List<NewTransaction>>(:final failure) => Err<ProfileSummary>(failure),
    };
  }

  /// Pure calculation, kept separate so it is easy to test.
  static ProfileSummary build(List<NewTransaction> transactions, DateTime now) {
    final today = dateOnly(now);
    final n = transactions.length;
    final xp = n == 0 ? 0 : firstTransactionXp + (n - 1) * transactionXp;

    var index = 0;
    for (var i = 0; i < levels.length; i++) {
      if (xp >= levels[i].$1) index = i;
    }
    final isTop = index == levels.length - 1;

    final days = transactions.map((t) => dateOnly(t.date)).toSet();
    final week = DateSpan(addDays(today, -(today.weekday - 1)), addDays(today, 7 - today.weekday));
    final weeklyDays = days.where(week.contains).length;

    var streak = 0;
    var cursor = days.contains(today) ? today : addDays(today, -1);
    while (days.contains(cursor)) {
      streak++;
      cursor = addDays(cursor, -1);
    }

    return ProfileSummary(
      xp: xp,
      level: index + 1,
      levelName: levels[index].$2,
      nextLevelName: isTop ? null : levels[index + 1].$2,
      levelStartXp: levels[index].$1,
      levelEndXp: isTop ? levels[index].$1 + 300 : levels[index + 1].$1,
      weeklyDaysLogged: weeklyDays,
      daysLeftInWeek: 8 - today.weekday,
      streakDays: streak,
    );
  }
}
