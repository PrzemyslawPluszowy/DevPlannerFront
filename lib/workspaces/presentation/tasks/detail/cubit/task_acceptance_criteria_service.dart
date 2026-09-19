import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';

/// Wydzielony use-case mutacji kryteriów akceptacji zadania.
///
/// Serwis zawiera walidację wejścia i kontrakt API, ale nie zna Fluttera ani
/// stanu widoku. `TaskDetailsCubit` odpowiada wyłącznie za scalenie
/// potwierdzonej odpowiedzi z własnym snapshotem szczegółów.
final class TaskAcceptanceCriteriaService {
  const TaskAcceptanceCriteriaService({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  });

  final TaskAcceptanceCriteriaRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;

  /// Dodaje kryterium po normalizacji tekstu.
  Future<
    Either<ApiError, TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  >
  add({required String text, required int expectedVersion}) {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      return Future.value(
        const Left(
          ApiError(
            type: ApiErrorType.validation,
            message: 'Treść kryterium nie może być pusta.',
          ),
        ),
      );
    }
    return repository.create(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: CreateTaskAcceptanceCriterionPayload(
        text: normalized,
        expectedVersion: expectedVersion,
      ),
    );
  }

  /// Aktualizuje tekst i stan akceptacji istniejącego kryterium.
  Future<
    Either<ApiError, TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  >
  update({
    required TaskAcceptanceCriterionResponse criterion,
    required int expectedVersion,
    String? text,
    bool? isAccepted,
  }) {
    final normalized = (text ?? criterion.text).trim();
    if (normalized.isEmpty) {
      return Future.value(
        const Left(
          ApiError(
            type: ApiErrorType.validation,
            message: 'Treść kryterium nie może być pusta.',
          ),
        ),
      );
    }
    return repository.update(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      criterionId: criterion.id,
      payload: UpdateTaskAcceptanceCriterionPayload(
        text: normalized,
        position: criterion.position,
        isAccepted: isAccepted ?? criterion.isAccepted,
        expectedVersion: expectedVersion,
      ),
    );
  }

  /// Usuwa kryterium z kontrolą wersji agregatu zadania.
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  delete({
    required TaskAcceptanceCriterionResponse criterion,
    required int expectedVersion,
  }) => repository.delete(
    workspaceId: workspaceId,
    projectId: projectId,
    taskId: taskId,
    criterionId: criterion.id,
    expectedVersion: expectedVersion,
  );
}
