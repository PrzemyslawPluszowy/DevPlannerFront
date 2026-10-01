import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/conversation/task_detail_conversation_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  test('thrown Dio preserves metadata and throttles explicit retry', () async {
    final repository = _MockRepository();
    final deadline = DateTime.now().toUtc().add(
      const Duration(milliseconds: 80),
    );
    final error = ApiError(
      type: ApiErrorType.server,
      message: 'Try later',
      statusCode: 429,
      apiCode: 'chat.rate_limit',
      contractCode: 'rate_limit',
      traceId: 'resolve-trace',
      fields: const {
        'taskId': ['Wait'],
      },
      retryAfterUtc: deadline,
    );
    var calls = 0;
    when(
      () => repository.resolveTaskConversation(
        taskId: 'task',
        workspaceId: 'ws',
        projectId: 'project',
      ),
    ).thenAnswer((_) async {
      calls++;
      final request = RequestOptions(path: '/resolve');
      throw DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: request,
          statusCode: 429,
          headers: Headers.fromMap({
            'Retry-After': ['1'],
          }),
          data: {
            'code': 'rate_limit',
            'message': 'Try later',
            'traceId': 'resolve-trace',
            'fields': {
              'taskId': ['Wait'],
            },
          },
        ),
      );
    });
    final cubit = TaskDetailConversationCubit(repository);
    addTearDown(cubit.close);
    cubit.resolve(taskId: 'task', workspaceId: 'ws', projectId: 'project');
    await Future<void>.delayed(Duration.zero);
    final failure = cubit.state as TaskDetailConversationFailure;
    expect(failure.error?.traceId, 'resolve-trace');
    expect(failure.error?.fields, error.fields);
    expect(failure.error?.contractCode, 'rate_limit');
    expect(cubit.canRetry, false);
    cubit.retry();
    expect(calls, 1);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    expect(cubit.canRetry, true);
    cubit.retry();
    await Future<void>.delayed(Duration.zero);
    expect(calls, 2);
  });

  test(
    'closed resolver ignores resolve and retry without repository calls',
    () async {
      final repository = _MockRepository();
      final cubit = TaskDetailConversationCubit(repository);
      await cubit.close();
      cubit.resolve(taskId: 'task', workspaceId: 'ws', projectId: 'project');
      cubit.retry();
      verifyNever(
        () => repository.resolveTaskConversation(
          taskId: any(named: 'taskId'),
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
        ),
      );
    },
  );

  test('throwing authorization remains neutral and unknown excludes exception content', () async {
    for (final denied in [true, false]) {
      final repository = _MockRepository();
      when(
        () => repository.resolveTaskConversation(
          taskId: 'task',
          workspaceId: 'ws',
          projectId: 'project',
        ),
      ).thenThrow(
        denied
            ? const ApiError(type: ApiErrorType.forbidden, message: 'private')
            : StateError('private token fixture'),
      );
      final cubit = TaskDetailConversationCubit(repository);
      cubit.resolve(taskId: 'task', workspaceId: 'ws', projectId: 'project');
      await Future<void>.delayed(Duration.zero);
      if (denied) {
        expect(cubit.state, isA<TaskDetailConversationDenied>());
      } else {
        final failure = cubit.state as TaskDetailConversationFailure;
        expect(failure.error?.apiCode, 'chat.resolve_failed');
        expect(failure.error?.message, isEmpty);
        expect(failure.exception, isNull);
      }
      await cubit.close();
    }
  });

  test('a late response from the previous task is ignored', () async {
    final first = Completer<Either<ApiError, ChatConversation>>();
    final second = Completer<Either<ApiError, ChatConversation>>();
    final repository = _ResourceChatRepository([first, second]);
    final cubit = TaskDetailConversationCubit(repository);
    addTearDown(cubit.close);

    cubit.resolve(taskId: 'task-a', workspaceId: 'ws', projectId: 'project');
    cubit.resolve(taskId: 'task-b', workspaceId: 'ws', projectId: 'project');
    second.complete(Right(_conversation('conversation-b')));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isA<TaskDetailConversationReady>());
    expect(
      (cubit.state as TaskDetailConversationReady).conversation.id,
      'conversation-b',
    );
    first.complete(Right(_conversation('conversation-a')));
    await Future<void>.delayed(Duration.zero);

    expect(
      (cubit.state as TaskDetailConversationReady).conversation.id,
      'conversation-b',
    );
  });

  test('a revoked session owner ignores an outstanding response', () async {
    final response = Completer<Either<ApiError, ChatConversation>>();
    final cubit = TaskDetailConversationCubit(
      _ResourceChatRepository([response]),
    );
    final states = <TaskDetailConversationState>[];
    final subscription = cubit.stream.listen(states.add);
    cubit.resolve(taskId: 'task', workspaceId: 'ws', projectId: 'project');
    await cubit.close();

    response.complete(Right(_conversation('private-conversation')));
    await Future<void>.delayed(Duration.zero);

    expect(states, hasLength(1));
    expect(states.single, isA<TaskDetailConversationLoading>());
    await subscription.cancel();
  });

  test('authorization failures become a neutral denied state', () async {
    final repository = _ResourceChatRepository([
      Completer<Either<ApiError, ChatConversation>>()..complete(
        const Left(
          ApiError(type: ApiErrorType.forbidden, message: 'private detail'),
        ),
      ),
    ]);
    final cubit = TaskDetailConversationCubit(repository);
    addTearDown(cubit.close);

    cubit.resolve(taskId: 'task', workspaceId: 'ws', projectId: 'project');
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isA<TaskDetailConversationDenied>());
  });
}

ChatConversation _conversation(String id) => ChatConversation(
  id: id,
  type: 'resource',
  scopeKind: 'Resource',
  scopeKey: 'task-id',
  version: 1,
  createdAtUtc: DateTime.utc(2026, 9, 30),
  postingPermission: 'Member',
  isArchived: false,
);

final class _ResourceChatRepository implements ResourceChatRepository {
  _ResourceChatRepository(this.responses);

  final List<Completer<Either<ApiError, ChatConversation>>> responses;
  int _index = 0;

  @override
  Future<Either<ApiError, ChatConversation>> resolveTaskConversation({
    required String taskId,
    required String workspaceId,
    required String projectId,
  }) => responses[_index++].future;

  @override
  Future<Either<ApiError, ChatConversation>> resolveFileConversation(
    ResourceChatFileRequest request,
  ) => throw UnimplementedError();
}

final class _MockRepository extends Mock implements ResourceChatRepository {}
