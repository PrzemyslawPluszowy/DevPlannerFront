import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/workspaces/data/chat/api/chat_api.dart';
import 'package:ready_next/workspaces/data/chat/models/chat_models.dart';
import 'package:ready_next/workspaces/data/chat/repositories/chat_repository_impl.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/chat_enums.dart';
import 'package:ready_next/workspaces/domain/chat/attachments/chat_attachments_export.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:ready_next/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_repository.dart';

/// Atrapa wygenerowanego klienta Retrofit używana do testu mapowania danych.
final class _MockChatApi extends Mock implements ChatApi {}

void main() {
  setUpAll(() {
    registerFallbackValue(_ChatRepositoryFixture.resolvePayload());
    registerFallbackValue(
      const SendChatMessagePayload(
        clientMessageId: 'fallback',
        text: 'fallback',
      ),
    );
    registerFallbackValue(
      const UpdateChatMessagePayload(text: 'fallback', version: 1),
    );
  });
  test('zachowuje cursor i mapuje DTO historii poza prezentacją', () async {
    final api = _MockChatApi();
    when(
      () => api.listMessages('conversation-1', cursor: 'older', limit: 25),
    ).thenAnswer(
      (_) async => CursorPageResponse(
        items: [_ChatRepositoryFixture.messageResponse()],
        nextCursor: 'oldest',
      ),
    );
    final repository = ChatRepositoryImpl(api);

    final result = await repository.listConversationMessages(
      conversationId: 'conversation-1',
      cursor: 'older',
      limit: 25,
    );

    final page = result.getOrElse(
      () => throw StateError('Oczekiwano poprawnej strony historii.'),
    );
    expect(page.nextCursor, 'oldest');
    expect(page.items.single, isA<ChatMessage>());
    expect(page.items.single.deliveryState, ChatMessageDeliveryState.sent);
    verify(
      () => api.listMessages('conversation-1', cursor: 'older', limit: 25),
    ).called(1);
  });

  test('mapuje snapshot rozmowy bez wystawiania modelu Retrofit', () async {
    final api = _MockChatApi();
    when(
      () => api.getConversation('conversation-1'),
    ).thenAnswer((_) async => _ChatRepositoryFixture.conversationResponse());
    final repository = ChatRepositoryImpl(api);

    final result = await repository.getConversation('conversation-1');

    final conversation = result.getOrElse(
      () => throw StateError('Oczekiwano poprawnego snapshotu rozmowy.'),
    );
    expect(conversation, isA<ChatConversation>());
    expect(conversation.scopeKind, 'workspace');
  });

  test(
    'rozwiązuje Channel Resource pliku workspace przez dokładny kontrakt backendu',
    () async {
      final api = _MockChatApi();
      when(() => api.resolve(any())).thenAnswer(
        (_) async => _ChatRepositoryFixture.conversationResponse(),
      );
      final repository = ChatRepositoryImpl(api) as ResourceChatRepository;

      final result = await repository.resolveFileConversation(
        _ChatRepositoryFixture.resourceFileRequest(),
      );

      expect(result.isRight(), isTrue);
      final captured =
          verify(() => api.resolve(captureAny())).captured.single
              as ResolveChatConversationPayload;
      expect(captured.type, ChatConversationType.channel);
      expect(captured.scopeKind, ChatScopeKind.resource);
      expect(captured.scopeProvider, 'files');
      expect(captured.scopeResourceType, 'file');
      expect(captured.scopeResourceId, '11111111-1111-4111-8111-111111111111');
      expect(
        captured.scopeKey,
        'resource:files:11111111111141118111111111111111',
      );
      expect(captured.workspaceId, '22222222-2222-4222-8222-222222222222');
      expect(captured.projectId, '33333333-3333-4333-8333-333333333333');
    },
  );

  test(
    'zachowuje null workspace i project dla prywatnego scope backendu',
    () async {
      final api = _MockChatApi();
      when(() => api.resolve(any())).thenAnswer(
        (_) async => _ChatRepositoryFixture.conversationResponse(),
      );
      final repository = ChatRepositoryImpl(api) as ResourceChatRepository;

      await repository.resolveFileConversation(
        _ChatRepositoryFixture.personalFileRequest(),
      );

      final captured =
          verify(() => api.resolve(captureAny())).captured.single
              as ResolveChatConversationPayload;
      expect(captured.type, ChatConversationType.channel);
      expect(captured.scopeKind, ChatScopeKind.resource);
      expect(captured.workspaceId, isNull);
      expect(captured.projectId, isNull);
      expect(
        captured.scopeKey,
        'resource:files:aaaaaaaaaaaa4aa18aaaaaaaaaaaaaaa',
      );
    },
  );

  test('mapuje sesję załączników i anuluje ją przez typed API', () async {
    final api = _MockChatApi();
    when(() => api.createAttachmentSession('conversation-1')).thenAnswer(
      (_) async => ChatTemporaryAttachmentSessionResponse(
        id: 'session-1',
        conversationId: 'conversation-1',
        expiresAtUtc: DateTime.utc(2026, 9, 14, 12),
      ),
    );
    when(
      () => api.cancelAttachmentSession('conversation-1', 'session-1'),
    ).thenAnswer((_) async {});
    final repository =
        ChatRepositoryImpl(api) as ChatAttachmentSessionRepository;

    final created = await repository.createAttachmentSession('conversation-1');
    expect(
      created.getOrElse(() => throw StateError('Brak sesji.')).id,
      'session-1',
    );
    final cancelled = await repository.cancelAttachmentSession(
      conversationId: 'conversation-1',
      sessionId: 'session-1',
    );

    expect(cancelled.isRight(), isTrue);
    verify(() => api.createAttachmentSession('conversation-1')).called(1);
    verify(
      () => api.cancelAttachmentSession('conversation-1', 'session-1'),
    ).called(1);
  });

  test(
    'przekazuje uporządkowane IDs i mapuje attachments wiadomości',
    () async {
      final api = _MockChatApi();
      when(() => api.sendMessage('conversation-1', any())).thenAnswer(
        (_) async => _ChatRepositoryFixture.messageResponse(
          attachments: [
            ChatAttachmentResponse(
              id: 'attachment-1',
              messageId: 'message-1',
              storageFileId: 'file-b',
              attachedByCoreUserId: 'user-1',
              position: 1,
              createdAtUtc: DateTime.utc(2026),
            ),
            ChatAttachmentResponse(
              id: 'attachment-2',
              messageId: 'message-1',
              storageFileId: 'file-a',
              attachedByCoreUserId: 'user-1',
              position: 0,
              createdAtUtc: DateTime.utc(2026),
            ),
          ],
        ),
      );
      final repository = ChatRepositoryImpl(api);

      final result = await repository.sendConversationMessage(
        const ChatSendMessageCommand(
          conversationId: 'conversation-1',
          clientMessageId: 'client-1',
          text: 'Treść',
          payloadHash: 'HASH',
          attachmentFileIds: ['file-a', 'file-b'],
        ),
      );

      final sent = result.getOrElse(() => throw StateError('Brak wiadomości.'));
      expect(sent.attachments.map((item) => item.storageFileId), [
        'file-b',
        'file-a',
      ]);
      final payload =
          verify(
                () => api.sendMessage('conversation-1', captureAny()),
              ).captured.single
              as SendChatMessagePayload;
      expect(payload.attachmentFileIds, ['file-a', 'file-b']);
    },
  );

  test(
    'mapuje edycję, rewizje i soft delete przez typowany kontrakt API',
    () async {
      final api = _MockChatApi();
      when(() => api.editMessage('message-1', any())).thenAnswer(
        (_) async => _ChatRepositoryFixture.messageResponse(),
      );
      when(() => api.listRevisions('message-1')).thenAnswer(
        (_) async => [
          ChatMessageRevisionResponse(
            id: 'revision-1',
            messageId: 'message-1',
            authorCoreUserId: 'author-1',
            editedByCoreUserId: 'editor-1',
            text: 'Wcześniejsza treść',
            createdAtUtc: DateTime.utc(2026),
            version: 1,
            newVersion: 2,
          ),
        ],
      );
      when(() => api.deleteMessage('message-1', 2)).thenAnswer((_) async {});
      final repository =
          ChatRepositoryImpl(api) as ChatMessageActionsRepository;

      final edited = await repository.editMessage(
        messageId: 'message-1',
        text: 'Zmieniona treść',
        deltaJson: '[{"insert":"Zmieniona treść"}]',
        version: 2,
      );
      final revisions = await repository.listRevisions('message-1');
      final deleted = await repository.deleteMessage(
        messageId: 'message-1',
        version: 2,
      );

      expect(
        edited.getOrElse(() => throw StateError('Brak edycji.')).id,
        'message-1',
      );
      expect(
        revisions
            .getOrElse(() => throw StateError('Brak rewizji.'))
            .single
            .newVersion,
        2,
      );
      expect(deleted.isRight(), isTrue);
      final payload =
          verify(() => api.editMessage('message-1', captureAny()))
                  .captured
                  .single
              as UpdateChatMessagePayload;
      expect(payload.version, 2);
      expect(payload.deltaJson, '[{"insert":"Zmieniona treść"}]');
      verify(() => api.deleteMessage('message-1', 2)).called(1);
    },
  );
}

