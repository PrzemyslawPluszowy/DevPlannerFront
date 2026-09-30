import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_action_models.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/chat_realtime_test_support.dart';

void main() {
  group('ChatConversationCubit realtime', () {
    test('conversation event odświeża metadane rozmowy z REST', () async {
      final repository = _RealtimeConversationRepository(
        pageResults: <Either<ApiError, ChatMessagePage>>[
          Right(
            ChatMessagePage(items: <ChatMessage>[_ChatFixture.message('m1')]),
          ),
        ],
      );
      final transport = ChatRealtimeTestTransport();
      final cubit = ChatConversationCubit(
        repository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'test-user',
        realtime: WorkspaceChatRealtimeService(client: transport),
      );
      await cubit.load();
      await ChatRealtimeTestPayload.flush();
      repository.conversationResult = _ChatFixture.conversation(
        name: 'Nowa nazwa',
      );

      transport.emit('chat.conversation.updated', <String, dynamic>{
        'conversationId': 'conversation-1',
        'eventId': 'conversation-updated-1',
        'sequence': 1,
      });
      await ChatRealtimeTestPayload.flush();

      expect(repository.getConversationCalls, 2);
      expect(
        (cubit.state as ChatConversationReady).conversation.name,
        'Nowa nazwa',
      );
      await cubit.close();
    });

    test('odświeża reakcje z serwera po zdarzeniu realtime', () async {
      final initial = _ChatFixture.message('message-1');
      final refreshed = _ChatFixture.message(
        'message-1',
        reactions: const <ChatReactionSummary>[
          ChatReactionSummary(
            emoji: '🔥',
            count: 2,
            reactedByCurrentUser: true,
          ),
        ],
      );
      final repository = _RealtimeConversationRepository(
        pageResults: <Either<ApiError, ChatMessagePage>>[
          Right(ChatMessagePage(items: <ChatMessage>[initial])),
        ],
        windowResult: ChatMessageWindow(
          anchorMessageId: initial.id,
          messages: <ChatMessage>[refreshed],
          hasMoreBefore: false,
          hasMoreAfter: false,
        ),
      );
      final transport = ChatRealtimeTestTransport();
      final cubit = ChatConversationCubit(
        repository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'test-user',
        realtime: WorkspaceChatRealtimeService(client: transport),
      );

      await cubit.load();
      await ChatRealtimeTestPayload.flush();
      transport.emit('chat.reaction.changed', <String, dynamic>{
        'conversationId': 'conversation-1',
        'messageId': initial.id,
        'eventId': 'reaction-1',
        'sequence': 1,
      });
      await ChatRealtimeTestPayload.flush();

      final state = cubit.state as ChatConversationReady;
      expect(repository.windowCalls, <String>[initial.id]);
      expect(state.messages.single.reactions.single.count, 2);
      expect(
        state.messages.single.reactions.single.reactedByCurrentUser,
        isTrue,
      );
      await cubit.close();
    });

    test('scala live message bez drugiego odczytu historii REST', () async {
      final repository = _RealtimeConversationRepository(
        pageResults: <Either<ApiError, ChatMessagePage>>[
          Right(
            ChatMessagePage(
              items: <ChatMessage>[_ChatFixture.message('initial-1')],
            ),
          ),
        ],
      );
      final transport = ChatRealtimeTestTransport();
      final cubit = ChatConversationCubit(
        repository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'test-user',
        realtime: WorkspaceChatRealtimeService(client: transport),
      );

      await cubit.load();
      await ChatRealtimeTestPayload.flush();
      transport.emit(
        'chat.message.created',
        ChatRealtimeTestPayload.message(eventId: 'remote-1', sequence: 1),
      );
      await ChatRealtimeTestPayload.flush();

      final state = cubit.state as ChatConversationReady;
      expect(repository.listCalls, 1);
      expect(state.messages.map((message) => message.id), <String>[
        'initial-1',
        'message-1',
      ]);
      await cubit.close();
    });

    test(
      'read event odświeża liczniki wcześniejszych wiadomości w historii',
      () async {
        final first = _ChatFixture.message('initial-1');
        final latest = _ChatFixture.message('message-1');
        final repository = _RealtimeConversationRepository(
          pageResults: <Either<ApiError, ChatMessagePage>>[
            Right(ChatMessagePage(items: <ChatMessage>[first, latest])),
          ],
          windowResult: ChatMessageWindow(
            anchorMessageId: latest.id,
            messages: <ChatMessage>[
              _ChatFixture.message('initial-1', readByCount: 1),
              _ChatFixture.message('message-1'),
            ],
            hasMoreBefore: false,
            hasMoreAfter: false,
          ),
        );
        final transport = ChatRealtimeTestTransport();
        final cubit = ChatConversationCubit(
          repository: repository,
          conversationId: 'conversation-1',
          currentUserId: 'test-user',
          realtime: WorkspaceChatRealtimeService(client: transport),
        );

        await cubit.load();
        await ChatRealtimeTestPayload.flush();
        transport.emit('chat.message.read', <String, dynamic>{
          'conversationId': 'conversation-1',
          'messageId': latest.id,
          'eventId': 'read-latest',
          'sequence': 1,
        });
        await ChatRealtimeTestPayload.flush();

        final state = cubit.state as ChatConversationReady;
        expect(repository.windowCalls, <String>[latest.id]);
        expect(state.messages.first.readByCount, 1);
        expect(state.messages.last.readByCount, 0);
        await cubit.close();
      },
    );

    test(
      'okno historii czyści cytat realtime po usunięciu celu poza zakresem',
      () async {
        final reply = _ChatFixture.message(
          'reply-1',
          replyToMessageId: 'old-target',
          replyPreview: const ChatMessageReplyTargetPreview(
            messageId: 'old-target',
            authorUserId: 'user-2',
            authorLabel: 'Anna',
            text: 'Stara treść',
            isDeleted: false,
            hasAttachments: false,
          ),
        );
        final anchor = _ChatFixture.message('window-anchor');
        final repository = _RealtimeConversationRepository(
          pageResults: <Either<ApiError, ChatMessagePage>>[
            Right(ChatMessagePage(items: <ChatMessage>[reply])),
          ],
          windowResult: ChatMessageWindow(
            anchorMessageId: anchor.id,
            messages: <ChatMessage>[anchor, reply],
            hasMoreBefore: false,
            hasMoreAfter: false,
          ),
        );
        final transport = ChatRealtimeTestTransport();
        final cubit = ChatConversationCubit(
          repository: repository,
          conversationId: 'conversation-1',
          currentUserId: 'test-user',
          realtime: WorkspaceChatRealtimeService(client: transport),
        );

        await cubit.load();
        await ChatRealtimeTestPayload.flush();
        await cubit.ensureTargetLoaded(anchor.id);
        expect(
          (cubit.state as ChatConversationReady).isWindowedHistory,
          isTrue,
        );
        transport.emit('chat.message.deleted', <String, dynamic>{
          'conversationId': 'conversation-1',
          'eventId': 'delete-old-target',
          'sequence': 1,
          'messageId': 'old-target',
          'version': 2,
        });
        await ChatRealtimeTestPayload.flush();

        final state = cubit.state as ChatConversationReady;
        expect(
          state.messages
              .singleWhere((message) => message.id == reply.id)
              .replyPreview
              ?.isDeleted,
          isTrue,
        );
        expect(
          state.messages
              .singleWhere((message) => message.id == reply.id)
              .replyPreview
              ?.text,
          isEmpty,
        );
        await cubit.close();
      },
    );

    test(
      'resync prowadzi do jednego snapshotu i odłącza zakres po 403',
      () async {
        final repository = _RealtimeConversationRepository(
          pageResults: <Either<ApiError, ChatMessagePage>>[
            const Right(ChatMessagePage(items: <ChatMessage>[])),
            const Left(
              ApiError(
                type: ApiErrorType.forbidden,
                message: 'Dostęp cofnięty.',
              ),
            ),
          ],
        );
        final transport = ChatRealtimeTestTransport()
          ..replayResult = const <String, dynamic>{'resyncRequired': true};
        final cubit = ChatConversationCubit(
          repository: repository,
          conversationId: 'conversation-1',
          currentUserId: 'test-user',
          realtime: WorkspaceChatRealtimeService(client: transport),
        );

        await cubit.load();
        await ChatRealtimeTestPayload.flush();
        transport.reconnect();
        await ChatRealtimeTestPayload.flush();

        expect(repository.listCalls, 2);
        expect(cubit.state, isA<ChatConversationDetached>());
        expect(
          transport.invocations.map((invocation) => invocation.$1),
          contains('UnsubscribeConversation'),
        );
        await cubit.close();
      },
    );

    test(
      'resync po 401 zatrzymuje scope bez przywracania lokalnego cache',
      () async {
        final repository = _RealtimeConversationRepository(
          pageResults: <Either<ApiError, ChatMessagePage>>[
            Right(
              ChatMessagePage(
                items: <ChatMessage>[_ChatFixture.message('initial-1')],
              ),
            ),
            const Left(
              ApiError(
                type: ApiErrorType.unauthorized,
                message: 'Sesja wygasła.',
              ),
            ),
          ],
        );
        final transport = ChatRealtimeTestTransport()
          ..replayResult = const <String, dynamic>{'resyncRequired': true};
        final cubit = ChatConversationCubit(
          repository: repository,
          conversationId: 'conversation-1',
          currentUserId: 'test-user',
          realtime: WorkspaceChatRealtimeService(client: transport),
        );

        await cubit.load();
        await ChatRealtimeTestPayload.flush();
        transport.reconnect();
        await ChatRealtimeTestPayload.flush();
        transport.emit(
          'chat.message.created',
          ChatRealtimeTestPayload.message(eventId: 'after-revoke', sequence: 1),
        );
        await ChatRealtimeTestPayload.flush();

        expect(repository.listCalls, 2);
        expect(cubit.state, isA<ChatConversationDetached>());
        expect(
          transport.invocations.map((invocation) => invocation.$1),
          contains('UnsubscribeConversation'),
        );
        await cubit.close();
      },
    );

    test(
      'nie gubi historii, gdy ACK wysyłki ściga się z live eventem',
      () async {
        final sentResult = Completer<Either<ApiError, ChatMessage>>();
        final repository = _RealtimeConversationRepository(
          pageResults: <Either<ApiError, ChatMessagePage>>[
            Right(
              ChatMessagePage(
                items: <ChatMessage>[_ChatFixture.message('initial-1')],
              ),
            ),
          ],
          sendResult: sentResult,
        );
        final transport = ChatRealtimeTestTransport();
        final cubit = ChatConversationCubit(
          repository: repository,
          conversationId: 'conversation-1',
          currentUserId: 'test-user',
          realtime: WorkspaceChatRealtimeService(client: transport),
        );
        await cubit.load();
        await ChatRealtimeTestPayload.flush();

        cubit.send('Lokalna wiadomość');
        await ChatRealtimeTestPayload.flush();
        final command = repository.sentCommands.single;
        transport.emit(
          'chat.message.created',
          ChatRealtimeTestPayload.message(eventId: 'remote-1', sequence: 1),
        );
        sentResult.complete(
          Right(
            _ChatFixture.message(
              'server-local-1',
              clientMessageId: command.clientMessageId,
              text: command.text,
              payloadHash: command.payloadHash,
            ),
          ),
        );
        await ChatRealtimeTestPayload.flush();

        final state = cubit.state as ChatConversationReady;
        expect(
          state.messages.map((message) => message.id),
          containsAll(<String>['initial-1', 'message-1', 'server-local-1']),
        );
        expect(state.messages, hasLength(3));
        await cubit.close();
      },
    );

    test(
      'zamknięcie ekranu odsubskrybowuje, ale nie niszczy shared transportu',
      () async {
        final repository = _RealtimeConversationRepository(
          pageResults: const <Either<ApiError, ChatMessagePage>>[
            Right(ChatMessagePage(items: <ChatMessage>[])),
          ],
        );
        final transport = ChatRealtimeTestTransport();
        final cubit = ChatConversationCubit(
          repository: repository,
          conversationId: 'conversation-1',
          currentUserId: 'test-user',
          realtime: WorkspaceChatRealtimeService(client: transport),
        );

        await cubit.load();
        await ChatRealtimeTestPayload.flush();
        await cubit.close();

        expect(transport.isDisposed, isFalse);
        expect(
          transport.invocations.map((invocation) => invocation.$1),
          contains('UnsubscribeConversation'),
        );
      },
    );

    test('zwalnia realtime utworzony dla pojedynczej rozmowy', () async {
      final repository = _RealtimeConversationRepository(
        pageResults: const <Either<ApiError, ChatMessagePage>>[
          Right(ChatMessagePage(items: <ChatMessage>[])),
        ],
      );
      final transport = ChatRealtimeTestTransport();
      final realtime = WorkspaceChatRealtimeService(client: transport);
      final cubit = ChatConversationCubit(
        repository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'test-user',
        realtime: realtime,
        disposeRealtime: realtime.dispose,
      );

      await cubit.load();
      await ChatRealtimeTestPayload.flush();
      await cubit.close();

      expect(transport.isDisposed, isTrue);
    });
  });
}

