import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';

/// Batched live-presence lookup for direct-chat peers visible in the inbox.
// One operation is the complete lease snapshot; a typed port keeps transport
// concerns out of presentation and remains replaceable in focused tests.
// ignore: one_member_abstracts
abstract interface class ChatInboxPresenceRepository {
  /// Returns one current lease-backed online flag for every requested user.
  Future<Either<ApiError, Map<String, bool>>> loadPresence(
    List<String> userIds,
  );
}
