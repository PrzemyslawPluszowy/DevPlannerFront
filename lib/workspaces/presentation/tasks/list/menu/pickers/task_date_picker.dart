import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wynik wyboru zakotwiczonej daty.
class AnchoredDateSelection {
  const AnchoredDateSelection(this.value);

  final DateTime? value;
}

/// Otwiera zakotwiczony kalendarz i normalizuje daty do początku dnia UTC.
///
/// Klasa obsługuje wyłącznie lokalne UI; zapis wybranej daty należy do
/// callbacku właściciela widoku/Cubita.
final class TaskDatePicker {
  const TaskDatePicker._();

  static DateTime? asUtcCalendarDate(DateTime? value) =>
      value == null ? null : DateTime.utc(value.year, value.month, value.day);

  static Future<AnchoredDateSelection?> pick(
    BuildContext context, {
    required DateTime? initialValue,
    required Offset globalPosition,
    bool allowClear = true,
  }) async {
    final result = Completer<AnchoredDateSelection?>();
    await AppContextMenu.showCustom(
      context,
      globalPosition: globalPosition,
      maxWidth: 350,
      contentBuilder: (_, dismiss) => CompactWebDatePickerPanel(
        initialValue: initialValue,
        onSelected: (value) {
          if (!result.isCompleted) {
            result.complete(AnchoredDateSelection(value));
          }
          dismiss();
        },
        onCleared: allowClear
            ? () {
                if (!result.isCompleted) {
                  result.complete(const AnchoredDateSelection(null));
                }
                dismiss();
              }
            : null,
        onCancelled: dismiss,
      ),
    );
    return result.isCompleted ? result.future : null;
  }
}

/// Kompaktowy panel wyboru daty zakotwiczony w menu kontekstowym wiersza.
class CompactWebDatePickerPanel extends StatefulWidget {
  const CompactWebDatePickerPanel({
    required this.initialValue,
    required this.onSelected,
    this.onCleared,
    required this.onCancelled,
    super.key,
  });

  final DateTime? initialValue;
  final ValueChanged<DateTime> onSelected;
  final VoidCallback? onCleared;
  final VoidCallback onCancelled;

  @override
  State<CompactWebDatePickerPanel> createState() =>
      _CompactWebDatePickerPanelState();
}

class _CompactWebDatePickerPanelState extends State<CompactWebDatePickerPanel> {
  late final ValueNotifier<DateTime> _selectedDay = ValueNotifier(
    widget.initialValue?.toLocal() ?? DateTime.now(),
  );
  late final ValueNotifier<DateTime> _displayedMonth = ValueNotifier(
    DateTime(_selectedDay.value.year, _selectedDay.value.month),
  );

  @override
  void dispose() {
    _selectedDay.dispose();
    _displayedMonth.dispose();
    super.dispose();
  }

  void _selectPreset(DateTime date) {
    _selectedDay.value = date;
    _displayedMonth.value = DateTime(date.year, date.month);
  }

  void _previousMonth() {
    final month = _displayedMonth.value;
    _displayedMonth.value = DateTime(month.year, month.month - 1);
  }

