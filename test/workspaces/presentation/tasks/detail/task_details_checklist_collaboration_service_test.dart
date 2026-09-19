import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_checklist_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_collaboration_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _ChecklistRepositoryMock extends Mock
    implements TaskChecklistRepository {}

final class _CollaborationRepositoryMock extends Mock
    implements TaskCollaborationRepository {}

const workspaceId = 'workspace-1';
const projectId = 'project-1';
const taskId = 'task-1';

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CreateTaskChecklistItemPayload(
        title: 'fallback',
        expectedVersion: 1,
      ),
    );
    registerFallbackValue(
      const UpdateTaskChecklistItemPayload(
        title: 'fallback',
        position: 0,
        isCompleted: false,
        expectedVersion: 1,
      ),
    );
  });

  test('checklista odrzuca pusty tytuł bez wywołania repository', () async {
    final repository = _ChecklistRepositoryMock();
    final service = TaskDetailsChecklistService(
      repository: repository,
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );

    final result = await service.add(title: '  ', expectedVersion: 4);

    expect(
      result,
      isA<Left<ApiError, TaskMutationResponse<TaskChecklistItemResponse>>>(),
    );
    verifyNever(
      () => repository.addItem(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
        taskId: any(named: 'taskId'),
        payload: any(named: 'payload'),
      ),
    );
  });

  test('checklista przekazuje znormalizowany tytuł i wersję', () async {
    final repository = _ChecklistRepositoryMock();
    when(
      () => repository.addItem(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        payload: any(named: 'payload'),
      ),
    ).thenAnswer(
      (_) async => left(
        const ApiError(
          type: ApiErrorType.server,
          message: 'test',
        ),
      ),
    );
    final service = TaskDetailsChecklistService(
      repository: repository,
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );

    await service.add(title: '  Gotowe  ', expectedVersion: 7);

    final payload =
        verify(
              () => repository.addItem(
                workspaceId: workspaceId,
                projectId: projectId,
                taskId: taskId,
                payload: captureAny(named: 'payload'),
              ),
            ).captured.single
            as CreateTaskChecklistItemPayload;
    expect(payload.title, 'Gotowe');
    expect(payload.expectedVersion, 7);
  });

  test('współpraca deleguje osobiste przypięcie', () async {
    final repository = _CollaborationRepositoryMock();
    when(
      () => repository.updatePinned(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        isPinned: true,
      ),
    ).thenAnswer((_) async => right(unit));
    final service = TaskDetailsCollaborationService(
      repository: repository,
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );

    final result = await service.togglePinned(isPinned: true);

    expect(result.isRight(), isTrue);
    verify(
      () => repository.updatePinned(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        isPinned: true,
      ),
    ).called(1);
  });
}
