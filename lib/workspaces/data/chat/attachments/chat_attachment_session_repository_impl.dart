import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/domain/chat/attachments/models/chat_attachment_session.dart';
import 'package:devplanner/workspaces/domain/chat/attachments/ports/chat_attachment_session_repository.dart';
import 'package:dio/dio.dart';

/// Implementacja portu prywatnych sesji uploadu załączników Chat.
///
/// Adapter nie przechowuje ani nie zwraca ticketów, URL-i presigned ani
/// tokenów Storage — trzyma je wyłącznie warstwa data, która wykonuje upload.
final class ChatAttachmentSessionRepositoryImpl
    implements ChatAttachmentSessionRepository {
  /// Tworzy adapter na uwierzytelnionym kliencie Chat.
  ChatAttachmentSessionRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, ChatAttachmentSession>> createAttachmentSession(
    String conversationId,
  ) => _guard(
    () async {
      final response = await _api.createAttachmentSession(conversationId);
      return ChatAttachmentSession(
        id: response.id,
        conversationId: response.conversationId,
        expiresAtUtc: response.expiresAtUtc,
      );
    },
    code: ChatApiErrorCode.createAttachmentSession,
  );

  @override
  Future<Either<ApiError, void>> cancelAttachmentSession({
    required String conversationId,
    required String sessionId,
  }) => _guard(
    () => _api.cancelAttachmentSession(conversationId, sessionId),
    code: ChatApiErrorCode.createAttachmentSession,
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
