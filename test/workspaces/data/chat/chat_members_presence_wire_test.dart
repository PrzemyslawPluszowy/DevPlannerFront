import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_members_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'generated GET uses conversation ACL route and preserves server timestamp',
    () async {
      final dio = Dio();
      final timestamp = DateTime.utc(2026, 10, 7, 12);
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.method, 'GET');
            expect(
              options.path,
              '/api/v1/chat/conversations/group/members/presence',
            );
            expect(options.queryParameters, isEmpty);
            expect(options.data, isNull);
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'snapshotAtUtc': timestamp.toIso8601String(),
                  'users': [
                    {'userId': 'peer', 'isOnline': false},
                  ],
                },
              ),
            );
          },
        ),
      );
      final result = await ChatMembersRepositoryImpl(ChatApi(dio))
          .loadMembersPresence('group');
      final snapshot = result.getOrElse(
        () => throw StateError('expected snapshot'),
      );
      expect(snapshot.snapshotAtUtc, timestamp);
      expect(snapshot.users, {'peer': false});
      dio.close();
    },
  );

  test(
    'denied request preserves shared error instead of inventing Offline',
    () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 403,
                  data: {
                    'code': 'chat.access_denied',
                    'message': 'Access denied',
                    'traceId': 'qa-trace',
                  },
                ),
              ),
            );
          },
        ),
      );
      final result = await ChatMembersRepositoryImpl(ChatApi(dio))
          .loadMembersPresence('group');
      expect(result.isLeft(), isTrue);
      final error = result.swap().getOrElse(
        () => throw StateError('expected error'),
      );
      expect(error.statusCode, 403);
      expect(error.traceId, 'qa-trace');
      dio.close();
    },
  );
}
