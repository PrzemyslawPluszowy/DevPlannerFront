import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';

/// Kontrakt leniwego katalogu zasobów jednego projektu.
///
/// Każdy odczyt jest wykonywany dopiero po rozwinięciu odpowiedniej gałęzi
/// menu. Warstwa prezentacji nie zna klienta HTTP ani DTO Retrofit.
abstract interface class ProjectResourcesRepository {
  /// Pobiera pierwszą stronę aktywnych zadań projektu.
  Future<Either<ApiError, List<ProjectResourceListItem>>> listTasks({
    required String workspaceId,
    required String projectId,
  });

  /// Pobiera pierwszą stronę whiteboardów projektu.
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWhiteboards({
    required String workspaceId,
    required String projectId,
  });

  /// Pobiera i spłaszcza drzewo stron Wiki projektu w kolejności backendu.
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWikiPages({
    required String workspaceId,
    required String projectId,
  });

  /// Pobiera katalog folderów projektu z wirtualnego Storage.
  Future<Either<ApiError, List<ProjectResourceListItem>>> listProjectFolders({
    required String workspaceId,
    required String projectId,
  });

  /// Pobiera aktywne reguły automatyzacji projektu.
  Future<Either<ApiError, List<ProjectResourceListItem>>> listAutomations({
    required String workspaceId,
    required String projectId,
  });

  /// Tworzy nowy whiteboard w projekcie.
  Future<Either<ApiError, ProjectResourceListItem>> createWhiteboard({
    required String workspaceId,
    required String projectId,
    required String name,
    String? description,
    String type = 'Canvas',
  });

  /// Tworzy nowe zadanie w projekcie.
  Future<Either<ApiError, ProjectResourceListItem>> createTask({
    required String workspaceId,
    required String projectId,
    required String title,
    String? description,
    String priority = 'Normal',
    String status = 'Todo',
    DateTime? dueAtUtc,
  });

  /// Tworzy nową stronę Wiki w projekcie.
  Future<Either<ApiError, ProjectResourceListItem>> createWikiPage({
    required String workspaceId,
    required String projectId,
    required String title,
    String? parentPageId,
  });

  /// Tworzy nowy folder w module Storage projektu.
  Future<Either<ApiError, ProjectResourceListItem>> createProjectFolder({
    required String workspaceId,
    required String projectId,
    required String name,
  });

  /// Tworzy kartę na tablicy korkowej (Corkboard).
  Future<Either<ApiError, String>> createCorkboardCard({
    required String workspaceId,
    required String projectId,
    required String title,
    String? content,
    String? colorHex,
  });
}
