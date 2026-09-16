import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/task_history_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/detail/history/cubit/task_history_cubit.dart';

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
    coreUserId: 'user-1',
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
