import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_conversation_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:dio/dio.dart';

/// Implementacja portu serwerowej skrzynki Chat.
///
/// Adapter mapuje wyłącznie kontrakt backendu na modele domenowe: licznik
/// nieprzeczytanych, znacznik odczytu i podgląd pochodzą z serwera, więc panel
/// nie musi pobierać historii, aby policzyć badge.
final class ChatInboxRepositoryImpl implements ChatInboxRepository {
  /// Tworzy adapter na uwierzytelnionym kliencie Chat.
  ChatInboxRepositoryImpl(this._api, {this.defaultLimit = 30});

  final ChatApi _api;

  /// Domyślny rozmiar strony skrzynki używany, gdy UI go nie poda.
  final int defaultLimit;

  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, ChatInboxPage>> loadInbox({
    ChatInboxFilter filter = ChatInboxFilter.all,
    String? cursor,
    int? limit,
  }) => _guard(
    () async {
      final page = await _api.loadInbox(
        cursor: cursor,
        limit: limit ?? defaultLimit,
        filter: filter.wireValue,
      );
      return ChatInboxPage(
        items: page.items.map(_toItem).toList(growable: false),
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
      );
    },
    code: ChatApiErrorCode.loadInbox,
  );

  @override
  Future<Either<ApiError, ChatInboxUnreadCount>> loadUnreadCount() => _guard(
    () async {
      final response = await _api.loadInboxUnreadCount();
      return ChatInboxUnreadCount(
        totalUnreadCount: response.totalUnreadCount,
        unreadConversationCount: response.unreadConversationCount,
        generatedAtUtc: response.generatedAtUtc,
      );
    },
    code: ChatApiErrorCode.loadInboxUnreadCount,
  );

  @override
  Future<Either<ApiError, void>> markRead({
    required String conversationId,
    required String messageId,
  }) => _guard(
    () => _api.markRead(conversationId, messageId),
    code: ChatApiErrorCode.markConversationRead,
  );

  ChatInboxItem _toItem(ChatInboxItemResponse response) => ChatInboxItem(
    conversation: ChatConversationMapper.toDomain(response.conversation),
    lastMessage: _toPreview(response.lastMessage),
    lastActivityAtUtc: response.lastActivityAtUtc,
    unreadCount: response.unreadCount,
    lastReadMessageId: response.lastReadMessageId,
    isMuted: response.isMuted,
    isDraft: response.isDraft,
    draftText: response.draftText,
    role: response.role,
    participants: response.participants
        .map(_toParticipant)
        .toList(growable: false),
    participantCount: response.participantCount,
  );

  ChatInboxMessagePreview? _toPreview(
    ChatInboxMessagePreviewResponse? response,
  ) => response == null
      ? null
      : ChatInboxMessagePreview(
          messageId: response.messageId,
          authorUserId: response.authorUserId,
          text: response.text,
          isDeleted: response.isDeleted,
          hasAttachments: response.hasAttachments,
          threadRootMessageId: response.threadRootMessageId,
          createdAtUtc: response.createdAtUtc,
        );

  ChatInboxParticipant _toParticipant(ChatInboxParticipantResponse response) =>
      ChatInboxParticipant(
        userId: response.userId,
        login: response.login,
        displayName: response.displayName,
        avatarUrl: response.avatarUrl,
        isCurrentUser: response.isCurrentUser,
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
