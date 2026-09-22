import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:dio/dio.dart';

/// Implementacja portu członkostwa rozmowy Chat.
final class ChatMembersRepositoryImpl implements ChatMembersRepository {
  /// Tworzy adapter na uwzględnionym kliencie Chat.
  ChatMembersRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, List<ChatMember>>> listMembers(
    String conversationId,
  ) => _guard(
    () async =>
        (await _api.listMembers(conversationId))
            .map(_toMember)
            .toList(growable: false),
    code: ChatApiErrorCode.loadMembers,
  );

  @override
  Future<Either<ApiError, List<ChatMember>>> addMembers({
    required String conversationId,
    required List<String> userIds,
  }) => _guard(
    () async => (await _api.addMembers(
      conversationId,
      AddChatMembersPayload(userIds: userIds),
    )).map(_toMember).toList(growable: false),
    code: ChatApiErrorCode.changeMembers,
  );

  @override
  Future<Either<ApiError, ChatMember>> updateMemberRole({
    required String conversationId,
    required String targetUserId,
    required ChatMemberRole role,
  }) => _guard(
    () async => _toMember(
      await _api.updateMemberRole(
        conversationId,
        targetUserId,
        UpdateChatMemberRolePayload(role: role.wireValue),
      ),
    ),
    code: ChatApiErrorCode.changeMembers,
  );

  @override
  Future<Either<ApiError, void>> removeMember({
    required String conversationId,
    required String targetUserId,
  }) => _guard(
    () => _api.removeMember(conversationId, targetUserId),
    code: ChatApiErrorCode.changeMembers,
  );

  static ChatMember _toMember(ChatMemberResponse response) => ChatMember(
    userId: response.userId,
    role: ChatMemberRole.fromWire(response.role),
    joinedAtUtc: response.joinedAtUtc,
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
