import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_conversation_actions_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _ConversationRepository extends Mock
    implements ChatRepository, ChatConversationRepository {}

class _DraftRepository extends Mock implements ChatDraftRepository {}

class _MessageActionsRepository extends Mock
    implements ChatMessageActionsRepository {}

void main() {
  for (final width in <double>[320, 1280]) {
    testWidgets(
      'menu opens saved cross-conversation error diagnostics at $width px',
      (tester) async {
        tester.view.physicalSize = Size(width, 760);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final currentConversation = ChatConversation(
          id: 'current-conversation',
          type: 'direct',
          scopeKind: 'global',
          scopeKey: 'current',
          version: 1,
          createdAtUtc: DateTime.utc(2026),
          postingPermission: 'Everyone',
          isArchived: false,
          name: 'Current conversation',
        );
        final repository = _ConversationRepository();
        final actions = _MessageActionsRepository();
        const messageError = ApiError(
          type: ApiErrorType.validation,
          message: 'The saved message conversation could not be loaded.',
          apiCode: 'chat.conversation.load_failed',
          contractCode: 'resource.unavailable',
          backendCode: 7304,
          statusCode: 503,
          traceId: 'saved-message-trace-7304',
          fields: <String, List<String>>{
            'conversationId': <String>['access_check_failed'],
          },
        );
        final bookmark = ChatBookmark(
          id: 'saved-cross-conversation-bookmark',
          messageId: 'message-outside-current-task',
          conversationId: 'other-conversation',
          userId: 'viewer',
          createdAtUtc: DateTime.utc(2026),
          messageText: 'Saved message from another conversation',
        );
        when(actions.listBookmarks).thenAnswer((_) async => Right([bookmark]));
        when(
          () => repository.getConversation(bookmark.conversationId),
        ).thenAnswer((_) async => const Left(messageError));

        final composition = DevPlannerGlobalChatComposition(
          repository: repository,
          draftRepository: _DraftRepository(),
          userId: 'viewer',
          messageActions: actions,
        );
        await tester.pumpWidget(
          RepositoryProvider<DevPlannerGlobalChatComposition>.value(
            value: composition,
            child: MaterialApp(
              locale: const Locale('en'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en')],
              home: Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: ChatConversationActionsMenu(
                    conversation: currentConversation,
                    messageActions: actions,
                    conversationRepository: repository,
                    canRename: false,
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(IconButton).first);
        await tester.pumpAndSettle();
        expect(find.text('Show saved'), findsOneWidget);
        await tester.tap(find.text('Show saved'));
        await tester.pumpAndSettle();
        expect(find.text(bookmark.messageText!), findsOneWidget);
        await tester.tap(find.text(bookmark.messageText!));
        await tester.pumpAndSettle();

        expect(find.text('Could not load conversations'), findsOneWidget);
        expect(
          find.text(messageError.message),
          findsOneWidget,
        );
        expect(
          find.text('API code: chat.conversation.load_failed'),
          findsOneWidget,
        );
        expect(find.text('HTTP: 503'), findsOneWidget);
        expect(
          find.textContaining('saved-message-trace-7304'),
          findsOneWidget,
        );
        expect(
          find.textContaining('conversationId: access_check_failed'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        verify(
          () => repository.getConversation(bookmark.conversationId),
        ).called(1);

        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
