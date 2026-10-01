import 'dart:async';

import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_state.dart';

/// Właściciel ograniczonego harmonogramu odzyskiwania wyłącznie przez GET.
final class TaskAttachmentRecoveryScheduler {
  TaskAttachmentRecoveryScheduler({required this.onRecover});

  final Future<void> Function() onRecover;
  Timer? _timer;
  int _attempt = 0;
  bool _disposed = false;

  void cancel() => _timer?.cancel();

  void reset() {
    cancel();
    _attempt = 0;
  }

  void schedule(TaskAttachmentsState state) {
    const delays = [2, 3, 5, 8, 13, 21];
    if (_disposed ||
        state is! TaskAttachmentsReady ||
        state.isUploading ||
        _attempt >= delays.length ||
        !state.uploads.any(
          (upload) =>
              upload.fileId != null &&
              (upload.status == TaskAttachmentUploadStatus.processing ||
                  upload.status == TaskAttachmentUploadStatus.unknown),
        )) {
      return;
    }
    cancel();
    var delay = Duration(seconds: delays[_attempt++]);
    final retryAfter = state.apiError?.retryAfterUtc;
    if (retryAfter != null) {
      final remaining = retryAfter.difference(DateTime.now().toUtc());
      if (remaining > delay) delay = remaining;
    }
    _timer = Timer(delay, () {
      if (!_disposed) unawaited(onRecover());
    });
  }

  void dispose() {
    _disposed = true;
    cancel();
  }
}
