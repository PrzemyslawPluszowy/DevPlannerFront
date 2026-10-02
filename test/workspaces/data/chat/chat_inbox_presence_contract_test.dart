import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_inbox_api.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_inbox_presence_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const peerId = '11111111-1111-1111-1111-111111111111';

  test('presence request and response use the exact camelCase wire fields', () {
    const request = ChatInboxPresenceRequest(userIds: [peerId]);
    final requestJson = request.toJson();
    final response = ChatInboxPresenceResponse.fromJson({
      'users': [
        {'userId': peerId, 'isOnline': true},
      ],
    });

    expect(requestJson, {
      'userIds': [peerId],
    });
    expect(
      ChatInboxPresenceRequest.fromJson(requestJson).userIds,
      [peerId],
    );
    expect(response.users.single.userId, peerId);
    expect(response.users.single.isOnline, isTrue);
    expect(response.toJson(), {
      'users': [
        {'userId': peerId, 'isOnline': true},
      ],
    });
  });

  test(
    'repository maps every batch value and rejects incomplete snapshots',
    () async {
      final api = _ChatInboxApiFake()
        ..response = const ChatInboxPresenceResponse(
          users: [
            ChatInboxPresenceUserResponse(userId: peerId, isOnline: false),
          ],
        );
      final repository = ChatInboxPresenceRepositoryImpl(api);

      final result = await repository.loadPresence([peerId]);
      final failed = await repository.loadPresence([
        '22222222-2222-2222-2222-222222222222',
      ]);

      expect(api.requests, hasLength(2));
      expect(api.requests.first.userIds, [peerId]);
      expect(result.fold((_) => null, (statuses) => statuses[peerId]), isFalse);
      expect(
        failed.fold((error) => error.type, (_) => null),
        ApiErrorType.parsing,
      );
    },
  );

  test('missing isOnline and extra or duplicate response rows fail closed', () {
    expect(
      () => ChatInboxPresenceResponse.fromJson({
        'users': [
          {'userId': peerId},
        ],
      }),
      throwsA(isA<Object>()),
    );
  });

  test('empty batch does not call transport', () async {
    final api = _ChatInboxApiFake();
    final repository = ChatInboxPresenceRepositoryImpl(api);

    expect(
      await repository.loadPresence(const []),
      const Right<ApiError, Map<String, bool>>(<String, bool>{}),
    );
    expect(api.requests, isEmpty);
  });

  test('response rejects duplicate and extra users', () async {
    final api = _ChatInboxApiFake()
      ..response = const ChatInboxPresenceResponse(
        users: [
          ChatInboxPresenceUserResponse(userId: peerId, isOnline: true),
          ChatInboxPresenceUserResponse(userId: peerId, isOnline: false),
        ],
      );
    final repository = ChatInboxPresenceRepositoryImpl(api);
    expect(
      (await repository.loadPresence([peerId]))
          .fold((error) => error.type, (_) => null),
      ApiErrorType.parsing,
    );
  });

  test('HTTP authorization and retry metadata remain typed', () async {
    final response = Response<dynamic>(
      requestOptions: RequestOptions(path: '/api/v1/chat/inbox/presence'),
      statusCode: 429,
      data: {
        'code': 'rate_limited',
        'message': 'Try later',
        'traceId': 'trace-123',
      },
      headers: Headers.fromMap({
        'retry-after': ['60'],
      }),
    );
    final api = _ChatInboxApiFake()
      ..failure = DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    final repository = ChatInboxPresenceRepositoryImpl(api);
    final error = (await repository.loadPresence([peerId]))
        .fold((error) => error, (_) => null)!;

    expect(error.type, ApiErrorType.badResponse);
    expect(error.statusCode, 429);
    expect(error.traceId, 'trace-123');
    expect(error.retryAfterUtc, isNotNull);
    expect(error.apiCode, 'chat.inbox.presence_failed');
  });
}

final class _ChatInboxApiFake implements ChatInboxApi {
  final List<ChatInboxPresenceRequest> requests = [];
  ChatInboxPresenceResponse response = const ChatInboxPresenceResponse();
  DioException? failure;

  @override
  Future<ChatInboxPresenceResponse> loadInboxPresence(
    ChatInboxPresenceRequest request,
  ) async {
    requests.add(request);
    if (failure case final error?) throw error;
    return response;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
