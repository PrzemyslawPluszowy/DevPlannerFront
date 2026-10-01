import 'dart:math';
import 'dart:typed_data';

import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_state.dart';

/// Jeden niezmienny wybór plików i klucz powtarzany przy odzyskiwaniu biletów.
final class TaskAttachmentUploadBatch {
  TaskAttachmentUploadBatch._(this.idempotencyKey, this.inputs);

  factory TaskAttachmentUploadBatch.freeze(
    List<TaskAttachmentUploadInput> inputs,
  ) {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 15) | 64;
    bytes[8] = (bytes[8] & 63) | 128;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    final key =
        '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
    return TaskAttachmentUploadBatch._(
      key,
      List.unmodifiable([
        for (final input in inputs)
          TaskAttachmentUploadInput(
            name: input.name,
            bytes: Uint8List.fromList(input.bytes).asUnmodifiableView(),
            mimeType: input.mimeType,
          ),
      ]),
    );
  }

  final String idempotencyKey;
  final List<TaskAttachmentUploadInput> inputs;
}
