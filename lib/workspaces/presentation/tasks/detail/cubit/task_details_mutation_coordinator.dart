import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_response_assembler.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';

/// Wspólna orkiestracja zapisu, konfliktu wersji i odświeżenia detalu.
///
/// Koordynator nie zna widgetów ani routingu. Otrzymuje tylko callback emisji
/// stanu, dzięki czemu Cubit pozostaje cienkim adapterem prezentacji.
final class TaskDetailsMutationCoordinator {
  const TaskDetailsMutationCoordinator({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    required this.emitState,
    required this.isClosed,
    required this.readState,
  });

  final TasksRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  final void Function(TaskDetailsState state) emitState;
  final bool Function() isClosed;
  final TaskDetailsState Function() readState;

  Future<bool> execute<T>({
    required TaskDetailsReady current,
    Object? mutationOwner,
    required Future<Either<ApiError, T>> operation,
    required TaskDetailsReady Function(TaskDetailsReady current, T value)
    onSuccess,
  }) async {
    final result = await operation;
    if (isClosed() || readState() is! TaskDetailsReady) return false;
    final latest = readState();
    if (latest is! TaskDetailsReady) return false;
    return result.fold(
      (error) => _handleError(current, error, mutationOwner),
      (value) {
        final updated = onSuccess(latest, value);
        emitState(
          updated.details.task.version < latest.details.task.version
              ? latest.copyWith(isSaving: false, clearMutationError: true)
              : updated,
        );
        return true;
      },
    );
  }

  /// Błąd gałęzi odświeża ACL; brak odczytu usuwa cały chroniony agregat.
  Future<void> checkAccess(ApiError error) async {
    if (isClosed()) return;
    if (error.type != ApiErrorType.forbidden &&
        error.type != ApiErrorType.notFound) {
      _emitAccessFailure(error);
      return;
    }
    final refreshed = await _load();
    if (isClosed()) return;
    refreshed.fold(
      _emitAccessFailure,
      (details) {
        final latest = readState();
        if (latest is! TaskDetailsReady) return;
        emitState(
          latest.copyWith(
            details: details.task.version >= latest.details.task.version
                ? details
                : latest.details.copyWith(capabilities: details.capabilities),
          ),
        );
      },
    );
  }

  Future<bool> executeProjectTask(
    TaskDetailsReady current,
    Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
    operation,
    TaskDetailsResponseAssembler assembler,
  ) {
    emitState(current.copyWith(isSaving: true, clearMutationError: true));
    return execute<TaskMutationResponse<ProjectTaskResponse>>(
      current: current,
      operation: operation,
      onSuccess: assembler.withProjectTaskMutation,
    );
  }

  Future<bool> refresh(
    TaskDetailsReady previous, {
    Object? mutationOwner,
  }) async {
    final refreshed = await _load();
    if (isClosed() || readState() is! TaskDetailsReady) return false;
    final latest = readState();
    if (latest is! TaskDetailsReady) return false;
    return refreshed.fold(
      (error) {
        if (_emitAccessFailure(error)) return false;
        emitState(
          latest.copyWith(
            isSaving: false,
            mutationError: error.message,
            mutationFailure: error,
            mutationOwner: mutationOwner,
            mutationSerial: latest.mutationSerial + 1,
          ),
        );
        return false;
      },
      (details) {
        emitState(
          latest.copyWith(
            details: details.task.version >= latest.details.task.version
                ? details
                : latest.details,
            isSaving: false,
            clearMutationError: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> executeAndRefresh<T>({
    required TaskDetailsReady current,
    Object? mutationOwner,
    required Future<Either<ApiError, T>> operation,
  }) async {
    final result = await operation;
    if (isClosed() || readState() is! TaskDetailsReady) return false;
    return result.fold(
      (error) => _handleError(current, error, mutationOwner),
      (_) => refresh(current, mutationOwner: mutationOwner),
    );
  }

  Future<bool> _handleError(
    TaskDetailsReady current,
    ApiError error,
    Object? mutationOwner,
  ) async {
    // Odmowa konkretnej akcji nie dowodzi utraty prawa odczytu zasobu.
    if (error.type != ApiErrorType.forbidden &&
        error.type != ApiErrorType.notFound &&
        _emitAccessFailure(error)) {
      return false;
    }
    if (error.type == ApiErrorType.conflict ||
        error.type == ApiErrorType.forbidden ||
        error.type == ApiErrorType.notFound) {
      final refreshed = await _load();
      if (isClosed() || readState() is! TaskDetailsReady) return false;
      final latest = readState();
      if (latest is! TaskDetailsReady) return false;
      return refreshed.fold(
        (refreshError) {
          if (_emitAccessFailure(refreshError)) return false;
          emitState(
            latest.copyWith(
              isSaving: false,
              mutationError: error.message,
              mutationFailure: error,
              mutationOwner: mutationOwner,
              mutationSerial: latest.mutationSerial + 1,
            ),
          );
          return false;
        },
        (details) {
          emitState(
            latest.copyWith(
              details: details.task.version >= latest.details.task.version
                  ? details
                  : latest.details.copyWith(
                      capabilities:
                          details.capabilities ?? latest.details.capabilities,
                    ),
              conflictBase: error.type == ApiErrorType.conflict
                  ? latest.conflictBase ?? current.details
                  : latest.conflictBase,
              isSaving: false,
              mutationError: error.message,
              mutationFailure: error,
              mutationOwner: mutationOwner,
              mutationSerial: latest.mutationSerial + 1,
            ),
          );
          return false;
        },
      );
    }
    final latest = readState();
    if (latest is! TaskDetailsReady) return false;
    emitState(
      latest.copyWith(
        isSaving: false,
        mutationError: error.message,
        mutationFailure: error,
        mutationOwner: mutationOwner,
        mutationSerial: latest.mutationSerial + 1,
      ),
    );
    return false;
  }

  bool _emitAccessFailure(ApiError error) {
    final kind = switch (error.type) {
      ApiErrorType.unauthorized ||
      ApiErrorType.forbidden => TaskDetailsFailureKind.forbidden,
      ApiErrorType.notFound => TaskDetailsFailureKind.notFound,
      _ => null,
    };
    if (kind == null) return false;
    emitState(
      TaskDetailsFailure(
        kind: kind,
        message: error.message,
        backendCode: error.backendCode,
        error: error,
      ),
    );
    return true;
  }

  Future<Either<ApiError, ProjectTaskDetailsResponse>> _load() =>
      repository.getTask(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
      );
}
