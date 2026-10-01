import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements TaskAttachmentRepository {
  int reads = 0;
  int completions = 0;
  int tickets = 0;
  int readyAfter = 99;
  final file = StorageFileResponse(
    id: 'f',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.task,
    originalFileName: 'a',
    extension: '',
    mimeType: 'text/plain',
    fileSizeBytes: 2,
    version: 1,
    ownerUserId: 'u',
    createdByUserId: 'u',
    createdAtUtc: DateTime.utc(2026),
    updatedAtUtc: DateTime.utc(2026),
    isDeleted: false,
    processingStatus: StorageProcessingStatus.queued,
    scanStatus: StorageScanStatus.pending,
    aiStatus: StorageAiStatus.none,
  );
  @override
  Future<Either<ApiError, List<StorageFileResponse>>> list({
    required String workspaceId,
    required String projectId,
    required String taskId,
    bool includeDeleted = false,
  }) async {
    reads++;
    return Right([
      if (reads >= readyAfter)
        file.copyWith(
          processingStatus: StorageProcessingStatus.ready,
          scanStatus: StorageScanStatus.clean,
          canDownload: true,
        )
      else
        file,
    ]);
  }

  @override
  Future<Either<ApiError, BulkStorageUploadTicketResponse>> requestTickets({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String idempotencyKey,
    required BulkTaskUploadTicketPayload payload,
  }) async {
    tickets++;
    return Right(
      BulkStorageUploadTicketResponse(
        tickets: [
          StorageUploadTicketResponse(
            fileId: 'f',
            storageObjectKey: 'key',
            uploadUrl: '',
            expiresAtUtc: DateTime.utc(2027),
            isAlreadyUploaded: true,
          ),
        ],
      ),
    );
  }

  @override
  Future<Either<ApiError, BulkCompleteUploadResponse>> complete({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required BulkCompleteUploadPayload payload,
  }) async {
    completions++;
    return Right(
      BulkCompleteUploadResponse(
        results: [
          BulkCompleteFileItemResult(fileId: 'f', success: true, file: file),
        ],
        totalCount: 1,
        successCount: 1,
        failedCount: 0,
      ),
    );
  }
}

final class _Transport implements TaskAttachmentUploadTransport {
  @override
  Future<Either<ApiError, Unit>> upload({
    required StorageUploadTicketResponse ticket,
    required Uint8List bytes,
    String? mimeType,
    OnStorageUploadProgress? onProgress,
    UploadCancellationToken? cancelToken,
  }) => throw StateError('Already uploaded must skip PUT');
}

void main() {
  testWidgets('processing GET recovery stops at Ready and never retries POST', (
    tester,
  ) async {
    final repository = _Repository()..readyAfter = 3;
    final cubit = TaskAttachmentsCubit(
      repository: repository,
      uploadTransport: _Transport(),
      workspaceId: 'w',
      projectId: 'p',
      taskId: 't',
    );
    await cubit.load();
    await cubit.upload([
      TaskAttachmentUploadInput(name: 'a', bytes: Uint8List(2)),
    ]);
    expect(
      (cubit.state as TaskAttachmentsReady).uploads.single.status,
      TaskAttachmentUploadStatus.processing,
    );
    await tester.pump(const Duration(seconds: 2));
    expect(
      (cubit.state as TaskAttachmentsReady).uploads.single.status,
      TaskAttachmentUploadStatus.ready,
    );
    final reads = repository.reads;
    await tester.pump(const Duration(minutes: 2));
    expect(repository.reads, reads);
    expect(repository.completions, 1);
    expect(repository.tickets, 1);
    await cubit.close();
  });
  testWidgets(
    'processing polls are bounded and close cancels the pending read',
    (tester) async {
      final repository = _Repository();
      final cubit = TaskAttachmentsCubit(
        repository: repository,
        uploadTransport: _Transport(),
        workspaceId: 'w',
        projectId: 'p',
        taskId: 't',
      );
      await cubit.load();
      await cubit.upload([
        TaskAttachmentUploadInput(name: 'a', bytes: Uint8List(2)),
      ]);
      for (final seconds in [2, 3, 5, 8, 13, 21]) {
        await tester.pump(Duration(seconds: seconds));
      }
      expect(repository.reads, 8);
      await tester.pump(const Duration(minutes: 2));
      expect(repository.reads, 8);
      await cubit.load();
      await cubit.close();
      await tester.pump(const Duration(minutes: 2));
      expect(repository.reads, 9);
      expect(repository.completions, 1);
      expect(repository.tickets, 1);
    },
  );
}
