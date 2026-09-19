import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_capacity_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_capacity_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/task_capacity_settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _CapacityRepository implements TaskCapacityRepository {
  WorkspaceCapacityResponse capacity = const WorkspaceCapacityResponse(
    workspaceId: 'workspace-1',
    defaultDailyCapacityMinutes: 480,
    version: 3,
  );
  List<UserCapacityOverrideResponse> overrides = [_override()];
  UpdateWorkspaceCapacityPayload? capacityPayload;
  String? deletedOverrideId;
  CreateUserCapacityOverridePayload? createPayload;
  UpdateUserCapacityOverridePayload? updatePayload;

  @override
  Future<Either<ApiError, WorkspaceCapacityResponse>> getWorkspaceCapacity({
    required String workspaceId,
  }) async => Right(capacity);

  @override
  Future<Either<ApiError, WorkspaceCapacityResponse>> updateWorkspaceCapacity({
    required String workspaceId,
    required UpdateWorkspaceCapacityPayload payload,
  }) async {
    capacityPayload = payload;
    capacity = capacity.copyWith(
      defaultDailyCapacityMinutes: payload.defaultDailyCapacityMinutes,
      version: capacity.version + 1,
    );
    return Right(capacity);
  }

  @override
  Future<Either<ApiError, List<UserCapacityOverrideResponse>>> listOverrides({
    required String workspaceId,
    required String projectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async => Right(overrides);

  @override
  Future<Either<ApiError, Unit>> deleteOverride({
    required String workspaceId,
    required String projectId,
    required String overrideId,
    required int expectedVersion,
  }) async {
    deletedOverrideId = overrideId;
    overrides = overrides.where((item) => item.id != overrideId).toList();
    return const Right(unit);
  }

  @override
  Future<Either<ApiError, UserCapacityOverrideResponse>> createOverride({
    required String workspaceId,
    required String projectId,
    required CreateUserCapacityOverridePayload payload,
  }) async {
    createPayload = payload;
    final value = UserCapacityOverrideResponse(
      id: 'override-2',
      workspaceId: workspaceId,
      projectId: projectId,
      userId: payload.userId,
      startDate: payload.startDate,
      endDate: payload.endDate,
      availableMinutesPerDay: payload.availableMinutesPerDay,
      reason: payload.reason,
      version: 1,
      updatedAtUtc: DateTime.utc(2026, 8, 20),
    );
    overrides = [...overrides, value];
    return Right(value);
  }

  @override
  Future<Either<ApiError, UserCapacityOverrideResponse>> updateOverride({
    required String workspaceId,
    required String projectId,
    required String overrideId,
    required UpdateUserCapacityOverridePayload payload,
  }) async {
    updatePayload = payload;
    final previous = overrides.singleWhere((item) => item.id == overrideId);
    final updated = previous.copyWith(
      startDate: payload.startDate,
      endDate: payload.endDate,
      availableMinutesPerDay: payload.availableMinutesPerDay,
      reason: payload.reason,
      version: previous.version + 1,
    );
    overrides = [
      for (final item in overrides)
        if (item.id == overrideId) updated else item,
    ];
    return Right(updated);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

UserCapacityOverrideResponse _override() => UserCapacityOverrideResponse(
  id: 'override-1',
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  userId: 'user-1',
  startDate: DateTime.utc(2026, 8),
  endDate: DateTime.utc(2026, 8, 31),
  availableMinutesPerDay: 240,
  version: 2,
  updatedAtUtc: DateTime.utc(2026, 8),
);

void main() {
  late _CapacityRepository repository;
  late TaskCapacitySettingsCubit cubit;

  setUp(() {
    repository = _CapacityRepository();
    cubit = TaskCapacitySettingsCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
  });
  tearDown(() => cubit.close());

  test('zapisuje domyślną pojemność z aktualną wersją', () async {
    await cubit.load();

    expect(await cubit.saveDefaultDailyCapacity(420), isTrue);
    expect(repository.capacityPayload?.expectedVersion, 3);
    expect(
      (cubit.state as TaskCapacitySettingsReady)
          .capacity
          .defaultDailyCapacityMinutes,
      420,
    );
  });

  test('usuwa override z jego expectedVersion', () async {
    await cubit.load();
    final override =
        (cubit.state as TaskCapacitySettingsReady).overrides.single;

    expect(await cubit.deleteOverride(override), isTrue);
    expect(repository.deletedOverrideId, 'override-1');
    expect((cubit.state as TaskCapacitySettingsReady).overrides, isEmpty);
  });

  test('tworzy i scala override dostępności osoby', () async {
    await cubit.load();
    final payload = CreateUserCapacityOverridePayload(
      userId: 'user-2',
      startDate: DateTime.utc(2026, 9),
      endDate: DateTime.utc(2026, 9, 5),
      availableMinutesPerDay: 180,
      reason: 'Szkolenie',
    );

    expect(await cubit.createOverride(payload), isTrue);
    expect(repository.createPayload, payload);
    expect((cubit.state as TaskCapacitySettingsReady).overrides, hasLength(2));
  });

  test('odrzuca override z odwróconym zakresem bez wywołania API', () async {
    await cubit.load();
    expect(
      await cubit.createOverride(
        CreateUserCapacityOverridePayload(
          userId: 'user-2',
          startDate: DateTime.utc(2026, 9, 5),
          endDate: DateTime.utc(2026, 9),
          availableMinutesPerDay: 180,
        ),
      ),
      isFalse,
    );
    expect(repository.createPayload, isNull);
  });
}
