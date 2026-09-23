import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/snippets/chat_snippet_repository.dart';
import 'package:dio/dio.dart';

/// Implementacja portu przygotowania snippet-u na kliencie Chat.
///
/// Adapter nie wysyła pliku: zwraca przygotowaną treść wraz z informacją o
/// skróceniu, a decyzję o publikacji TXT podejmuje użytkownik w composerze.
final class ChatSnippetRepositoryImpl implements ChatSnippetRepository {
  /// Tworzy adapter na uwierzytelnionym kliencie Chat.
  ChatSnippetRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, ChatSnippetPreparation>> prepare({
    required String conversationId,
    required String text,
    bool force = false,
  }) => _guard(
    () async => _toPreparation(
      await _api.prepareSnippet(
        conversationId,
        ChatSnippetPayload(text: text, force: force),
      ),
    ),
    code: ChatApiErrorCode.prepareSnippet,
  );

  static ChatSnippetPreparation _toPreparation(ChatSnippetResponse response) =>
      ChatSnippetPreparation(
        isSnippet: response.isSnippet,
        originalLength: response.originalLength,
        content: response.content,
        isTruncated: response.isTruncated,
        suggestedFileName: response.suggestedFileName,
        mimeType: response.mimeType,
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
