import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';

/// Rozszerzenie mapujące pełną odpowiedź serii cyklicznej na podsumowanie widokowe.
extension TaskRecurrenceResponseMappingX on TaskRecurrenceResponse {
  /// Redukuje pełną odpowiedź edytora do lekkiego kontraktu osadzanego w Liście i Kanbanie.
  TaskRecurrenceSummaryResponse toSummary({
    required String taskId,
  }) => TaskRecurrenceSummaryResponse(
    id: id,
    sourceTaskId: sourceTaskId,
    mode: mode,
    frequency: frequency,
    interval: interval,
    timeZoneId: timeZoneId,
    nextOccurrenceAtUtc: nextOccurrenceAtUtc,
    occurrenceStatus: occurrenceStatus,
    skipIfPreviousOpen: skipIfPreviousOpen,
    isActive: isActive,
    isSourceTask: sourceTaskId == taskId,
    version: version,
  );
}
