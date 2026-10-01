import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';

sealed class TaskTimeTrackingState {
  const TaskTimeTrackingState();
  bool get isRetryBlocked => false;
}

final class TaskTimeTrackingLoading extends TaskTimeTrackingState {
  const TaskTimeTrackingLoading();
}

final class TaskTimeTrackingFailure extends TaskTimeTrackingState {
  const TaskTimeTrackingFailure(
    this.message, {
    this.apiError,
    this.isRetryBlocked = false,
  });
  final String message;
  final ApiError? apiError;
  @override
  final bool isRetryBlocked;
}

final class TaskTimeTrackingReady extends TaskTimeTrackingState {
  TaskTimeTrackingReady({
    required List<TaskTimeEntryResponse> entries,
    this.isSaving = false,
    this.error,
    this.apiError,
    this.isRetryBlocked = false,
    this.nowUtc,
  }) : entries = List.unmodifiable(entries),
       totalMinutes = _totalMinutes(entries, nowUtc),
       activeTimers = List.unmodifiable(
         entries.where(
           (entry) =>
               entry.kind == TaskTimeEntryKind.timer &&
               entry.stoppedAtUtc == null,
         ),
       ),
       ownActiveTimers = List.unmodifiable(
         entries.where((entry) => entry.canStopTimer),
       );
  final List<TaskTimeEntryResponse> entries;
  final bool isSaving;
  final String? error;
  final ApiError? apiError;
  @override
  final bool isRetryBlocked;
  final DateTime? nowUtc;
  final List<TaskTimeEntryResponse> activeTimers;
  final List<TaskTimeEntryResponse> ownActiveTimers;
  final int totalMinutes;

  static int _totalMinutes(
    List<TaskTimeEntryResponse> entries,
    DateTime? nowUtc,
  ) {
    final now = nowUtc ?? DateTime.now().toUtc();
    return entries.fold<int>(
      0,
      (sum, entry) =>
          sum +
          (entry.durationMinutes ??
              (entry.stoppedAtUtc ?? now)
                  .difference(entry.startedAtUtc)
                  .inMinutes
                  .clamp(0, 1 << 31)),
    );
  }

  TaskTimeTrackingReady copyWith({
    List<TaskTimeEntryResponse>? entries,
    bool? isSaving,
    String? error,
    ApiError? apiError,
    bool? isRetryBlocked,
    bool clearError = false,
    DateTime? nowUtc,
  }) => TaskTimeTrackingReady(
    entries: entries ?? this.entries,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
    apiError: clearError ? null : apiError ?? this.apiError,
    isRetryBlocked: isRetryBlocked ?? this.isRetryBlocked,
    nowUtc: nowUtc ?? this.nowUtc,
  );
}
