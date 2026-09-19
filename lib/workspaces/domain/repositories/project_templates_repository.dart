import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';

/// Kontrakt repozytorium szablonów projektów w workspace.
abstract interface class ProjectTemplatesRepository {
  /// Pobiera listę szablonów projektów dostępnych w workspace.
  Future<Either<ApiError, List<ProjectTemplateResponse>>> listTemplates(
    String workspaceId,
  );

  /// Tworzy nowy szablon z bieżącego projektu.
  Future<Either<ApiError, ProjectTemplateResponse>> createTemplateFromProject({
    required String workspaceId,
    required String projectId,
    required String name,
  });

  /// Pobiera pełne szczegóły i podgląd konfiguracji szablonu.
  Future<Either<ApiError, ProjectTemplateDetailsResponse>> getTemplateDetails({
    required String workspaceId,
    required String templateId,
  });

  /// Odświeża szablon aktualnym stanem projektu.
  Future<Either<ApiError, ProjectTemplateDetailsResponse>> refreshTemplate({
    required String workspaceId,
    required String templateId,
    required String projectId,
    required String name,
    required int expectedVersion,
  });

  /// Trwale usuwa szablon projektu.
  Future<Either<ApiError, void>> deleteTemplate({
    required String workspaceId,
    required String templateId,
    required int expectedVersion,
  });

  /// Tworzy nowy projekt na podstawie szablonu.
  Future<Either<ApiError, ApplyProjectTemplateResponse>> applyTemplate({
    required String workspaceId,
    required String templateId,
    required String newProjectName,
  });
}
