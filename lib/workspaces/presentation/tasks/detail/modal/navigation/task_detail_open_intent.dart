enum TaskDetailOpenSource {
  taskList,
  kanban,
  myTasks,
  search,
  notification,
  subtask,
  deepLink,
}

enum TaskDetailModalTab {
  work('work'),
  conversation('conversation'),
  files('files'),
  planning('planning'),
  history('history');

  const TaskDetailModalTab(this.queryValue);

  final String queryValue;
}

/// Jednoznaczny zamiar otwarcia zadania z dowolnej powierzchni aplikacji.
final class TaskDetailOpenIntent {
  const TaskDetailOpenIntent({
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    this.source,
    this.targetTab,
  });

  final String workspaceId;
  final String projectId;
  final String taskId;
  final TaskDetailOpenSource? source;
  final TaskDetailModalTab? targetTab;

  String toLocation({
    Uri? currentLocation,
    Map<String, List<String>> queryParameters = const {},
  }) {
    final path = '/workspaces/$workspaceId/projects/$projectId/tasks';
    final sameProject = currentLocation?.path == path;
    final query = <String, List<String>>{
      if (sameProject) ...?currentLocation?.queryParametersAll,
      ...queryParameters,
      'task': [taskId],
    };
    final tab = targetTab;
    if (tab != null) {
      query['taskTab'] = [tab.queryValue];
    } else {
      query.remove('taskTab');
    }
    final previousReturn = currentLocation?.queryParametersAll['taskReturn'];
    final retainsPersonalReturn =
        sameProject &&
        source == TaskDetailOpenSource.subtask &&
        previousReturn?.length == 1 &&
        previousReturn?.single == '/me/tasks';
    if (source == TaskDetailOpenSource.myTasks || retainsPersonalReturn) {
      query['taskReturn'] = ['/me/tasks'];
    } else {
      query.remove('taskReturn');
    }
    if (!sameProject &&
        source != TaskDetailOpenSource.taskList &&
        source != TaskDetailOpenSource.kanban &&
        !query.containsKey('view')) {
      query['view'] = ['list'];
    }
    return Uri(path: path, queryParameters: query).toString();
  }
}
