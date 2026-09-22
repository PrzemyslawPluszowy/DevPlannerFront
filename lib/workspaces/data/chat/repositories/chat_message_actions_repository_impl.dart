import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_attachment.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_action_models.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_revision.dart';
import 'package:dio/dio.dart';

/// Implementacja portu akcji na wiadomości Chat.
///
/// Adapter nie ukrywa konfliktów wersji ani odmowy dostępu: każdy błąd wraca
/// jako typowany [ApiError] z zachowanym statusem i `traceId`, więc UI może
/// pokazać realny powód zamiast pozornego sukcesu.
final class ChatMessageActionsRepositoryImpl
    implements ChatMessageActionsRepository {
  /// Tworzy adapter na uwierzytelnionym kliencie Chat.
  ChatMessageActionsRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, ChatMessage>> editMessage({
    required String messageId,
    required String text,
    required String? deltaJson,
    required int version,
  }) => _guard(
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
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, void>> deleteMessage({
    required String messageId,
    required int version,
  }) => _guard(
    () => _api.deleteMessage(messageId, version),
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, List<ChatMessageRevision>>> listRevisions(
    String messageId,
  ) => _guard(
    () async =>
        (await _api.listRevisions(messageId))
            .map(_toRevision)
            .toList(growable: false),
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, ChatMessage>> forwardMessage({
    required String messageId,
    required String targetConversationId,
    required String clientMessageId,
  }) => _guard(
    () async => _toMessage(
      await _api.forwardMessage(
        messageId,
        ForwardChatMessagePayload(
          targetConversationId: targetConversationId,
          clientMessageId: clientMessageId,
        ),
      ),
    ),
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, ChatPinnedMessage>> pinMessage({
    required String conversationId,
    required String messageId,
  }) => _guard(
    () async => _toPin(await _api.pinMessage(conversationId, messageId)),
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, void>> unpinMessage({
    required String conversationId,
    required String messageId,
  }) => _guard(
    () => _api.unpinMessage(conversationId, messageId),
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, List<ChatPinnedMessage>>> listPins(
    String conversationId,
  ) => _guard(
    () async =>
        (await _api.listPins(conversationId))
            .map(_toPin)
            .toList(growable: false),
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, ChatBookmark>> bookmarkMessage({
    required String messageId,
    String? note,
  }) => _guard(
    () async => _toBookmark(
      await _api.bookmark(messageId, ChatBookmarkPayload(note: note)),
    ),
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, void>> removeBookmark(String messageId) => _guard(
    () => _api.removeBookmark(messageId),
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, List<ChatBookmark>>> listBookmarks() => _guard(
    () async =>
        (await _api.listBookmarks()).map(_toBookmark).toList(growable: false),
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, ChatMessageReaction>> addReaction({
    required String messageId,
    required String emoji,
  }) => _guard(
    () async => _toReaction(
      await _api.addReaction(messageId, AddChatReactionPayload(emoji: emoji)),
    ),
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, void>> removeReaction({
    required String messageId,
    required String emoji,
  }) => _guard(
    () => _api.removeReaction(messageId, emoji),
    code: ChatApiErrorCode.actOnMessage,
  );

  @override
  Future<Either<ApiError, List<ChatMessageReaction>>> listReactions(
    String messageId,
  ) => _guard(
    () async =>
        (await _api.listReactions(messageId))
            .map(_toReaction)
            .toList(growable: false),
    code: ChatApiErrorCode.actOnMessage,
  );

  static ChatMessageRevision _toRevision(
    ChatMessageRevisionResponse response,
  ) => ChatMessageRevision(
    id: response.id,
    messageId: response.messageId,
    authorUserId: response.authorUserId,
    editedByUserId: response.editedByUserId,
    text: response.text,
    deltaJson: response.deltaJson,
    createdAtUtc: response.createdAtUtc,
    version: response.version,
    newVersion: response.newVersion,
  );

  static ChatPinnedMessage _toPin(ChatPinnedMessageResponse response) =>
      ChatPinnedMessage(
        id: response.id,
        conversationId: response.conversationId,
        messageId: response.messageId,
        pinnedByUserId: response.pinnedByUserId,
        pinnedAtUtc: response.pinnedAtUtc,
      );

  static ChatBookmark _toBookmark(ChatBookmarkResponse response) =>
      ChatBookmark(
        id: response.id,
        messageId: response.messageId,
        conversationId: response.conversationId,
        userId: response.userId,
        note: response.note,
        createdAtUtc: response.createdAtUtc,
      );

  static ChatMessageReaction _toReaction(ChatReactionResponse response) =>
      ChatMessageReaction(
        id: response.id,
        messageId: response.messageId,
        userId: response.userId,
        emoji: response.emoji,
        createdAtUtc: response.createdAtUtc,
      );

  static ChatMessage _toMessage(ChatMessageResponse response) => ChatMessage(
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
