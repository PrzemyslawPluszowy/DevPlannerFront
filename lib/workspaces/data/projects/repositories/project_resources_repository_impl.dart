import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/corkboard/api/corkboard_api.dart';
import 'package:devplanner/workspaces/data/corkboard/models/corkboard_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/tasks_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/corkboard_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/data/whiteboard/api/whiteboard_api.dart';
import 'package:devplanner/workspaces/data/whiteboard/models/whiteboard_models.dart';
import 'package:devplanner/workspaces/data/wiki/api/wiki_api.dart';
import 'package:devplanner/workspaces/data/wiki/models/wiki_models.dart';
import 'package:devplanner/workspaces/data/workspaces/api/automation_api.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';

/// Implementacja katalogu zasobów projektu przez dedykowane API domenowe.
final class ProjectResourcesRepositoryImpl extends ApiRepository
    implements ProjectResourcesRepository {
  ProjectResourcesRepositoryImpl({
    required this._tasksApi,
    required this._whiteboardApi,
    required this._wikiApi,
    required this._storageApi,
    required this._automationApi,
    required this._corkboardApi,
  });

  final WhiteboardApi _whiteboardApi;
  final TasksApi _tasksApi;
  final WikiApi _wikiApi;
  final StorageApi _storageApi;
  final AutomationApi _automationApi;
  final CorkboardApi _corkboardApi;

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listTasks({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async => (await _tasksApi.listTasks(workspaceId, projectId)).items
        .map(
          (task) => ProjectResourceListItem(
            id: task.id,
            title: '${task.key} · ${task.title}',
            kind: ProjectResourceKind.tasks,
          ),
        )
        .toList(growable: false),
    fallbackMessage: 'Nie udało się pobrać zadań projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę zadań.',
  );

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWhiteboards({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async =>
        (await _whiteboardApi.listProjectWhiteboards(
              workspaceId,
              projectId,
              limit: 100,
            )).items
            .map(
              (item) => ProjectResourceListItem(
                id: item.id,
                title: item.name,
                kind: ProjectResourceKind.whiteboards,
              ),
            )
            .toList(growable: false),
    fallbackMessage: 'Nie udało się pobrać whiteboardów projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę whiteboardów.',
  );

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWikiPages({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async => _flattenWikiTree(
      await _wikiApi.getProjectTree(workspaceId, projectId),
    ),
    fallbackMessage: 'Nie udało się pobrać drzewa Wiki projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłowe drzewo Wiki.',
  );

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listProjectFolders({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async =>
        (await _storageApi.listFolders(
              folderType: StorageFolderType.project.apiValue,
              workspaceId: workspaceId,
              projectId: projectId,
            ))
            .map(
              (folder) => ProjectResourceListItem(
                id: folder.id,
                title: folder.name,
                kind: ProjectResourceKind.files,
              ),
            )
            .toList(growable: false),
    fallbackMessage: 'Nie udało się pobrać folderów projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę folderów projektu.',
  );

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listAutomations({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () async => (await _automationApi.listRules(workspaceId, projectId))
        .where((rule) => rule.archivedAtUtc == null)
        .map(
          (rule) => ProjectResourceListItem(
            id: rule.id,
            title: rule.name,
            kind: ProjectResourceKind.automations,
          ),
        )
        .toList(growable: false),
    fallbackMessage: 'Nie udało się pobrać automatyzacji projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę automatyzacji.',
  );

  List<ProjectResourceListItem> _flattenWikiTree(
    List<WikiPageTreeNodeResponse> nodes,
  ) {
    final result = <ProjectResourceListItem>[];
    void visit(WikiPageTreeNodeResponse node) {
      result.add(
        ProjectResourceListItem(
          id: node.id,
          title: node.title,
          kind: ProjectResourceKind.wiki,
          isVerified: node.isVerified,
        ),
      );
      node.children.forEach(visit);
    }

    nodes.forEach(visit);
    return List.unmodifiable(result);
  }

  @override
  Future<Either<ApiError, ProjectResourceListItem>> createWhiteboard({
    required String workspaceId,
    required String projectId,
    required String name,
    String? description,
    String type = 'Canvas',
  }) => guardApiCall(
    () async {
      final response = await _whiteboardApi.createProjectWhiteboard(
        workspaceId,
        projectId,
        CreateWhiteboardPayload(
          name: name,
          description: description,
          type: type,
        ),
        null,
      );
      return ProjectResourceListItem(
        id: response.id,
        title: response.name,
        kind: ProjectResourceKind.whiteboards,
      );
    },
    fallbackMessage: 'Nie udało się utworzyć whiteboardu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź whiteboardu.',
  );

  @override
  Future<Either<ApiError, ProjectResourceListItem>> createTask({
    required String workspaceId,
    required String projectId,
    required String title,
    String? description,
    String priority = 'Normal',
    String status = 'Todo',
    DateTime? dueAtUtc,
  }) => guardApiCall(
    () async {
      final taskStatus = switch (status.toLowerCase()) {
        'backlog' => ProjectTaskStatus.backlog,
        'inprogress' => ProjectTaskStatus.inProgress,
        'blocked' => ProjectTaskStatus.blocked,
        'done' => ProjectTaskStatus.done,
        _ => ProjectTaskStatus.todo,
      };
      final taskPriority = switch (priority.toLowerCase()) {
        'low' => TaskPriority.low,
        'high' => TaskPriority.high,
        'critical' || 'urgent' => TaskPriority.critical,
        _ => TaskPriority.normal,
      };

      final response = await _tasksApi.createTask(
        workspaceId,
        projectId,
        CreateProjectTaskPayload(
          title: title,
          description: description,
          status: taskStatus,
          targetStatus: taskStatus,
          priority: taskPriority,
          dueAtUtc: dueAtUtc,
        ),
      );
      return ProjectResourceListItem(
        id: response.data.id,
        title: '${response.data.key} · ${response.data.title}',
        kind: ProjectResourceKind.tasks,
      );
    },
    fallbackMessage: 'Nie udało się utworzyć zadania.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź zadania.',
  );

  @override
  Future<Either<ApiError, ProjectResourceListItem>> createWikiPage({
    required String workspaceId,
    required String projectId,
    required String title,
    String? parentPageId,
  }) => guardApiCall(
    () async {
      final response = await _wikiApi.createProjectPage(
        workspaceId,
        projectId,
        CreateWikiPagePayload(
          title: title,
          parentPageId: parentPageId,
          contentJson: '{"ops":[{"insert":"\\n"}]}',
        ),
      );
      return ProjectResourceListItem(
        id: response.id,
        title: response.title,
        kind: ProjectResourceKind.wiki,
      );
    },
    fallbackMessage: 'Nie udało się utworzyć strony Wiki.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź Wiki.',
  );

  @override
  Future<Either<ApiError, ProjectResourceListItem>> createProjectFolder({
    required String workspaceId,
    required String projectId,
    required String name,
  }) => guardApiCall(
    () async {
      final response = await _storageApi.createFolder(
        CreateStorageFolderPayload(
          folderType: StorageFolderType.project,
          name: name,
          workspaceId: workspaceId,
          projectId: projectId,
        ),
      );
      return ProjectResourceListItem(
        id: response.id,
        title: response.name,
        kind: ProjectResourceKind.files,
      );
    },
    fallbackMessage: 'Nie udało się utworzyć folderu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź folderu.',
  );

  @override
  Future<Either<ApiError, String>> createCorkboardCard({
    required String workspaceId,
    required String projectId,
    required String title,
    String? content,
    String? colorHex,
  }) => guardApiCall(
    () async {
      final fullContent = content != null && content.trim().isNotEmpty
          ? '$title\n$content'
          : title;
      final cardColor = switch (colorHex?.toUpperCase()) {
        '#BAE6FD' => CorkboardCardColor.blue,
        '#BBF7D0' => CorkboardCardColor.green,
        '#FBCFE8' => CorkboardCardColor.pink,
        '#DDD6FE' => CorkboardCardColor.purple,
        _ => CorkboardCardColor.yellow,
      };
      final response = await _corkboardApi.createCard(
        workspaceId,
        projectId,
        CreateCorkboardCardPayload(
          content: fullContent,
          color: cardColor,
        ),
      );
      return response.id;
    },
    fallbackMessage: 'Nie udało się przypiąć notatki na tablicy korkowej.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź notatki.',
  );
}
