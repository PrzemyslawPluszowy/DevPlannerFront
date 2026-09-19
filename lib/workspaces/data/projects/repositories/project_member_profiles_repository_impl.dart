import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/api/projects_api.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_member_profile_response.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';

/// Repozytorium profili członków, dozwolonych przez ACL danego projektu.
final class ProjectMemberProfilesRepositoryImpl extends ApiRepository
    implements ProjectMemberProfilesRepository {
  /// Tworzy repozytorium na bazie uwierzytelnionego klienta Projects API.
  ProjectMemberProfilesRepositoryImpl({required this._api});

  final ProjectsApi _api;
  final Map<String, List<ProjectMemberProfile>> _cache = {};

  @override
  Future<Either<ApiError, List<ProjectMemberProfile>>> listProfiles({
    required String workspaceId,
    required String projectId,
    bool forceRefresh = false,
  }) async {
    final key = _cacheKey(workspaceId, projectId);
    final cached = _cache[key];
    if (!forceRefresh && cached != null) return Right(cached);
    final result = await guardApiCall(
      () => _loadAllProfiles(workspaceId: workspaceId, projectId: projectId),
      fallbackMessage: 'Nie udało się pobrać profili członków projektu.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe profile członków projektu.',
    );
    result.fold((_) {}, (profiles) => _cache[key] = profiles);
    return result;
  }

  @override
  Future<Either<ApiError, ProjectMemberProfilePage>> listProfilesPage({
    required String workspaceId,
    required String projectId,
    String? search,
    String? cursor,
    int limit = 30,
  }) => guardApiCall(
    () async {
      final page = await _api.listProjectMemberProfiles(
        workspaceId,
        projectId,
        search?.trim().isEmpty ?? true ? null : search?.trim(),
        cursor: cursor,
        limit: limit.clamp(1, 100),
      );
      return ProjectMemberProfilePage(
        items: page.items.map(_toDomain).toList(growable: false),
        nextCursor: page.nextCursor,
      );
    },
    fallbackMessage: 'Nie udało się pobrać profili członków projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłowe profile członków projektu.',
  );

  @override
  Future<Either<ApiError, List<ProjectMemberProfile>>> searchProfiles({
    required String workspaceId,
    required String projectId,
    required String query,
  }) {
    final normalized = query.trim();
    if (normalized.length < 2) return Future.value(const Right([]));
    return guardApiCall(
      () async => (await _api.listProjectMemberProfiles(
        workspaceId,
        projectId,
        normalized,
        limit: 30,
      )).items.map(_toDomain).toList(growable: false),
      fallbackMessage: 'Nie udało się wyszukać osób w projekcie.',
      parsingMessage: 'Backend zwrócił nieprawidłowe profile osób.',
    );
  }

  ProjectMemberProfile _toDomain(ProjectMemberProfileResponse response) =>
      ProjectMemberProfile(
        userId: response.userId,
        displayName: response.displayName,
        avatarUrl: response.avatarUrl,
        role: response.role,
      );

  /// Zachowuje kontrakt starszych konsumentów wymagających pełnego katalogu,
  /// lecz pobiera go wyłącznie przez cursorowe strony API. Picker listy zadań
  /// używa zamiast tego `listProfilesPage` i nie wywołuje tej metody.
  Future<List<ProjectMemberProfile>> _loadAllProfiles({
    required String workspaceId,
    required String projectId,
  }) async {
    final profiles = <ProjectMemberProfile>[];
    final seenCursors = <String>{};
    String? cursor;
    do {
      final page = await _api.listProjectMemberProfiles(
        workspaceId,
        projectId,
        null,
        cursor: cursor,
        limit: 100,
      );
      profiles.addAll(page.items.map(_toDomain));
      cursor = page.nextCursor;
      if (cursor != null && !seenCursors.add(cursor)) {
        throw const FormatException(
          'Backend zwrócił zapętlony kursor profili.',
        );
      }
    } while (cursor != null);
    return profiles;
  }

  @override
  void invalidate({required String workspaceId, required String projectId}) {
    _cache.remove(_cacheKey(workspaceId, projectId));
  }

  String _cacheKey(String workspaceId, String projectId) =>
      '$workspaceId/$projectId';
}
