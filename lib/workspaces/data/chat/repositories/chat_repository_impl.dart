import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:dio/dio.dart';

/// Implementacja portów listy, historii i rozmowy zasobu globalnego Chatu.
///
/// Mapuje wyłącznie odpowiedzi kontraktu backendu do małych modeli domenowych.
/// Rozszerzenia (wątki, rewizje, placementy i realtime) pozostają osobnymi
/// pionami, bez wprowadzania zależności transportu do UI.
final class ChatRepositoryImpl
    implements
        ChatRepository,
        ChatConversationRepository,
        ResourceChatRepository {
  /// Tworzy repozytorium na uwierzytelnionym kliencie Chat.
  ChatRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, List<ChatConversationResponse>>>
  listConversations() => _guard(
    _api.listConversations,
    code: ChatApiErrorCode.loadConversations,
  );

  @override
  Future<Either<ApiError, List<ChatMessageResponse>>> listMessages(
    String conversationId,
  ) => _guard(
    () async => (await _api.listMessages(conversationId, limit: 100)).items,
    code: ChatApiErrorCode.loadMessages,
  );

  @override
  Future<Either<ApiError, ChatMessageResponse>> sendMessage({
    required String conversationId,
    required String clientMessageId,
    required String text,
  }) => _guard(
    () => _api.sendMessage(
      conversationId,
      SendChatMessagePayload(
        clientMessageId: clientMessageId,
        text: text,
      ),
    ),
    code: ChatApiErrorCode.sendMessage,
  );

  @override
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  ) => _guard(
    () async => _toConversation(await _api.getConversation(conversationId)),
    code: ChatApiErrorCode.loadConversations,
  );

  @override
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  }) => _guard(
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
    code: ChatApiErrorCode.loadMessages,
  );

  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) => _guard(
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
    code: ChatApiErrorCode.sendMessage,
  );

  @override
  Future<Either<ApiError, ChatConversation>> resolveFileConversation(
    ResourceChatFileRequest request,
  ) => _guard(
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
    code: ChatApiErrorCode.loadConversations,
  );

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
    authorUserId: response.authorUserId,
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
    deliveryState: ChatMessageDeliveryState.sent,
    attachments:
        response.attachments
            ?.map(
              (attachment) => ChatMessageAttachment(
                id: attachment.id,
                messageId: attachment.messageId,
                storageFileId: attachment.storageFileId,
                attachedByUserId: attachment.attachedByUserId,
                position: attachment.position,
                createdAtUtc: attachment.createdAtUtc,
              ),
            )
            .toList(growable: false) ??
        const <ChatMessageAttachment>[],
  );

  Future<Either<ApiError, T>> _guard<T>(
    Future<T> Function() call, {
    required ChatApiErrorCode code,
  }) async {
    try {
      return Right(await call());
    } on DioException catch (error) {
      return Left(_errorMapper.fromDioException(error, code: code));
    } on Object {
      return Left(_errorMapper.fromParsing(code: code));
    }
  }
}
