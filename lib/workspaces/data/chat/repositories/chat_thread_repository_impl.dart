import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_conversation_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_attachment.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_page.dart';
import 'package:devplanner/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:dio/dio.dart';

/// Implementacja portów wątku i dyskusji na kontrakcie backendu.
///
/// Wątek czyta tę samą historię z filtrem root-a, a dyskusja używa
/// `resolve` z typem `Discussion`, więc UI nie buduje transportowego payloadu.
final class ChatThreadRepositoryImpl
    implements ChatThreadRepository, ChatDiscussionRepository {
  /// Tworzy adapter na uwierzytelnionym kliencie Chat.
  ChatThreadRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, ChatMessagePage>> listThreadMessages({
    required String conversationId,
    required String threadRootMessageId,
    String? cursor,
    int limit = 50,
  }) => _guard(
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
    code: ChatApiErrorCode.loadMessages,
  );

  @override
  Future<Either<ApiError, ChatConversation>> resolveDiscussion({
    required ChatConversation parentConversation,
    required String rootMessageId,
    required String name,
  }) => _guard(
    () async => ChatConversationMapper.toDomain(
      await _api.resolve(
        ResolveChatConversationPayload(
          type: ChatConversationType.discussion,
          scopeKind: ChatScopeKind.global,
          scopeKey: 'discussion:$rootMessageId',
          name: name,
          discussionRootMessageId: rootMessageId,
        ),
      ),
    ),
    code: ChatApiErrorCode.loadConversations,
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
