import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy_repository.dart';
import 'package:dio/dio.dart';

/// Implementacja portu polityki snippetów na kliencie Chat.
///
/// Adapter mapuje odpowiedź serwera na model domenowy; brak polityki nie jest
/// zastępowany wartościami domyślnymi, żeby klient nie zgadywał progów.
final class ChatLinkPolicyRepositoryImpl implements ChatLinkPolicyRepository {
  /// Tworzy adapter na uwierzytelnionym kliencie Chat.
  ChatLinkPolicyRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, ChatLinkPolicy>> getPolicy() => _guard(
    () async => (await _api.loadLinkPolicy()).toDomain(),
    code: ChatApiErrorCode.loadLinkPolicy,
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
