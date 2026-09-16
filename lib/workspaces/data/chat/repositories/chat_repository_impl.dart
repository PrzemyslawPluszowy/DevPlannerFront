import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/chat/api/chat_api.dart';
import 'package:ready_next/workspaces/data/chat/models/chat_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/chat_enums.dart';
import 'package:ready_next/workspaces/domain/chat/attachments/chat_attachments_export.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:ready_next/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:ready_next/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:ready_next/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/chat_repository.dart';

/// Implementacja odczytu rozmów Chat dla globalnego overlay.
class ChatRepositoryImpl extends ApiRepository
    implements
        ChatRepository,
        ChatConversationRepository,
        ResourceChatRepository,
        ChatThreadRepository,
        ChatDiscussionRepository,
        ChatAttachmentSessionRepository,
        ChatMessageActionsRepository {
  /// Tworzy repozytorium na uwierzytelnionym kliencie Workspaces.
  ChatRepositoryImpl(ChatApi api) : _api = api;

  final ChatApi _api;

  @override
  Future<Either<ApiError, ChatConversation>> resolveFileConversation(
    ResourceChatFileRequest request,
  ) => guardApiCall(
    () async => _toConversation(
      await _api.resolve(
        ResolveChatConversationPayload(
          type: ChatConversationType.channel,
          scopeKind: ChatScopeKind.resource,
          scopeKey: request.canonicalScopeKey,
          workspaceId: request.workspaceId,
          projectId: request.projectId,
          scopeProvider: 'files',
          scopeResourceType: 'file',
          scopeResourceId: request.fileId,
        ),
      ),
    ),
    fallbackMessage: 'Nie udało się otworzyć czatu pliku.',
    parsingMessage: 'Backend zwrócił nieprawidłową rozmowę pliku.',
  );

  @override
  Future<Either<ApiError, List<ChatConversationResponse>>>
  listConversations() async => guardApiCall(
    _api.listConversations,
    fallbackMessage: 'Nie udało się pobrać rozmów Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę rozmów Chat.',
  );

  @override
  Future<Either<ApiError, List<ChatMessageResponse>>> listMessages(
    String conversationId,
  ) async => guardApiCall(
    () async => (await _api.listMessages(conversationId, limit: 100)).items,
    fallbackMessage: 'Nie udało się pobrać wiadomości Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową historię rozmowy.',
  );

  @override
  Future<Either<ApiError, ChatMessageResponse>> sendMessage({
    required String conversationId,
    required String clientMessageId,
    required String text,
  }) async => guardApiCall(
    () => _api.sendMessage(
      conversationId,
      SendChatMessagePayload(
        clientMessageId: clientMessageId,
        text: text,
      ),
    ),
    fallbackMessage: 'Nie udało się wysłać wiadomości Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową wiadomość.',
  );

  @override
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  ) async => guardApiCall(
    () async => _toConversation(await _api.getConversation(conversationId)),
    fallbackMessage: 'Nie udało się pobrać rozmowy Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową rozmowę Chat.',
  );

  @override
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  }) async => guardApiCall(
    () async {
      final page = await _api.listMessages(
        conversationId,
        cursor: cursor,
        limit: limit,
      );
      return ChatMessagePage(
        items: page.items.map(_toMessage).toList(growable: false),
        nextCursor: page.nextCursor,
      );
    },
    fallbackMessage: 'Nie udało się pobrać wiadomości Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową historię rozmowy.',
  );

  @override
  Future<Either<ApiError, ChatMessagePage>> listThreadMessages({
    required String conversationId,
    required String threadRootMessageId,
    String? cursor,
    int limit = 50,
  }) async => guardApiCall(
    () async {
      final page = await _api.listThreadMessages(
        conversationId,
        threadRootMessageId,
        cursor: cursor,
        limit: limit,
      );
      return ChatMessagePage(
        items: page.items.map(_toMessage).toList(growable: false),
        nextCursor: page.nextCursor,
      );
    },
    fallbackMessage: 'Nie udało się pobrać wątku Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłowy wątek Chat.',
  );

  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) async => guardApiCall(
    () async => _toMessage(
      await _api.sendMessage(
        command.conversationId,
        SendChatMessagePayload(
          clientMessageId: command.clientMessageId,
          text: command.text,
          deltaJson: command.deltaJson,
          replyToMessageId: command.replyToMessageId,
          attachmentFileIds: command.attachmentFileIds,
        ),
      ),
    ),
    fallbackMessage: 'Nie udało się wysłać wiadomości Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową wiadomość Chat.',
  );

  @override
  Future<Either<ApiError, ChatMessage>> editMessage({
    required String messageId,
    required String text,
    required String? deltaJson,
    required int version,
  }) => guardApiCall(
    () async => _toMessage(
      await _api.editMessage(
        messageId,
        UpdateChatMessagePayload(
          text: text,
          deltaJson: deltaJson,
          version: version,
        ),
      ),
    ),
    fallbackMessage: 'Nie udało się edytować wiadomości Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową wiadomość Chat.',
  );

  @override
  Future<Either<ApiError, void>> deleteMessage({
    required String messageId,
    required int version,
  }) => guardApiCall(
    () => _api.deleteMessage(messageId, version),
    fallbackMessage: 'Nie udało się usunąć wiadomości Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź usunięcia Chat.',
  );

  @override
  Future<Either<ApiError, List<ChatMessageRevision>>> listRevisions(
    String messageId,
  ) => guardApiCall(
    () async => (await _api.listRevisions(messageId))
        .map(
          (revision) => ChatMessageRevision(
            id: revision.id,
            messageId: revision.messageId,
            authorCoreUserId: revision.authorCoreUserId,
            editedByCoreUserId: revision.editedByCoreUserId,
            text: revision.text,
            deltaJson: revision.deltaJson,
            createdAtUtc: revision.createdAtUtc,
            version: revision.version,
            newVersion: revision.newVersion,
          ),
        )
        .toList(growable: false),
    fallbackMessage: 'Nie udało się pobrać historii edycji Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową historię edycji Chat.',
  );

  @override
  Future<Either<ApiError, ChatAttachmentSession>> createAttachmentSession(
    String conversationId,
  ) => guardApiCall(
    () async {
      final response = await _api.createAttachmentSession(conversationId);
      return ChatAttachmentSession(
        id: response.id,
        conversationId: response.conversationId,
        expiresAtUtc: response.expiresAtUtc,
      );
    },
    fallbackMessage: 'Nie udało się utworzyć sesji załączników Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową sesję załączników Chat.',
  );

  @override
  Future<Either<ApiError, void>> cancelAttachmentSession({
    required String conversationId,
    required String sessionId,
  }) => guardApiCall(
    () => _api.cancelAttachmentSession(conversationId, sessionId),
    fallbackMessage: 'Nie udało się anulować sesji załączników Chat.',
    parsingMessage:
        'Backend zwrócił nieprawidłową odpowiedź sesji załączników Chat.',
  );

  @override
  Future<Either<ApiError, ChatConversation>> resolveDiscussion({
    required ChatConversation parentConversation,
    required String rootMessageId,
    required String name,
  }) => guardApiCall(
    () async => _toConversation(
      await _api.resolve(
        ResolveChatConversationPayload(
          type: ChatConversationType.discussion,
          scopeKind: _scopeKindFrom(parentConversation.scopeKind),
          scopeKey: parentConversation.scopeKey,
          workspaceId: parentConversation.workspaceId,
          projectId: parentConversation.projectId,
          name: name,
          discussionRootMessageId: rootMessageId,
        ),
      ),
    ),
    fallbackMessage: 'Nie udało się otworzyć dyskusji Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłową dyskusję Chat.',
  );

  ChatScopeKind _scopeKindFrom(String value) => switch (value) {
    'global' => ChatScopeKind.global,
    'workspace' => ChatScopeKind.workspace,
    'project' => ChatScopeKind.project,
    'resource' => ChatScopeKind.resource,
    _ => throw FormatException('Nieznany scope rozmowy Chat: $value'),
  };

  ChatConversation _toConversation(ChatConversationResponse response) =>
      ChatConversation(
        id: response.id,
        type: response.type.name,
        scopeKind: response.scopeKind.name,
        scopeKey: response.scopeKey,
        workspaceId: response.workspaceId,
        projectId: response.projectId,
        name: response.name,
        discussionRootMessageId: response.discussionRootMessageId,
        version: response.version,
        createdAtUtc: response.createdAtUtc,
        postingPermission: response.postingPermission,
        isArchived: response.isArchived,
      );

  ChatMessage _toMessage(ChatMessageResponse response) => ChatMessage(
    id: response.id,
    conversationId: response.conversationId,
    authorCoreUserId: response.authorCoreUserId,
    clientMessageId: response.clientMessageId,
    text: response.text,
    deltaJson: response.deltaJson,
    replyToMessageId: response.replyToMessageId,
    payloadHash: response.payloadHash,
    version: response.version,
    createdAtUtc: response.createdAtUtc,
    isDeleted: response.isDeleted,
    threadRootMessageId: response.threadRootMessageId,
    isEdited: response.isEdited,
    deletedAtUtc: response.deletedAtUtc,
    attachments:
        response.attachments
            ?.map(
              (attachment) => ChatMessageAttachment(
                id: attachment.id,
                messageId: attachment.messageId,
                storageFileId: attachment.storageFileId,
                attachedByCoreUserId: attachment.attachedByCoreUserId,
                position: attachment.position,
                createdAtUtc: attachment.createdAtUtc,
              ),
            )
            .toList(growable: false) ??
        const <ChatMessageAttachment>[],
    deliveryState: ChatMessageDeliveryState.sent,
  );
}
