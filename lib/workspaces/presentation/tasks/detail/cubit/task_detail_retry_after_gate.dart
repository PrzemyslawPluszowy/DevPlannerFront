import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:flutter/foundation.dart';

/// Owns a task-detail `Retry-After` timer and its teardown.
final class TaskDetailRetryAfterGate {
  DateTime? _retryAfterUtc;
  Timer? _timer;

  bool get isBlocked {
    final retryAt = _retryAfterUtc;
    return retryAt != null && DateTime.now().toUtc().isBefore(retryAt);
  }

  void schedule(ApiError error, {required VoidCallback onAvailable}) {
    clear();
    final retryAt = error.retryAfterUtc?.toUtc();
    if (retryAt == null) return;
    final delay = retryAt.difference(DateTime.now().toUtc());
    if (delay <= Duration.zero) return;
    _retryAfterUtc = retryAt;
    _timer = Timer(delay, () {
      _timer = null;
      _retryAfterUtc = null;
      onAvailable();
    });
  }

  void clear() {
    _timer?.cancel();
    _timer = null;
    _retryAfterUtc = null;
  }

  void dispose() => clear();
}
