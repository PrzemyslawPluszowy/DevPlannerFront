import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachment_completion_mapper.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_state.dart';
import 'package:flutter_test/flutter_test.dart';

StorageFileResponse _file(String id) => StorageFileResponse(
  id: id,
  module: StorageModule.workspaces,
  resourceType: StorageResourceType.task,
  originalFileName: '$id.txt',
  extension: 'txt',
  mimeType: 'text/plain',
  fileSizeBytes: 2,
  version: 1,
  ownerUserId: 'u',
  createdByUserId: 'u',
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  isDeleted: false,
  processingStatus: StorageProcessingStatus.ready,
  scanStatus: StorageScanStatus.clean,
  aiStatus: StorageAiStatus.completed,
  canDownload: true,
);
TaskAttachmentUploadProgress _upload(String id) => TaskAttachmentUploadProgress(
  name: '$id.txt',
  fileId: id,
  status: TaskAttachmentUploadStatus.completing,
);
void main() {
  test('partial complete koreluje po fileId mimo odwróconej kolejności', () {
    final result = TaskAttachmentCompletionMapper.map(
      [_upload('a'), _upload('b')],
      BulkCompleteUploadResponse(
        results: [
          const BulkCompleteFileItemResult(
            fileId: 'b',
            success: false,
            errorCode: 'storage_rejected',
            errorMessage: 'Rejected',
          ),
          BulkCompleteFileItemResult(
            fileId: 'a',
            success: true,
            file: _file('a'),
          ),
        ],
        totalCount: 2,
        successCount: 1,
        failedCount: 1,
      ),
    );
    expect(result[0].status, TaskAttachmentUploadStatus.ready);
    expect(result[1].status, TaskAttachmentUploadStatus.failed);
    expect(result[1].apiError?.contractCode, 'storage_rejected');
  });
  test('brak wyniku pozostaje unknown; GET odzyskuje wynik bez POST', () {
    final result = TaskAttachmentCompletionMapper.map(
      [_upload('a')],
      const BulkCompleteUploadResponse(
        results: [],
        totalCount: 1,
        successCount: 1,
        failedCount: 0,
      ),
    );
    expect(result.single.status, TaskAttachmentUploadStatus.unknown);
    final recovered = TaskAttachmentCompletionMapper.reconcile(result, [
      _file('a'),
    ]);
    expect(recovered.single.status, TaskAttachmentUploadStatus.ready);
    expect(recovered.single.apiError, isNull);
  });
  test('Ready ze zablokowanym Skipped nie kręci processing bez końca', () {
    final result = TaskAttachmentCompletionMapper.reconcile(
      [
        _upload('a').copyWith(status: TaskAttachmentUploadStatus.processing),
      ],
      [
        _file(
          'a',
        ).copyWith(scanStatus: StorageScanStatus.skipped, canDownload: false),
      ],
    );
    expect(result.single.status, TaskAttachmentUploadStatus.failed);
  });
  test('duplikat wyniku nie jest sukcesem', () {
    final result = TaskAttachmentCompletionMapper.map(
      [_upload('a')],
      BulkCompleteUploadResponse(
        results: [
          BulkCompleteFileItemResult(
            fileId: 'a',
            success: true,
            file: _file('a'),
          ),
          BulkCompleteFileItemResult(
            fileId: 'a',
            success: true,
            file: _file('a'),
          ),
        ],
        totalCount: 2,
        successCount: 2,
        failedCount: 0,
      ),
    );
    expect(result.single.status, TaskAttachmentUploadStatus.unknown);
  });
}
