import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_open_intent.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_route_policy.dart';

/// Public inventory and URL builders owned by the standalone router.
abstract final class DevPlannerRouteCatalog {
  static const workspaces = '/workspaces';

  static const authPaths = <String>[
    '/login',
    '/auth/activate',
    '/auth/reset',
    '/auth/mfa',
  ];

  static const topLevelPaths = <String>['/workspaces', '/me', '/admin'];
  static const publicSharePrefix = '/storage/public/';
  static const storageFileDetailsPrefix = '/storage/files/';

  static String workspace(String workspaceId) =>
      '/workspaces/${Uri.encodeComponent(workspaceId)}';

  static String workspaceFiles(String workspaceId) =>
      '${workspace(workspaceId)}/files';

  static bool isUuid(String value) => TaskDetailRoutePolicy.isUuid(value);

  static String project(String workspaceId, String projectId) =>
      '${workspace(workspaceId)}/projects/${Uri.encodeComponent(projectId)}';

  static String projectTasks(String workspaceId, String projectId) =>
      '${project(workspaceId, projectId)}/tasks';

  static String projectTasksView(
    String workspaceId,
    String projectId,
    String view,
  ) =>
      '${projectTasks(workspaceId, projectId)}?view=${Uri.encodeQueryComponent(view)}';

  static String projectFiles(String workspaceId, String projectId) =>
      '${project(workspaceId, projectId)}/files';

  static String storageFileDetails(String fileId) =>
      '$storageFileDetailsPrefix${Uri.encodeComponent(fileId)}';

  static String projectKanban(String workspaceId, String projectId) =>
      '${projectTasks(workspaceId, projectId)}?view=kanban';

  static String task(
    String workspaceId,
    String projectId,
    String taskId, {
    Uri? currentLocation,
    Map<String, List<String>> queryParameters = const {},
    TaskDetailOpenSource? source,
    TaskDetailModalTab? targetTab,
  }) =>
      TaskDetailOpenIntent(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        source: source,
        targetTab: targetTab,
      ).toLocation(
        currentLocation: currentLocation,
        queryParameters: queryParameters,
      );

  static String legacyTask(
    String workspaceId,
    String projectId,
    String taskId,
  ) => '${projectTasks(workspaceId, projectId)}/${Uri.encodeComponent(taskId)}';

  static String projectResource(
    String workspaceId,
    String projectId,
    String resourceKind,
  ) => '${project(workspaceId, projectId)}/$resourceKind';

  static String projectResourceItem(
    String workspaceId,
    String projectId,
    String resourceKind,
    String resourceId,
  ) =>
      '${projectResource(workspaceId, projectId, resourceKind)}/${Uri.encodeComponent(resourceId)}';

  static const myTasks = '/me/tasks';
  static const myFiles = '/me/files';

  static String safeInitialLocation(String? value) {
    final uri = Uri.tryParse(value?.trim() ?? '');
    final path = uri?.path ?? '';
    if (!isStandalonePath(path) && !authPaths.contains(path)) return '/';
    return uri!.hasQuery ? '$path?${uri.query}' : path;
  }

  static bool isStandalonePath(String path) =>
      topLevelPaths.any(
        (candidate) => path == candidate || path.startsWith('$candidate/'),
      ) ||
      isPublicSharePath(path) ||
      isStorageFileDetailsPath(path);

  static bool isPublicSharePath(String path) {
    final token = path.startsWith(publicSharePrefix)
        ? path.substring(publicSharePrefix.length)
        : '';
    return token.isNotEmpty && !token.contains('/');
  }

  static bool isStorageFileDetailsPath(String path) {
    final fileId = path.startsWith(storageFileDetailsPrefix)
        ? path.substring(storageFileDetailsPrefix.length)
        : '';
    return isUuid(fileId);
  }
}
