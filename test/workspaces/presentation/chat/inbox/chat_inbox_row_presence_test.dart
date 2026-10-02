import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_row.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/widgets/chat_inbox_presence_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('presence labels are explicit and localized in $locale', (
      tester,
    ) async {
      final labels = await AppLocalizations.delegate.load(locale);
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: Column(
              children: [
                ChatInboxPresenceLabel(isOnline: true),
                ChatInboxPresenceLabel(isOnline: false),
              ],
            ),
          ),
        ),
      );

      expect(find.text(labels.tasksPresenceOnline), findsOneWidget);
      expect(find.text(labels.tasksPresenceOffline), findsOneWidget);
    });
  }

  testWidgets('direct inbox preview remains visible at narrow width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ChatInboxRow(
            item: _item(type: 'direct'),
            nowUtc: DateTime.utc(2026, 10, 2),
          ),
        ),
      ),
    );

    expect(find.text('Last message preview'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('group rows do not claim the whole group is online or offline', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ChatInboxRow(
            item: _item(type: 'group'),
            nowUtc: DateTime.utc(2026, 10, 2),
          ),
        ),
      ),
    );

    final l10n = AppLocalizations.of(
      tester.element(find.byType(ChatInboxRow)),
    )!;
    expect(find.text(l10n.tasksPresenceOnline), findsNothing);
    expect(find.text(l10n.tasksPresenceOffline), findsNothing);
  });
}

ChatInboxItem _item({required String type}) => ChatInboxItem(
  conversation: ChatConversation(
    id: 'conversation',
    type: type,
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
  participantCount: type == 'direct' ? 2 : 3,
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
    ChatInboxParticipant(userId: 'peer', isCurrentUser: false),
  ],
);