/// Repozytorium z kolejką odpowiedzi pozwala kontrolować snapshot i ACK.
final class _RealtimeConversationRepository
    implements ChatConversationRepository {
  _RealtimeConversationRepository({
    required List<Either<ApiError, ChatMessagePage>> pageResults,
    this.sendResult,
    this.windowResult,
  }) : _pageResults = List<Either<ApiError, ChatMessagePage>>.of(pageResults);

  final List<Either<ApiError, ChatMessagePage>> _pageResults;
  final Completer<Either<ApiError, ChatMessage>>? sendResult;
  final ChatMessageWindow? windowResult;
  ChatConversation? conversationResult;
  final List<ChatSendMessageCommand> sentCommands = <ChatSendMessageCommand>[];
  final List<String> windowCalls = <String>[];
  int listCalls = 0;
  int getConversationCalls = 0;

  @override
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  ) async {
    getConversationCalls++;
    return Right(conversationResult ?? _ChatFixture.conversation());
  }

  @override
  Future<Either<ApiError, ChatMessageWindow>> loadMessageWindow({
    required String conversationId,
    required String messageId,
    int before = 20,
    int after = 20,
  }) async {
    windowCalls.add(messageId);
    final result = windowResult;
    if (result == null) throw UnimplementedError();
    return Right(result);
  }

  @override
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  }) async {
    listCalls++;
    return _pageResults.removeAt(0);
  }

  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) {
    sentCommands.add(command);
    return sendResult?.future ??
        Future<Either<ApiError, ChatMessage>>.value(
          const Left(ApiError(type: ApiErrorType.server, message: 'Brak ACK.')),
        );
  }

  @override
  Future<Either<ApiError, void>> markMessageDelivered({
    required String messageId,
  }) async => const Right(null);

  @override
  Future<Either<ApiError, void>> markConversationRead({
    required String conversationId,
    required String messageId,
  }) async => const Right(null);
}

