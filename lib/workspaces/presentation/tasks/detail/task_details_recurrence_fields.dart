import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/task_recurrence_time_zone_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_labelers.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_recurrence_time_fields.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class TaskRecurrenceFields extends StatelessWidget {
  const TaskRecurrenceFields({
    required this.mode,
    required this.frequency,
    required this.intervalController,
    required this.timeZoneController,
    required this.timeZoneRepository,
    required this.timeZoneSelectionScope,
    required this.workspaceId,
    required this.projectId,
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
    required this.onTimeZoneChanged,
    super.key,
  });
  final TaskRecurrenceMode mode;
  final TaskRecurrenceFrequency frequency;
  final TextEditingController intervalController;
  final TextEditingController timeZoneController;
  final TaskRecurrenceRepository timeZoneRepository;
  final Object timeZoneSelectionScope;
  final String workspaceId;
  final String projectId;
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
  final ValueChanged<String> onTimeZoneChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TaskDetailsSelectField<TaskRecurrenceMode>(
        label: context.l10n.taskDetailsRecurrenceMode,
        value: mode,
        enabled: enabled,
        options: [
          for (final item in TaskRecurrenceMode.values)
            TaskDetailsSelectOption(
              value: item,
              label: TaskRecurrenceModeLabeler.label(context, item),
            ),
        ],
        onChanged: onModeChanged,
      ),
      const SizedBox(height: 12),
      TaskDetailsSelectField<TaskRecurrenceFrequency>(
        label: context.l10n.taskDetailsRecurrenceFrequency,
        value: frequency,
        enabled: enabled,
        options: [
          for (final item in TaskRecurrenceFrequency.values)
            TaskDetailsSelectOption(
              value: item,
              label: TaskRecurrenceFrequencyLabeler.label(context, item),
            ),
        ],
        onChanged: onFrequencyChanged,
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
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.taskDetailsRecurrenceTimeZone,
            style: context.tasksTheme.controlText,
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: TaskRecurrenceTimeZonePicker(
              repository: timeZoneRepository,
              selectionScope: timeZoneSelectionScope,
              workspaceId: workspaceId,
              projectId: projectId,
              value: timeZoneController.text,
              enabled: enabled,
              onSelected: onTimeZoneChanged,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      TaskDetailsSelectField<ProjectTaskStatus>(
        label: context.l10n.taskDetailsRecurrenceOccurrenceStatus,
        value: occurrenceStatus,
        enabled: enabled,
        options: [
          for (final item in ProjectTaskStatus.values)
            TaskDetailsSelectOption(
              value: item,
              label: TaskDetailsLabeler.status(context, item),
            ),
        ],
        onChanged: onStatusChanged,
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        activeThumbColor: context.colors.primary,
        activeTrackColor: context.colors.primaryContainer,
        inactiveTrackColor: context.colors.surfaceContainerHighest,
        title: Text(
          context.l10n.taskDetailsRecurrenceSkipPrevious,
          style: context.tasksTheme.controlText,
        ),
        value: skipIfPreviousOpen,
        onChanged: enabled ? onSkipChanged : null,
      ),
      DateField(
        label: recurrence == null
            ? context.l10n.taskDetailsRecurrenceFirstOccurrence
            : context.l10n.taskDetailsRecurrenceNextOccurrence,
        value: occurrenceAtUtc,
        format: DateFormat.yMMMd(
          Localizations.localeOf(context).toLanguageTag(),
        ),
        enabled: enabled,
        onChanged: onDateChanged,
      ),
      const SizedBox(height: 12),
      TaskRecurrenceTimeFields(
        value: occurrenceAtUtc,
        selectionScope: timeZoneSelectionScope,
        enabled: enabled,
        onChanged: onDateChanged,
      ),
      const SizedBox(height: 4),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          context.l10n.taskRecurrenceTimeZoneScheduleHint,
          style: context.tasksTheme.metaText,
        ),
      ),
    ],
  );
}
