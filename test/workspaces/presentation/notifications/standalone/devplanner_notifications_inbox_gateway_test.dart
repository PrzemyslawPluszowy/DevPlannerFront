import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/data/devplanner_notifications_inbox_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DevPlannerNotificationsInboxGateway', () {
    test(
      'maps the Backend cursor page and sends the documented query',
      () async {
        final transport = _RecordingTransport(
          responses: [
            const DevPlannerHttpResponse(
              statusCode: 200,
              body: <String, Object?>{
                'items': <Object?>[
                  <String, Object?>{
                    'id': 'a2e7b8e0-2b15-4d83-a96f-85c1fcb3f3c4',
                    'eventType': 'task.created',
                    'title': 'Nowe zadanie',
                    'body': 'Dodano zadanie do projektu',
                    'createdAtUtc': '2026-09-17T10:00:00Z',
                    'readAtUtc': null,
                    'category': 'Task',
                    'priority': 'Normal',
                    'deepLink': '/workspaces/one/tasks/two',
                    'groupKey': 'workspace:one',
                  },
                ],
                'nextCursor': 'cursor-2',
              },
            ),
          ],
        );
        final gateway = DevPlannerNotificationsInboxGateway(transport);

        final result = await gateway.list(
          cursor: 'cursor-1',
          limit: 20,
          unreadOnly: true,
          category: NotificationCategory.task,
        );

        expect(result.isRight(), isTrue);
        final page = result.getOrElse(() => throw StateError('expected page'));
        expect(page.nextCursor, 'cursor-2');
        expect(page.items.single.isUnread, isTrue);
        expect(page.items.single.category, NotificationCategory.task);
        expect(transport.requests.single.path, '/api/v1/notifications/');
        expect(transport.requests.single.query, {
          'cursor': 'cursor-1',
          'limit': '20',
          'isUnreadOnly': 'true',
          'category': 'task',
        });
      },
    );

    test('maps unread count and the idempotent mark-read endpoint', () async {
      final transport = _RecordingTransport(
        responses: [
          const DevPlannerHttpResponse(
            statusCode: 200,
            body: <String, Object?>{'count': 3},
          ),
          const DevPlannerHttpResponse(statusCode: 204),
        ],
      );
      final gateway = DevPlannerNotificationsInboxGateway(transport);

      final count = await gateway.unreadCount();
      expect(count.getOrElse(() => -1), 3);
      expect(
        (await gateway.markRead('a2e7b8e0-2b15-4d83-a96f-85c1fcb3f3c4'))
            .isRight(),
        isTrue,
      );
      expect(transport.requests[1].method, DevPlannerHttpMethod.post);
      expect(
        transport.requests[1].path,
        '/api/v1/notifications/a2e7b8e0-2b15-4d83-a96f-85c1fcb3f3c4/read',
      );
    });

    test(
      'preserves typed unauthorized errors and rejects malformed JSON',
      () async {
        final unauthorized = _RecordingTransport(
          responses: [
            const DevPlannerHttpResponse(
              statusCode: 401,
              body: <String, Object?>{
                'code': 'auth.required',
                'message': 'Sesja wygasła.',
                'traceId': 'trace-1',
              },
              traceId: 'trace-transport',
            ),
          ],
        );
        final unauthorizedResult = await DevPlannerNotificationsInboxGateway(
          unauthorized,
        ).unreadCount();
        final unauthorizedError = unauthorizedResult.fold(
          (error) => error,
          (_) => null,
        );
        expect(unauthorizedError?.type.name, 'unauthorized');
        expect(unauthorizedError?.apiCode, 'auth.required');
        expect(unauthorizedError?.traceId, 'trace-1');

        final malformed = _RecordingTransport(
          responses: [
            const DevPlannerHttpResponse(
              statusCode: 200,
              body: <String, Object?>{
                'items': <Object?>[<String, Object?>{}],
              },
            ),
          ],
        );
        final malformedResult = await DevPlannerNotificationsInboxGateway(
          malformed,
        ).list();
        final malformedError = malformedResult.fold(
          (error) => error,
          (_) => null,
        );
        expect(malformedError?.type.name, 'parsing');
      },
    );
  });
}

final class _RecordingTransport extends DevPlannerHttpTransport {
  _RecordingTransport({required this.responses})
    : super(
        baseUrl: 'https://example.test',
        isWeb: false,
        tokenProvider: () => 'test-token',
      );

  final List<DevPlannerHttpResponse> responses;
  final List<DevPlannerHttpRequest> requests = [];

  @override
  Future<DevPlannerHttpResponse> execute(DevPlannerHttpRequest request) async {
    requests.add(request);
    return responses.removeAt(0);
  }
}
