import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/api/projects_api.dart';
import 'package:devplanner/workspaces/data/projects/mappers/project_list_item_mapper.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_preview_models.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_request_models.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/repositories/project_setups_repository.dart';

/// Implementacja atomowego kreatora projektu oparta o Retrofit API projektów.
///
/// Klient HTTP jest współdzielony z resztą modułu projektów, bo `project-setups`
/// należy do tej samej grupy endpointów i korzysta z tej samej sesji. Klasa nie
/// buforuje planu ani klucza idempotencji — oba należą do draftu kreatora, dzięki
/// czemu ponowienie po timeoucie wysyła identyczne żądanie z tym samym kluczem.
final class ProjectSetupsRepositoryImpl extends ApiRepository
    implements ProjectSetupsRepository {
  /// Tworzy repozytorium na bazie klienta Retrofit projektów.
  ProjectSetupsRepositoryImpl({required this.api});

  /// Klient HTTP endpointów projektów razem z `project-setups`.
  final ProjectsApi api;

  @override
  Future<Either<ApiError, ProjectSetupPreviewResponse>> previewProjectSetup({
    required String workspaceId,
    required CreateProjectSetupRequest request,
  }) => guardApiCall(
    () => api.previewProjectSetup(workspaceId, request),
    fallbackMessage: 'Nie udało się zbudować planu projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłowy plan utworzenia projektu.',
  );

  @override
  Future<Either<ApiError, ProjectSetupCreation>> createProjectSetup({
    required String workspaceId,
    required CreateProjectSetupRequest request,
    required String idempotencyKey,
  }) => guardApiCall(
    () async {
      final response = await api.createProjectSetup(
        workspaceId,
        request,
        idempotencyKey: idempotencyKey,
      );
      return ProjectSetupCreation(
        project: ProjectListItemMapper.fromProjectResponse(response.project),
        replayed: response.replayed,
        memberCount: response.memberCount,
        installedRecipeKeys: [
          for (final rule in response.automationRules) rule.recipeKey,
        ],
        defaultView: response.taskView.defaultView,
      );
    },
    fallbackMessage: 'Nie udało się utworzyć projektu.',
    parsingMessage:
        'Backend zwrócił nieprawidłową odpowiedź tworzenia projektu.',
  );
}