/// Dostarcza modele domenowe bez odwzorowywania DTO wygenerowanego API.
abstract final class _ChatFixture {
  /// Tworzy rozmowę autoryzowaną do odczytu i pisania w testach Cubita.
  static ChatConversation conversation({String? name}) => ChatConversation(
    id: 'conversation-1',
    name: name,
    type: 'Channel',
    scopeKind: 'Workspace',
    scopeKey: 'workspace:demo',
    version: 1,
    createdAtUtc: DateTime.utc(2026),
    postingPermission: 'Everyone',
    isArchived: false,
  );

  /// Tworzy potwierdzoną wiadomość API dla listy albo ACK kolejki.
  static ChatMessage message(
    String id, {
    String? clientMessageId,
    String text = 'Treść',
    String payloadHash = 'HASH',
    int readByCount = 0,
    List<ChatReactionSummary> reactions = const <ChatReactionSummary>[],
    String? replyToMessageId,
    ChatMessageReplyTargetPreview? replyPreview,
  }) => ChatMessage(
    id: id,
    conversationId: 'conversation-1',
    authorUserId: 'user-1',
    clientMessageId: clientMessageId ?? 'client-$id',
    text: text,
    replyToMessageId: replyToMessageId,
    replyPreview: replyPreview,
    payloadHash: payloadHash,
    version: 1,
    createdAtUtc: DateTime.utc(2026),
    isDeleted: false,
    deliveryState: ChatMessageDeliveryState.sent,
    readByCount: readByCount,
    reactions: reactions,
  );
}
