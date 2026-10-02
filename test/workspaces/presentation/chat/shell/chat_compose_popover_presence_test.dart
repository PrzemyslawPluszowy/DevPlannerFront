import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_presence.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_realtime_client.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_user_status_changed.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_presence_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_conversation_presence_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/widgets/chat_peer_status_line.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_compose_popover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final status in <bool?>[true, false, null]) {
    testWidgets('directory result shows presence $status before opening chat', (
      tester,
    ) async {
      final inbox = ChatInboxCubit(repository: _InboxRepository(_item()));
      await inbox.load();
      final presence = ChatInboxPresenceCubit(
        inbox: inbox,
        repository: _PresenceRepository(status),
        currentUserId: 'me',
        refreshInterval: const Duration(hours: 1),
        maxStaleAge: const Duration(hours: 1),
      );
      var closed = false;
      addTearDown(() async {
        if (closed) return;
        await tester.runAsync(() async {
          await presence.close();
          await inbox.close();
        });
      });
      final directory = _DirectoryRepositoryFake(status);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => unawaited(
                  ChatComposePopover.show(
                    context,
                    globalPosition: const Offset(120, 80),
                    repository: _ManagementRepositoryFake(),
                    directoryRepository: directory,
                    inboxPresenceCubit: presence,
                  ),
                ),
                child: const Text('New chat'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('New chat'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.enterText(
        find.byKey(const ValueKey('chat-compose-search')),
        'New',
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      await _waitFor(tester, () => presence.state.snapshotAtUtc != null);
      await tester.pump();
      expect(find.text('New person'), findsOneWidget);
      final l10n = AppLocalizations.of(
        tester.element(find.text('New person')),
      )!;
      final expected = switch (status) {
        true => l10n.tasksPresenceOnline,
        false => l10n.tasksPresenceOffline,
        null => l10n.projectPeoplePresenceUnknown,
      };
      expect(find.text(expected), findsOneWidget);
      if (status == true) {
        directory.isOnline = false;
        await tester.pump(const Duration(seconds: 15));
        await tester.pump();
        expect(find.text(l10n.tasksPresenceOffline), findsOneWidget);
        expect(find.text(l10n.tasksPresenceOnline), findsNothing);
      }
      expect(tester.takeException(), isNull);
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(() async {
        await presence.close();
        await inbox.close();
      });
      closed = true;
    });
  }

  testWidgets(
    'recent chat keeps the existing batch presence provider in popover',
    (
      tester,
    ) async {
      final item = _item();
      final inbox = ChatInboxCubit(repository: _InboxRepository(item));
      await inbox.load();
      final presence = ChatInboxPresenceCubit(
        inbox: inbox,
        repository: _PresenceRepository(),
        currentUserId: 'me',
        refreshInterval: const Duration(hours: 1),
        maxStaleAge: const Duration(hours: 1),
      );
      var ownersClosed = false;
      addTearDown(() async {
        if (ownersClosed) return;
        await tester.runAsync(() async {
          await presence.close();
          await inbox.close();
        });
      });
      await _waitFor(tester, () => presence.state.statusFor('peer') == true);
      final management = _ManagementRepositoryFake();
      final directory = _DirectoryRepositoryFake();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => unawaited(
                  ChatComposePopover.show(
                    context,
                    globalPosition: const Offset(120, 80),
                    repository: management,
                    directoryRepository: directory,
                    recent: [item],
                    inboxPresenceCubit: presence,
                  ),
                ),
                child: const Text('New chat'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('New chat'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump();
      final l10n = AppLocalizations.of(tester.element(find.text('Peer')));
      expect(l10n, isNotNull);
      expect(find.text(l10n!.tasksPresenceOnline), findsOneWidget);
      expect(find.text('Last message preview'), findsOneWidget);
      expect(tester.takeException(), isNull);

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(() async {
        await presence.close();
        await inbox.close();
      });
      ownersClosed = true;
    },
  );

  for (final status in <bool?>[true, false, null]) {
    testWidgets('direct header uses global presence $status', (tester) async {
      final item = _item();
      final inbox = ChatInboxCubit(repository: _InboxRepository(item));
      await inbox.load();
      final presence = ChatInboxPresenceCubit(
        inbox: inbox,
        repository: _PresenceRepository(status),
        currentUserId: 'me',
        refreshInterval: const Duration(hours: 1),
        maxStaleAge: const Duration(hours: 1),
      );
      final conversationPresence = ChatConversationPresenceCubit(
        realtime: _OfflineRealtimeClient(),
      );
      var ownersClosed = false;
      addTearDown(() async {
        if (ownersClosed) return;
        await tester.runAsync(() async {
          await conversationPresence.close();
          await presence.close();
          await inbox.close();
        });
      });
      await _waitFor(tester, () => presence.state.snapshotAtUtc != null);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider<ChatInboxPresenceCubit>.value(value: presence),
                BlocProvider<ChatConversationPresenceCubit>.value(
                  value: conversationPresence,
                ),
              ],
              child: const ChatPeerStatusLine(userId: 'peer'),
            ),
          ),
        ),
      );

      final l10n = AppLocalizations.of(
        tester.element(find.byType(ChatPeerStatusLine)),
      )!;
      final expected = switch (status) {
        true => l10n.chatPeerOnline,
        false => l10n.chatPeerOffline,
        null => l10n.projectPeoplePresenceUnknown,
      };
      expect(find.text(expected), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(() async {
        await conversationPresence.close();
        await presence.close();
        await inbox.close();
      });
      ownersClosed = true;
    });
  }
}

