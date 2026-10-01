import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_history_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/history/cubit/task_history_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _ProfilesRepository extends Mock
    implements ProjectMemberProfilesRepository {}

final class _TaskHistoryRepository implements TaskHistoryRepository {
  _TaskHistoryRepository(this.responses);

  final List<Either<ApiError, CursorPageResponse<TaskHistoryEventResponse>>>
  responses;
  final cursors = <String?>[];

  @override
  Future<Either<ApiError, CursorPageResponse<TaskHistoryEventResponse>>>
  listHistory({
    required String workspaceId,
    required String projectId,
    required String taskId,
    String? cursor,
  }) async {
    cursors.add(cursor);
    return responses.removeAt(0);
  }
}

TaskHistoryEventResponse _event(String id) => TaskHistoryEventResponse(
  eventId: id,
  eventType: TaskHistoryEventType.updated,
  actionLabel: 'Zmieniono zadanie',
  actor: const TaskHistoryActorResponse(
    type: TaskActorType.user,
    userId: 'user-1',
  ),
  changes: const [],
  taskVersion: 2,
  correlationId: 'correlation-$id',
  createdAtUtc: DateTime.utc(2026, 8, 26),
);

TaskHistoryCubit _cubit(_TaskHistoryRepository repository) => TaskHistoryCubit(
  repository: repository,
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  taskId: 'task-1',
);

void main() {
  test('late author lookup cannot replace a newer history load', () async {
    final profiles = _ProfilesRepository();
    final oldRead = Completer<Either<ApiError, List<ProjectMemberProfile>>>();
    final started = Completer<void>();
    var reads = 0;
    when(
      () => profiles.listProfiles(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer((_) {
      if (reads++ == 0) {
        started.complete();
        return oldRead.future;
      }
      return Future.value(
        right([
          const ProjectMemberProfile(
            userId: 'user-1',
            role: ProjectRole.member,
            displayName: 'Current Author',
          ),
        ]),
      );
    });
    final repository = _TaskHistoryRepository([
      Right(CursorPageResponse(items: [_event('old-event')])),
      Right(CursorPageResponse(items: [_event('current-event')])),
    ]);
    final cubit = TaskHistoryCubit(
      repository: repository,
      memberProfilesRepository: profiles,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    addTearDown(cubit.close);
    final oldLoad = cubit.load();
    await started.future;
    await cubit.load();
    oldRead.complete(
      right([
        const ProjectMemberProfile(
          userId: 'user-1',
          role: ProjectRole.member,
          displayName: 'Old Author',
        ),
      ]),
    );
    await oldLoad;
    final ready = cubit.state as TaskHistoryReady;
    expect(ready.events.single.eventId, 'current-event');
    expect(ready.actorNames['user-1'], 'Current Author');
  });

  test(
    'actor lookup access loss fails closed and notifies the task owner',
    () async {
      final profiles = _ProfilesRepository();
      const failure = ApiError(
        type: ApiErrorType.forbidden,
        message: 'Access revoked',
        statusCode: 403,
      );
      when(
        () => profiles.listProfiles(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).thenAnswer((_) async => left(failure));
      final repository = _TaskHistoryRepository([
        Right(CursorPageResponse(items: [_event('event-1')])),
      ]);
      final accessLost = <ApiError>[];
      final cubit = TaskHistoryCubit(
        repository: repository,
        memberProfilesRepository: profiles,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
        onAccessLost: accessLost.add,
      );
      addTearDown(cubit.close);
      await cubit.load();
      expect(cubit.state, isA<TaskHistoryFailure>());
      expect((cubit.state as TaskHistoryFailure).apiError, same(failure));
      expect(accessLost, [failure]);
    },
  );
  test(
    'loads access-safe author names once and keeps them across pagination',
    () async {
      final profiles = _ProfilesRepository();
      when(
        () => profiles.listProfiles(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).thenAnswer(
        (_) async => right([
          const ProjectMemberProfile(
            userId: 'user-1',
            role: ProjectRole.member,
            displayName: 'QA Author',
          ),
        ]),
      );
      final repository = _TaskHistoryRepository([
        Right(
          CursorPageResponse(items: [_event('event-1')], nextCursor: 'next'),
        ),
        Right(CursorPageResponse(items: [_event('event-2')])),
      ]);
      final cubit = TaskHistoryCubit(
        repository: repository,
        memberProfilesRepository: profiles,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      addTearDown(cubit.close);
      await cubit.load();
      await cubit.loadMore();
      expect((cubit.state as TaskHistoryReady).actorNames, {
        'user-1': 'QA Author',
      });
      verify(
        () => profiles.listProfiles(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).called(1);
    },
  );

  test('profile failure keeps history and its complete lookup error', () async {
    final profiles = _ProfilesRepository();
    const failure = ApiError(
      type: ApiErrorType.server,
      message: 'Profiles unavailable',
      statusCode: 503,
      traceId: 'qa-trace',
      apiCode: 'qa.profiles_unavailable',
    );
    when(
      () => profiles.listProfiles(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer((_) async => left(failure));
    final repository = _TaskHistoryRepository([
      Right(CursorPageResponse(items: [_event('event-1')])),
    ]);
    final cubit = TaskHistoryCubit(
      repository: repository,
      memberProfilesRepository: profiles,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    addTearDown(cubit.close);
    await cubit.load();
    final ready = cubit.state as TaskHistoryReady;
    expect(ready.events, hasLength(1));
    expect(ready.actorNames, isEmpty);
    expect(ready.actorLookupFailure, same(failure));
  });
  test('ładuje pierwszą cursorową stronę historii', () async {
    final repository = _TaskHistoryRepository([
      Right(CursorPageResponse(items: [_event('event-1')], nextCursor: 'next')),
    ]);
    final cubit = _cubit(repository);

    await cubit.load();

    final ready = cubit.state as TaskHistoryReady;
    expect(ready.events.map((event) => event.eventId), ['event-1']);
    expect(ready.nextCursor, 'next');
    expect(repository.cursors, [isNull]);
    await cubit.close();
  });

  test('dopina stronę historii i deduplikuje powtórzone zdarzenia', () async {
    final repository = _TaskHistoryRepository([
      Right(CursorPageResponse(items: [_event('event-1')], nextCursor: 'next')),
      Right(
        CursorPageResponse(
          items: [_event('event-1'), _event('event-2')],
        ),
      ),
    ]);
    final cubit = _cubit(repository);

    await cubit.load();
    await cubit.loadMore();

    final ready = cubit.state as TaskHistoryReady;
    expect(ready.events.map((event) => event.eventId), ['event-1', 'event-2']);
    expect(ready.hasMore, isFalse);
    expect(repository.cursors, [isNull, 'next']);
    await cubit.close();
  });

  test('pokazuje błąd pierwszego pobrania historii', () async {
    final repository = _TaskHistoryRepository([
      const Left(
        ApiError(
          type: ApiErrorType.connection,
          message: 'Brak połączenia z historią',
        ),
      ),
    ]);
    final cubit = _cubit(repository);

    await cubit.load();

    expect(cubit.state, isA<TaskHistoryFailure>());
    expect(
      (cubit.state as TaskHistoryFailure).message,
      'Brak połączenia z historią',
    );
    await cubit.close();
  });
}
