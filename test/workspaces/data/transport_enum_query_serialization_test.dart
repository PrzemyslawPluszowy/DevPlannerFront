import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/workspaces/data/kanban/api/kanban_api.dart';
import 'package:devplanner/workspaces/data/kanban/repositories/kanban_repository_impl.dart';
import 'package:devplanner/workspaces/data/notifications/api/notifications_api.dart';
import 'package:devplanner/workspaces/data/notifications/repositories/notifications_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_feature_enums.dart';
import 'package:devplanner/workspaces/data/workspaces/api/workspace_feature_api.dart';
import 'package:devplanner/workspaces/data/workspaces/repositories/workspace_features_repository_impl.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/task_list_query.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Tasks serializuje status i priorytet zgodnie z enumami backendu', () {
    const query = TaskListQuery(
      status: ProjectTaskStatus.inProgress,
      priority: TaskPriority.high,
    );

    final grouped = query.groups(groupBy: TaskSavedViewGroupBy.status);

    expect(grouped.status, 'InProgress');
    expect(grouped.priority, 'High');
    expect(query.listPage().status, 'InProgress');
    expect(query.selectionTokenPayload().priority, 'High');
  });

  test('pozostałe enumy query/path są wysyłane jako PascalCase', () async {
    final adapter = _RejectingRecordingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter;

    final kanban = KanbanRepositoryImpl(KanbanApi(dio));
    await kanban.getBoard(
      workspaceId: 'workspace-id',
      projectId: 'project-id',
      filter: const KanbanBoardFilter(priority: TaskPriority.critical),
    );
    await kanban.getSystemColumn(
      workspaceId: 'workspace-id',
      projectId: 'project-id',
      status: ProjectTaskStatus.inProgress,
      query: const KanbanColumnQuery(priority: TaskPriority.high),
    );

    final notifications = NotificationsRepositoryImpl(NotificationsApi(dio));
    await notifications.listGroups(category: NotificationCategory.task);

    final workspaces = WorkspaceFeaturesRepositoryImpl(
      WorkspaceFeatureApi(dio),
    );
    await workspaces.getDashboardPreferences(
      workspaceId: 'workspace-id',
      context: DashboardContextKind.project,
      projectId: 'project-id',
    );

    expect(adapter.requests[0].queryParameters['priority'], 'Critical');
    expect(adapter.requests[1].path, contains('/columns/InProgress'));
    expect(adapter.requests[1].queryParameters['priority'], 'High');
    expect(adapter.requests[2].queryParameters['category'], 'Task');
    expect(adapter.requests[3].queryParameters['context'], 'Project');
  });
}

final class _RejectingRecordingAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(const {
        'code': 'diagnostic.rejected',
        'message': 'Celowy błąd testowy.',
      }),
      400,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
