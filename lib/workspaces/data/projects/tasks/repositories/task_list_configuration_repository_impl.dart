import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_list_configuration_repository.dart';

/// Implementacja HTTP repozytorium polityki i preferencji listy zadań.
final class TaskListConfigurationRepositoryImpl extends ApiRepository
    implements TaskListConfigurationRepository {
  TaskListConfigurationRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<Either<ApiError, EffectiveTaskListConfigurationResponse>>
  getEffectiveConfiguration({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/workspaces/$workspaceId/projects/$projectId/task-list/configuration',
      );
      return EffectiveTaskListConfigurationResponse.fromJson(response.data!);
    },
    fallbackMessage:
        'Nie udało się pobrać konfiguracji kolumn listy zadań projektu.',
  );

  @override
  Future<Either<ApiError, ProjectTaskListPolicyResponse>> getPolicy({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/workspaces/$workspaceId/projects/$projectId/task-list/policy',
      );
      return ProjectTaskListPolicyResponse.fromJson(response.data!);
    },
    fallbackMessage: 'Nie udało się pobrać polityki kolumn projektu.',
  );

  @override
  Future<Either<ApiError, ProjectTaskListPolicyResponse>> updatePolicy({
    required String workspaceId,
    required String projectId,
    required UpdateProjectTaskListPolicyPayload payload,
  }) => guardApiCall(
    () async {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/v1/workspaces/$workspaceId/projects/$projectId/task-list/policy',
        data: payload.toJson(),
      );
      return ProjectTaskListPolicyResponse.fromJson(response.data!);
    },
    fallbackMessage: 'Nie udało się zapisać polityki kolumn projektu.',
  );

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/workspaces/$workspaceId/projects/$projectId/task-list/preferences',
      );
      return TaskListUserPreferenceResponse.fromJson(response.data!);
    },
    fallbackMessage: 'Nie udało się pobrać preferencji kolumn użytkownika.',
  );

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>>
  updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateTaskListUserPreferencePayload payload,
  }) => guardApiCall(
    () async {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/v1/workspaces/$workspaceId/projects/$projectId/task-list/preferences',
        data: payload.toJson(),
      );
      return TaskListUserPreferenceResponse.fromJson(response.data!);
    },
    fallbackMessage: 'Nie udało się zapisać preferencji kolumn użytkownika.',
  );

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>> resetUserPreference({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/v1/workspaces/$workspaceId/projects/$projectId/task-list/preferences/reset',
      );
      return TaskListUserPreferenceResponse.fromJson(response.data!);
    },
    fallbackMessage: 'Nie udało się zresetować preferencji kolumn użytkownika.',
  );
}