/// Buduje pełne DTO kontraktu backendu bez kopiowania go do warstwy UI.
abstract final class _ChatRepositoryFixture {
  static ResourceChatFileRequest resourceFileRequest() =>
      const ResourceChatFileRequest(
        fileId: '11111111-1111-4111-8111-111111111111',
        workspaceId: '22222222-2222-4222-8222-222222222222',
        projectId: '33333333-3333-4333-8333-333333333333',
        fileContext: ResourceChatFileContext(
          fileId: '11111111-1111-4111-8111-111111111111',
          fileName: 'Projekt.pdf',
          ownerUserId: 'owner-1',
          accessLevel: 'reader',
        ),
      );

  static ResourceChatFileRequest personalFileRequest() =>
      const ResourceChatFileRequest(
        fileId: 'aaaaaaaa-aaaa-4aa1-8aaa-aaaaaaaaaaaa',
        workspaceId: null,
        projectId: null,
        fileContext: ResourceChatFileContext(
          fileId: 'aaaaaaaa-aaaa-4aa1-8aaa-aaaaaaaaaaaa',
          fileName: 'Osobisty.pdf',
          ownerUserId: 'owner-1',
          accessLevel: 'reader',
        ),
      );

  static ResolveChatConversationPayload resolvePayload() =>
      const ResolveChatConversationPayload(
        type: ChatConversationType.discussion,
        scopeKind: ChatScopeKind.resource,
        scopeKey: 'files:fallback',
      );

  /// Tworzy odpowiedź rozmowy zgodną z wygenerowanym kontraktem transportowym.
  static ChatConversationResponse conversationResponse() =>
      ChatConversationResponse(
        id: 'conversation-1',
        type: ChatConversationType.channel,
        scopeKind: ChatScopeKind.workspace,
        scopeKey: 'workspace:demo',
        version: 1,
        createdAtUtc: DateTime.utc(2026),
      );

  /// Tworzy odpowiedź wiadomości zgodną z wygenerowanym kontraktem transportowym.
  static ChatMessageResponse messageResponse({
    List<ChatAttachmentResponse>? attachments,
  }) => ChatMessageResponse(
    id: 'message-1',
    conversationId: 'conversation-1',
    authorCoreUserId: 'user-1',
    clientMessageId: 'client-1',
    text: 'Treść',
    payloadHash: 'HASH',
    version: 1,
    createdAtUtc: DateTime.utc(2026),
    isDeleted: false,
    attachments: attachments,
  );
}
