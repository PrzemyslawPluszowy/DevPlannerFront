import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _SearchCall {
  _SearchCall({
    required this.query,
    required this.workspaceId,
    required this.projectId,
    required this.cursor,
    required this.completer,
  });

  final String query;
  final String? workspaceId;
  final String? projectId;
  final String? cursor;
  final Completer<
    Either<ApiError, CursorPageResponse<GlobalTaskSearchItemResponse>>
  >
  completer;
}

final class _Repository implements TaskViewRepository {
  final List<_SearchCall> calls = [];

  @override
  Future<Either<ApiError, CursorPageResponse<GlobalTaskSearchItemResponse>>>
  searchTasks({
    required String query,
    String? workspaceId,
    String? projectId,
    String? status,
    int limit = 50,
    String? cursor,
  }) {
    final completer =
        Completer<
          Either<ApiError, CursorPageResponse<GlobalTaskSearchItemResponse>>
        >();
    calls.add(
      _SearchCall(
        query: query,
        workspaceId: workspaceId,
        projectId: projectId,
        cursor: cursor,
        completer: completer,
      ),
    );
    return completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

GlobalTaskSearchItemResponse _item(String id) => GlobalTaskSearchItemResponse(
  id: id,
  number: 1,
  key: 'DP-1',
  workspaceId: 'workspace-$id',
  workspaceName: 'Workspace',
  projectId: 'project-$id',
  projectName: 'Project',
  title: 'Task $id',
  matchedLabels: const [],
  score: 1,
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);

CursorPageResponse<GlobalTaskSearchItemResponse> _page(
  List<GlobalTaskSearchItemResponse> items, {
  String? nextCursor,
}) => CursorPageResponse(items: items, nextCursor: nextCursor);

void main() {
  test('closed cubit ignores queued search commands', () async {
    final cubit = TasksGlobalSearchCubit(repository: _Repository());
    await cubit.close();

    cubit.updateQuery('closed');
    cubit.retry();
    await cubit.loadMore();
    expect(cubit.state.query, isEmpty);
  });

  test('thrown cursor failure preserves results and retry recovers', () async {
    final repository = _Repository();
    final cubit = TasksGlobalSearchCubit(repository: repository);
    addTearDown(cubit.close);
    cubit.updateQuery('tasks');
    await Future<void>.delayed(const Duration(milliseconds: 280));
    repository.calls.single.completer.complete(
      Right(_page([_item('first')], nextCursor: 'next')),
    );
    await Future<void>.delayed(Duration.zero);
    final pending = cubit.loadMore();
    repository.calls.last.completer.completeError(StateError('adapter secret'));
    await pending;
    expect(cubit.state.isLoadingMore, isFalse);
    expect(cubit.state.failure?.apiCode, 'tasks.search_failed');
    expect(cubit.state.failure?.message, isNot(contains('adapter secret')));
    expect(cubit.state.items.single.id, 'first');
    expect(cubit.state.nextCursor, 'next');
    cubit.retry();
    repository.calls.last.completer.complete(Right(_page([_item('second')])));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.failure, isNull);
    expect(cubit.state.items.map((item) => item.id), ['first', 'second']);
    expect(() => cubit.state.items.clear(), throwsUnsupportedError);
  });

  test(
    'debounces globally, ignores stale responses, and retries cursor pages',
    () async {
      final repository = _Repository();
      final cubit = TasksGlobalSearchCubit(repository: repository);
      addTearDown(cubit.close);

      cubit.updateQuery(' alpha ');
      await Future<void>.delayed(const Duration(milliseconds: 100));
      cubit.updateQuery('alpha task');
      await Future<void>.delayed(const Duration(milliseconds: 280));

      expect(repository.calls, hasLength(1));
      expect(repository.calls.single.query, 'alpha task');
      expect(repository.calls.single.workspaceId, isNull);
      expect(repository.calls.single.projectId, isNull);

      cubit.updateQuery('beta');
      await Future<void>.delayed(const Duration(milliseconds: 280));
      expect(repository.calls, hasLength(2));

      repository.calls[0].completer.complete(Right(_page([_item('stale')])));
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.query, 'beta');
      expect(cubit.state.items, isEmpty);

      repository.calls[1].completer.complete(
        Right(_page([_item('beta-1')], nextCursor: 'cursor-1')),
      );
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.items.single.id, 'beta-1');
      expect(cubit.state.nextCursor, 'cursor-1');

      final failedPage = cubit.loadMore();
      expect(repository.calls, hasLength(3));
      expect(repository.calls[2].cursor, 'cursor-1');
      repository.calls[2].completer.complete(
        const Left(ApiError(type: ApiErrorType.unknown, message: 'offline')),
      );
      await failedPage;
      expect(cubit.state.failure?.message, 'offline');
      expect(cubit.state.items.single.id, 'beta-1');

      cubit.retry();
      await Future<void>.delayed(Duration.zero);
      expect(repository.calls, hasLength(4));
      expect(repository.calls[3].cursor, 'cursor-1');
      repository.calls[3].completer.complete(
        Right(_page([_item('beta-2')])),
      );
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.items.map((item) => item.id), ['beta-1', 'beta-2']);
      expect(cubit.state.failure, isNull);
      expect(cubit.state.nextCursor, isNull);
    },
  );

  test('429 without Retry-After allows only an explicit retry', () async {
    final repository = _Repository();
    final cubit = TasksGlobalSearchCubit(repository: repository);
    addTearDown(cubit.close);
    cubit.updateQuery('tasks');
    await Future<void>.delayed(const Duration(milliseconds: 280));
    repository.calls.single.completer.complete(
      const Left(
        ApiError(
          type: ApiErrorType.server,
          message: 'Throttled',
          statusCode: 429,
        ),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.retryWaitSeconds, 0);
    expect(cubit.state.failure?.statusCode, 429);
    cubit.retry();
    expect(repository.calls, hasLength(2));
    repository.calls.last.completer.complete(
      Right(_page([_item('recovered')])),
    );
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.items.single.id, 'recovered');
  });

  test('query replacement cannot bypass a 429 Retry-After deadline', () async {
    final repository = _Repository();
    final cubit = TasksGlobalSearchCubit(repository: repository);
    addTearDown(cubit.close);
    cubit.updateQuery('first query');
    await Future<void>.delayed(const Duration(milliseconds: 280));
    repository.calls.single.completer.complete(
      Right(
        _page([
          _item('first'),
        ]),
      ),
    );
    await Future<void>.delayed(Duration.zero);
    cubit.updateQuery('second query');
    await Future<void>.delayed(const Duration(milliseconds: 280));
    repository.calls[1].completer.complete(
      Left(
        ApiError(
          type: ApiErrorType.server,
          message: 'Throttled',
          statusCode: 429,
          retryAfterUtc: DateTime.now().toUtc().add(
            const Duration(milliseconds: 1400),
          ),
        ),
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.retryWaitSeconds, greaterThan(0));

    cubit.updateQuery('replacement query');
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(repository.calls, hasLength(2));
    expect(cubit.state.query, 'replacement query');
    expect(cubit.state.failure?.statusCode, 429);
    expect(cubit.state.items, isEmpty);
    cubit.retry();
    await cubit.loadMore();
    expect(repository.calls, hasLength(2));

    await Future<void>.delayed(const Duration(milliseconds: 1500));
    expect(
      repository.calls,
      hasLength(2),
      reason: 'expiry must not auto-retry',
    );
    expect(cubit.state.retryWaitSeconds, 0);
    cubit.retry();
    expect(repository.calls, hasLength(3));
    expect(repository.calls.last.query, 'replacement query');
    expect(repository.calls.last.cursor, isNull);
    repository.calls.last.completer.complete(Right(_page([_item('new')])));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.items.single.id, 'new');
  });

  test(
    '503 Retry-After keeps page cursor and retries it after deadline',
    () async {
      final repository = _Repository();
      final cubit = TasksGlobalSearchCubit(repository: repository);
      addTearDown(cubit.close);
      cubit.updateQuery('tasks');
      await Future<void>.delayed(const Duration(milliseconds: 280));
      repository.calls.single.completer.complete(
        Right(_page([_item('first')], nextCursor: 'cursor-1')),
      );
      await Future<void>.delayed(Duration.zero);

      final pending = cubit.loadMore();
      repository.calls[1].completer.complete(
        Left(
          ApiError(
            type: ApiErrorType.server,
            message: 'Temporarily unavailable',
            statusCode: 503,
            retryAfterUtc: DateTime.now().toUtc().add(
              const Duration(milliseconds: 900),
            ),
            apiCode: 'tasks.search_unavailable',
            contractCode: 'tasks.search_unavailable',
            fields: const {
              'query': ['try again'],
            },
            traceId: 'trace-search-503',
          ),
        ),
      );
      await pending;
      expect(cubit.state.items.single.id, 'first');
      expect(cubit.state.nextCursor, 'cursor-1');
      expect(cubit.state.failure?.traceId, 'trace-search-503');
      expect(cubit.state.retryWaitSeconds, greaterThan(0));

      cubit.retry();
      await cubit.loadMore();
      expect(repository.calls, hasLength(2));
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      expect(
        repository.calls,
        hasLength(2),
        reason: 'expiry must not auto-retry',
      );
      cubit.retry();
      expect(repository.calls, hasLength(3));
      expect(repository.calls.last.cursor, 'cursor-1');
      repository.calls.last.completer.complete(Right(_page([_item('second')])));
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.items.map((item) => item.id), ['first', 'second']);
      expect(cubit.state.nextCursor, isNull);
      expect(cubit.state.failure, isNull);
    },
  );

  test('closing cancels retry countdown without later emissions', () async {
    final repository = _Repository();
    final cubit = TasksGlobalSearchCubit(repository: repository);
    cubit.updateQuery('tasks');
    await Future<void>.delayed(const Duration(milliseconds: 280));
    repository.calls.single.completer.complete(
      Left(
        ApiError(
          type: ApiErrorType.server,
          message: 'Throttled',
          statusCode: 429,
          retryAfterUtc: DateTime.now().toUtc().add(
            const Duration(seconds: 2),
          ),
        ),
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.retryWaitSeconds, greaterThan(0));
    var emissions = 0;
    final subscription = cubit.stream.listen((_) => emissions++);
    await cubit.close();
    final afterClose = emissions;
    await Future<void>.delayed(const Duration(milliseconds: 350));
    expect(emissions, afterClose);
    await subscription.cancel();
  });

  test(
    'stale query response still establishes repository-wide cooldown',
    () async {
      final repository = _Repository();
      final cubit = TasksGlobalSearchCubit(repository: repository);
      addTearDown(cubit.close);
      cubit.updateQuery('older query');
      await Future<void>.delayed(const Duration(milliseconds: 280));
      expect(repository.calls, hasLength(1));

      cubit.updateQuery('newer query');
      await Future<void>.delayed(const Duration(milliseconds: 100));
      repository.calls.first.completer.complete(
        Left(
          ApiError(
            type: ApiErrorType.server,
            message: 'Request throttled',
            statusCode: 429,
            retryAfterUtc: DateTime.now().toUtc().add(
              const Duration(milliseconds: 1200),
            ),
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 220));

      expect(repository.calls, hasLength(1));
      expect(cubit.state.query, 'newer query');
      expect(cubit.state.items, isEmpty);
      expect(cubit.state.failure?.statusCode, 429);
      expect(cubit.state.retryWaitSeconds, greaterThan(0));
    },
  );

  test('stale permission failure does not become a global cooldown', () async {
    final repository = _Repository();
    final cubit = TasksGlobalSearchCubit(repository: repository);
    addTearDown(cubit.close);
    cubit.updateQuery('older query');
    await Future<void>.delayed(const Duration(milliseconds: 280));
    cubit.updateQuery('newer query');
    await Future<void>.delayed(const Duration(milliseconds: 100));
    repository.calls.first.completer.complete(
      const Left(
        ApiError(
          type: ApiErrorType.forbidden,
          message: 'Access denied',
          statusCode: 403,
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 220));

    expect(repository.calls, hasLength(2));
    expect(cubit.state.query, 'newer query');
    expect(cubit.state.cooldownUntilUtc, isNull);
    expect(cubit.state.failure, isNull);
  });
}
