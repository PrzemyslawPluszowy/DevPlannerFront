import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_state.dart';

/// Wysyła zamrożone pliki; zatwierdzenie pozostaje osobnym etapem Cubita.
final class TaskAttachmentBatchUploadRunner {
  const TaskAttachmentBatchUploadRunner(this.transport);
  final TaskAttachmentUploadTransport transport;

  Future<
    ({
      List<TaskAttachmentUploadProgress> progress,
      List<BulkCompleteFileItemPayload> completed,
    })
  >
  run({
    required List<TaskAttachmentUploadInput> inputs,
    required List<StorageUploadTicketResponse> tickets,
    required List<TaskAttachmentUploadProgress> initialProgress,
    required UploadCancellationToken cancellation,
    required bool Function() isCurrent,
    required void Function(List<TaskAttachmentUploadProgress>) onProgress,
  }) async {
    final progress = List<TaskAttachmentUploadProgress>.of(initialProgress);
    final completed = <BulkCompleteFileItemPayload>[];
    for (var index = 0; index < inputs.length; index++) {
      if (!isCurrent() || cancellation.isCancelled) break;
      final input = inputs[index];
      final ticket = tickets[index];
      progress[index] = progress[index].copyWith(
        fileId: ticket.fileId,
        status: TaskAttachmentUploadStatus.uploading,
        totalBytes: input.bytes.length,
      );
      onProgress(List.of(progress));
      if (!ticket.isAlreadyUploaded) {
        final uploadIndex = index;
        var acceptsProgress = true;
        final result = await transport.upload(
          ticket: ticket,
          bytes: input.bytes,
          mimeType: input.mimeType,
          cancelToken: cancellation,
          onProgress: (sent, total) {
            if (!acceptsProgress || !isCurrent() || cancellation.isCancelled) {
              return;
            }
            progress[uploadIndex] = progress[uploadIndex].copyWith(
              sentBytes: sent.clamp(
                progress[uploadIndex].sentBytes,
                input.bytes.length,
              ),
              totalBytes: input.bytes.length,
            );
            onProgress(List.of(progress));
          },
        );
        acceptsProgress = false;
        if (!isCurrent() || cancellation.isCancelled) break;
        final error = result.fold((error) => error, (_) => null);
        if (error != null) {
          progress[index] = progress[index].copyWith(
            status: TaskAttachmentUploadStatus.failed,
            error: error.message,
            apiError: error,
          );
          onProgress(List.of(progress));
          continue;
        }
      }
      progress[index] = progress[index].copyWith(
        status: TaskAttachmentUploadStatus.uploaded,
        sentBytes: input.bytes.length,
        totalBytes: input.bytes.length,
      );
      completed.add(
        BulkCompleteFileItemPayload(
          fileId: ticket.fileId,
          fileSizeBytes: input.bytes.length,
        ),
      );
      onProgress(List.of(progress));
    }
    return (progress: progress, completed: completed);
  }
}
