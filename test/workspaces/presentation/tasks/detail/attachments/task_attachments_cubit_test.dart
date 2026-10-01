import 'dart:async';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements TaskAttachmentRepository {
  List<Either<ApiError, List<StorageFileResponse>>> lists = [const Right([])];
  Either<ApiError, BulkStorageUploadTicketResponse>? tickets;
  Either<ApiError, BulkCompleteUploadResponse>? completion;
  final keys = <String>[];
  final deletedFilters = <bool>[];
  BulkTaskUploadTicketPayload? ticketPayload;
  BulkCompleteUploadPayload? completePayload;

  @override
  Future<Either<ApiError, List<StorageFileResponse>>> list({
    required String workspaceId,
    required String projectId,
    required String taskId,
    bool includeDeleted = false,
  }) async {
    deletedFilters.add(includeDeleted);
    return lists.removeAt(0);
  }

  @override
  Future<Either<ApiError, BulkStorageUploadTicketResponse>> requestTickets({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String idempotencyKey,
    required BulkTaskUploadTicketPayload payload,
  }) async {
    keys.add(idempotencyKey);
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
  final sent = <List<int>>[];
  Completer<Either<ApiError, Unit>>? pending;
  UploadCancellationToken? cancellation;
  OnStorageUploadProgress? progress;
  @override
  Future<Either<ApiError, Unit>> upload({
    required StorageUploadTicketResponse ticket,
    required Uint8List bytes,
    String? mimeType,
    OnStorageUploadProgress? onProgress,
    UploadCancellationToken? cancelToken,
  }) async {
    sent.add(List.of(bytes));
    cancellation = cancelToken;
    progress = onProgress;
    if (pending != null) return pending!.future;
    return results.removeAt(0);
  }
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
    'tryb usuniętych plików zostaje po błędzie i po ręcznym retry GET',
    () async {
      const error = ApiError(
        type: ApiErrorType.connection,
        message: 'Brak sieci',
      );
      final repository = _Repository()
        ..lists = [const Right([]), const Left(error), const Right([])];
      final cubit = TaskAttachmentsCubit(
        repository: repository,
        uploadTransport: _Transport(),
        workspaceId: 'w',
        projectId: 'p',
        taskId: 't',
      );
      await cubit.load();
      await cubit.setIncludeDeleted(true);
      final failed = cubit.state as TaskAttachmentsReady;
      expect(failed.includeDeleted, isTrue);
      expect(failed.isRefreshing, isFalse);
      expect(failed.apiError, error);
      await cubit.load();
      expect(repository.deletedFilters, [false, true, true]);
      expect((cubit.state as TaskAttachmentsReady).includeDeleted, isTrue);
      expect((cubit.state as TaskAttachmentsReady).apiError, isNull);
      expect(repository.keys, isEmpty);
      await cubit.close();
      await cubit.setIncludeDeleted(false);
      expect(repository.deletedFilters, [false, true, true]);
    },
  );
  test('błąd wyboru pliku zachowuje stan i nie rozpoczyna uploadu', () async {
    final repository = _Repository();
    final cubit = TaskAttachmentsCubit(
      repository: repository,
      uploadTransport: _Transport(),
      workspaceId: 'w',
      projectId: 'p',
      taskId: 't',
    );
    await cubit.load();
    const error = ApiError(
      type: ApiErrorType.validation,
      message: 'Nie można odczytać wybranego pliku.',
      apiCode: 'task_upload_read_failed',
    );
    cubit.reportSelectionError(error);
    final ready = cubit.state as TaskAttachmentsReady;
    expect(ready.apiError, error);
    expect(ready.isUploading, isFalse);
    expect(repository.keys, isEmpty);
    expect(repository.completePayload, isNull);
    await cubit.close();
    cubit.reportSelectionError(error);
    expect(repository.keys, isEmpty);
  });
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
  test(
    'timeout biletu zachowuje klucz i zamrożone bajty przy jawnym retry',
    () async {
      final repository = _Repository()
        ..tickets = const Left(
          ApiError(type: ApiErrorType.receiveTimeout, message: 'Timeout'),
        );
      final transport = _Transport()
        ..results.add(
          const Left(
            ApiError(type: ApiErrorType.connection, message: 'PUT error'),
          ),
        );
      final cubit = TaskAttachmentsCubit(
        repository: repository,
        uploadTransport: transport,
        workspaceId: 'w',
        projectId: 'p',
        taskId: 't',
      );
      await cubit.load();
      final bytes = Uint8List.fromList([1, 2]);
      await cubit.upload([
        TaskAttachmentUploadInput(name: 'a.txt', bytes: bytes),
      ]);
      expect(
        (cubit.state as TaskAttachmentsReady).uploads.single.status,
        TaskAttachmentUploadStatus.unknown,
      );
      expect(repository.keys, hasLength(1));
      expect(
        (cubit.state as TaskAttachmentsReady).uploads.single.apiError?.type,
        ApiErrorType.receiveTimeout,
      );
      bytes[0] = 99;
      repository.tickets = Right(
        BulkStorageUploadTicketResponse(tickets: [_ticket('f')]),
      );
      await cubit.retryUpload();
      expect(repository.keys[1], repository.keys[0]);
      expect(transport.sent.single, [1, 2]);
      expect((cubit.state as TaskAttachmentsReady).apiError, isNull);
      await cubit.close();
      await cubit.retryUpload();
      expect(repository.keys, hasLength(2));
    },
  );

  test(
    'pusty plik jest błędem walidacji, nie znika z wejścia po cichu',
    () async {
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
        TaskAttachmentUploadInput(name: 'empty', bytes: Uint8List(0)),
      ]);
      expect(
        (cubit.state as TaskAttachmentsReady).apiError?.type,
        ApiErrorType.validation,
      );
      expect(repository.keys, isEmpty);
      await cubit.close();
    },
  );
  test(
    'anulowanie PUT przerywa token i nie wywołuje complete po późnym sukcesie',
    () async {
      final repository = _Repository()
        ..tickets = Right(
          BulkStorageUploadTicketResponse(tickets: [_ticket('f')]),
        );
      final pending = Completer<Either<ApiError, Unit>>();
      final transport = _Transport()..pending = pending;
      final cubit = TaskAttachmentsCubit(
        repository: repository,
        uploadTransport: transport,
        workspaceId: 'w',
        projectId: 'p',
        taskId: 't',
      );
      await cubit.load();
      final uploading = cubit.upload([
        TaskAttachmentUploadInput(name: 'a', bytes: Uint8List(10)),
      ]);
      await Future<void>.delayed(Duration.zero);
      transport.progress!(5, 10);
      expect((cubit.state as TaskAttachmentsReady).uploads.single.sentBytes, 5);
      cubit.cancelUpload();
      expect(transport.cancellation!.isCancelled, isTrue);
      expect((cubit.state as TaskAttachmentsReady).isUploading, isFalse);
      expect(
        (cubit.state as TaskAttachmentsReady).uploads.single.status,
        TaskAttachmentUploadStatus.unknown,
      );
      transport.progress!(9, 10);
      expect((cubit.state as TaskAttachmentsReady).uploads.single.sentBytes, 5);
      pending.complete(const Right(unit));
      await uploading;
      expect(repository.completePayload, isNull);
      await cubit.close();
    },
  );

  test('close anuluje aktywny transport bez emisji i bez complete', () async {
    final repository = _Repository()
      ..tickets = Right(
        BulkStorageUploadTicketResponse(tickets: [_ticket('f')]),
      );
    final pending = Completer<Either<ApiError, Unit>>();
    final transport = _Transport()..pending = pending;
    final cubit = TaskAttachmentsCubit(
      repository: repository,
      uploadTransport: transport,
      workspaceId: 'w',
      projectId: 'p',
      taskId: 't',
    );
    await cubit.load();
    final uploading = cubit.upload([
      TaskAttachmentUploadInput(name: 'a', bytes: Uint8List(10)),
    ]);
    await Future<void>.delayed(Duration.zero);
    await cubit.close();
    expect(transport.cancellation!.isCancelled, isTrue);
    pending.complete(const Right(unit));
    await uploading;
    expect(repository.completePayload, isNull);
  });
}
