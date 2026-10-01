import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_open_intent.dart';
import 'package:go_router/go_router.dart';

/// Owns task-detail URL normalization and the last task-board view snapshot.
///
/// Keeping this policy outside the app router makes task navigation behavior
/// independently testable and prevents feature URL rules from growing the
/// global route table.
final class TaskDetailRoutePolicy {
  Uri? _lastTaskBoardLocation;

  static bool isUuid(String value) => RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  ).hasMatch(value);

  void rememberLocation(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.length == 5 &&
        segments[0] == 'workspaces' &&
        segments[2] == 'projects' &&
        segments[4] == 'tasks') {
      _lastTaskBoardLocation = uri;
    } else if (segments.length < 6 ||
        segments[0] != 'workspaces' ||
        segments[2] != 'projects' ||
        segments[4] != 'tasks') {
      _lastTaskBoardLocation = null;
    }
  }

  String? invalidTaskQueryRedirect(GoRouterState state) {
    final values = state.uri.queryParametersAll['task'];
    if (values == null) return null;
    final taskId = values.length == 1 ? values.single : null;
    if (taskId == null || !isUuid(taskId)) {
      final query = Map<String, List<String>>.of(state.uri.queryParametersAll)
        ..remove('task')
        ..remove('taskTab')
        ..remove('taskReturn');
      return state.uri.replace(queryParameters: query).toString();
    }

    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    final projectId = state.pathParameters['projectId'] ?? '';
    final previous = _lastTaskBoardLocation;
    final sameProject = _isSameProject(previous, workspaceId, projectId);
    final query = <String, List<String>>{
      if (sameProject && previous != null) ...previous.queryParametersAll,
      ...state.uri.queryParametersAll,
    };
    if (!state.uri.queryParametersAll.containsKey('taskTab')) {
      query.remove('taskTab');
    }
    if (!state.uri.queryParametersAll.containsKey('taskReturn')) {
      query.remove('taskReturn');
    }
    query['task'] = [taskId];
    if (!sameProject && !query.containsKey('view')) query['view'] = ['list'];
    final normalized = state.uri.replace(queryParameters: query);
    if (normalized != state.uri) return normalized.toString();
    _lastTaskBoardLocation = state.uri;
    return null;
  }

  String legacyTaskRedirect(GoRouterState state) {
    final workspaceId = state.pathParameters['workspaceId'] ?? '';
    final projectId = state.pathParameters['projectId'] ?? '';
    final taskId = state.pathParameters['taskId'] ?? '';
    if (!isUuid(workspaceId) || !isUuid(projectId) || !isUuid(taskId)) {
      return '/workspaces';
    }

    final previous = _lastTaskBoardLocation;
    final sameProject = _isSameProject(previous, workspaceId, projectId);
    return TaskDetailOpenIntent(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      source: sameProject ? null : TaskDetailOpenSource.deepLink,
      targetTab: _modalTab(state.uri.queryParameters['taskTab']),
    ).toLocation(
      currentLocation: sameProject ? previous : state.uri,
      queryParameters: state.uri.queryParametersAll,
    );
  }

  bool _isSameProject(Uri? uri, String workspaceId, String projectId) {
    final segments = uri?.pathSegments;
    return segments != null &&
        segments.length == 5 &&
        segments[0] == 'workspaces' &&
        segments[1] == workspaceId &&
        segments[2] == 'projects' &&
        segments[3] == projectId &&
        segments[4] == 'tasks';
  }

  TaskDetailModalTab? _modalTab(String? value) {
    for (final tab in TaskDetailModalTab.values) {
      if (tab.queryValue == value) return tab;
    }
    return null;
  }
}
