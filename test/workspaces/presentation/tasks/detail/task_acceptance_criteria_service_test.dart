import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_acceptance_criteria_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _AcceptanceRepositoryMock extends Mock
    implements TaskAcceptanceCriteriaRepository {}

const workspaceId = 'workspace-1';
const projectId = 'project-1';
const taskId = 'task-1';

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CreateTaskAcceptanceCriterionPayload(
        text: 'fallback',
        expectedVersion: 1,
      ),
    );
  });

  test('nie wysyła pustego kryterium', () async {
    final repository = _AcceptanceRepositoryMock();
    final service = TaskAcceptanceCriteriaService(
      repository: repository,
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );

    final result = await service.add(text: '  ', expectedVersion: 4);

    expect(
      result,
      isA<
        Left<ApiError, TaskMutationResponse<TaskAcceptanceCriterionResponse>>
      >(),
    );
    verifyNever(
      () => repository.create(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
        taskId: any(named: 'taskId'),
        payload: any(named: 'payload'),
      ),
    );
  });

  test('normalizuje tekst i przekazuje wersję do repository', () async {
    final repository = _AcceptanceRepositoryMock();
    final response = TaskMutationResponse<TaskAcceptanceCriterionResponse>(
      taskId: taskId,
      data: _criterion(),
      taskVersion: 5,
      taskUpdatedAtUtc: DateTime.utc(2026, 9, 18),
    );
    when(
      () => repository.create(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async => right(response));

    final service = TaskAcceptanceCriteriaService(
      repository: repository,
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );

    final result = await service.add(text: '  Gotowe  ', expectedVersion: 4);

    expect(result.isRight(), isTrue);
    final captured =
        verify(
              () => repository.create(
                workspaceId: workspaceId,
                projectId: projectId,
                taskId: taskId,
                payload: captureAny(named: 'payload'),
              ),
            ).captured.single
            as CreateTaskAcceptanceCriterionPayload;
    expect(captured.text, 'Gotowe');
    expect(captured.expectedVersion, 4);
  });
}

TaskAcceptanceCriterionResponse _criterion() => TaskAcceptanceCriterionResponse(
  id: 'criterion-1',
  text: 'Gotowe',
  position: 0,
  isAccepted: false,
  updatedAtUtc: DateTime.utc(2026, 9, 18),
);
