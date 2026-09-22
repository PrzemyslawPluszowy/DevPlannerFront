import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:dio/dio.dart';

/// Implementacja portu obecności opartej o REST.
///
/// Adapter zwraca `null` bez błędu, gdy backend nie ma aktywnego statusu, żeby
/// UI nie pokazywało wygasłego statusu jako aktualnego.
final class ChatPresenceRepositoryImpl implements ChatPresenceRepository {
  /// Tworzy adapter na uwierzytelnionym kliencie Chat.
  ChatPresenceRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, ChatUserStatus?>> getUserStatus(String userId) =>
      _guard(
        () async {
          final response = await _api.getUserStatus(userId);
          return response == null ? null : _toStatus(response);
        },
        code: ChatApiErrorCode.loadUserStatus,
      );

  @override
  Future<Either<ApiError, ChatUserStatus>> setOwnStatus(
    ChatUserStatusUpdate update,
  ) => _guard(
    () async => _toStatus(
      await _api.upsertStatus(
        UpsertChatUserStatusPayload(
          emoji: update.emoji,
          text: update.text,
          expiresAtUtc: update.expiresAtUtc,
          isDnd: update.isDnd,
        ),
      ),
    ),
    code: ChatApiErrorCode.updateOwnStatus,
  );

  @override
  Future<Either<ApiError, void>> clearOwnStatus() => _guard(
    _api.clearStatus,
    code: ChatApiErrorCode.updateOwnStatus,
  );

  static ChatUserStatus _toStatus(ChatUserStatusResponse response) =>
      ChatUserStatus(
        userId: response.userId,
        emoji: response.emoji,
        text: response.text,
        expiresAtUtc: response.expiresAtUtc,
        isDnd: response.isDnd,
        updatedAtUtc: response.updatedAtUtc,
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
