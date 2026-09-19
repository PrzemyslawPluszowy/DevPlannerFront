import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';

/// Mapuje pełną odpowiedź serii na lekki kontrakt osadzany w List i Kanbanie.
final class TaskRecurrenceSummaryMapper {
  const TaskRecurrenceSummaryMapper._();

  static TaskRecurrenceSummaryResponse fromResponse(
    TaskRecurrenceResponse response, {
    required String taskId,
  }) {
    return TaskRecurrenceSummaryResponse(
      id: response.id,
      sourceTaskId: response.sourceTaskId,
      mode: response.mode,
      frequency: response.frequency,
      interval: response.interval,
      timeZoneId: response.timeZoneId,
      nextOccurrenceAtUtc: response.nextOccurrenceAtUtc,
      occurrenceStatus: response.occurrenceStatus,
      skipIfPreviousOpen: response.skipIfPreviousOpen,
      isActive: response.isActive,
      isSourceTask: response.sourceTaskId == taskId,
      version: response.version,
    );
  }
}
