import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/milestone_settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _MilestoneRepository implements MilestoneRepository {
  List<MilestoneResponse> milestones = [_milestone('milestone-1', 'Wdrożenie')];
  CreateMilestonePayload? createPayload;
  UpdateMilestonePayload? updatePayload;
  String? deletedId;

  @override
  Future<Either<ApiError, List<MilestoneResponse>>> listMilestones({
    required String workspaceId,
    required String projectId,
  }) async => Right(milestones);

  @override
  Future<Either<ApiError, MilestoneResponse>> getMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) async => Right(milestones.firstWhere((m) => m.id == milestoneId));

  @override
  Future<Either<ApiError, MilestoneResponse>> createMilestone({
    required String workspaceId,
    required String projectId,
    required CreateMilestonePayload payload,
  }) async {
    createPayload = payload;
    final milestone = _milestone('milestone-2', payload.name).copyWith(
      description: payload.description,
      dueAtUtc: payload.dueAtUtc,
    );
    milestones = [...milestones, milestone];
    return Right(milestone);
  }

  @override
  Future<Either<ApiError, MilestoneResponse>> updateMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required UpdateMilestonePayload payload,
  }) async {
    updatePayload = payload;
    final milestone = _milestone(milestoneId, payload.name).copyWith(
      description: payload.description,
      dueAtUtc: payload.dueAtUtc,
      status: payload.status,
    );
    milestones = [milestone];
    return Right(milestone);
  }

  @override
  Future<Either<ApiError, Unit>> deleteMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) async {
    deletedId = milestoneId;
    milestones = [];
    return const Right(unit);
  }

  @override
  Future<Either<ApiError, List<MilestoneTaskResponse>>> listTasks({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, Unit>> assignTask({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required String taskId,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, Unit>> unassignTask({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required String taskId,
  }) => throw UnimplementedError();
}

MilestoneResponse _milestone(String id, String name) => MilestoneResponse(
  id: id,
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  name: name,
  status: MilestoneStatus.active,
  progress: 0,
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);

void main() {
  late _MilestoneRepository repository;
  late MilestoneSettingsCubit cubit;

  setUp(() {
    repository = _MilestoneRepository();
    cubit = MilestoneSettingsCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
  });
  tearDown(() => cubit.close());

  test('tworzy kamień milowy z oczyszczonymi danymi', () async {
    await cubit.load();

    expect(
      await cubit.save(
        name: '  Premiera  ',
        description: '  Wersja pierwsza  ',
        dueAtUtc: DateTime.utc(2026, 8, 20),
        status: MilestoneStatus.active,
      ),
      isTrue,
    );
    expect(repository.createPayload?.name, 'Premiera');
    expect(repository.createPayload?.description, 'Wersja pierwsza');
  });

  test(
    'aktualizuje i usuwa kamień milowy lokalnie po sukcesie backendu',
    () async {
      await cubit.load();
      final original =
          (cubit.state as MilestoneSettingsReady).milestones.single;

      expect(
        await cubit.save(
          existing: original,
          name: 'Zamknięte',
          description: '',
          dueAtUtc: null,
          status: MilestoneStatus.completed,
        ),
        isTrue,
      );
      expect(repository.updatePayload?.status, MilestoneStatus.completed);
      expect(await cubit.delete(original), isTrue);
      expect(repository.deletedId, 'milestone-1');
      expect((cubit.state as MilestoneSettingsReady).milestones, isEmpty);
    },
  );
}
