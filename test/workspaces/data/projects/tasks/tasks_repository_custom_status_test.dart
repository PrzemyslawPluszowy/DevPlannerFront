import 'package:devplanner/workspaces/data/projects/tasks/api/tasks_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/repositories/tasks_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _TasksApiMock extends Mock implements TasksApi {}

final class _TaskListItemMock extends Mock
    implements ProjectTaskListItemResponse {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const UpdateTaskListItemPayload(expectedVersion: 1),
    );
  });

  test('moveCustomStatus uses list-item contract with version and no system status', () async {
    final api = _TasksApiMock();
    final repository = TasksRepositoryImpl(api);
    final data = _TaskListItemMock();
    final updatedAt = DateTime.utc(2026, 9, 30);
    when(
      () => api.updateListItem(
        'workspace-id',
        'project-id',
        'task-id',
        any(),
      ),
    ).thenAnswer(
      (_) async => TaskMutationResponse<ProjectTaskListItemResponse>(
        taskId: 'task-id',
        taskVersion: 12,
        taskUpdatedAtUtc: updatedAt,
        data: data,
      ),
    );

    final result = await repository.moveCustomStatus(
      workspaceId: 'workspace-id',
      projectId: 'project-id',
      taskId: 'task-id',
      customStatusId: 'custom-status-id',
      expectedVersion: 11,
    );

    expect(result.isRight(), isTrue);
    final payload =
        verify(
              () => api.updateListItem(
                'workspace-id',
                'project-id',
                'task-id',
                captureAny(),
              ),
            ).captured.single
            as UpdateTaskListItemPayload;
    final json = payload.toJson();
    expect(json['customStatusId'], 'custom-status-id');
    expect(json['expectedVersion'], 11);
    expect(json['status'], isNull);
  });
}
