import 'dart:async';

import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_state.dart';
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

  void _init(TaskRecurrenceSummaryResponse? summary) {
    if (summary != null) {
      final next =
          summary.nextOccurrenceAtUtc?.toLocal() ??
          DateTime.now().add(const Duration(days: 1));
      emit(
        TaskRecurrenceEditorLoaded(
          preset: _resolvePreset(summary.frequency, summary.interval),
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

  static TaskRecurrencePreset _resolvePreset(
    TaskRecurrenceFrequency freq,
    int interval,
  ) {
    if (freq == TaskRecurrenceFrequency.daily && interval == 1) {
      return TaskRecurrencePreset.daily;
    }
    if (freq == TaskRecurrenceFrequency.weekly && interval == 1) {
      return TaskRecurrencePreset.weekly;
    }
    if (freq == TaskRecurrenceFrequency.monthly && interval == 1) {
      return TaskRecurrencePreset.monthly;
    }
    return TaskRecurrencePreset.custom;
  }

  Future<void> _fetchFullRecurrence() async {
    final result = await repository.get(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );

    if (isClosed) return;

    final current = state;
    if (current is! TaskRecurrenceEditorLoaded) return;

    result.fold(
      (err) => emit(current.copyWith(errorMessage: err.message)),
      (data) {
        final next =
            data.nextOccurrenceAtUtc?.toLocal() ??
            DateTime.now().add(const Duration(days: 1));
        emit(
          current.copyWith(
            recurrence: data,
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
            preset: _resolvePreset(data.frequency, data.interval),
            clearError: true,
          ),
        );
      },
    );
  }

  /// Zmienia wybrany preset.
  void setPreset(TaskRecurrencePreset preset) {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded) return;

    final (freq, interval) = switch (preset) {
      TaskRecurrencePreset.daily => (TaskRecurrenceFrequency.daily, 1),
      TaskRecurrencePreset.workdays => (TaskRecurrenceFrequency.daily, 1),
      TaskRecurrencePreset.weekly => (TaskRecurrenceFrequency.weekly, 1),
      TaskRecurrencePreset.monthly => (TaskRecurrenceFrequency.monthly, 1),
      TaskRecurrencePreset.custom => (current.frequency, current.interval),
    };

    emit(
      current.copyWith(
        preset: preset,
        frequency: freq,
        interval: interval,
        clearError: true,
      ),
    );
  }

  /// Zmienia interwał w dniach/tygodniach/miesiącach.
  void setInterval(int interval) {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded) return;
    emit(current.copyWith(interval: interval, clearError: true));
  }

  /// Zmienia częstotliwość powtórzeń.
  void setFrequency(TaskRecurrenceFrequency frequency) {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded) return;
    emit(current.copyWith(frequency: frequency, clearError: true));
  }

  /// Zmienia tryb serii (harmonogram lub po ukończeniu).
  void setMode(TaskRecurrenceMode mode) {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded) return;
    emit(current.copyWith(mode: mode, clearError: true));
  }

  /// Zmienia status nowo tworzonego zadania.
  void setOccurrenceStatus(ProjectTaskStatus status) {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded) return;
    emit(current.copyWith(occurrenceStatus: status, clearError: true));
  }

  /// Zmienia flagę pomijania gdy poprzednie zadanie jest otwarte.
  void setSkipIfPreviousOpen(bool skip) {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded) return;
    emit(current.copyWith(skipIfPreviousOpen: skip, clearError: true));
  }

  /// Zmienia datę startu najbliższego wykonania.
  void setScheduledDate(DateTime date) {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded) return;
    emit(current.copyWith(scheduledDate: date, clearError: true));
  }

  /// Zmienia godzinę najbliższego wykonania.
  void setScheduledTime(TaskRecurrenceScheduledTime time) {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded) return;
    emit(current.copyWith(scheduledTime: time, clearError: true));
  }

  /// Zapisuje konfigurację powtarzania.
  Future<void> save() async {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded || current.isSaving) return;

    emit(current.copyWith(isSaving: true, clearError: true));

    final scheduledDateTimeUtc = DateTime.utc(
      current.scheduledDate.year,
      current.scheduledDate.month,
      current.scheduledDate.day,
      current.scheduledTime.hour,
      current.scheduledTime.minute,
    ).toUtc();

    final isUpdate = hasRecurrence && current.recurrence != null;
    final expectedVersion =
        current.recurrence?.version ?? _initialSummary?.version ?? taskVersion;

    final result = isUpdate
        ? await repository.update(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: taskId,
            payload: UpdateTaskRecurrencePayload(
              mode: current.mode,
              frequency: current.frequency,
              interval: current.interval,
              timeZoneId: 'Europe/Warsaw',
              nextOccurrenceAtUtc: current.mode == TaskRecurrenceMode.scheduled
                  ? scheduledDateTimeUtc
                  : null,
              occurrenceStatus: current.occurrenceStatus,
              skipIfPreviousOpen: current.skipIfPreviousOpen,
              expectedVersion: expectedVersion,
            ),
          )
        : await repository.create(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: taskId,
            payload: CreateTaskRecurrencePayload(
              mode: current.mode,
              frequency: current.frequency,
              interval: current.interval,
              timeZoneId: 'Europe/Warsaw',
              firstOccurrenceAtUtc: current.mode == TaskRecurrenceMode.scheduled
                  ? scheduledDateTimeUtc
                  : null,
              occurrenceStatus: current.occurrenceStatus,
              skipIfPreviousOpen: current.skipIfPreviousOpen,
              expectedVersion: expectedVersion,
            ),
          );

    if (isClosed) return;

    result.fold(
      (err) => emit(
        current.copyWith(
          isSaving: false,
          errorMessage: err.message,
        ),
      ),
      (res) => emit(
        TaskRecurrenceEditorSuccess(
          mutationResult: res,
          message: 'Harmonogram powtarzania został zapisany',
        ),
      ),
    );
  }

  /// Wstrzymuje lub wznawia serię.
  Future<void> toggleActive() async {
    final current = state;
    if (current is! TaskRecurrenceEditorLoaded ||
        current.isSaving ||
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
        ),
      ),
      (res) => emit(
        TaskRecurrenceEditorSuccess(
          mutationResult: res,
          message: isPausing
              ? 'Wstrzymano serię cykliczną'
              : 'Wznowiono serię cykliczną',
        ),
      ),
    );
  }

  /// Usuwa konfigurację cykliczności zadania.
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
        ),
      ),
      (res) => emit(
        const TaskRecurrenceEditorDeleted(
          message: 'Pomyślnie usunięto cykliczność zadania',
        ),
      ),
    );
  }
}
