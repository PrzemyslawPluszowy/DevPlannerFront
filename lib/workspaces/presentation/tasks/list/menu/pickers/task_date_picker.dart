import 'dart:async';

import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker_content.dart';
import 'package:flutter/material.dart';

/// Wynik wyboru zakotwiczonej daty.
class AnchoredDateSelection {
  const AnchoredDateSelection(this.value);

  final DateTime? value;
}

/// Otwiera wspólny, kompaktowy kalendarz używany przez Listę i Kanban.
final class TaskDatePicker {
  const TaskDatePicker._();

  static DateTime? asUtcCalendarDate(DateTime? value) =>
      value == null ? null : DateTime.utc(value.year, value.month, value.day);

  /// Maps a selected local calendar day onto an existing UTC task instant.
  /// New values use local midnight; changing a date preserves its local clock.
  static DateTime? asUtcTaskInstant(DateTime? selectedDay, DateTime? current) {
    if (selectedDay == null) return null;
    final localCurrent = current?.toLocal();
    return DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
      localCurrent?.hour ?? 0,
      localCurrent?.minute ?? 0,
      localCurrent?.second ?? 0,
      localCurrent?.millisecond ?? 0,
      localCurrent?.microsecond ?? 0,
    ).toUtc();
  }

  static Future<AnchoredDateSelection?> pick(
    BuildContext context, {
    required DateTime? initialValue,
    required Offset globalPosition,
    bool allowClear = true,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final result = Completer<AnchoredDateSelection?>();
    await AppContextMenu.showCustom(
      context,
      globalPosition: globalPosition,
      maxWidth: 348,
      maxHeight: 560,
      contentBuilder: (_, dismiss) => CompactWebDatePickerPanel(
        initialValue: initialValue,
        firstDate: firstDate ?? DateTime(1900),
        lastDate: lastDate ?? DateTime(2100),
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

/// Stan i zasoby jednej instancji kalendarza w menu.
class CompactWebDatePickerPanel extends StatefulWidget {
  const CompactWebDatePickerPanel({
    required this.initialValue,
    required this.firstDate,
    required this.lastDate,
    required this.onSelected,
    required this.onCancelled,
    this.onCleared,
    super.key,
  });

  /// Dzień kalendarzowy; wywołujący przelicza timestamp na lokalny czas przed
  /// przekazaniem, jeśli jego pole reprezentuje moment zamiast samej daty.
  final DateTime? initialValue;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;
  final VoidCallback? onCleared;
  final VoidCallback onCancelled;

  @override
  State<CompactWebDatePickerPanel> createState() =>
      _CompactWebDatePickerPanelState();
}

class _CompactWebDatePickerPanelState extends State<CompactWebDatePickerPanel> {
  late final ValueNotifier<DateTime> _selectedDay;
  late final ValueNotifier<DateTime> _displayedMonth;
  late final Listenable _calendarChanges;

  @override
  void initState() {
    super.initState();
    final initial = _clampDate(
      widget.initialValue ?? DateTime.now(),
    );
    _selectedDay = ValueNotifier(initial);
    _displayedMonth = ValueNotifier(DateTime(initial.year, initial.month));
    _calendarChanges = Listenable.merge([_selectedDay, _displayedMonth]);
  }

  DateTime _clampDate(DateTime value) {
    final day = DateTime(value.year, value.month, value.day);
    final first = DateTime(
      widget.firstDate.year,
      widget.firstDate.month,
      widget.firstDate.day,
    );
    final last = DateTime(
      widget.lastDate.year,
      widget.lastDate.month,
      widget.lastDate.day,
    );
    if (day.isBefore(first)) return first;
    if (day.isAfter(last)) return last;
    return day;
  }

  @override
  void didUpdateWidget(CompactWebDatePickerPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue ||
        oldWidget.firstDate != widget.firstDate ||
        oldWidget.lastDate != widget.lastDate) {
      final next = _clampDate(widget.initialValue ?? DateTime.now());
      _selectedDay.value = next;
      _displayedMonth.value = DateTime(next.year, next.month);
    }
  }

  @override
  void dispose() {
    _selectedDay.dispose();
    _displayedMonth.dispose();
    super.dispose();
  }

  void _selectDate(DateTime value) {
    _selectedDay.value = _clampDate(value);
  }

  void _selectPreset(DateTime value) {
    final selected = _clampDate(value);
    _selectedDay.value = selected;
    _displayedMonth.value = DateTime(selected.year, selected.month);
  }

  void _showPreviousMonth() {
    final month = _displayedMonth.value;
    _displayedMonth.value = DateTime(month.year, month.month - 1);
  }

  void _showNextMonth() {
    final month = _displayedMonth.value;
    _displayedMonth.value = DateTime(month.year, month.month + 1);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _calendarChanges,
    builder: (context, _) => TaskDatePickerContent(
      selectedDate: _selectedDay.value,
      displayedMonth: _displayedMonth.value,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      onSelected: _selectDate,
      onPresetSelected: _selectPreset,
      onShowPreviousMonth: _showPreviousMonth,
      onShowNextMonth: _showNextMonth,
      onCleared: widget.onCleared,
      onCancelled: widget.onCancelled,
      onConfirmed: () => widget.onSelected(_selectedDay.value),
    ),
  );
}
