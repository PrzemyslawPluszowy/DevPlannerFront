import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_state.dart';

/// Rozlicza każdy fileId; sukces HTTP nie oznacza sukcesu wszystkich plików.
final class TaskAttachmentCompletionMapper {
  const TaskAttachmentCompletionMapper._();

  static List<TaskAttachmentUploadProgress> map(
    List<TaskAttachmentUploadProgress> uploads,
    BulkCompleteUploadResponse response,
  ) {
    final results = <String, BulkCompleteFileItemResult>{};
    final duplicateIds = <String>{};
    for (final result in response.results) {
      if (results.containsKey(result.fileId)) duplicateIds.add(result.fileId);
      results[result.fileId] = result;
    }
    return [
      for (final upload in uploads)
        if (upload.status != TaskAttachmentUploadStatus.completing)
          upload
        else if (duplicateIds.contains(upload.fileId) ||
            !results.containsKey(upload.fileId))
          _unknown(upload)
        else
          _mapResult(upload, results[upload.fileId]!),
    ];
  }

  static TaskAttachmentUploadProgress _mapResult(
    TaskAttachmentUploadProgress upload,
    BulkCompleteFileItemResult result,
  ) {
    if (!result.success) {
      final error = ApiError(
        type: ApiErrorType.badResponse,
        message: result.errorMessage ?? 'Nie udało się zatwierdzić pliku.',
        apiCode: result.errorCode ?? 'task_upload_complete_failed',
        contractCode: result.errorCode,
      );
      return upload.copyWith(
        status: TaskAttachmentUploadStatus.failed,
        error: error.message,
        apiError: error,
      );
    }
    final file = result.file;
    if (file == null || file.id != upload.fileId) return _unknown(upload);
    return _fromFile(upload, file);
  }

  /// GET odzyskuje wynik po utracie odpowiedzi bez ponowienia POST.
  static List<TaskAttachmentUploadProgress> reconcile(
    List<TaskAttachmentUploadProgress> uploads,
    List<StorageFileResponse> files,
  ) {
    final byId = {for (final file in files) file.id: file};
    return [
      for (final upload in uploads)
        if (upload.fileId != null &&
            byId.containsKey(upload.fileId) &&
            (upload.status == TaskAttachmentUploadStatus.unknown ||
                upload.status == TaskAttachmentUploadStatus.processing ||
                upload.status == TaskAttachmentUploadStatus.ready))
          _fromFile(upload, byId[upload.fileId]!)
        else
          upload,
    ];
  }

  static TaskAttachmentUploadProgress _fromFile(
    TaskAttachmentUploadProgress upload,
    StorageFileResponse file,
  ) {
    if (file.scanStatus == StorageScanStatus.infected ||
        file.processingStatus == StorageProcessingStatus.failed ||
        (file.processingStatus == StorageProcessingStatus.ready &&
            file.scanStatus == StorageScanStatus.skipped &&
            !file.canDownload)) {
      const error = ApiError(
        type: ApiErrorType.badResponse,
        message: 'Plik został odrzucony podczas skanowania lub przetwarzania.',
        apiCode: 'task_upload_processing_failed',
      );
      return upload.copyWith(
        status: TaskAttachmentUploadStatus.failed,
        error: error.message,
        apiError: error,
      );
    }
    if (file.processingStatus == StorageProcessingStatus.none) {
      return _unknown(upload);
    }
    final ready =
        file.processingStatus == StorageProcessingStatus.ready &&
        (file.scanStatus == StorageScanStatus.clean ||
            (file.scanStatus == StorageScanStatus.skipped && file.canDownload));
    return upload.copyWith(
      status: ready
          ? TaskAttachmentUploadStatus.ready
          : TaskAttachmentUploadStatus.processing,
      clearError: true,
    );
  }

  static TaskAttachmentUploadProgress _unknown(
    TaskAttachmentUploadProgress upload,
  ) {
    const error = ApiError(
      type: ApiErrorType.parsing,
      message: 'Wynik zatwierdzenia pliku wymaga sprawdzenia stanu serwera.',
      apiCode: 'task_upload_result_unknown',
    );
    return upload.copyWith(
      status: TaskAttachmentUploadStatus.unknown,
      error: error.message,
      apiError: error,
    );
  }
}