final class _OfflineRealtimeClient implements ChatConversationRealtimeClient {
  @override
  Stream<ChatConversationPresenceSnapshot?> get presenceSnapshots =>
      Stream.value(
        ChatConversationPresenceSnapshot(
          conversationId: 'conversation',
          users: const [],
          changedAtUtc: DateTime.utc(2026, 10, 2),
        ),
      );

  @override
  Stream<ChatUserStatusChanged> get userStatusChanges => const Stream.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _waitFor(WidgetTester tester, bool Function() condition) async {
  for (var i = 0; i < 100 && !condition(); i++) {
    await tester.pump(const Duration(milliseconds: 1));
  }
  expect(condition(), isTrue);
}

ChatInboxItem _item() => ChatInboxItem(
  conversation: ChatConversation(
    id: 'conversation',
    type: 'direct',
    scopeKind: 'global',
    scopeKey: 'global',
    version: 1,
    createdAtUtc: DateTime.utc(2026, 10, 2),
    postingPermission: 'Everyone',
    isArchived: false,
  ),
  lastActivityAtUtc: DateTime.utc(2026, 10, 2),
  unreadCount: 0,
  isMuted: false,
  isDraft: false,
  participantCount: 2,
  lastMessage: ChatInboxMessagePreview(
    messageId: 'message',
    authorUserId: 'peer',
    text: 'Last message preview',
    isDeleted: false,
    hasAttachments: false,
    createdAtUtc: DateTime.utc(2026, 10, 2),
  ),
  participants: const [
    ChatInboxParticipant(userId: 'me', isCurrentUser: true),
    ChatInboxParticipant(
      userId: 'peer',
      displayName: 'Peer',
      isCurrentUser: false,
    ),
  ],
);

final class _InboxRepository implements ChatInboxRepository {
  _InboxRepository(this.item);
  final ChatInboxItem item;

  @override
  Future<Either<ApiError, ChatInboxPage>> loadInbox({
    ChatInboxFilter filter = ChatInboxFilter.all,
    String? cursor,
    int? limit,
    String? query,
  }) async => Right(ChatInboxPage(items: [item], hasMore: false));

  @override
  Future<Either<ApiError, ChatInboxUnreadCount>> loadUnreadCount() async =>
      Right(
        ChatInboxUnreadCount(
          totalUnreadCount: 0,
          unreadConversationCount: 0,
          generatedAtUtc: DateTime.utc(2026),
        ),
      );

  @override
  Future<Either<ApiError, void>> markRead({
    required String conversationId,
    required String messageId,
  }) async => const Right(null);
}

final class _PresenceRepository implements ChatInboxPresenceRepository {
  _PresenceRepository([this.status = true]);

  final bool? status;

  @override
  Future<Either<ApiError, Map<String, bool>>> loadPresence(
    List<String> userIds,
  ) async {
    final isOnline = status;
    return Right(
      isOnline == null
          ? <String, bool>{}
          : <String, bool>{for (final id in userIds) id: isOnline},
    );
  }
}

final class _ManagementRepositoryFake
    implements ChatConversationManagementRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _DirectoryRepositoryFake implements ChatDirectoryRepository {
  _DirectoryRepositoryFake([this.isOnline]);
  bool? isOnline;
  @override
  Future<Either<ApiError, List<ChatDirectoryEntry>>> search({
    required String term,
    int limit = 20,
  }) async => Right([
    ChatDirectoryEntry(
      userId: 'new-person',
      login: 'new.person',
      displayName: 'New person',
      isOnline: isOnline,
    ),
  ]);
}
