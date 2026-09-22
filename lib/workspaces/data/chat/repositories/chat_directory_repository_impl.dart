import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:dio/dio.dart';

/// Implementacja portu lokalnego katalogu kont Chat.
final class ChatDirectoryRepositoryImpl implements ChatDirectoryRepository {
  /// Tworzy adapter na uwierzytelnionym kliencie Chat.
  ChatDirectoryRepositoryImpl(this._api, {this.defaultLimit = 20});

  final ChatApi _api;

  /// Domyślna liczba kandydatów, gdy UI nie poda własnej.
  final int defaultLimit;

  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, List<ChatDirectoryEntry>>> search({
    required String term,
    int? limit,
  }) => _guard(
    () async => (await _api.searchDirectory(
      query: term,
      limit: limit ?? defaultLimit,
    )).map(_toEntry).toList(growable: false),
    code: ChatApiErrorCode.loadDirectory,
  );

  static ChatDirectoryEntry _toEntry(ChatDirectoryUserResponse response) =>
      ChatDirectoryEntry(
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
