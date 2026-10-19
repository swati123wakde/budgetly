import 'date_span.dart';

/// Minimal date formatting (avoids pulling in `intl`).
abstract final class DateFormatter {
  static const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  static String _two(int n) => n.toString().padLeft(2, '0');
  static String _short(String s) => s.substring(0, 3);

  /// "September"
  static String monthName(DateTime d) => months[d.month - 1];

  /// "Sunday" for DateTime.sunday (7).
  static String weekdayName(int weekday) => weekdays[weekday - 1];

  /// "01 Sep 26"
  static String dayMonthYear(DateTime d) =>
      '${_two(d.day)} ${_short(monthName(d))} ${_two(d.year % 100)}';

  /// "Sun 27 Sep 26"
  static String weekdayDayMonthYear(DateTime d) =>
      '${_short(weekdayName(d.weekday))} ${d.day} ${_short(monthName(d))} ${_two(d.year % 100)}';

  /// "01 Sep 26 - 30 Sep 26"
  static String span(DateSpan s) => '${dayMonthYear(s.start)} - ${dayMonthYear(s.end)}';
}
