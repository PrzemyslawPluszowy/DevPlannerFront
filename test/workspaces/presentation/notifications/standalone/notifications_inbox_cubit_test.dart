import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/domain/notifications_inbox_gateway.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/domain/notifications_inbox_models.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/presentation/notifications_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/presentation/notifications_inbox_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StandaloneNotificationsInboxCubit', () {
    test('loads a page and unread count through the narrow gateway', () async {
      final gateway = _FakeGateway(
        page: StandaloneNotificationPage(
          items: <StandaloneNotificationItem>[
            StandaloneNotificationItem(
              id: 'notification-1',
              title: 'Tytuł',
              body: 'Treść',
              createdAtUtc: DateTime(2026, 9, 17),
              readAtUtc: null,
              category: NotificationCategory.task,
              priority: NotificationPriority.normal,
              deepLink: null,
              groupKey: null,
              eventType: 'task.created',
            ),
          ],
          nextCursor: 'next',
        ),
        unread: 1,
      );
      final cubit = StandaloneNotificationsInboxCubit(gateway);
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.status, StandaloneNotificationsInboxStatus.ready);
      expect(cubit.state.items.single.id, 'notification-1');
      expect(cubit.state.unreadCount, 1);
      expect(cubit.state.hasMore, isTrue);
    });

    test('loads the next cursor page and marks an item read', () async {
      final gateway = _FakeGateway(
        page: const StandaloneNotificationPage(
          items: <StandaloneNotificationItem>[],
          nextCursor: 'next',
        ),
        unread: 1,
        morePage: StandaloneNotificationPage(
          items: <StandaloneNotificationItem>[
            StandaloneNotificationItem(
              id: 'notification-1',
              title: 'Tytuł',
              body: 'Treść',
              createdAtUtc: DateTime(2026, 9, 17),
              readAtUtc: null,
              category: NotificationCategory.chat,
              priority: NotificationPriority.high,
              deepLink: null,
              groupKey: null,
              eventType: 'chat.message',
            ),
          ],
          nextCursor: null,
        ),
      );
      final cubit = StandaloneNotificationsInboxCubit(gateway);
      addTearDown(cubit.close);

      await cubit.load();
      await cubit.loadMore();
      await cubit.markRead('notification-1');

      expect(cubit.state.items.single.isUnread, isFalse);
      expect(cubit.state.unreadCount, 0);
      expect(gateway.markedIds, ['notification-1']);
    });

    test('exposes typed failure and retry restores ready state', () async {
      final gateway = _FakeGateway(
        page: const StandaloneNotificationPage(
          items: <StandaloneNotificationItem>[],
          nextCursor: null,
        ),
        unread: 0,
        pageError: const ApiError(
          type: ApiErrorType.unauthorized,
          message: 'expired',
        ),
      );
      final cubit = StandaloneNotificationsInboxCubit(gateway);
      addTearDown(cubit.close);

      await cubit.load();
      expect(cubit.state.status, StandaloneNotificationsInboxStatus.failure);
      expect(cubit.state.error?.type, ApiErrorType.unauthorized);

      gateway.pageError = null;
      await cubit.retry();
      expect(cubit.state.status, StandaloneNotificationsInboxStatus.ready);
    });
  });
}

final class _FakeGateway implements StandaloneNotificationsInboxGateway {
  _FakeGateway({
    required this.page,
    required this.unread,
    this.morePage,
    this.pageError,
  });

  final StandaloneNotificationPage page;
  final int unread;
  final StandaloneNotificationPage? morePage;
  ApiError? pageError;
  final List<String> markedIds = [];

  @override
  Future<Either<ApiError, StandaloneNotificationPage>> list({
    String? cursor,
    int limit = 30,
    bool unreadOnly = false,
    NotificationCategory? category,
  }) async {
    if (pageError case final error?) return Left(error);
    return Right(cursor == null ? page : (morePage ?? page));
  }

  @override
  Future<Either<ApiError, int>> unreadCount() async => Right(unread);

  @override
  Future<Either<ApiError, Unit>> markRead(String notificationId) async {
    markedIds.add(notificationId);
    return const Right(unit);
  }
}
