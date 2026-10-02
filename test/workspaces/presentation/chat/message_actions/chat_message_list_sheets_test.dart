import 'package:dartz/dartz.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_action_side_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_list_sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Actions extends Mock implements ChatMessageActionsRepository {}

void main() {
  for (final pinned in [false, true]) {
    testWidgets(
      'message preview is visible and opens its target, pinned=$pinned',
      (tester) async {
        final repository = _Actions();
        final now = DateTime.utc(2026, 10, 2);
      when(repository.listBookmarks).thenAnswer(
          (_) async => Right([
            ChatBookmark(
              id: 'bookmark',
              messageId: 'message',
              conversationId: 'conversation',
              userId: 'user',
              createdAtUtc: now,
              note: 'Private note',
              messageText: 'Actual message preview',
            ),
          ]),
        );
        when(() => repository.listPins('conversation')).thenAnswer(
          (_) async => Right([
            ChatPinnedMessage(
              id: 'pin',
              messageId: 'message',
              conversationId: 'conversation',
              pinnedByUserId: 'user',
              pinnedAtUtc: now,
              messageText: 'Actual message preview',
            ),
          ]),
        );
        String? opened;
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('pl'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => TextButton(
                onPressed: () => pinned
                    ? ChatPinnedMessagesSheet.show(
                        context,
                        repository: repository,
                        conversationId: 'conversation',
                        onOpenMessage: (messageId) => opened = messageId,
                      )
                    : ChatBookmarksSheet.show(
                        context,
                        repository: repository,
                        onOpenMessage: (_, messageId) => opened = messageId,
                      ),
                child: const Text('Open'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(find.text('Actual message preview'), findsOneWidget);
        if (!pinned) {
          expect(find.textContaining('Private note'), findsOneWidget);
        }
        expect(tester.getSize(find.byType(ChatActionSideSheet)).width, 480);
        await tester.tap(find.text('Actual message preview'));
        await tester.pumpAndSettle();
        expect(opened, 'message');
        expect(find.byType(ChatActionSideSheet), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
