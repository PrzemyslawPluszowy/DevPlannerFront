import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_status_category.dart';
import 'package:ready_next/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/task_workflow_settings_cubit.dart';

final class _WorkflowRepository implements TaskWorkflowRepository {
  _WorkflowRepository(this.workflow);

  ProjectTaskWorkflowResponse workflow;
  UpdateProjectTaskWorkflowPayload? payload;
  ApiError? updateError;

  @override
  Future<Either<ApiError, ProjectTaskWorkflowResponse>> getWorkflow({
    required String workspaceId,
    required String projectId,
  }) async => Right(workflow);

  @override
  Future<Either<ApiError, ProjectTaskWorkflowResponse>> updateWorkflow({
    required String workspaceId,
    required String projectId,
    required UpdateProjectTaskWorkflowPayload payload,
  }) async {
    this.payload = payload;
    final error = updateError;
    if (error != null) return Left(error);
    workflow = workflow.copyWith(
      transitions: payload.transitions,
      version: workflow.version + 1,
    );
    return Right(workflow);
  }
}

ProjectTaskWorkflowResponse _workflow() => const ProjectTaskWorkflowResponse(
  statuses: [
    ProjectTaskWorkflowStatusResponse(
      status: ProjectTaskStatus.todo,
      displayName: 'Do zrobienia',
      color: '#6750A4',
      position: 0,
      isInitial: true,
      isTerminal: false,
      category: TaskStatusCategory.todo,
    ),
    ProjectTaskWorkflowStatusResponse(
      status: ProjectTaskStatus.inProgress,
      displayName: 'W toku',
      color: '#1565C0',
      position: 1,
      isInitial: false,
      isTerminal: false,
      category: TaskStatusCategory.inProgress,
    ),
  ],
  transitions: [],
  version: 8,
);

void main() {
  late _WorkflowRepository repository;
  late TaskWorkflowSettingsCubit cubit;

  setUp(() {
    repository = _WorkflowRepository(_workflow());
    cubit = TaskWorkflowSettingsCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
  });
  tearDown(() => cubit.close());

  test('zapisuje pełny workflow i dodaje kierunkowe przejście', () async {
    await cubit.load();

    expect(
      await cubit.toggleTransition(
        from: ProjectTaskStatus.todo,
        to: ProjectTaskStatus.inProgress,
        allowed: true,
      ),
      isTrue,
    );
    expect(repository.payload?.expectedVersion, 8);
    expect(repository.payload?.statuses, hasLength(2));
    expect(
      repository.payload?.transitions,
      contains(
        const ProjectTaskWorkflowTransitionResponse(
          fromStatus: ProjectTaskStatus.todo,
          toStatus: ProjectTaskStatus.inProgress,
        ),
      ),
    );
    expect((cubit.state as TaskWorkflowSettingsReady).workflow.version, 9);
  });

  test('pozostawia poprzedni workflow po błędzie zapisu', () async {
    await cubit.load();
    repository.updateError = const ApiError(
      type: ApiErrorType.conflict,
      message: 'Konflikt wersji.',
    );

    expect(
      await cubit.toggleTransition(
        from: ProjectTaskStatus.todo,
        to: ProjectTaskStatus.inProgress,
        allowed: true,
      ),
      isFalse,
    );
    final state = cubit.state as TaskWorkflowSettingsReady;
    expect(state.workflow.transitions, isEmpty);
    expect(state.error, 'Konflikt wersji.');
  });
}
