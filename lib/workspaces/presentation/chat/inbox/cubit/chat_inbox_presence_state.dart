import 'package:devplanner/core/error/api_error.dart';

/// Last batch snapshot for the currently visible direct-chat peers.
final class ChatInboxPresenceState {
  const ChatInboxPresenceState({
    this.statuses = const <String, bool>{},
    this.snapshotAtUtc,
    this.isRefreshing = false,
    this.retryAfterUtc,
    this.retryCountdownSeconds = 0,
    this.error,
  });

  /// A missing user means loading, stale or failed; it never means offline.
  final Map<String, bool> statuses;
  final DateTime? snapshotAtUtc;
  final bool isRefreshing;
  final DateTime? retryAfterUtc;
  final int retryCountdownSeconds;
  final ApiError? error;

  bool? statusFor(String userId) => statuses[userId];
}
