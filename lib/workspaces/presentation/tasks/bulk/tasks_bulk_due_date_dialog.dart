import 'package:devplanner/foundation/platform/calendar_time_zone.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';

final class TasksBulkDueDateChoice {
  const TasksBulkDueDateChoice(this.value);
  final DateTime? value;
}

/// Jeden jawny moment dla atomowej komendy zbiorczej; cancel i clear są różne.
final class TasksBulkDueDateDialog extends StatefulWidget {
  const TasksBulkDueDateDialog({
    required this.currentValues,
    required this.scopeLabel,
    this.calendarTimeZoneId,
    this.hasCompleteClockScope = true,
    super.key,
  });
  final List<DateTime?> currentValues;
  final String scopeLabel;
  final String? calendarTimeZoneId;
  final bool hasCompleteClockScope;

  static Future<TasksBulkDueDateChoice?> show(
    BuildContext context, {
    required List<DateTime?> currentValues,
    required String scopeLabel,
    String? calendarTimeZoneId,
    bool hasCompleteClockScope = true,
  }) => DevPlannerModalHost.showDialog<TasksBulkDueDateChoice>(
    context,
    builder: (_) => TasksBulkDueDateDialog(
      currentValues: currentValues,
      scopeLabel: scopeLabel,
      calendarTimeZoneId: calendarTimeZoneId,
      hasCompleteClockScope: hasCompleteClockScope,
    ),
  );

  /// Odrzuca lokalny czas normalizowany przez platformę podczas przejścia DST.
  static DateTime? resolve(DateTime day, DateTime clock) {
    final local = DateTime(
      day.year,
      day.month,
      day.day,
      clock.hour,
      clock.minute,
      clock.second,
      clock.millisecond,
      clock.microsecond,
    );
    if (local.year != day.year ||
        local.month != day.month ||
        local.day != day.day ||
        local.hour != clock.hour ||
        local.minute != clock.minute) {
      return null;
    }
    return local.toUtc();
  }

  @override
  State<TasksBulkDueDateDialog> createState() => _TasksBulkDueDateDialogState();
}

final class _TasksBulkDueDateDialogState extends State<TasksBulkDueDateDialog> {
  late final ValueNotifier<DateTime> _day;
  late final ValueNotifier<DateTime> _clock;
  final ValueNotifier<bool> _invalid = ValueNotifier(false);
  late final Listenable _changes;
  late final bool _mixedClock;
  late final List<TaskDetailsSelectOption<int>> _hours;
  late final List<TaskDetailsSelectOption<int>> _minutes;
  late final String _zone;

  @override
  void initState() {
    super.initState();
    final values = widget.currentValues
        .whereType<DateTime>()
        .map((value) => value.toLocal())
        .toList(growable: false);
    final first = values.firstOrNull;
    _mixedClock =
        !widget.hasCompleteClockScope ||
        values.length != widget.currentValues.length ||
        values.any((value) => first == null || !_sameClock(value, first));
    final now = DateTime.now();
    _day = ValueNotifier(first ?? now);
    _clock = ValueNotifier(
      !_mixedClock && first != null
          ? first
          : DateTime(now.year, now.month, now.day),
    );
    _changes = Listenable.merge([_day, _clock, _invalid]);
    _hours = List.unmodifiable([
      for (var hour = 0; hour < 24; hour++)
        TaskDetailsSelectOption(
          value: hour,
          label: hour.toString().padLeft(2, '0'),
        ),
    ]);
    _minutes = List.unmodifiable([
      for (var minute = 0; minute < 60; minute++)
        TaskDetailsSelectOption(
          value: minute,
          label: minute.toString().padLeft(2, '0'),
        ),
    ]);
    _zone =
        widget.calendarTimeZoneId ??
        const CalendarTimeZone().read() ??
        now.timeZoneName;
  }

  bool _sameClock(DateTime a, DateTime b) =>
      a.hour == b.hour &&
      a.minute == b.minute &&
      a.second == b.second &&
      a.millisecond == b.millisecond &&
      a.microsecond == b.microsecond;

  Future<void> _pickDay(BuildContext anchor) async {
    final selection = await TaskDatePicker.pick(
      anchor,
      initialValue: _day.value,
      globalPosition: AppContextMenu.positionFor(anchor),
      allowClear: false,
    );
    if (!mounted || !anchor.mounted || selection?.value == null) return;
    _day.value = selection!.value!;
    _invalid.value = false;
  }

  void _hour(int value) {
    _clock.value = DateTime(2000, 1, 1, value, _clock.value.minute);
    _invalid.value = false;
  }

  void _minute(int value) {
    _clock.value = DateTime(2000, 1, 1, _clock.value.hour, value);
    _invalid.value = false;
  }

  void _submit() {
    final value = TasksBulkDueDateDialog.resolve(_day.value, _clock.value);
    if (value == null) {
      _invalid.value = true;
      return;
    }
    Navigator.of(context).pop(TasksBulkDueDateChoice(value));
  }

  void _clear() =>
      Navigator.of(context).pop(const TasksBulkDueDateChoice(null));

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _changes,
    builder: (context, _) => WorkspaceCreationModalWrapper(
      title: context.l10n.tasksBulkDueDate,
      icon: Symbols.event_rounded,
      accentColor: context.colors.primary,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      maxWidth: 460,
      onSubmit: _submit,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.scopeLabel, style: context.tasksTheme.dataStrongText),
          const SizedBox(height: 8),
          Text(
            context.l10n.tasksBulkDueExplanation,
            style: context.tasksTheme.metaText,
          ),
          if (_mixedClock) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.tasksBulkDueMixed,
              style: context.tasksTheme.metaText,
            ),
          ],
          const SizedBox(height: 16),
          Builder(
            builder: (anchor) => OutlinedButton.icon(
              onPressed: () => _pickDay(anchor),
              icon: const Icon(Symbols.calendar_today, size: 18),
              label: Text(
                DateFormat.yMMMd(
                  Localizations.localeOf(context).toLanguageTag(),
                ).format(_day.value),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TaskDetailsSelectField<int>(
                  label: context.l10n.tasksBulkHour,
                  value: _clock.value.hour,
                  options: _hours,
                  onChanged: _hour,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TaskDetailsSelectField<int>(
                  label: context.l10n.tasksBulkMinute,
                  value: _clock.value.minute,
                  options: _minutes,
                  onChanged: _minute,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.tasksBulkTimeZone(_zone),
            style: context.tasksTheme.metaText,
          ),
          if (_invalid.value) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.tasksBulkInvalidLocalTime,
              style: TextStyle(color: context.colors.error),
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _clear,
              icon: const Icon(Symbols.event_busy_rounded, size: 18),
              label: Text(context.l10n.tasksBulkClearDueDate),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  void dispose() {
    _day.dispose();
    _clock.dispose();
    _invalid.dispose();
    super.dispose();
  }
}