  void _nextMonth() {
    final month = _displayedMonth.value;
    _displayedMonth.value = DateTime(month.year, month.month + 1);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([_selectedDay, _displayedMonth]),
    builder: (context, _) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final locale = Localizations.localeOf(context).toLanguageTag();
      final monthName = DateFormat.yMMMM(locale).format(_displayedMonth.value);

      return SizedBox(
        width: 310,
        child: Padding(
          padding: const .all(Sizes.p8),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPresets(context, today),
              const SizedBox(height: Sizes.p8),
              _buildMonthHeader(context, monthName),
              const SizedBox(height: Sizes.p4),
              _buildWeekDaysHeader(context, locale),
              const SizedBox(height: Sizes.p2),
              _buildDaysGrid(context, today),
              const SizedBox(height: Sizes.p8),
              _buildActionFooter(context),
            ],
          ),
        ),
      );
    },
  );

  Widget _buildPresets(BuildContext context, DateTime today) {
    final presets = [
      (
        context.l10n.tasksListDatePresetToday,
        today,
      ),
      (
        context.l10n.tasksListDatePresetTomorrow,
        today.add(const Duration(days: 1)),
      ),
      (
        context.l10n.tasksListDatePresetNextWeek,
        today.add(const Duration(days: 7)),
      ),
      (
        context.l10n.tasksListDatePresetNextMonth,
        DateTime(today.year, today.month + 1, today.day),
      ),
    ];

    return Wrap(
      spacing: Sizes.p4,
      runSpacing: Sizes.p4,
      children: [
        for (final (label, date) in presets)
          InkWell(
            borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
            onTap: () => _selectPreset(date),
            child: Container(
              padding: const .symmetric(
                horizontal: Sizes.p6,
                vertical: Sizes.p2,
              ),
              decoration: BoxDecoration(
                color: _isSameDay(_selectedDay.value, date)
                    ? context.colors.primaryContainer
                    : context.colors.surfaceContainerHighest.withValues(
                        alpha: .5,
                      ),
                borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
                border: Border.all(
                  color: _isSameDay(_selectedDay.value, date)
                      ? context.colors.primary.withValues(alpha: .4)
                      : context.colors.outlineVariant.withValues(alpha: .4),
                ),
              ),
              child: Text(
                label,
                style: context.text.labelSmall?.copyWith(
                  fontSize: 11,
                  fontWeight: _isSameDay(_selectedDay.value, date)
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMonthHeader(BuildContext context, String monthName) => Row(
    children: [
      Text(
        monthName,
        style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      const Spacer(),
      IconButton(
        visualDensity: .compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 24, height: 24),
        onPressed: _previousMonth,
        icon: const Icon(Symbols.chevron_left_rounded, size: 18),
      ),
      IconButton(
        visualDensity: .compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 24, height: 24),
        onPressed: _nextMonth,
        icon: const Icon(Symbols.chevron_right_rounded, size: 18),
      ),
    ],
  );

  Widget _buildWeekDaysHeader(BuildContext context, String locale) {
    final firstDayOfWeek = MaterialLocalizations.of(context)
        .firstDayOfWeekIndex;
    final now = DateTime.now();
    final currentDayOfWeek = now.weekday % 7;
    final sunday = now.subtract(Duration(days: currentDayOfWeek));

    final weekDays = List.generate(7, (index) {
      final day = sunday.add(Duration(days: (firstDayOfWeek + index) % 7));
      return DateFormat.E(locale).format(day).substring(0, 2);
    });

    return Row(
      children: [
        for (final day in weekDays)
          Expanded(
            child: Center(
              child: Text(
                day,
                style: context.text.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant.withValues(alpha: .6),
                  fontSize: context.tasksTheme.metaText.fontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDaysGrid(BuildContext context, DateTime today) {
    final firstDayOfMonth = DateTime(
      _displayedMonth.value.year,
      _displayedMonth.value.month,
    );
    final daysInMonth = DateTime(
      _displayedMonth.value.year,
      _displayedMonth.value.month + 1,
      0,
    ).day;
    final firstDayOfWeek = MaterialLocalizations.of(context)
        .firstDayOfWeekIndex;
    final startingWeekday =
        (firstDayOfMonth.weekday % 7 - firstDayOfWeek + 7) % 7;
    final totalCells = ((startingWeekday + daysInMonth) / 7).ceil() * 7;

    return Column(
      children: [
        for (var row = 0; row < totalCells / 7; row++)
          Row(
            children: [
              for (var col = 0; col < 7; col++) ...[
                () {
                  final cellIndex = row * 7 + col;
                  final dayNumber = cellIndex - startingWeekday + 1;
                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const Expanded(child: SizedBox(height: 28));
                  }
                  final cellDate = DateTime(
                    _displayedMonth.value.year,
                    _displayedMonth.value.month,
                    dayNumber,
                  );
                  final isSelected = _isSameDay(_selectedDay.value, cellDate);
                  final isToday = _isSameDay(today, cellDate);

                  return Expanded(
                    child: InkWell(
                      borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
                      onTap: () => _selectedDay.value = cellDate,
                      child: Container(
                        height: 28,
                        alignment: .center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.colors.primary
                              : isToday
                              ? context.colors.primaryContainer.withValues(
                                  alpha: .4,
                                )
                              : null,
                          borderRadius: const BorderRadius.all(
                            .circular(Sizes.p4),
                          ),
                        ),
                        child: Text(
                          '$dayNumber',
                          style: context.text.bodySmall?.copyWith(
                            color: isSelected
                                ? context.colors.onPrimary
                                : isToday
                                ? context.colors.primary
                                : context.colors.onSurface,
                            fontWeight: isSelected || isToday
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }(),
              ],
            ],
          ),
      ],
    );
  }

  Widget _buildActionFooter(BuildContext context) => Row(
    children: [
      if (widget.onCleared != null)
        TextButton(
          style: TextButton.styleFrom(
            visualDensity: .compact,
            padding: const .symmetric(horizontal: Sizes.p4, vertical: Sizes.p4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: widget.onCleared,
          child: Text(
            context.l10n.tasksListClearDateButton,
            style: context.text.labelSmall,
          ),
        ),
      const Spacer(),
      TextButton(
        style: TextButton.styleFrom(
          visualDensity: .compact,
          padding: const .symmetric(horizontal: Sizes.p4, vertical: Sizes.p4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: widget.onCancelled,
        child: Text(
          context.l10n.tasksListCancelButton,
          style: context.text.labelSmall,
        ),
      ),
      const SizedBox(width: Sizes.p4),
      FilledButton(
        style: FilledButton.styleFrom(
          visualDensity: .compact,
          padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => widget.onSelected(_selectedDay.value),
        child: Text(
          context.l10n.tasksListSaveButton,
          style: context.tasksTheme.controlText.copyWith(
            color: context.tasksTheme.onAccent,
          ),
        ),
      ),
    ],
  );

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
