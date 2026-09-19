import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements TaskAttachmentRepository {
  List<Either<ApiError, List<StorageFileResponse>>> lists = [const Right([])];
  Either<ApiError, BulkStorageUploadTicketResponse>? tickets;
  Either<ApiError, BulkCompleteUploadResponse>? completion;
  BulkTaskUploadTicketPayload? ticketPayload;
  BulkCompleteUploadPayload? completePayload;

  @override
  Future<Either<ApiError, List<StorageFileResponse>>> list({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async => lists.removeAt(0);
  @override
  Future<Either<ApiError, BulkStorageUploadTicketResponse>> requestTickets({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required BulkTaskUploadTicketPayload payload,
  }) async {
    ticketPayload = payload;
    return tickets!;
  }

  @override
  Future<Either<ApiError, BulkCompleteUploadResponse>> complete({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required BulkCompleteUploadPayload payload,
  }) async {
    completePayload = payload;
    return completion!;
  }
}

final class _Transport implements TaskAttachmentUploadTransport {
  final results = <Either<ApiError, Unit>>[];
  @override
  Future<Either<ApiError, Unit>> upload({
    required StorageUploadTicketResponse ticket,
    required Uint8List bytes,
    String? mimeType,
  }) async => results.removeAt(0);
}

StorageUploadTicketResponse _ticket(String id) => StorageUploadTicketResponse(
  fileId: id,
  storageObjectKey: 'key',
  uploadUrl: 'https://upload.example/$id',
  expiresAtUtc: DateTime.utc(2026, 8, 26),
  isAlreadyUploaded: false,
);
BulkCompleteUploadResponse get _complete => const BulkCompleteUploadResponse(
  results: [],
  totalCount: 1,
  successCount: 1,
  failedCount: 0,
);

void main() {
  test(
    'wysyła bilety, plik i bulk-complete, a następnie odświeża listę',
    () async {
      final repository = _Repository()
        ..lists = [const Right([]), const Right([])]
        ..tickets = Right(
          BulkStorageUploadTicketResponse(tickets: [_ticket('file-1')]),
        )
        ..completion = Right(_complete);
      final transport = _Transport()..results.add(const Right(unit));
      final cubit = TaskAttachmentsCubit(
        repository: repository,
        uploadTransport: transport,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await cubit.load();

      await cubit.upload([
        TaskAttachmentUploadInput(
          name: 'brief.pdf',
          bytes: Uint8List.fromList([1, 2]),
          mimeType: 'application/pdf',
        ),
      ]);

      expect(repository.ticketPayload?.files.single.fileName, 'brief.pdf');
      expect(repository.completePayload?.files.single.fileId, 'file-1');
      expect(cubit.state, isA<TaskAttachmentsReady>());
      await cubit.close();
    },
  );

  test('nie zatwierdza pliku, którego upload zakończył się błędem', () async {
    final repository = _Repository()
      ..lists = [const Right([])]
      ..tickets = Right(
        BulkStorageUploadTicketResponse(tickets: [_ticket('file-1')]),
      )
      ..completion = Right(_complete);
    final transport = _Transport()
      ..results.add(
        const Left(
          ApiError(type: ApiErrorType.connection, message: 'Brak połączenia'),
        ),
      );
    final cubit = TaskAttachmentsCubit(
      repository: repository,
      uploadTransport: transport,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();

    await cubit.upload([
      TaskAttachmentUploadInput(
        name: 'brief.pdf',
        bytes: Uint8List.fromList([1]),
      ),
    ]);

    expect(repository.completePayload, isNull);
    expect(
      (cubit.state as TaskAttachmentsReady).uploads.single.status,
      TaskAttachmentUploadStatus.failed,
    );
    await cubit.close();
  });
}
