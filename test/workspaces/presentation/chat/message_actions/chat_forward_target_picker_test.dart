import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_forward_target_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class _ForwardTargetsRepository implements ChatInboxRepository {
  _ForwardTargetsRepository(this.error);

  final ApiError error;
  int calls = 0;

  @override
  Future<Either<ApiError, ChatInboxPage>> loadInbox({
    ChatInboxFilter filter = ChatInboxFilter.all,
    String? cursor,
    int? limit,
    String? query,
  }) async {
    calls++;
    return calls == 1 ? Left(error) : const Right(ChatInboxPage.empty);
  }

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

ChatInboxItem _target(String id, String name) => ChatInboxItem(
  conversation: ChatConversation(
    id: id,
    type: 'direct',
    scopeKind: 'global',
    scopeKey: 'direct:global:$id',
    version: 1,
    createdAtUtc: DateTime.utc(2026),
    postingPermission: 'Everyone',
    isArchived: false,
    name: name,
  ),
  lastActivityAtUtc: DateTime.utc(2026),
  unreadCount: 0,
  isMuted: false,
  isDraft: false,
  participantCount: 2,
);

void main() {
  testWidgets('uses and filters the supplied fallback snapshot', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: ChatForwardTargetPicker(
              sourceConversationId: 'source',
              targets: <ChatInboxItem>[
                _target('source', 'Source conversation'),
                _target('one', 'First conversation'),
                _target('two', 'Second conversation'),
              ],
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Source conversation'), findsNothing);
    expect(find.text('First conversation'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('chat-forward-target-search')),
      'second',
    );
    await tester.pumpAndSettle();
    expect(find.text('Second conversation'), findsOneWidget);
    expect(find.text('First conversation'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('scrolls long API details and retries within 340x350', (
    tester,
  ) async {
    final error = ApiError(
      type: ApiErrorType.validation,
      message: 'Request could not be processed',
      apiCode: 'chat.inbox.query_invalid',
      contractCode: 'validation.failed',
      statusCode: 422,
      traceId: 'forward-picker-trace-123',
      fields: <String, List<String>>{
        for (var index = 0; index < 20; index++)
          'field-$index': <String>['validation detail $index'],
      },
    );
    final repository = _ForwardTargetsRepository(error);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 340,
              height: 350,
              child: ChatForwardTargetPicker(
                sourceConversationId: 'source',
                targets: const <ChatInboxItem>[],
                repository: repository,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('chat.inbox.query_invalid'), findsOneWidget);
    expect(find.textContaining('422'), findsOneWidget);
    expect(find.textContaining('forward-picker-trace-123'), findsOneWidget);
    await tester.ensureVisible(find.textContaining('field-19'));
    expect(find.textContaining('field-19'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(repository.calls, 2);
    expect(find.text('No other conversations to forward to.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
