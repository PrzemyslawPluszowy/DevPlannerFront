import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_time_tracking_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements TaskTimeTrackingRepository {
  _Repository(this.listResult);
  Either<ApiError, List<TaskTimeEntryResponse>> listResult;
  Either<ApiError, TaskTimeEntryResponse>? startResult;
  Either<ApiError, TaskTimeEntryResponse>? createResult;
  Object? listThrown;
  Object? startThrown;
  Object? secondListThrown;
  int listCalls = 0;
  int workflowCalls = 0;
  int startCalls = 0;
  int stopCalls = 0;
  int createCalls = 0;
  TimeEntryWorkflowPayload? workflowPayload;
  @override
  Future<Either<ApiError, List<TaskTimeEntryResponse>>> list({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async {
    listCalls++;
    if (listCalls == 1 && listThrown != null) {
      Error.throwWithStackTrace(listThrown!, StackTrace.current);
    }
    if (listCalls > 1 && secondListThrown != null) {
      Error.throwWithStackTrace(secondListThrown!, StackTrace.current);
    }
    return listResult;
  }

  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> startTimer({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async {
    startCalls++;
    if (startThrown case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    return startResult!;
  }

  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskTimeEntryPayload payload,
  }) async {
    createCalls++;
    return createResult!;
  }

  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> stopTimer({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required StopTaskTimerPayload payload,
  }) async {
    stopCalls++;
    return Right(_entry());
  }

  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> submit({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String entryId,
    required TimeEntryWorkflowPayload payload,
  }) async {
    workflowCalls++;
    workflowPayload = payload;
    return Right(_entry());
  }

  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> approve({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String entryId,
    required TimeEntryWorkflowPayload payload,
  }) async {
    workflowCalls++;
    workflowPayload = payload;
    return Right(_entry());
  }

  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> reject({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String entryId,
    required TimeEntryWorkflowPayload payload,
  }) async {
    workflowCalls++;
    workflowPayload = payload;
    return Right(_entry());
  }

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
  canSubmit: !active,
  canStopTimer: active,
);
TaskTimeTrackingCubit _cubit(_Repository repository) => TaskTimeTrackingCubit(
  repository: repository,
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  taskId: 'task-1',
);

final class _Profiles implements ProjectMemberProfilesRepository {
  _Profiles(this.result);
  Either<ApiError, List<ProjectMemberProfile>> result;
  int calls = 0;
  bool? lastForceRefresh;
  final pendingResults =
      <Completer<Either<ApiError, List<ProjectMemberProfile>>>>[];

  @override
  Future<Either<ApiError, List<ProjectMemberProfile>>> listProfiles({
    required String workspaceId,
    required String projectId,
    bool forceRefresh = false,
  }) async {
    calls++;
    lastForceRefresh = forceRefresh;
    if (pendingResults.isNotEmpty) return pendingResults.removeAt(0).future;
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('wzbogaca autora recenzji tylko nazwą z profilu ACL projektu', () async {
    final entry = _entry().copyWith(
      approvalStatus: TaskTimeEntryApprovalStatus.approved,
      reviewedByUserId: 'reviewer-uuid',
      reviewedAtUtc: DateTime.utc(2026, 8, 27),
      reviewComment: 'Checked',
    );
    final cubit = TaskTimeTrackingCubit(
      repository: _Repository(Right([entry])),
      memberProfilesRepository: _Profiles(
        const Right([
          ProjectMemberProfile(
            userId: 'reviewer-uuid',
            displayName: 'Reviewer Name',
            role: ProjectRole.member,
          ),
        ]),
      ),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );

    await cubit.load();
    await cubit.stream.firstWhere(
      (state) =>
          state is TaskTimeTrackingReady &&
          state.reviewerIdsLookedUp.contains('reviewer-uuid'),
    );

    final state = cubit.state as TaskTimeTrackingReady;
    expect(state.entries, [entry]);
    expect(state.reviewerNames, {'reviewer-uuid': 'Reviewer Name'});
    expect(state.reviewerLookupFailure, isNull);
    expect(state.reviewerIdsLookedUp, {'reviewer-uuid'});
    await cubit.close();
  });

  test('błąd profili nie odrzuca wpisów czasu ani nie ujawnia UUID', () async {
    final entry = _entry().copyWith(
      approvalStatus: TaskTimeEntryApprovalStatus.rejected,
      reviewedByUserId: 'reviewer-uuid',
    );
    const profileFailure = ApiError(
      type: ApiErrorType.connection,
      message: 'offline',
    );
    final profiles = _Profiles(const Left(profileFailure));
    final cubit = TaskTimeTrackingCubit(
      repository: _Repository(Right([entry])),
      memberProfilesRepository: profiles,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );

    await cubit.load();
    await cubit.stream.firstWhere(
      (state) =>
          state is TaskTimeTrackingReady && state.reviewerLookupFailure != null,
    );

    var state = cubit.state as TaskTimeTrackingReady;
    expect(state.entries, [entry]);
    expect(state.reviewerNames, isEmpty);
    expect(state.reviewerLookupFailure, profileFailure);
    expect(state.reviewerIdsLookedUp, isEmpty);
    profiles.result = const Right([
      ProjectMemberProfile(
        userId: 'reviewer-uuid',
        displayName: 'Reviewer Name',
        role: ProjectRole.member,
      ),
    ]);
    await cubit.retryReviewerNames();
    state = cubit.state as TaskTimeTrackingReady;
    expect(profiles.lastForceRefresh, isTrue);
    expect(state.reviewerNames, {'reviewer-uuid': 'Reviewer Name'});
    expect(state.reviewerLookupFailure, isNull);
    await cubit.close();
  });

  test(
    'looks up a newly seen reviewer after a successful prior lookup',
    () async {
      final firstEntry = _entry().copyWith(reviewedByUserId: 'reviewer-one');
      final repository = _Repository(Right([firstEntry]));
      final profiles = _Profiles(
        const Right([
          ProjectMemberProfile(
            userId: 'reviewer-one',
            displayName: 'Reviewer One',
            role: ProjectRole.member,
          ),
          ProjectMemberProfile(
            userId: 'reviewer-two',
            displayName: 'Reviewer Two',
            role: ProjectRole.member,
          ),
        ]),
      );
      final cubit = TaskTimeTrackingCubit(
        repository: repository,
        memberProfilesRepository: profiles,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await cubit.load();
      await cubit.stream.firstWhere(
        (state) =>
            state is TaskTimeTrackingReady &&
            state.reviewerIdsLookedUp.contains('reviewer-one'),
      );

      repository.listResult = Right([
        firstEntry.copyWith(reviewedByUserId: 'reviewer-two'),
      ]);
      repository.startResult = Right(_entry());
      await cubit.startTimer();
      await cubit.stream.firstWhere(
        (state) =>
            state is TaskTimeTrackingReady &&
            state.reviewerIdsLookedUp.contains('reviewer-two'),
      );

      final state = cubit.state as TaskTimeTrackingReady;
      expect(state.reviewerNames['reviewer-two'], 'Reviewer Two');
      expect(profiles.calls, 2);
      expect(profiles.lastForceRefresh, isTrue);
      await cubit.close();
    },
  );

  test(
    'blocks duplicate reviewer lookup while one request is pending',
    () async {
      final entry = _entry().copyWith(reviewedByUserId: 'reviewer-uuid');
      final profiles = _Profiles(const Right([]));
      final pending = Completer<Either<ApiError, List<ProjectMemberProfile>>>();
      profiles.pendingResults.add(pending);
      final cubit = TaskTimeTrackingCubit(
        repository: _Repository(Right([entry])),
        memberProfilesRepository: profiles,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );

      await cubit.load();
      expect(profiles.calls, 1);
      expect(
        (cubit.state as TaskTimeTrackingReady).isReviewerLookupLoading,
        isTrue,
      );
      await cubit.retryReviewerNames();
      await cubit.retryReviewerNames();
      expect(profiles.calls, 1);

      pending.complete(
        const Right([
          ProjectMemberProfile(
            userId: 'reviewer-uuid',
            displayName: 'Reviewer',
            role: ProjectRole.member,
          ),
        ]),
      );
      await cubit.stream.firstWhere(
        (state) =>
            state is TaskTimeTrackingReady &&
            state.reviewerIdsLookedUp.contains('reviewer-uuid'),
      );
      await cubit.close();
    },
  );

  test(
    'reviewer 429 cooldown blocks retry but leaves time actions enabled',
    () async {
      final entry = _entry().copyWith(reviewedByUserId: 'reviewer-uuid');
      final profiles = _Profiles(
        Left(
          ApiError(
            type: ApiErrorType.server,
            message: 'rate limited',
            statusCode: 429,
            retryAfterUtc: DateTime.now().toUtc().add(
              const Duration(minutes: 1),
            ),
            traceId: 'reviewer-trace-429',
          ),
        ),
      );
      final repository = _Repository(Right([entry]))
        ..startResult = Right(_entry());
      final cubit = TaskTimeTrackingCubit(
        repository: repository,
        memberProfilesRepository: profiles,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );

      await cubit.load();
      await cubit.stream.firstWhere(
        (state) =>
            state is TaskTimeTrackingReady &&
            state.reviewerLookupFailure?.statusCode == 429,
      );
      final state = cubit.state as TaskTimeTrackingReady;
      expect(state.isReviewerLookupRetryBlocked, isTrue);
      expect(state.reviewerLookupFailure?.traceId, 'reviewer-trace-429');
      await cubit.retryReviewerNames();
      expect(profiles.calls, 1);

      expect(await cubit.startTimer(), isTrue);
      final afterStart = cubit.state as TaskTimeTrackingReady;
      expect(repository.startCalls, 1);
      expect(afterStart.entries, isNotEmpty);
      expect(afterStart.isReviewerLookupRetryBlocked, isTrue);
      expect(afterStart.isRetryBlocked, isFalse);
      await cubit.close();
    },
  );

  test('ignores stale profile retry after a newer entries reload', () async {
    final entry = _entry().copyWith(reviewedByUserId: 'reviewer-uuid');
    final profiles = _Profiles(
      const Left(
        ApiError(type: ApiErrorType.connection, message: 'offline'),
      ),
    );
    final cubit = TaskTimeTrackingCubit(
      repository: _Repository(Right([entry])),
      memberProfilesRepository: profiles,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();
    await cubit.stream.firstWhere(
      (state) =>
          state is TaskTimeTrackingReady && state.reviewerLookupFailure != null,
    );

    final stale = Completer<Either<ApiError, List<ProjectMemberProfile>>>();
    final fresh = Completer<Either<ApiError, List<ProjectMemberProfile>>>();
    profiles.pendingResults.add(stale);
    final staleRetry = cubit.retryReviewerNames();
    expect(profiles.calls, 2);
    profiles.pendingResults.add(fresh);
    await cubit.load();
    expect(profiles.calls, 3);

    stale.complete(
      const Right([
        ProjectMemberProfile(
          userId: 'reviewer-uuid',
          displayName: 'Stale reviewer',
          role: ProjectRole.member,
        ),
      ]),
    );
    await staleRetry;
    expect((cubit.state as TaskTimeTrackingReady).reviewerNames, isEmpty);

    fresh.complete(
      const Right([
        ProjectMemberProfile(
          userId: 'reviewer-uuid',
          displayName: 'Current reviewer',
          role: ProjectRole.member,
        ),
      ]),
    );
    await cubit.stream.firstWhere(
      (state) =>
          state is TaskTimeTrackingReady &&
          state.reviewerNames.containsKey('reviewer-uuid'),
    );
    expect(
      (cubit.state as TaskTimeTrackingReady).reviewerNames['reviewer-uuid'],
      'Current reviewer',
    );
    await cubit.close();
  });

  test('does not publish profile results after Cubit closes', () async {
    final entry = _entry().copyWith(reviewedByUserId: 'reviewer-uuid');
    final profiles = _Profiles(const Right([]));
    final pending = Completer<Either<ApiError, List<ProjectMemberProfile>>>();
    profiles.pendingResults.add(pending);
    final cubit = TaskTimeTrackingCubit(
      repository: _Repository(Right([entry])),
      memberProfilesRepository: profiles,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();
    expect(profiles.calls, 1);
    await cubit.close();

    pending.complete(
      const Right([
        ProjectMemberProfile(
          userId: 'reviewer-uuid',
          displayName: 'Late reviewer',
          role: ProjectRole.member,
        ),
      ]),
    );
    await Future<void>.delayed(Duration.zero);
    expect(cubit.isClosed, isTrue);
  });

  test('snapshot czasu nie zmienia się po mutacji listy repozytorium', () {
    final entries = [_entry(), _entry(active: true).copyWith(id: 'timer-2')];
    final ready = TaskTimeTrackingReady(
      entries: entries,
      nowUtc: DateTime.utc(2026, 8, 26, 11, 5),
    );
    entries.clear();
    expect(ready.entries, hasLength(2));
    expect(ready.totalMinutes, 95);
    expect(
      ready.copyWith(nowUtc: DateTime.utc(2026, 8, 26, 11, 6)).totalMinutes,
      96,
    );
    expect(ready.entries.clear, throwsUnsupportedError);
  });
  test('ładuje wpisy i rozpoznaje aktywny timer', () async {
    final cubit = _cubit(_Repository(Right([_entry(active: true)])));
    await cubit.load();
    final state = cubit.state as TaskTimeTrackingReady;
    expect(state.entries, hasLength(1));
    expect(state.activeTimers, hasLength(1));
    await cubit.close();
  });
  test('odzyskuje się po wyjątku odczytu bez ujawnienia szczegółów', () async {
    final repository = _Repository(const Right([]))
      ..listThrown = StateError('private transport detail');
    final cubit = _cubit(repository);

    await cubit.load();

    final failed = cubit.state as TaskTimeTrackingFailure;
    expect(failed.apiError?.type, ApiErrorType.unknown);
    expect(failed.message, isEmpty);
    repository.listThrown = null;
    await cubit.load();
    expect(cubit.state, isA<TaskTimeTrackingReady>());
    expect(repository.listCalls, 2);
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
  test('wyjątek mutacji zachowuje Retry-After i kończy stan zapisu', () async {
    final retryAt = DateTime.now().toUtc().add(const Duration(hours: 1));
    final apiError = ApiError(
      type: ApiErrorType.server,
      message: 'Spróbuj później',
      statusCode: 429,
      apiCode: 'rate_limited',
      contractCode: 'rate_limited',
      backendCode: 4291,
      fields: const {
        'timer': ['cooldown'],
      },
      traceId: 'trace-time-429',
      retryAfterUtc: retryAt,
    );
    final repository = _Repository(Right([_entry()]))..startThrown = apiError;
    final cubit = _cubit(repository);
    await cubit.load();

    expect(await cubit.startTimer(), isFalse);

    final state = cubit.state as TaskTimeTrackingReady;
    expect(state.isSaving, isFalse);
    expect(state.apiError, apiError);
    expect(state.apiError?.retryAfterUtc, retryAt);
    expect(state.apiError?.fields, apiError.fields);
    await cubit.close();
  });
  test('Retry-After blokuje zapis do czasu odblokowania', () async {
    final repository = _Repository(Right([_entry()]))
      ..startThrown = ApiError(
        type: ApiErrorType.server,
        message: 'Rate limited',
        statusCode: 429,
        retryAfterUtc: DateTime.now().toUtc().add(
          const Duration(milliseconds: 80),
        ),
      );
    final cubit = _cubit(repository);
    await cubit.load();

    expect(await cubit.startTimer(), isFalse);
    expect((cubit.state as TaskTimeTrackingReady).isRetryBlocked, isTrue);
    expect(await cubit.startTimer(), isFalse);
    expect(repository.startCalls, 1);

    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect((cubit.state as TaskTimeTrackingReady).isRetryBlocked, isFalse);
    repository.startThrown = null;
    repository.startResult = Right(_entry(active: true));
    expect(await cubit.startTimer(), isTrue);
    expect(repository.startCalls, 2);
    await cubit.close();
  });
  test('potwierdzony start zwraca sukces mimo wyjątku odświeżenia', () async {
    const apiError = ApiError(
      type: ApiErrorType.unknown,
      message: 'Refresh failed',
      apiCode: 'task_time_entries_load_failed',
      traceId: 'trace-refresh',
    );
    final repository = _Repository(Right([_entry()]))
      ..startResult = Right(_entry(active: true))
      ..secondListThrown = apiError;
    final cubit = _cubit(repository);
    await cubit.load();

    expect(await cubit.startTimer(), isTrue);

    final state = cubit.state as TaskTimeTrackingReady;
    expect(state.isSaving, isFalse);
    expect(state.entries, hasLength(1));
    expect(state.apiError, apiError);
    expect(repository.listCalls, 2);
    await cubit.close();
  });
  test(
    'potwierdzony wpis create zostaje w liście po błędzie refreshu',
    () async {
      const apiError = ApiError(
        type: ApiErrorType.unknown,
        message: 'Refresh failed',
        apiCode: 'task_time_entries_load_failed',
      );
      final repository = _Repository(const Right([]))
        ..createResult = Right(_entry())
        ..secondListThrown = apiError;
      final cubit = _cubit(repository);
      await cubit.load();

      final created = await cubit.create(
        const CreateTaskTimeEntryPayload(
          durationMinutes: 30,
          isBillable: true,
        ),
      );

      final state = cubit.state as TaskTimeTrackingReady;
      expect(created, isTrue);
      expect(repository.createCalls, 1);
      expect(state.entries, hasLength(1));
      expect(state.entries.single.id, 'entry-1');
      expect(state.apiError, apiError);
      await cubit.close();
    },
  );
  test(
    'potwierdzone zatrzymanie nie pokazuje aktywnego timera ponownie',
    () async {
      final repository = _Repository(Right([_entry(active: true)]))
        ..secondListThrown = const ApiError(
          type: ApiErrorType.unknown,
          message: 'Refresh failed',
        );
      final cubit = _cubit(repository);
      await cubit.load();

      expect(await cubit.stopTimer(), isTrue);
      final state = cubit.state as TaskTimeTrackingReady;
      expect(state.activeTimers, isEmpty);
      expect(state.ownActiveTimers, isEmpty);
      expect(await cubit.stopTimer(), isFalse);
      expect(repository.stopCalls, 1);
      await cubit.close();
    },
  );
  test('cudzy aktywny timer nie daje prawa zatrzymania', () async {
    final repository = _Repository(
      Right([_entry(active: true).copyWith(canStopTimer: false)]),
    );
    final cubit = _cubit(repository);
    await cubit.load();
    final ready = cubit.state as TaskTimeTrackingReady;
    expect(ready.activeTimers, hasLength(1));
    expect(ready.ownActiveTimers, isEmpty);
    expect(await cubit.stopTimer(), isFalse);
    expect(repository.stopCalls, 0);
    await cubit.close();
  });
  test('własny timer można zatrzymać w zadaniu tylko do odczytu', () async {
    final repository = _Repository(Right([_entry(active: true)]));
    final cubit = TaskTimeTrackingCubit(
      repository: repository,
      workspaceId: 'w',
      projectId: 'p',
      taskId: 't',
      canEdit: () => false,
    );
    await cubit.load();
    expect(await cubit.startTimer(), isFalse);
    repository.listResult = Right([_entry()]);
    expect(await cubit.stopTimer(), isTrue);
    expect(repository.stopCalls, 1);
    expect((cubit.state as TaskTimeTrackingReady).ownActiveTimers, isEmpty);
    await cubit.close();
    expect(await cubit.stopTimer(), isFalse);
    expect(repository.stopCalls, 1);
  });
  test(
    'workflow używa capability aktualnego wpisu, nie dowolnego argumentu',
    () async {
      final entry = _entry().copyWith(canSubmit: false, canReview: false);
      final repository = _Repository(Right([entry]));
      final cubit = _cubit(repository);
      await cubit.load();
      final forged = entry.copyWith(canSubmit: true, canReview: true);
      expect(await cubit.submit(forged), isFalse);
      expect(await cubit.approve(forged), isFalse);
      expect(await cubit.reject(forged), isFalse);
      expect(repository.workflowCalls, 0);
      await cubit.close();
    },
  );
  test(
    'review wpisu z archiwum taska zachowuje uprawnienie i komentarz',
    () async {
      final entry = _entry().copyWith(
        approvalStatus: TaskTimeEntryApprovalStatus.submitted,
        canSubmit: false,
        canReview: true,
        version: 7,
      );
      final repository = _Repository(Right([entry]));
      final cubit = TaskTimeTrackingCubit(
        repository: repository,
        workspaceId: 'w',
        projectId: 'p',
        taskId: 't',
        canEdit: () => false,
      );
      await cubit.load();
      expect(await cubit.startTimer(), isFalse);
      expect(await cubit.submit(entry), isFalse);
      expect(await cubit.approve(entry, comment: 'Zweryfikowano'), isTrue);
      expect(repository.workflowPayload?.comment, 'Zweryfikowano');
      expect(repository.workflowPayload?.expectedVersion, 7);
      expect(repository.workflowCalls, 1);
      await cubit.close();
      expect(await cubit.reject(entry, comment: 'Późno'), isFalse);
      expect(repository.workflowCalls, 1);
    },
  );
}
