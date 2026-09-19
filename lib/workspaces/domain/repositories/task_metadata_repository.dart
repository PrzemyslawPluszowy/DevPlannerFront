import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';

/// Metadane konfigurowane na poziomie projektu i przypisywane do taska.
abstract interface class TaskMetadataRepository {
  /// Pobiera aktywne etykiety dostępne w projekcie.
  Future<Either<ApiError, List<TaskLabelResponse>>> listLabels({
    required String workspaceId,
    required String projectId,
  });

  /// Tworzy aktywną etykietę dostępną dla zadań w projekcie.
  Future<Either<ApiError, TaskLabelResponse>> createLabel({
    required String workspaceId,
    required String projectId,
    required CreateTaskLabelPayload payload,
  });

  /// Zmienia nazwę lub kolor istniejącej etykiety projektu.
  Future<Either<ApiError, TaskLabelResponse>> updateLabel({
    required String workspaceId,
    required String projectId,
    required String labelId,
    required UpdateTaskLabelPayload payload,
  });

  /// Archiwizuje etykietę, bez usuwania historii jej użycia w zadaniach.
  Future<Either<ApiError, Unit>> archiveLabel({
    required String workspaceId,
    required String projectId,
    required String labelId,
  });

  /// Pobiera aktywne definicje pól własnych projektu.
  Future<Either<ApiError, List<TaskCustomFieldResponse>>> listCustomFields({
    required String workspaceId,
    required String projectId,
  });

  /// Tworzy definicję pola własnego. Typ pola jest ustalany przy utworzeniu.
  Future<Either<ApiError, TaskCustomFieldResponse>> createCustomField({
    required String workspaceId,
    required String projectId,
    required CreateTaskCustomFieldPayload payload,
  });

  /// Aktualizuje dane definicji bez zmiany jej typu.
  Future<Either<ApiError, TaskCustomFieldResponse>> updateCustomField({
    required String workspaceId,
    required String projectId,
    required String fieldId,
    required UpdateTaskCustomFieldPayload payload,
  });

  /// Archiwizuje definicję pola własnego projektu.
  Future<Either<ApiError, Unit>> archiveCustomField({
    required String workspaceId,
    required String projectId,
    required String fieldId,
  });

  /// Atomowo zastępuje pełną listę etykiet taska.
  Future<Either<ApiError, TaskMutationResponse<List<TaskLabelResponse>>>>
  replaceLabels({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required ReplaceTaskLabelsPayload payload,
  });

  /// Atomowo zastępuje wartości pól własnych taska.
  Future<
    Either<ApiError, TaskMutationResponse<List<TaskCustomFieldValueResponse>>>
  >
  replaceCustomFieldValues({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required ReplaceTaskCustomFieldValuesPayload payload,
  });
}
