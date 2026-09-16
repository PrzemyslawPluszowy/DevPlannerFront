part of 'task_details_page.dart';

class _TaskRecurrenceFields extends StatelessWidget {
  const _TaskRecurrenceFields({
    required this.mode,
    required this.frequency,
    required this.intervalController,
    required this.timeZoneController,
    required this.occurrenceStatus,
    required this.skipIfPreviousOpen,
    required this.occurrenceAtUtc,
    required this.recurrence,
    required this.enabled,
    required this.onModeChanged,
    required this.onFrequencyChanged,
    required this.onStatusChanged,
    required this.onSkipChanged,
    required this.onDateChanged,
  });
  final TaskRecurrenceMode mode;
  final TaskRecurrenceFrequency frequency;
  final TextEditingController intervalController;
  final TextEditingController timeZoneController;
  final ProjectTaskStatus occurrenceStatus;
  final bool skipIfPreviousOpen;
  final DateTime? occurrenceAtUtc;
  final TaskRecurrenceResponse? recurrence;
  final bool enabled;
  final ValueChanged<TaskRecurrenceMode> onModeChanged;
  final ValueChanged<TaskRecurrenceFrequency> onFrequencyChanged;
  final ValueChanged<ProjectTaskStatus> onStatusChanged;
  final ValueChanged<bool> onSkipChanged;
  final ValueChanged<DateTime?> onDateChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      DropdownButtonFormField<TaskRecurrenceMode>(
        initialValue: mode,
        decoration: InputDecoration(
          labelText: context.l10n.taskDetailsRecurrenceMode,
        ),
        items: [
          for (final item in TaskRecurrenceMode.values)
            DropdownMenuItem(
              value: item,
              child: Text(_recurrenceModeLabel(context, item)),
            ),
        ],
        onChanged: enabled
            ? (value) {
                if (value != null) onModeChanged(value);
              }
            : null,
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<TaskRecurrenceFrequency>(
        initialValue: frequency,
        decoration: InputDecoration(
          labelText: context.l10n.taskDetailsRecurrenceFrequency,
        ),
        items: [
          for (final item in TaskRecurrenceFrequency.values)
            DropdownMenuItem(
              value: item,
              child: Text(_recurrenceFrequencyLabel(context, item)),
            ),
        ],
        onChanged: enabled
            ? (value) {
                if (value != null) onFrequencyChanged(value);
              }
            : null,
      ),
      const SizedBox(height: 12),
      TextField(
        controller: intervalController,
        enabled: enabled,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: context.l10n.taskDetailsRecurrenceInterval,
        ),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: timeZoneController,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: context.l10n.taskDetailsRecurrenceTimeZone,
        ),
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<ProjectTaskStatus>(
        initialValue: occurrenceStatus,
        decoration: InputDecoration(
          labelText: context.l10n.taskDetailsRecurrenceOccurrenceStatus,
        ),
        items: [
          for (final item in ProjectTaskStatus.values)
            DropdownMenuItem(
              value: item,
              child: Text(_statusLabel(context, item)),
            ),
        ],
        onChanged: enabled
            ? (value) {
                if (value != null) onStatusChanged(value);
              }
            : null,
      ),
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(context.l10n.taskDetailsRecurrenceSkipPrevious),
        value: skipIfPreviousOpen,
        onChanged: enabled ? onSkipChanged : null,
      ),
      _DateField(
        label: recurrence == null
            ? context.l10n.taskDetailsRecurrenceFirstOccurrence
            : context.l10n.taskDetailsRecurrenceNextOccurrence,
        value: occurrenceAtUtc,
        format: DateFormat.yMMMd(),
        enabled: enabled,
        onChanged: onDateChanged,
      ),
    ],
  );
}
