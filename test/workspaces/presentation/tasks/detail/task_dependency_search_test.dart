import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_dependencies_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Tasks extends Mock implements TasksRepository {}

final class _Search extends Mock implements TaskViewRepository {}

GlobalTaskSearchItemResponse _item(
  String id, {
  String? parentTaskId,
  String projectId = 'project',
}) => GlobalTaskSearchItemResponse(
  id: id,
  number: 1,
  key: 'TASK-1',
  workspaceId: 'workspace',
  workspaceName: 'Workspace',
  projectId: projectId,
  projectName: 'Project',
  parentTaskId: parentTaskId,
  title: 'QA child',
  matchedLabels: const [],
  score: 1,
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);

void main() {
  test(
    'lookup includes subtasks, excludes self and stays within project',
    () async {
      final search = _Search();
      when(
        () => search.searchTasks(
          query: 'QA',
          workspaceId: 'workspace',
          projectId: 'project',
          limit: 20,
        ),
      ).thenAnswer(
        (_) async => Right(
          CursorPageResponse(
            items: [
              _item('self'),
              _item('child', parentTaskId: 'parent'),
              _item('other', projectId: 'another-project'),
            ],
          ),
        ),
      );
      final service = TaskDetailsDependenciesService(
        repository: _Tasks(),
        searchRepository: search,
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'self',
      );
      final result = await service.search(' QA ');
      result.fold((error) => fail(error.message), (items) {
        expect(items.map((item) => item.id), ['child']);
        expect(items.single.key, 'TASK-1');
      });
    },
  );

  test(
    'short phrase makes no request and search failures remain failures',
    () async {
      final search = _Search();
      const failure = ApiError(
        type: ApiErrorType.connection,
        message: 'Offline',
      );
      when(
        () => search.searchTasks(
          query: 'QA',
          workspaceId: 'workspace',
          projectId: 'project',
          limit: 20,
        ),
      ).thenAnswer((_) async => const Left(failure));
      final service = TaskDetailsDependenciesService(
        repository: _Tasks(),
        searchRepository: search,
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'self',
      );
      final short = await service.search(' Q ');
      expect(short.isRight(), isTrue);
      verifyZeroInteractions(search);
      final result = await service.search('QA');
      expect(result, const Left<ApiError, dynamic>(failure));
    },
  );
}
