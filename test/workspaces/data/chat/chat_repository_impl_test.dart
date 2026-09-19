import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_repository_impl.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockChatApi extends Mock implements ChatApi {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const SendChatMessagePayload(
        clientMessageId: 'fallback-client-id',
        text: 'fallback text',
      ),
    );
    registerFallbackValue(
      const ResolveChatConversationPayload(
        type: ChatConversationType.channel,
        scopeKind: ChatScopeKind.global,
        scopeKey: 'fallback',
      ),
    );
  });

  group('ChatRepositoryImpl', () {
    test('przekazuje aktywne rozmowy bez ujawniania transportu', () async {
      final api = _MockChatApi();
      final expected = <ChatConversationResponse>[
        _ChatRepositoryFixture.conversation(),
      ];
      when(api.listConversations).thenAnswer((_) async => expected);

      final result = await ChatRepositoryImpl(api).listConversations();

      expect(result.getOrElse(List.empty), expected);
      verify(api.listConversations).called(1);
    });

    test('pobiera aktualną stronę wiadomości z limitem adaptera', () async {
      final api = _MockChatApi();
      final expected = <ChatMessageResponse>[_ChatRepositoryFixture.message()];
      when(
        () => api.listMessages('conversation-1', limit: 100),
      ).thenAnswer(
        (_) async => CursorPageResponse(items: expected, nextCursor: 'older'),
      );

      final result = await ChatRepositoryImpl(api).listMessages(
        'conversation-1',
      );

      expect(result.getOrElse(List.empty), expected);
      verify(() => api.listMessages('conversation-1', limit: 100)).called(1);
    });

    test(
      'wysyła wyłącznie tekst i idempotency key aktualnego kontraktu',
      () async {
        final api = _MockChatApi();
        when(() => api.sendMessage('conversation-1', any())).thenAnswer(
          (_) async => _ChatRepositoryFixture.message(),
        );

        final result = await ChatRepositoryImpl(api).sendMessage(
          conversationId: 'conversation-1',
          clientMessageId: 'client-1',
          text: '  Treść zachowana przez adapter  ',
        );

        expect(result.isRight(), isTrue);
        final payload =
            verify(
                  () => api.sendMessage('conversation-1', captureAny()),
                ).captured.single
                as SendChatMessagePayload;
        expect(payload.clientMessageId, 'client-1');
        expect(payload.text, '  Treść zachowana przez adapter  ');
      },
    );

    test('mapuje błąd HTTP listy rozmów na stabilny kod Chat', () async {
      final api = _MockChatApi();
      when(api.listConversations).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/chat/conversations'),
          response: Response<void>(
            requestOptions: RequestOptions(path: '/api/v1/chat/conversations'),
            statusCode: 403,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await ChatRepositoryImpl(api).listConversations();

      final error = result.swap().getOrElse(
        () => throw StateError('Oczekiwano błędu API.'),
      );
      expect(error.type, ApiErrorType.forbidden);
      expect(error.apiCode, 'chat.conversations.load_failed');
    });

    test('mapuje nieoczekiwany wyjątek wysyłki na błąd parsowania', () async {
      final api = _MockChatApi();
      when(() => api.sendMessage('conversation-1', any())).thenThrow(
        const FormatException('Niepoprawna odpowiedź'),
      );

      final result = await ChatRepositoryImpl(api).sendMessage(
        conversationId: 'conversation-1',
        clientMessageId: 'client-1',
        text: 'Treść',
      );

      final error = result.swap().getOrElse(
        () => throw StateError('Oczekiwano błędu parsowania.'),
      );
      expect(error.type, ApiErrorType.parsing);
      expect(error.apiCode, 'chat.messages.send_failed');
    });

    test('mapuje szczegóły i cursor historii do kontraktu rozmowy', () async {
      final api = _MockChatApi();
      when(
        () => api.getConversation('conversation-1'),
      ).thenAnswer((_) async => _ChatRepositoryFixture.conversation());
      when(
        () => api.listMessages(
          'conversation-1',
          cursor: 'older',
          limit: 20,
        ),
      ).thenAnswer(
        (_) async => CursorPageResponse(
          items: [_ChatRepositoryFixture.message()],
          nextCursor: 'oldest',
        ),
      );
      final repository = ChatRepositoryImpl(api);

      final conversation = await repository.getConversation('conversation-1');
      final messages = await repository.listConversationMessages(
        conversationId: 'conversation-1',
        cursor: 'older',
        limit: 20,
      );

      expect(
        conversation.getOrElse(() => throw StateError('Brak rozmowy.')),
        isA<ChatConversation>(),
      );
      expect(
        messages.getOrElse(() => throw StateError('Brak historii.')).nextCursor,
        'oldest',
      );
      expect(
        messages
            .getOrElse(() => throw StateError('Brak historii.'))
            .items
            .single
            .text,
        'Treść',
      );
    });

    test(
      'przekazuje pełną komendę composera bez utraty delta i załączników',
      () async {
        final api = _MockChatApi();
        when(() => api.sendMessage('conversation-1', any())).thenAnswer(
          (_) async => _ChatRepositoryFixture.message(),
        );

        final result = await ChatRepositoryImpl(api).sendConversationMessage(
          const ChatSendMessageCommand(
            conversationId: 'conversation-1',
            clientMessageId: 'client-1',
            text: 'Treść',
            payloadHash: 'HASH',
            deltaJson: '[{"insert":"Treść"}]',
            replyToMessageId: 'reply-1',
            attachmentFileIds: ['file-1'],
          ),
        );

        expect(result.isRight(), isTrue);
        final payload =
            verify(
                  () => api.sendMessage('conversation-1', captureAny()),
                ).captured.single
                as SendChatMessagePayload;
        expect(payload.deltaJson, '[{"insert":"Treść"}]');
        expect(payload.replyToMessageId, 'reply-1');
        expect(payload.attachmentFileIds, ['file-1']);
      },
    );

    test('rozwiązuje Resource Chat przez autoryzowany scope pliku', () async {
      final api = _MockChatApi();
      when(() => api.resolve(any())).thenAnswer(
        (_) async => _ChatRepositoryFixture.conversation(),
      );

      final result = await ChatRepositoryImpl(api).resolveFileConversation(
        const ResourceChatFileRequest(
          fileId: '61d9c4bf-2b18-4d8c-a1b4-996628d6c113',
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          fileContext: ResourceChatFileContext(
            fileId: '61d9c4bf-2b18-4d8c-a1b4-996628d6c113',
            fileName: 'plan.pdf',
            ownerUserId: 'owner-1',
            accessLevel: 'read',
          ),
        ),
      );

      expect(result.isRight(), isTrue);
      final payload =
          verify(() => api.resolve(captureAny())).captured.single
              as ResolveChatConversationPayload;
      expect(payload.scopeKind, ChatScopeKind.resource);
      expect(payload.scopeProvider, 'files');
      expect(payload.scopeResourceId, '61d9c4bf-2b18-4d8c-a1b4-996628d6c113');
    });
  });
}

abstract final class _ChatRepositoryFixture {
  static ChatConversationResponse conversation() => ChatConversationResponse(
    id: 'conversation-1',
    type: ChatConversationType.channel,
    scopeKind: ChatScopeKind.workspace,
    scopeKey: 'workspace:demo',
    version: 1,
    createdAtUtc: DateTime.utc(2026),
  );

  static ChatMessageResponse message() => ChatMessageResponse(
    id: 'message-1',
    conversationId: 'conversation-1',
    authorUserId: 'user-1',
    clientMessageId: 'client-1',
    text: 'Treść',
    payloadHash: 'HASH',
    version: 1,
    createdAtUtc: DateTime.utc(2026),
    isDeleted: false,
  );
}
