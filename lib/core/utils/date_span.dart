import 'package:equatable/equatable.dart';

/// Inclusive range of calendar days, e.g. 01 Sep 26 – 30 Sep 26.
/// Times are always stripped, so comparisons are by day.
class DateSpan extends Equatable {
  DateSpan(DateTime start, DateTime end)
      : start = dateOnly(start),
        end = dateOnly(end);

  final DateTime start;
  final DateTime end;

  int get days => end.difference(start).inDays + 1;

  bool contains(DateTime date) {
    final d = dateOnly(date);
    return !d.isBefore(start) && !d.isAfter(end);
  }

  /// True when this span is exactly one calendar month.
  bool get isWholeMonth =>
      start.day == 1 && start.month == end.month && start.year == end.year &&
          addDays(end, 1).day == 1;

  @override
  List<Object?> get props => [start, end];
}

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Calendar-safe day arithmetic (avoids daylight-saving drift of Duration).
DateTime addDays(DateTime d, int days) => DateTime(d.year, d.month, d.day + days);
