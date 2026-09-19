import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan lokalnego edytora serii cyklicznej zadania.
sealed class TaskRecurrenceState {
  const TaskRecurrenceState();
}

final class TaskRecurrenceLoading extends TaskRecurrenceState {
  const TaskRecurrenceLoading();
}

final class TaskRecurrenceFailure extends TaskRecurrenceState {
  const TaskRecurrenceFailure(this.message);

  final String message;
}

final class TaskRecurrenceReady extends TaskRecurrenceState {
  const TaskRecurrenceReady({
    required this.recurrence,
    this.isSaving = false,
    this.error,
  });

  final TaskRecurrenceResponse? recurrence;
  final bool isSaving;
  final String? error;

  TaskRecurrenceReady copyWith({
    TaskRecurrenceResponse? recurrence,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) => TaskRecurrenceReady(
    recurrence: recurrence ?? this.recurrence,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
  );
}

/// Właściciel odczytu i wersjonowanych mutacji jednej serii cyklicznej.
final class TaskRecurrenceCubit extends Cubit<TaskRecurrenceState> {
  TaskRecurrenceCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  }) : super(const TaskRecurrenceLoading());

  final TaskRecurrenceRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;

  /// Ładuje pełną konfigurację tylko wtedy, gdy task ma serię cykliczną.
  Future<void> load({required bool hasRecurrence}) async {
    if (!hasRecurrence) {
      emit(const TaskRecurrenceReady(recurrence: null));
      return;
    }
    emit(const TaskRecurrenceLoading());
    final result = await repository.get(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(TaskRecurrenceFailure(error.message)),
      (recurrence) => emit(TaskRecurrenceReady(recurrence: recurrence)),
    );
  }

  /// Tworzy serię na wersji agregatu taska przekazanej przez detail.
  Future<bool> create(CreateTaskRecurrencePayload payload) => _save(
    (repository) => repository.create(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: payload,
    ),
  );

  /// Aktualizuje pełną konfigurację na aktualnej wersji serii.
  Future<bool> update(UpdateTaskRecurrencePayload payload) => _save(
    (repository) => repository.update(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: payload,
    ),
  );

  /// Wstrzymuje lub wznawia serię z `expectedVersion` konfiguracji.
  Future<bool> toggleActive() {
    final recurrence = switch (state) {
      TaskRecurrenceReady(:final recurrence?) => recurrence,
      _ => null,
    };
    if (recurrence == null) return Future.value(false);
    return _save(
      (repository) => recurrence.isActive
          ? repository.pause(
              workspaceId: workspaceId,
              projectId: projectId,
              taskId: taskId,
              expectedVersion: recurrence.version,
            )
          : repository.resume(
              workspaceId: workspaceId,
              projectId: projectId,
              taskId: taskId,
              expectedVersion: recurrence.version,
            ),
    );
  }

  /// Usuwa regułę powtarzania zadania.
  Future<bool> delete() async {
    final recurrence = switch (state) {
      TaskRecurrenceReady(:final recurrence?) => recurrence,
      _ => null,
    };
    final current = state;
    if (current is! TaskRecurrenceReady || current.isSaving) return false;
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.delete(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      expectedVersion: recurrence?.version,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (response) {
        emit(const TaskRecurrenceReady(recurrence: null));
        return true;
      },
    );
  }

  Future<bool> _save(
    Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
    Function(TaskRecurrenceRepository repository)
    operation,
  ) async {
    final current = state;
    if (current is! TaskRecurrenceReady || current.isSaving) return false;
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await operation(repository);
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (response) {
        emit(
          TaskRecurrenceReady(
            recurrence: response.data,
          ),
        );
        return true;
      },
    );
  }
}
