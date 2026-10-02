import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_saved_conversation_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Repository extends Mock
    implements ChatRepository, ChatConversationRepository {}

class _Inbox extends Mock implements ChatInboxRepository {}

class _Drafts extends Mock implements ChatDraftRepository {}

class _Actions extends Mock implements ChatMessageActionsRepository {}

void main() {
  for (final (width, useActions) in [
    (320.0, true),
    (1280.0, true),
    (1280.0, false),
  ]) {
    testWidgets(
      'saved conversation opens target at $width, actions=$useActions',
      (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final repository = _Repository();
        final inbox = _Inbox();
        final drafts = _Drafts();
        final actions = _Actions();
        when(actions.listBookmarks).thenAnswer((_) async => const Right([]));
        when(() => actions.listPins('other-conversation'))
            .thenAnswer((_) async => const Right([]));
        final conversation = ChatConversation(
          id: 'other-conversation',
          type: 'direct',
          scopeKind: 'global',
          scopeKey: 'other',
          version: 1,
          createdAtUtc: DateTime.utc(2026),
          postingPermission: 'Everyone',
          isArchived: false,
          name: 'Other conversation',
        );
        final message = ChatMessage(
          id: 'old-target',
          conversationId: conversation.id,
          authorUserId: 'author',
          clientMessageId: 'client',
          text: 'Saved message outside the task',
          payloadHash: 'hash',
          version: 1,
          createdAtUtc: DateTime.utc(2026),
          isDeleted: false,
          deliveryState: ChatMessageDeliveryState.sent,
        );
        when(() => repository.getConversation(conversation.id))
            .thenAnswer((_) async => Right(conversation));
        when(
          () => repository.markConversationRead(
            conversationId: conversation.id,
            messageId: message.id,
          ),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => repository.listConversationMessages(
            conversationId: conversation.id,
          ),
        ).thenAnswer((_) async => const Right(ChatMessagePage(items: [])));
        when(
          () => repository.loadMessageWindow(
            conversationId: conversation.id,
            messageId: message.id,
          ),
        ).thenAnswer(
          (_) async => Right(
            ChatMessageWindow(
              anchorMessageId: message.id,
              messages: [message],
              hasMoreBefore: false,
              hasMoreAfter: false,
            ),
          ),
        );
        when(
          () => inbox.loadInbox(
            limit: 30,
          ),
        ).thenAnswer(
          (_) async => const Right(ChatInboxPage.empty),
        );
        when(inbox.loadUnreadCount).thenAnswer(
          (_) async => Right(
            ChatInboxUnreadCount(
              totalUnreadCount: 0,
              unreadConversationCount: 0,
              generatedAtUtc: DateTime.utc(2026),
            ),
          ),
        );
        final composition = DevPlannerGlobalChatComposition(
          repository: repository,
          inboxRepository: inbox,
          draftRepository: drafts,
          messageActions: useActions ? actions : null,
          userId: 'viewer',
        );
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('pl')],
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => unawaited(
                    ChatSavedConversationSheet.show(
                      context,
                      composition: composition,
                      conversation: conversation,
                      messageId: message.id,
                    ),
                  ),
                  child: const Text('Open saved'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open saved'));
        await tester.pumpAndSettle();
        expect(find.text('Other conversation'), findsWidgets);
        expect(find.text(message.text), findsOneWidget);
        expect(tester.takeException(), isNull);
        verify(
          () => repository.loadMessageWindow(
            conversationId: conversation.id,
            messageId: message.id,
          ),
        ).called(1);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
