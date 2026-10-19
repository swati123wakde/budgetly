import 'package:equatable/equatable.dart';

/// Gamification stats shown on the profile screen.
class ProfileSummary extends Equatable {
  const ProfileSummary({
    required this.xp,
    required this.level,
    required this.levelName,
    required this.nextLevelName,
    required this.levelStartXp,
    required this.levelEndXp,
    required this.weeklyDaysLogged,
    required this.daysLeftInWeek,
    required this.streakDays,
  });

  static const int weeklyTarget = 3;
  static const int weeklyBonusXp = 100;

  final int xp;
  final int level;
  final String levelName;

  /// Null at the top level.
  final String? nextLevelName;
  final int levelStartXp;
  final int levelEndXp;

  /// Distinct days with a transaction this week (Mon–Sun).
  final int weeklyDaysLogged;
  final int daysLeftInWeek;

  /// Consecutive days with a transaction, ending today (or yesterday).
  final int streakDays;

  double get levelProgress =>
      ((xp - levelStartXp) / (levelEndXp - levelStartXp)).clamp(0.0, 1.0).toDouble();

  bool get weeklyBonusComplete => weeklyDaysLogged >= weeklyTarget;

  @override
  List<Object?> get props => [
    xp, level, levelName, nextLevelName, levelStartXp, levelEndXp,
    weeklyDaysLogged, daysLeftInWeek, streakDays,
  ];
}
