import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';

/// Repozytorium konfiguracji polityki kolumn projektu i preferencji użytkownika listy zadań.
abstract interface class TaskListConfigurationRepository {
  /// Pobiera wyliczoną efektywną konfigurację kolumn i sortowania.
  Future<Either<ApiError, EffectiveTaskListConfigurationResponse>>
  getEffectiveConfiguration({
    required String workspaceId,
    required String projectId,
  });

  /// Pobiera politykę administratora dla projektu.
  Future<Either<ApiError, ProjectTaskListPolicyResponse>> getPolicy({
    required String workspaceId,
    required String projectId,
  });

  /// Aktualizuje politykę administratora dla projektu (wymaga roli Owner/Admin).
  Future<Either<ApiError, ProjectTaskListPolicyResponse>> updatePolicy({
    required String workspaceId,
    required String projectId,
    required UpdateProjectTaskListPolicyPayload payload,
  });

  /// Pobiera osobiste preferencje użytkownika dla projektu.
  Future<Either<ApiError, TaskListUserPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  });

  /// Zapisuje osobiste preferencje użytkownika dla projektu.
  Future<Either<ApiError, TaskListUserPreferenceResponse>>
  updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateTaskListUserPreferencePayload payload,
  });

  /// Resetuje preferencje użytkownika do wartości domyślnych projektu.
  Future<Either<ApiError, TaskListUserPreferenceResponse>> resetUserPreference({
    required String workspaceId,
    required String projectId,
  });
}
