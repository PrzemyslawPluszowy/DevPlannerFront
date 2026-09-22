import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:dio/dio.dart';

/// Implementacja portu wyszukiwania wiadomości Chat.
final class ChatSearchRepositoryImpl implements ChatSearchRepository {
  /// Tworzy adapter na uwierzytelnionym kliencie Chat.
  ChatSearchRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, ChatSearchPage>> searchMessages(
    ChatSearchQuery query,
  ) => _guard(
    () async {
      final response = await _api.search(
        query: query.term,
        conversationId: query.conversationId,
        senderId: query.senderId,
        workspaceId: query.workspaceId,
        projectId: query.projectId,
        fromUtc: query.fromUtc,
        toUtc: query.toUtc,
        mentionedUserId: query.mentionedUserId,
        limit: query.limit,
        cursor: query.cursor,
      );
      return ChatSearchPage(
        hits: response.items.map(_toHit).toList(growable: false),
        nextCursor: response.nextCursor,
        totalApproximate: response.totalApproximate,
      );
    },
    code: ChatApiErrorCode.searchMessages,
  );

  @override
  Future<Either<ApiError, ChatSearchFacets>> loadFacets({
    required String term,
    String? conversationId,
  }) => _guard(
    () async {
      final response = await _api.searchFacets(
        query: term,
        conversationId: conversationId,
      );
      return ChatSearchFacets(
        total: response.total,
        conversations: response.conversations
            .map(_toBucket)
            .toList(
              growable: false,
            ),
        senders: response.senders.map(_toBucket).toList(growable: false),
        workspaces: response.workspaces.map(_toBucket).toList(growable: false),
        projects: response.projects.map(_toBucket).toList(growable: false),
      );
    },
    code: ChatApiErrorCode.searchMessages,
  );

  @override
  Future<Either<ApiError, List<ChatMentionSuggestion>>> suggestMentions({
    required String conversationId,
    required String term,
  }) => _guard(
    () async => (await _api.mentionSuggestions(
      conversationId,
      term,
    )).map(_toSuggestion).toList(growable: false),
    code: ChatApiErrorCode.searchMessages,
  );

  static ChatSearchHit _toHit(ChatSearchItemResponse response) => ChatSearchHit(
    messageId: response.messageId,
    conversationId: response.conversationId,
    authorUserId: response.authorUserId,
    text: response.text,
    highlight: response.highlight,
    conversationName: response.conversationName,
    createdAtUtc: response.createdAtUtc,
    hasMention: response.hasMention,
  );

  static ChatSearchFacetBucket _toBucket(
    ChatSearchFacetBucketResponse response,
  ) => ChatSearchFacetBucket(
    id: response.id,
    label: response.label,
    count: response.count,
  );

  static ChatMentionSuggestion _toSuggestion(
    ChatMentionSuggestionResponse response,
  ) => ChatMentionSuggestion(
    userId: response.userId,
    login: response.login,
    displayName: response.displayName,
    avatarUrl: response.avatarUrl,
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
