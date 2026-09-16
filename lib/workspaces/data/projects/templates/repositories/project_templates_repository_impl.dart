import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/templates/api/project_templates_api.dart';
import 'package:ready_next/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:ready_next/workspaces/domain/repositories/project_templates_repository.dart';

/// Implementacja repozytorium szablonów projektów oparta o Retrofit API.
final class ProjectTemplatesRepositoryImpl extends ApiRepository
    implements ProjectTemplatesRepository {
  ProjectTemplatesRepositoryImpl({required this.api});

  final ProjectTemplatesApi api;

  @override
  Future<Either<ApiError, List<ProjectTemplateResponse>>> listTemplates(
    String workspaceId,
  ) => guardApiCall(
    () => api.listTemplates(workspaceId),
    fallbackMessage: 'Nie udało się pobrać szablonów projektów.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę szablonów.',
  );

  @override
  Future<Either<ApiError, ProjectTemplateResponse>> createTemplateFromProject({
    required String workspaceId,
    required String projectId,
    required String name,
  }) => guardApiCall(
    () => api.createTemplate(
      workspaceId,
      projectId,
      CreateProjectTemplatePayload(name: name),
    ),
    fallbackMessage: 'Nie udało się utworzyć szablonu z projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź nowego szablonu.',
  );

  @override
  Future<Either<ApiError, ProjectTemplateDetailsResponse>> getTemplateDetails({
    required String workspaceId,
    required String templateId,
  }) => guardApiCall(
    () => api.getTemplateDetails(workspaceId, templateId),
    fallbackMessage: 'Nie udało się pobrać szczegółów szablonu.',
    parsingMessage: 'Backend zwrócił nieprawidłowe szczegóły szablonu.',
  );

  @override
  Future<Either<ApiError, ProjectTemplateDetailsResponse>> refreshTemplate({
    required String workspaceId,
    required String templateId,
    required String projectId,
    required String name,
    required int expectedVersion,
  }) => guardApiCall(
    () => api.refreshTemplate(
      workspaceId,
      templateId,
      projectId,
      RefreshProjectTemplatePayload(
        name: name,
        expectedVersion: expectedVersion,
      ),
    ),
    fallbackMessage: 'Nie udało się odświeżyć szablonu z projektu.',
    parsingMessage:
        'Backend zwrócił nieprawidłową odpowiedź odświeżenia szablonu.',
  );

  @override
  Future<Either<ApiError, void>> deleteTemplate({
    required String workspaceId,
    required String templateId,
    required int expectedVersion,
  }) => guardApiCall(
    () => api.deleteTemplate(workspaceId, templateId, expectedVersion),
    fallbackMessage: 'Nie udało się usunąć szablonu projektu.',
  );

  @override
  Future<Either<ApiError, ApplyProjectTemplateResponse>> applyTemplate({
    required String workspaceId,
    required String templateId,
    required String newProjectName,
  }) => guardApiCall(
    () => api.applyTemplate(
      workspaceId,
      templateId,
      ApplyProjectTemplatePayload(name: newProjectName),
    ),
    fallbackMessage: 'Nie udało się zastosować szablonu projektu.',
    parsingMessage:
        'Backend zwrócił nieprawidłową strukturę utworzonego projektu.',
  );
}
