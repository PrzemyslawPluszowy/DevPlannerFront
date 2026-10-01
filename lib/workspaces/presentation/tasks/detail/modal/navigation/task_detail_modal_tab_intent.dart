import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';

abstract final class TaskDetailModalTabIntent {
  static TaskDetailsModalTab? fromUri(Uri uri) =>
      switch (uri.queryParameters['taskTab']) {
        'work' => TaskDetailsModalTab.work,
        'conversation' => TaskDetailsModalTab.conversation,
        'files' => TaskDetailsModalTab.files,
        'planning' => TaskDetailsModalTab.planAndTime,
        'history' => TaskDetailsModalTab.history,
        _ => null,
      };

  static Uri withSelection(Uri uri, TaskDetailsModalTab tab) {
    final query = Map<String, List<String>>.of(uri.queryParametersAll);
    final value = switch (tab) {
      TaskDetailsModalTab.work => null,
      TaskDetailsModalTab.conversation => 'conversation',
      TaskDetailsModalTab.files => 'files',
      TaskDetailsModalTab.planAndTime => 'planning',
      TaskDetailsModalTab.history => 'history',
    };
    if (value == null) {
      query.remove('taskTab');
    } else {
      query['taskTab'] = [value];
    }
    return uri.replace(queryParameters: query);
  }
}
