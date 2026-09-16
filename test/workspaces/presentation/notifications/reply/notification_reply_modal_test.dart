import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/notification_enums.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:ready_next/workspaces/domain/notifications/models/notification_reply_command.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_reply_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_state.dart';
import 'package:ready_next/workspaces/presentation/notifications/global_notifications_page.dart';
import 'package:ready_next/workspaces/presentation/notifications/notification_widgets.dart';

class _FakeNotificationsRepository implements NotificationsRepository {
  int listGroupCalls = 0;

  @override
  Future<Either<ApiError, void>> archiveGroup(String groupKey) async =>
      const Right(null);

  @override
  Future<Either<ApiError, CursorPageResponse<NotificationGroupResponse>>>
  listGroups({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async {
    listGroupCalls++;
    return Right(
      CursorPageResponse(
        items: [_NotificationReplyModalFixture.chatMessageGroup()],
      ),
    );
  }

  @override
  Future<Either<ApiError, CursorPageResponse<WorkspaceNotificationResponse>>>
  listNotifications({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async => const Right(CursorPageResponse(items: []));

  @override
  Future<Either<ApiError, void>> markAllRead() async => const Right(null);

  @override
  Future<Either<ApiError, void>> markGroupRead(String groupKey) async =>
      const Right(null);

  @override
  Future<Either<ApiError, void>> quickAction(
    String notificationId,
    NotificationQuickActionKind action,
  ) async => const Right(null);

  @override
  Future<Either<ApiError, int>> unreadCount() async => const Right(0);
}

class _FakeNotificationReplyRepository implements NotificationReplyRepository {
  final List<NotificationReplyCommand> commands = <NotificationReplyCommand>[];

  @override
  Future<Either<ApiError, ChatMessage>> reply(
    NotificationReplyCommand command,
  ) async {
    commands.add(command);
    return Right(
      ChatMessage(
        id: 'sent-message',
        conversationId: 'conversation-id',
        authorCoreUserId: 'current-user',
        clientMessageId: command.clientMessageId,
        text: command.text,
        deltaJson: command.deltaJson,
        payloadHash: 'hash',
        version: 1,
        createdAtUtc: DateTime.utc(2026),
        isDeleted: false,
        deliveryState: ChatMessageDeliveryState.sent,
      ),
    );
  }
}

abstract final class _NotificationReplyModalFixture {
  static WorkspaceNotificationResponse taskNotification() =>
      WorkspaceNotificationResponse(
        id: 'notification-id',
        sourceModule: 'workspaces',
        eventType: 'task.assigned',
        entityType: 'Task',
        entityId: 'task-id',
        title: 'Przypisano zadanie',
        body: 'Możesz odpowiedzieć na powiązaną wiadomość.',
        eventId: 'event-id',
        contractVersion: 1,
        createdAtUtc: DateTime.utc(2026),
        isPinned: false,
        category: NotificationCategory.task,
        priority: NotificationPriority.normal,
        metadataJson:
            '{"chatMessageId":"11111111-1111-4111-8111-111111111111"}',
      );

  static WorkspaceNotificationResponse chatMessageNotification() =>
      WorkspaceNotificationResponse(
        id: 'chat-notification-id',
        sourceModule: 'workspaces',
        eventType: 'chat.message.created',
        entityType: 'ChatMessage',
        entityId: 'legacy-server-message-reference',
        title: 'Nowa wiadomość',
        body: 'Wiadomość na czacie.',
        eventId: 'chat-event-id',
        contractVersion: 1,
        createdAtUtc: DateTime.utc(2026),
        isPinned: false,
        category: NotificationCategory.chat,
        priority: NotificationPriority.normal,
      );

  static NotificationGroupResponse chatMessageGroup() =>
      NotificationGroupResponse(
        groupKey: 'chat-group',
        count: 1,
        unreadCount: 1,
        latest: chatMessageNotification(),
        notificationIds: const ['chat-notification-id'],
      );

  static NotificationsInbox inbox() => NotificationsInbox(
    groups: const [],
    items: [taskNotification()],
    unreadCount: 1,
    groupNextCursor: null,
    itemNextCursor: null,
    view: NotificationsInboxView.items,
    category: null,
    unreadOnly: false,
  );
}

void main() {
  testWidgets(
    'Task metadata mapujący do Chat udostępnia modal odpowiedzi i wysyła reply',
    (tester) async {
      final notificationsRepository = _FakeNotificationsRepository();
      final notificationsCubit = NotificationsCubit(notificationsRepository);
      final replyRepository = _FakeNotificationReplyRepository();
      addTearDown(notificationsCubit.close);

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<NotificationReplyRepository>.value(
              value: replyRepository,
            ),
          ],
          child: BlocProvider<NotificationsCubit>.value(
            value: notificationsCubit,
            child: MaterialApp(
              locale: const Locale('pl'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: NotificationsList(
                  inbox: _NotificationReplyModalFixture.inbox(),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byTooltip('Odpowiedz'), findsOneWidget);
      await tester.tap(find.byTooltip('Odpowiedz'));
      await tester.pumpAndSettle();
      expect(find.text('Odpowiedź na czacie'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Jasne, zrobię to.');
      await tester.pump();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      await tester.tap(find.text('Wyślij odpowiedź'));
      await tester.pumpAndSettle();

      expect(replyRepository.commands, hasLength(1));
      expect(replyRepository.commands.single.notificationId, 'notification-id');
      expect(replyRepository.commands.single.text, 'Jasne, zrobię to.');
      expect(notificationsRepository.listGroupCalls, greaterThanOrEqualTo(1));
      expect(find.text('Odpowiedź na czacie'), findsNothing);
    },
  );

  testWidgets(
    'akcja reply dla ChatMessage jest osiągalna z pełnej strony powiadomień',
    (tester) async {
      final notificationsRepository = _FakeNotificationsRepository();
      final notificationsCubit = NotificationsCubit(notificationsRepository);
      final replyRepository = _FakeNotificationReplyRepository();
      addTearDown(notificationsCubit.close);
      await notificationsCubit.load();

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<NotificationReplyRepository>.value(
              value: replyRepository,
            ),
          ],
          child: BlocProvider<NotificationsCubit>.value(
            value: notificationsCubit,
            child: const MaterialApp(
              locale: Locale('pl'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: GlobalNotificationsPage(),
            ),
          ),
        ),
      );

      expect(find.byTooltip('Odpowiedz'), findsOneWidget);
      await tester.tap(find.byTooltip('Odpowiedz'));
      await tester.pumpAndSettle();
      expect(find.text('Odpowiedź na czacie'), findsOneWidget);
    },
  );

  testWidgets(
    'akcja reply dla ChatMessage jest osiągalna z globalnego panelu',
    (tester) async {
      final notificationsRepository = _FakeNotificationsRepository();
      final notificationsCubit = NotificationsCubit(notificationsRepository);
      final replyRepository = _FakeNotificationReplyRepository();
      addTearDown(notificationsCubit.close);
      await notificationsCubit.load();

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<NotificationReplyRepository>.value(
              value: replyRepository,
            ),
          ],
          child: BlocProvider<NotificationsCubit>.value(
            value: notificationsCubit,
            child: MaterialApp(
              locale: const Locale('pl'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: AppGlobalNotificationsPanel(
                repository: notificationsRepository,
              ),
            ),
          ),
        ),
      );

      expect(find.byTooltip('Odpowiedz'), findsOneWidget);
      await tester.tap(find.byTooltip('Odpowiedz'));
      await tester.pumpAndSettle();
      expect(find.text('Odpowiedź na czacie'), findsOneWidget);
    },
  );
}
