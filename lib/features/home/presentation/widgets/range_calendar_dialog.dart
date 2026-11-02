import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/date_span.dart';

/// Opens the compact month calendar used by the home header.
///
/// Tap one day to start a range, tap a second day to finish it.
/// Returns the picked [DateSpan], or null when the user cancels.
Future<DateSpan?> showRangeCalendarDialog({
  required BuildContext context,
  required DateSpan initialRange,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDialog<DateSpan>(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => RangeCalendarDialog(
      initialRange: initialRange,
      firstDate: dateOnly(firstDate),
      lastDate: dateOnly(lastDate),
    ),
  );
}

/// Same calendar, but picks a single day (used by "Add transaction").
Future<DateTime?> showSingleDateCalendarDialog({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  final picked = await showDialog<DateSpan>(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => RangeCalendarDialog(
      initialRange: DateSpan(initialDate, initialDate),
      firstDate: dateOnly(firstDate),
      lastDate: dateOnly(lastDate),
      singleDate: true,
    ),
  );
  return picked?.start;
}

class RangeCalendarDialog extends StatefulWidget {
  const RangeCalendarDialog({
    super.key,
    required this.initialRange,
    required this.firstDate,
    required this.lastDate,
    this.singleDate = false,
  });

  final DateSpan initialRange;
  final DateTime firstDate;
  final DateTime lastDate;

  /// When true, every tap selects just that one day.
  final bool singleDate;

  @override
  State<RangeCalendarDialog> createState() => _RangeCalendarDialogState();
}

class _RangeCalendarDialogState extends State<RangeCalendarDialog> {
  static const _weekdayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  late DateTime _month; // always the 1st of the visible month
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialRange.start;
    _end = widget.initialRange.end;
    _month = DateTime(_start!.year, _start!.month);
  }

  DateTime get _firstMonth => DateTime(widget.firstDate.year, widget.firstDate.month);
  DateTime get _lastMonth => DateTime(widget.lastDate.year, widget.lastDate.month);

  bool get _canGoBack => _month.isAfter(_firstMonth);
  bool get _canGoForward => _month.isBefore(_lastMonth);

  void _changeMonth(int delta) {
    if (delta < 0 && !_canGoBack) return;
    if (delta > 0 && !_canGoForward) return;
    setState(() => _month = DateTime(_month.year, _month.month + delta));
  }

  bool _isEnabled(DateTime d) => !d.isBefore(widget.firstDate) && !d.isAfter(widget.lastDate);

  void _onDayTap(DateTime day) {
    setState(() {
      if (widget.singleDate) {
        _start = day;
        _end = day;
      } else if (_start == null || _end != null) {
        // Start a fresh selection.
        _start = day;
        _end = null;
      } else if (day.isBefore(_start!)) {
        _start = day;
      } else {
        _end = day;
      }
    });
  }

  bool _isSelected(DateTime d) {
    if (_start == null) return false;
    final end = _end ?? _start!;
    return !d.isBefore(_start!) && !d.isAfter(end);
  }

  void _submit() {
    if (_start == null) return;
    Navigator.of(context).pop(DateSpan(_start!, _end ?? _start!));
  }

  /// Day cells for the visible month, starting on Sunday. Leading days from
  /// the previous month are included (greyed out); trailing days only fill
  /// the last week.
  List<DateTime> _visibleDays() {
    final leading = _month.weekday % 7; // Sunday = 0
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final total = ((leading + daysInMonth) / 7).ceil() * 7;
    return [for (var i = 0; i < total; i++) DateTime(_month.year, _month.month, 1 - leading + i)];
  }

  @override
  Widget build(BuildContext context) {
    final days = _visibleDays();

    return Dialog(
      backgroundColor: AppColors.surfaceHigh,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding + 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.lg, AppSpacing.sm, AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MonthHeader(
              title: '${DateFormatter.monthName(_month)} ${_month.year}',
              onPrevious: _canGoBack ? () => _changeMonth(-1) : null,
              onNext: _canGoForward ? () => _changeMonth(1) : null,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                for (final label in _weekdayLabels)
                  Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: AppTextStyles.bodyLarge.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            // Swipe left/right to change month, like the arrows.
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragEnd: (details) {
                final v = details.primaryVelocity ?? 0;
                if (v < -200) _changeMonth(1);
                if (v > 200) _changeMonth(-1);
              },
              child: AnimatedSwitcher(
                duration: AppDurations.fast,
                child: Column(
                  key: ValueKey(_month),
                  children: [
                    for (var row = 0; row < days.length ~/ 7; row++)
                      Row(
                        children: [
                          for (final day in days.sublist(row * 7, row * 7 + 7))
                            Expanded(child: _buildDay(day)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(foregroundColor: AppColors.textPrimary),
                  child: Text('Cancel', style: AppTextStyles.bodyLarge.copyWith(fontSize: 15)),
                ),
                const SizedBox(width: AppSpacing.xs),
                TextButton(
                  onPressed: _start == null ? null : _submit,
                  style: TextButton.styleFrom(foregroundColor: AppColors.textPrimary),
                  child: Text('OK', style: AppTextStyles.bodyLarge.copyWith(fontSize: 15)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDay(DateTime day) {
    final inMonth = day.month == _month.month;
    final enabled = inMonth && _isEnabled(day);
    final selected = inMonth && _isSelected(day);

    final Color textColor;
    if (selected) {
      textColor = AppColors.onRed;
    } else if (!inMonth || !enabled) {
      textColor = AppColors.textMuted;
    } else {
      textColor = AppColors.textPrimary;
    }

    return AspectRatio(
      aspectRatio: 1 / 1.2,
      child: Center(
        child: InkResponse(
          onTap: enabled ? () => _onDayTap(day) : null,
          radius: 24,
          child: AnimatedContainer(
            duration: AppDurations.fast,
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? AppColors.matteRed : Colors.transparent,
            ),
            child: Text(
              '${day.day}',
              style: AppTextStyles.bodyLarge.copyWith(fontSize: 15, height: 1, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.title, this.onPrevious, this.onNext});

  final String title;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPrevious,
          color: AppColors.textPrimary,
          disabledColor: AppColors.textMuted,
          icon: const Icon(Icons.chevron_left_rounded, size: 28),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
          onPressed: onNext,
          color: AppColors.textPrimary,
          disabledColor: AppColors.textMuted,
          icon: const Icon(Icons.chevron_right_rounded, size: 28),
        ),
      ],
    );
  }
}