import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/task_time_tracking_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_cubit.dart';

final class _Repository implements TaskTimeTrackingRepository {
  _Repository(this.listResult);
  Either<ApiError, List<TaskTimeEntryResponse>> listResult;
  Either<ApiError, TaskTimeEntryResponse>? startResult;
  int listCalls = 0;
  @override
  Future<Either<ApiError, List<TaskTimeEntryResponse>>> list({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async {
    listCalls++;
    return listResult;
  }

  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> startTimer({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async => startResult!;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

TaskTimeEntryResponse _entry({bool active = false}) => TaskTimeEntryResponse(
  id: 'entry-1',
  taskId: 'task-1',
  userId: 'user-1',
  kind: TaskTimeEntryKind.timer,
  startedAtUtc: DateTime.utc(2026, 8, 26, 10),
  stoppedAtUtc: active ? null : DateTime.utc(2026, 8, 26, 10, 30),
  durationMinutes: active ? null : 30,
  isBillable: true,
  createdAtUtc: DateTime.utc(2026, 8, 26),
  approvalStatus: TaskTimeEntryApprovalStatus.draft,
  version: 1,
);
TaskTimeTrackingCubit _cubit(_Repository repository) => TaskTimeTrackingCubit(
  repository: repository,
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  taskId: 'task-1',
);

void main() {
  test('ładuje wpisy i rozpoznaje aktywny timer', () async {
    final cubit = _cubit(_Repository(Right([_entry(active: true)])));
    await cubit.load();
    final state = cubit.state as TaskTimeTrackingReady;
    expect(state.entries, hasLength(1));
    expect(state.activeTimers, hasLength(1));
    await cubit.close();
  });
  test('po starcie timera odświeża wpisy z backendu', () async {
    final repository = _Repository(const Right([]))
      ..startResult = Right(_entry(active: true));
    final cubit = _cubit(repository);
    await cubit.load();
    repository.listResult = Right([_entry(active: true)]);
    expect(await cubit.startTimer(), isTrue);
    expect(repository.listCalls, 2);
    await cubit.close();
  });
  test('zachowuje listę po błędzie startu timera', () async {
    final repository = _Repository(Right([_entry()]))
      ..startResult = const Left(
        ApiError(
          type: ApiErrorType.conflict,
          message: 'Timer jest już uruchomiony',
        ),
      );
    final cubit = _cubit(repository);
    await cubit.load();
    expect(await cubit.startTimer(), isFalse);
    final state = cubit.state as TaskTimeTrackingReady;
    expect(state.entries, hasLength(1));
    expect(state.error, 'Timer jest już uruchomiony');
    await cubit.close();
  });
}
