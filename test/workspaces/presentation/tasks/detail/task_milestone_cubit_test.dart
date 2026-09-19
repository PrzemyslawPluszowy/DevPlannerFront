import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/milestone/cubit/task_milestone_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements MilestoneRepository {
  final assignedTaskIds = <String, Set<String>>{
    'milestone-1': {'task-1'},
    'milestone-2': {},
  };
  String? assignedMilestoneId;
  String? unassignedMilestoneId;

  @override
  Future<Either<ApiError, List<MilestoneResponse>>> listMilestones({
    required String workspaceId,
    required String projectId,
  }) async => Right([_milestone('milestone-1'), _milestone('milestone-2')]);

  @override
  Future<Either<ApiError, MilestoneResponse>> getMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) async => Right(_milestone(milestoneId));

  @override
  Future<Either<ApiError, List<MilestoneTaskResponse>>> listTasks({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) async => Right([
    for (final id in assignedTaskIds[milestoneId]!) _task(id),
  ]);

  @override
  Future<Either<ApiError, Unit>> assignTask({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required String taskId,
  }) async {
    assignedMilestoneId = milestoneId;
    assignedTaskIds[milestoneId]!.add(taskId);
    return const Right(unit);
  }

  @override
  Future<Either<ApiError, Unit>> unassignTask({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required String taskId,
  }) async {
    unassignedMilestoneId = milestoneId;
    assignedTaskIds[milestoneId]!.remove(taskId);
    return const Right(unit);
  }

  @override
  Future<Either<ApiError, MilestoneResponse>> createMilestone({
    required String workspaceId,
    required String projectId,
    required CreateMilestonePayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, MilestoneResponse>> updateMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required UpdateMilestonePayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, Unit>> deleteMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) => throw UnimplementedError();
}

MilestoneResponse _milestone(String id) => MilestoneResponse(
  id: id,
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  name: id,
  status: MilestoneStatus.active,
  progress: 0,
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);

MilestoneTaskResponse _task(String id) => MilestoneTaskResponse(
  id: id,
  number: 1,
  key: 'PRO-1',
  title: 'Zadanie',
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  version: 1,
);

void main() {
  late _Repository repository;
  late TaskMilestoneCubit cubit;

  setUp(() {
    repository = _Repository();
    cubit = TaskMilestoneCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
  });
  tearDown(() => cubit.close());

  test('odczytuje przypisanie przez listę zadań milestone’ów', () async {
    await cubit.load();

    expect((cubit.state as TaskMilestoneReady).assigned?.id, 'milestone-1');
  });

  test(
    'odpina zadanie, a potem pozwala przypisać je do innego milestone’u',
    () async {
      await cubit.load();

      expect(await cubit.unassign(), isTrue);
      expect(repository.unassignedMilestoneId, 'milestone-1');
      final target = (cubit.state as TaskMilestoneReady).milestones.last;
      expect(await cubit.assign(target), isTrue);
      expect(repository.assignedMilestoneId, 'milestone-2');
    },
  );
}
