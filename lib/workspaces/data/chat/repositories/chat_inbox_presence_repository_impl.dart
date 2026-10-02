import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_inbox_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_presence_repository.dart';
import 'package:dio/dio.dart';

/// Adapter batchowego kontraktu live presence dla rozmówców 1:1.
final class ChatInboxPresenceRepositoryImpl
    implements ChatInboxPresenceRepository {
  ChatInboxPresenceRepositoryImpl(this._api);

  final ChatInboxApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, Map<String, bool>>> loadPresence(
    List<String> userIds,
  ) async {
    if (userIds.isEmpty) return const Right(<String, bool>{});
    try {
      final requested = userIds.toSet();
      if (requested.length != userIds.length || requested.length > 100) {
        return Left(
          _errorMapper.fromParsing(code: ChatApiErrorCode.loadInboxPresence),
        );
      }
      final response = await _api.loadInboxPresence(
        ChatInboxPresenceRequest(userIds: userIds),
      );
      final statuses = <String, bool>{};
      for (final user in response.users) {
        if (!requested.contains(user.userId) ||
            statuses.containsKey(user.userId)) {
          throw const FormatException('Presence batch did not match request.');
        }
        statuses[user.userId] = user.isOnline;
      }
      if (statuses.length != requested.length) {
        throw const FormatException('Presence batch was incomplete.');
      }
      return Right(Map<String, bool>.unmodifiable(statuses));
    } on DioException catch (error) {
      return Left(
        _errorMapper.fromDioException(
          error,
          code: ChatApiErrorCode.loadInboxPresence,
        ),
      );
    } on Object {
      return Left(
        _errorMapper.fromParsing(code: ChatApiErrorCode.loadInboxPresence),
      );
    }
  }
}
