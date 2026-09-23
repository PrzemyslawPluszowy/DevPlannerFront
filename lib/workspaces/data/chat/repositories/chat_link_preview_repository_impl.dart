import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_link_preview.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_link_preview_repository.dart';
import 'package:dio/dio.dart';

/// Adapter dla sanitizowanego podglądu URL wykonywanego przez backend.
final class ChatLinkPreviewRepositoryImpl implements ChatLinkPreviewRepository {
  /// Tworzy adapter na sesyjnym kliencie API Chat.
  ChatLinkPreviewRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, ChatLinkPreview>> loadPreview({
    required String conversationId,
    required String url,
  }) async {
    try {
      final response = await _api.previewLink(conversationId, url);
      return Right(
        ChatLinkPreview(
          finalUrl: response.finalUrl,
          title: response.title,
          description: response.description,
          contentType: response.contentType,
          fetchedAtUtc: response.fetchedAtUtc,
        ),
      );
    } on DioException catch (error) {
      return Left(
        _errorMapper.fromDioException(
          error,
          code: ChatApiErrorCode.loadLinkPreview,
        ),
      );
    } on Object {
      return Left(
        _errorMapper.fromParsing(code: ChatApiErrorCode.loadLinkPreview),
      );
    }
  }
}
