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
    required this.emitReady,
    required this.isClosed,
  });

  final TasksRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  final void Function(TaskDetailsReady state) emitReady;
  final bool Function() isClosed;

  Future<bool> execute<T>({
    required TaskDetailsReady current,
    required Future<Either<ApiError, T>> operation,
    required TaskDetailsReady Function(TaskDetailsReady current, T value)
    onSuccess,
  }) async {
    final result = await operation;
    if (isClosed()) return false;
    return result.fold(
      (error) => _handleError(current, error),
      (value) {
        emitReady(onSuccess(current, value));
        return true;
      },
    );
  }

  Future<bool> executeProjectTask(
    TaskDetailsReady current,
    Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
    operation,
    TaskDetailsResponseAssembler assembler,
  ) {
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return execute<TaskMutationResponse<ProjectTaskResponse>>(
      current: current,
      operation: operation,
      onSuccess: assembler.withProjectTaskMutation,
    );
  }

  Future<bool> refresh(TaskDetailsReady previous) async {
    final refreshed = await _load();
    if (isClosed()) return false;
    return refreshed.fold(
      (error) {
        emitReady(
          previous.copyWith(
            isSaving: false,
            mutationError: error.message,
            mutationSerial: previous.mutationSerial + 1,
          ),
        );
        return false;
      },
      (details) {
        emitReady(
          previous.copyWith(
            details: details,
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
    required Future<Either<ApiError, T>> operation,
  }) async {
    final result = await operation;
    if (isClosed()) return false;
    return result.fold(
      (error) => _handleError(current, error),
      (_) => refresh(current),
    );
  }

  Future<bool> _handleError(
    TaskDetailsReady current,
    ApiError error,
  ) async {
    if (error.type == ApiErrorType.conflict) {
      final refreshed = await _load();
      if (isClosed()) return false;
      return refreshed.fold(
        (_) {
          emitReady(
            current.copyWith(
              isSaving: false,
              mutationError: error.message,
              mutationSerial: current.mutationSerial + 1,
            ),
          );
          return false;
        },
        (details) {
          emitReady(
            current.copyWith(
              details: details,
              isSaving: false,
              mutationError: error.message,
              mutationSerial: current.mutationSerial + 1,
            ),
          );
          return false;
        },
      );
    }
    emitReady(
      current.copyWith(
        isSaving: false,
        mutationError: error.message,
        mutationSerial: current.mutationSerial + 1,
      ),
    );
    return false;
  }

  Future<Either<ApiError, ProjectTaskDetailsResponse>> _load() =>
      repository.getTask(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
      );
}
