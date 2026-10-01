import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_state.dart';

/// Mapuje szkic formularza na kontrakt bez zmiany strefy istniejącej serii.
final class TaskRecurrencePayloadComposer {
  const TaskRecurrencePayloadComposer({
    required this.state,
    required this.taskVersion,
    this.initialSummary,
  });

  final TaskRecurrenceEditorLoaded state;
  final int taskVersion;
  final TaskRecurrenceSummaryResponse? initialSummary;

  int get _expectedVersion =>
      state.recurrence?.version ?? initialSummary?.version ?? taskVersion;
  String get _timeZoneId =>
      state.recurrence?.timeZoneId ??
      initialSummary?.timeZoneId ??
      'Europe/Warsaw';

  // Formularz wyświetla datę i godzinę w lokalnej strefie urządzenia. Payload
  // przekazuje ten sam moment w UTC, zamiast oznaczać lokalne składowe jako UTC.
  DateTime? get _scheduledAtUtc => state.mode != TaskRecurrenceMode.scheduled
      ? null
      : DateTime(
          state.scheduledDate.year,
          state.scheduledDate.month,
          state.scheduledDate.day,
          state.scheduledTime.hour,
          state.scheduledTime.minute,
        ).toUtc();

  CreateTaskRecurrencePayload create() => CreateTaskRecurrencePayload(
    mode: state.mode,
    frequency: state.frequency,
    interval: state.interval,
    timeZoneId: _timeZoneId,
    firstOccurrenceAtUtc: _scheduledAtUtc,
    occurrenceStatus: state.occurrenceStatus,
    skipIfPreviousOpen: state.skipIfPreviousOpen,
    expectedVersion: _expectedVersion,
  );

  UpdateTaskRecurrencePayload update() => UpdateTaskRecurrencePayload(
    mode: state.mode,
    frequency: state.frequency,
    interval: state.interval,
    timeZoneId: _timeZoneId,
    nextOccurrenceAtUtc: _scheduledAtUtc,
    occurrenceStatus: state.occurrenceStatus,
    skipIfPreviousOpen: state.skipIfPreviousOpen,
    expectedVersion: _expectedVersion,
  );
}
