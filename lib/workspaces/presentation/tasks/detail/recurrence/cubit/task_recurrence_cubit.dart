import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_operation_error_normalizer.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_retry_after_gate.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/session/task_detail_section_lifecycle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan lokalnego edytora serii cyklicznej zadania.
sealed class TaskRecurrenceState {
  const TaskRecurrenceState();
  bool get isRetryBlocked => false;
}

final class TaskRecurrenceLoading extends TaskRecurrenceState {
  const TaskRecurrenceLoading();
}

final class TaskRecurrenceFailure extends TaskRecurrenceState {
  const TaskRecurrenceFailure(
    this.message, {
    this.apiError,
    this.isRetryBlocked = false,
  });

  final String message;
  final ApiError? apiError;
  @override
  final bool isRetryBlocked;
}

final class TaskRecurrenceReady extends TaskRecurrenceState {
  const TaskRecurrenceReady({
    required this.recurrence,
    this.isSaving = false,
    this.error,
    this.apiError,
    this.isRetryBlocked = false,
  });

  final TaskRecurrenceResponse? recurrence;
  final bool isSaving;
  final String? error;
  final ApiError? apiError;
  @override
  final bool isRetryBlocked;

  TaskRecurrenceReady copyWith({
    TaskRecurrenceResponse? recurrence,
    bool? isSaving,
    String? error,
    ApiError? apiError,
    bool? isRetryBlocked,
    bool clearError = false,
  }) => TaskRecurrenceReady(
    recurrence: recurrence ?? this.recurrence,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
    apiError: clearError ? null : apiError ?? this.apiError,
    isRetryBlocked: isRetryBlocked ?? this.isRetryBlocked,
  );
}

/// Właściciel odczytu i wersjonowanych mutacji jednej serii cyklicznej.
final class TaskRecurrenceCubit extends Cubit<TaskRecurrenceState> {
  TaskRecurrenceCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    this.canEdit,
    this.onAccessLost,
  }) : super(const TaskRecurrenceLoading());

  final TaskRecurrenceRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  final bool Function()? canEdit;
  final void Function(ApiError)? onAccessLost;
  late final _lifecycle = TaskDetailSectionLifecycle(
    isClosed: () => isClosed,
    canEdit: canEdit,
    onAccessLost: onAccessLost,
  );
  final _retryAfter = TaskDetailRetryAfterGate();

  /// Ładuje pełną konfigurację tylko wtedy, gdy task ma serię cykliczną.
  Future<void> load({required bool hasRecurrence}) async {
    if (_retryAfter.isBlocked) return;
    if (state is TaskRecurrenceReady &&
        (state as TaskRecurrenceReady).isSaving) {
      return;
    }
    final generation = _lifecycle.begin();
    if (generation == null) return;
    if (!hasRecurrence) {
      _retryAfter.clear();
      emit(const TaskRecurrenceReady(recurrence: null));
      return;
    }
    _retryAfter.clear();
    emit(const TaskRecurrenceLoading());
    late final Either<ApiError, TaskRecurrenceResponse> result;
    try {
      result = await repository.get(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
      );
    } on Object catch (error) {
      if (!_lifecycle.isCurrent(generation)) return;
      final apiError = TaskDetailOperationErrorNormalizer.fromThrown(
        error,
        fallbackMessage: '',
      );
      _emitLoadFailure(apiError);
      return;
    }
    if (!_lifecycle.isCurrent(generation)) return;
    result.fold(
      _emitLoadFailure,
      (recurrence) {
        _retryAfter.clear();
        emit(TaskRecurrenceReady(recurrence: recurrence));
      },
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
    if (!_lifecycle.canMutate ||
        current is! TaskRecurrenceReady ||
        current.isSaving ||
        current.isRetryBlocked ||
        _retryAfter.isBlocked) {
      return false;
    }
    final generation = _lifecycle.begin()!;
    emit(current.copyWith(isSaving: true, clearError: true));
    late final Either<ApiError, TaskMutationResponse<bool>> result;
    try {
      result = await repository.delete(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        expectedVersion: recurrence?.version,
      );
    } on Object catch (error) {
      if (!_lifecycle.isCurrent(generation)) return false;
      final apiError = TaskDetailOperationErrorNormalizer.fromThrown(
        error,
        fallbackMessage: '',
      );
      _emitMutationFailure(current, apiError);
      return false;
    }
    if (!_lifecycle.isCurrent(generation)) return false;
    return result.fold(
      (error) {
        _emitMutationFailure(current, error);
        return false;
      },
      (response) {
        _retryAfter.clear();
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
    if (!_lifecycle.canMutate ||
        current is! TaskRecurrenceReady ||
        current.isSaving ||
        current.isRetryBlocked ||
        _retryAfter.isBlocked) {
      return false;
    }
    final generation = _lifecycle.begin()!;
    emit(current.copyWith(isSaving: true, clearError: true));
    late final Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>
    result;
    try {
      result = await operation(repository);
    } on Object catch (error) {
      if (!_lifecycle.isCurrent(generation)) return false;
      final apiError = TaskDetailOperationErrorNormalizer.fromThrown(
        error,
        fallbackMessage: '',
      );
      _emitMutationFailure(current, apiError);
      return false;
    }
    if (!_lifecycle.isCurrent(generation)) return false;
    return result.fold(
      (error) {
        _emitMutationFailure(current, error);
        return false;
      },
      (response) {
        _retryAfter.clear();
        emit(
          TaskRecurrenceReady(
            recurrence: response.data,
          ),
        );
        return true;
      },
    );
  }

  void _emitMutationFailure(TaskRecurrenceReady current, ApiError error) {
    _retryAfter.schedule(error, onAvailable: _publishRetryAvailable);
    emit(
      current.copyWith(
        isSaving: false,
        error: error.message,
        apiError: error,
        isRetryBlocked: _retryAfter.isBlocked,
      ),
    );
    _lifecycle.reportError(error);
  }

  void _emitLoadFailure(ApiError error) {
    _retryAfter.schedule(error, onAvailable: _publishRetryAvailable);
    emit(
      TaskRecurrenceFailure(
        error.message,
        apiError: error,
        isRetryBlocked: _retryAfter.isBlocked,
      ),
    );
    _lifecycle.reportError(error);
  }

  void _publishRetryAvailable() {
    if (isClosed) return;
    switch (state) {
      case TaskRecurrenceFailure(:final message, :final apiError):
        emit(TaskRecurrenceFailure(message, apiError: apiError));
      case TaskRecurrenceReady(:final isRetryBlocked) when isRetryBlocked:
        emit((state as TaskRecurrenceReady).copyWith(isRetryBlocked: false));
      default:
        break;
    }
  }

  @override
  Future<void> close() {
    _retryAfter.dispose();
    _lifecycle.invalidate();
    return super.close();
  }
}
