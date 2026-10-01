import 'dart:async';

import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_payload_composer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit zarządzający stanem i logiką biznesową edytora powtarzania zadania.
class TaskRecurrenceEditorCubit extends Cubit<TaskRecurrenceEditorState> {
  /// Tworzy instancję edytora.
  TaskRecurrenceEditorCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    required this.taskVersion,
    required this.hasRecurrence,
    TaskRecurrenceSummaryResponse? initialSummary,
  }) : _initialSummary = initialSummary,
       super(const TaskRecurrenceEditorInitial()) {
    _init(initialSummary);
  }

  final TaskRecurrenceRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  final int taskVersion;
  final bool hasRecurrence;
  final TaskRecurrenceSummaryResponse? _initialSummary;
  int _draftRevision = 0;
  bool _isFetchingFullRecurrence = false;

  void _init(TaskRecurrenceSummaryResponse? summary) {
    if (summary != null) {
      final next =
          summary.nextOccurrenceAtUtc?.toLocal() ??
          DateTime.now().add(const Duration(days: 1));
      emit(
        TaskRecurrenceEditorLoaded(
          preset: TaskRecurrenceEditorLoaded.resolvePreset(
            summary.frequency,
            summary.interval,
          ),
          mode: summary.mode,
          frequency: summary.frequency,
          interval: summary.interval,
          occurrenceStatus: summary.occurrenceStatus,
          skipIfPreviousOpen: summary.skipIfPreviousOpen,
          scheduledDate: DateTime(next.year, next.month, next.day),
          scheduledTime: TaskRecurrenceScheduledTime(
            hour: next.hour,
            minute: next.minute,
          ),
          hasRecurrence: hasRecurrence,
          isSourceTask: summary.isSourceTask,
        ),
      );
    } else {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      emit(
        TaskRecurrenceEditorLoaded(
          preset: TaskRecurrencePreset.weekly,
          mode: TaskRecurrenceMode.scheduled,
          frequency: TaskRecurrenceFrequency.weekly,
          interval: 1,
          occurrenceStatus: ProjectTaskStatus.todo,
          skipIfPreviousOpen: true,
          scheduledDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
          scheduledTime: const TaskRecurrenceScheduledTime(hour: 9, minute: 0),
          hasRecurrence: false,
          isSourceTask: true,
        ),
      );
    }

    if (hasRecurrence) {
      unawaited(_fetchFullRecurrence());
    }
  }

  Future<void> _fetchFullRecurrence() async {
    if (isClosed || _isFetchingFullRecurrence) return;
    final initial = state;
    if (initial is! TaskRecurrenceEditorLoaded || initial.isSaving) return;
    _isFetchingFullRecurrence = true;
    final revision = _draftRevision;
    emit(initial.copyWith(isLoadingRecurrence: true, clearError: true));
    try {
      final result = await repository.get(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
      );

      if (isClosed) return;

      final current = state;
      if (current is! TaskRecurrenceEditorLoaded) return;

      result.fold(
        (err) => emit(
          current.copyWith(
            isLoadingRecurrence: false,
            errorMessage: err.message,
            apiError: err,
            errorOperation: TaskRecurrenceEditorErrorOperation.load,
          ),
        ),
        (data) {
          if (_draftRevision != revision) {
            emit(
              current.copyWith(
                recurrence: data,
                isLoadingRecurrence: false,
                clearError: true,
              ),
            );
            return;
          }
          final next =
              data.nextOccurrenceAtUtc?.toLocal() ??
              DateTime.now().add(const Duration(days: 1));
          emit(
            current.copyWith(
              recurrence: data,
              isLoadingRecurrence: false,
              mode: data.mode,
              frequency: data.frequency,
              interval: data.interval,
              occurrenceStatus: data.occurrenceStatus,
              skipIfPreviousOpen: data.skipIfPreviousOpen,
              scheduledDate: DateTime(next.year, next.month, next.day),
              scheduledTime: TaskRecurrenceScheduledTime(
                hour: next.hour,
                minute: next.minute,
              ),
              preset: TaskRecurrenceEditorLoaded.resolvePreset(
                data.frequency,
                data.interval,
              ),
              clearError: true,
            ),
          );
        },
      );
    } finally {
      _isFetchingFullRecurrence = false;
    }
  }

  Future<void> retryLoad() => _fetchFullRecurrence();

  TaskRecurrenceEditorLoaded? _editableState() {
    final current = state;
    return current is TaskRecurrenceEditorLoaded && !current.isSaving
        ? current
        : null;
  }

  void setPreset(TaskRecurrencePreset preset) {
    final current = _editableState();
    if (current == null) return;

    final (freq, interval) = switch (preset) {
      TaskRecurrencePreset.daily => (TaskRecurrenceFrequency.daily, 1),
      TaskRecurrencePreset.workdays => (TaskRecurrenceFrequency.daily, 1),
      TaskRecurrencePreset.weekly => (TaskRecurrenceFrequency.weekly, 1),
      TaskRecurrencePreset.monthly => (TaskRecurrenceFrequency.monthly, 1),
      TaskRecurrencePreset.custom => (current.frequency, current.interval),
    };

    _draftRevision++;
    emit(
      current.copyWith(
        preset: preset,
        frequency: freq,
        interval: interval,
        clearError: true,
      ),
    );
  }

  void setInterval(int interval) {
    final current = _editableState();
    if (current == null) return;
    _draftRevision++;
    emit(current.copyWith(interval: interval, clearError: true));
  }

  void setFrequency(TaskRecurrenceFrequency frequency) {
    final current = _editableState();
    if (current == null) return;
    _draftRevision++;
    emit(current.copyWith(frequency: frequency, clearError: true));
  }

  void setMode(TaskRecurrenceMode mode) {
    final current = _editableState();
    if (current == null) return;
    _draftRevision++;
    emit(current.copyWith(mode: mode, clearError: true));
  }

  void setOccurrenceStatus(ProjectTaskStatus status) {
    final current = _editableState();
    if (current == null) return;
    _draftRevision++;
    emit(current.copyWith(occurrenceStatus: status, clearError: true));
  }

  void setSkipIfPreviousOpen(bool skip) {
    final current = _editableState();
    if (current == null) return;
    _draftRevision++;
    emit(current.copyWith(skipIfPreviousOpen: skip, clearError: true));
  }

  void setScheduledDate(DateTime date) {
    final current = _editableState();
    if (current == null) return;
    _draftRevision++;
    emit(current.copyWith(scheduledDate: date, clearError: true));
  }

  void setScheduledTime(TaskRecurrenceScheduledTime time) {
    final current = _editableState();
    if (current == null) return;
    _draftRevision++;
    emit(current.copyWith(scheduledTime: time, clearError: true));
  }

  Future<void> save() async {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded ||
        current.isSaving ||
        current.isLoadingRecurrence ||
        (hasRecurrence && current.recurrence == null)) {
      return;
    }

    emit(current.copyWith(isSaving: true, clearError: true));

    final isUpdate = hasRecurrence;
    final payloads = TaskRecurrencePayloadComposer(
      state: current,
      taskVersion: taskVersion,
      initialSummary: _initialSummary,
    );

    final result = isUpdate
        ? await repository.update(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: taskId,
            payload: payloads.update(),
          )
        : await repository.create(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: taskId,
            payload: payloads.create(),
          );

    if (isClosed) return;

    result.fold(
      (err) => emit(
        current.copyWith(
          isSaving: false,
          errorMessage: err.message,
          apiError: err,
          errorOperation: isUpdate
              ? TaskRecurrenceEditorErrorOperation.update
              : TaskRecurrenceEditorErrorOperation.create,
        ),
      ),
      (res) => emit(
        TaskRecurrenceEditorSuccess(
          mutationResult: res,
          operation: TaskRecurrenceEditorSuccessOperation.saved,
        ),
      ),
    );
  }

  Future<void> toggleActive() async {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded ||
        current.isSaving ||
        current.isLoadingRecurrence ||
        current.recurrence == null) {
      return;
    }

    emit(current.copyWith(isSaving: true, clearError: true));

    final isPausing = current.isActive;
    final expectedVersion = current.recurrence!.version;

    final result = isPausing
        ? await repository.pause(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: taskId,
            expectedVersion: expectedVersion,
          )
        : await repository.resume(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: taskId,
            expectedVersion: expectedVersion,
          );

    if (isClosed) return;

    result.fold(
      (err) => emit(
        current.copyWith(
          isSaving: false,
          errorMessage: err.message,
          apiError: err,
          errorOperation: isPausing
              ? TaskRecurrenceEditorErrorOperation.pause
              : TaskRecurrenceEditorErrorOperation.resume,
        ),
      ),
      (res) => emit(
        TaskRecurrenceEditorSuccess(
          mutationResult: res,
          operation: isPausing
              ? TaskRecurrenceEditorSuccessOperation.paused
              : TaskRecurrenceEditorSuccessOperation.resumed,
        ),
      ),
    );
  }

  Future<void> delete() async {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded ||
        current.isSaving ||
        !hasRecurrence) {
      return;
    }

    emit(current.copyWith(isSaving: true, clearError: true));

    final expectedVersion = current.recurrence?.version;

    final result = await repository.delete(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      expectedVersion: expectedVersion,
    );

    if (isClosed) return;

    result.fold(
      (err) => emit(
        current.copyWith(
          isSaving: false,
          errorMessage: err.message,
          apiError: err,
          errorOperation: TaskRecurrenceEditorErrorOperation.delete,
        ),
      ),
      (res) => emit(
        const TaskRecurrenceEditorDeleted(),
      ),
    );
  }
}
