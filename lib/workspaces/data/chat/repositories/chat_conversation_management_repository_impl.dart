import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_conversation_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:dio/dio.dart';

/// Implementacja portu zarządzania rozmowami Chat.
///
/// Adapter mapuje wyłącznie kontrakt backendu na model domenowy. Idempotencję
/// tworzenia rozmowy 1:1 egzekwuje backend, więc adapter nie próbuje jej
/// powtarzać po stronie klienta.
final class ChatConversationManagementRepositoryImpl
    implements ChatConversationManagementRepository {
  /// Tworzy adapter na uwierzytelnionym kliencie Chat.
  ChatConversationManagementRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, ChatConversation>> createConversation(
    ChatConversationCreateCommand command,
  ) => _guard(
    () async => ChatConversationMapper.toDomain(
      await _api.resolve(
        ResolveChatConversationPayload(
          type: _toType(command.kind),
          scopeKind: _toScope(command.scope),
          scopeKey: command.scopeKey,
          name: command.name,
          userIds: command.userIds.isEmpty ? null : command.userIds,
          workspaceId: command.workspaceId,
          projectId: command.projectId,
          discussionRootMessageId: command.discussionRootMessageId,
          postingPermission: command.postingPermission,
        ),
      ),
    ),
    code: ChatApiErrorCode.manageConversation,
  );

  @override
  Future<Either<ApiError, ChatConversation>> updateDetails({
    required String conversationId,
    required String? name,
    required String postingPermission,
  }) => _guard(
    () async => ChatConversationMapper.toDomain(
      await _api.updateConversation(
        conversationId,
        UpdateChatConversationPayload(
          name: name,
          postingPermission: postingPermission,
        ),
      ),
    ),
    code: ChatApiErrorCode.manageConversation,
  );

  @override
  Future<Either<ApiError, void>> archiveConversation(
    String conversationId,
  ) => _guard(
    () => _api.archiveConversation(conversationId),
    code: ChatApiErrorCode.manageConversation,
  );

  @override
  Future<Either<ApiError, void>> restoreConversation(
    String conversationId,
  ) => _guard(
    () => _api.restoreConversation(conversationId),
    code: ChatApiErrorCode.manageConversation,
  );

  @override
  Future<Either<ApiError, void>> leaveConversation(String conversationId) =>
      _guard(
        () => _api.leaveConversation(conversationId),
        code: ChatApiErrorCode.manageConversation,
      );

  @override
  Future<Either<ApiError, List<ChatConversation>>>
  listArchivedConversations() => _guard(
    () async => (await _api.listArchivedConversations())
        .map(ChatConversationMapper.toDomain)
        .toList(growable: false),
    code: ChatApiErrorCode.manageConversation,
  );

  static ChatConversationType _toType(ChatConversationKind kind) =>
      switch (kind) {
        ChatConversationKind.direct => ChatConversationType.direct,
        ChatConversationKind.group => ChatConversationType.group,
        ChatConversationKind.channel => ChatConversationType.channel,
        ChatConversationKind.broadcast => ChatConversationType.broadcast,
      };

  static ChatScopeKind _toScope(ChatConversationScope scope) => switch (scope) {
    ChatConversationScope.global => ChatScopeKind.global,
    ChatConversationScope.workspace => ChatScopeKind.workspace,
    ChatConversationScope.project => ChatScopeKind.project,
  };

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
