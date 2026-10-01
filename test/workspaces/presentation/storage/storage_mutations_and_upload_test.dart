import 'dart:async';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

class _MockDownloadTransport extends Mock implements DownloadTransport {}

class _MockUploadTransport extends Mock implements UploadTransport {}

void main() {
  late _MockStorageRepository repository;
  late _MockDownloadTransport downloadTransport;
  late _MockUploadTransport uploadTransport;

  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(StorageDocumentFormat.docx);
    registerFallbackValue(
      const StorageUploadTicketPayload(
        module: StorageModule.workspaces,
        resourceType: StorageResourceType.document,
        fileName: 'test.pdf',
        fileSizeBytes: 100,
      ),
    );
    registerFallbackValue(
      StorageUploadTicketResponse(
        fileId: 'f-1',
        storageObjectKey: 'k1',
        uploadUrl: 'https://minio.local/upload',
        expiresAtUtc: DateTime.utc(2026, 9, 9, 13),
        isAlreadyUploaded: false,
      ),
    );
    registerFallbackValue(
      StorageUploadInput(
        name: 'test.pdf',
        size: 100,
        bytes: Uint8List.fromList([1, 2, 3]),
      ),
    );
  });

  setUp(() {
    repository = _MockStorageRepository();
    downloadTransport = _MockDownloadTransport();
    uploadTransport = _MockUploadTransport();
  });

  final now = DateTime.utc(2026, 9, 9, 12);

  final sampleFolder = StorageFolderResponse(
    id: 'folder-1',
    name: 'Ważne',
    folderType: StorageFolderType.personal,
    itemCount: 0,
    updatedAtUtc: now,
    accessLevel: StorageEffectiveAccessLevel.owner,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
  );

  final sampleFile = StorageFileResponse(
    id: 'file-1',
    originalFileName: 'raport.pdf',
    extension: 'pdf',
    fileSizeBytes: 1024,
    mimeType: 'application/pdf',
    createdAtUtc: now,
    updatedAtUtc: now,
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    resourceId: 'res-1',
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    scanStatus: StorageScanStatus.clean,
    processingStatus: StorageProcessingStatus.ready,
    aiStatus: StorageAiStatus.completed,
    accessLevel: StorageEffectiveAccessLevel.owner,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
    version: 1,
    isDeleted: false,
  );

  group('StorageFolderMutationCubit', () {
    test('createFolder emituje Success po utworzeniu', () async {
      when(
        () => repository.createFolder(
          scope: any(named: 'scope'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => right(sampleFolder));

      final cubit = StorageFolderMutationCubit(repository: repository);

      await cubit.createFolder(
        scope: const StorageScope.personal(),
        name: 'Ważne',
      );

      expect(cubit.state, isA<StorageFolderMutationSuccess>());
      final s = cubit.state as StorageFolderMutationSuccess;
      expect(s.type, equals(StorageFolderMutationType.created));
      expect(s.folder?.name, equals('Ważne'));

      await cubit.close();
    });

    test('deleteFolder emituje Success po usunięciu', () async {
      when(() => repository.deleteFolder('folder-1'))
          .thenAnswer((_) async => right(unit));

      final cubit = StorageFolderMutationCubit(repository: repository);

      await cubit.deleteFolder('folder-1');

      expect(cubit.state, isA<StorageFolderMutationSuccess>());
      final s = cubit.state as StorageFolderMutationSuccess;
      expect(s.type, equals(StorageFolderMutationType.deleted));
      expect(s.folderId, equals('folder-1'));

      await cubit.close();
    });

    test('renameFolder i moveFolder zachowują odpowiedź backendu', () async {
      final renamed = sampleFolder.copyWith(name: 'Nowa nazwa');
      when(
        () => repository.updateFolder(
          folderId: 'folder-1',
          name: 'Nowa nazwa',
        ),
      ).thenAnswer((_) async => right(renamed));
      when(
        () => repository.moveFolder(
          folderId: 'folder-1',
          newParentFolderId: 'parent-1',
        ),
      ).thenAnswer((_) async => right(sampleFolder));

      final cubit = StorageFolderMutationCubit(repository: repository);

      await cubit.renameFolder(folderId: 'folder-1', newName: ' Nowa nazwa ');
      expect(cubit.state, isA<StorageFolderMutationSuccess>());
      expect(
        (cubit.state as StorageFolderMutationSuccess).type,
        StorageFolderMutationType.updated,
      );

      await cubit.moveFolder(
        folderId: 'folder-1',
        newParentFolderId: 'parent-1',
      );
      expect(cubit.state, isA<StorageFolderMutationSuccess>());
      expect(
        (cubit.state as StorageFolderMutationSuccess).type,
        StorageFolderMutationType.moved,
      );

      await cubit.close();
    });
  });

  group('StorageDocumentMutationCubit', () {
    test(
      'retry zachowuje klucz idempotencji, a nowa akcja dostaje nowy klucz',
      () async {
        var calls = 0;
        when(
          () => repository.createStorageDocument(
            scope: any(named: 'scope'),
            name: any(named: 'name'),
            format: any(named: 'format'),
            idempotencyKey: any(named: 'idempotencyKey'),
          ),
        ).thenAnswer((invocation) async {
          calls++;
          final result = calls == 1
              ? const Left<ApiError, StorageFileResponse>(
                  ApiError(type: ApiErrorType.connection, message: 'offline'),
                )
              : Right<ApiError, StorageFileResponse>(sampleFile);
          return result;
        });

        final cubit = StorageDocumentMutationCubit(repository: repository);
        const scope = StorageScope.personal();
        await cubit.createDocument(
          scope: scope,
          name: 'nowy dokument',
          format: StorageDocumentFormat.docx,
        );
        final operationId =
            (cubit.state as StorageDocumentMutationFailure).operationId;
        await cubit.retry(operationId: operationId);
        await cubit.createDocument(
          scope: scope,
          name: 'nowy dokument',
          format: StorageDocumentFormat.docx,
        );

        final captured = verify(
          () => repository.createStorageDocument(
            scope: scope,
            name: 'nowy dokument',
            format: StorageDocumentFormat.docx,
            idempotencyKey: captureAny(named: 'idempotencyKey'),
          ),
        ).captured;
        expect(captured, hasLength(3));
        expect(captured[0], captured[1]);
        expect(captured[1], isNot(captured[2]));
        await cubit.close();
      },
    );
  });

  group('StorageFileMutationCubit', () {
    test('toggleFavorite ustawia stan ulubionego', () async {
      when(
        () => repository.setFileFavorite(
          fileId: 'file-1',
          isFavorite: true,
        ),
      ).thenAnswer(
        (_) async => right(
          StorageFileUserStateResponse(
            fileId: 'file-1',
            isFavorite: true,
            favoritedAtUtc: now,
          ),
        ),
      );

      final cubit = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: downloadTransport,
      );

      await cubit.toggleFavorite(sampleFile);

      expect(cubit.state, isA<StorageFileMutationSuccess>());
      final s = cubit.state as StorageFileMutationSuccess;
      expect(s.type, equals(StorageFileMutationType.favoriteToggled));

      await cubit.close();
    });

    test('bulk delete partial keeps complete API diagnostics', () async {
      final error = ApiError(
        type: ApiErrorType.badResponse,
        message: 'Poczekaj przed kolejną próbą.',
        statusCode: 429,
        backendCode: 28,
        apiCode: 'storage.rate_limited',
        contractCode: 'storage.rate_limited',
        fields: const {
          'fileId': ['file-2 is temporarily locked.'],
        },
        traceId: 'bulk-delete-trace',
        retryAfterUtc: DateTime.utc(2026, 10, 1, 12),
      );
      when(() => repository.deleteFile('file-1')).thenAnswer(
        (_) async => right(unit),
      );
      when(() => repository.deleteFile('file-2')).thenAnswer(
        (_) async => left(error),
      );
      final cubit = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: downloadTransport,
      );

      await cubit.bulkDelete(fileIds: const ['file-1', 'file-2']);

      final partial = cubit.state as StorageFileMutationPartialSuccess;
      expect(partial.succeededIds, ['file-1']);
      expect(partial.failedIds, ['file-2']);
      expect(partial.apiError, error);
      expect(partial.apiError?.fields, error.fields);
      expect(partial.apiError?.contractCode, error.contractCode);
      expect(partial.apiError?.traceId, error.traceId);
      expect(partial.apiError?.retryAfterUtc, error.retryAfterUtc);
      expect(partial.apiErrorsById, {'file-2': error});
      verify(() => repository.deleteFile('file-1')).called(1);
      verify(() => repository.deleteFile('file-2')).called(1);
      await cubit.close();
    });

    for (final partialSuccess in [false, true]) {
      test(
        'bulk stops before later requests (partial=$partialSuccess)',
        () async {
          final limited = ApiError(
            type: ApiErrorType.badResponse,
            message: 'Wait',
            statusCode: 429,
            apiCode: 'storage.rate_limited',
            retryAfterUtc: DateTime.now().toUtc().add(
              const Duration(minutes: 5),
            ),
          );
          const conflict = ApiError(
            type: ApiErrorType.badResponse,
            message: 'Conflict',
            statusCode: 409,
            apiCode: 'storage.conflict',
          );
          when(() => repository.deleteFile('limited'))
              .thenAnswer((_) async => left(limited));
          when(() => repository.deleteFile('conflict'))
              .thenAnswer((_) async => left(conflict));
          when(() => repository.deleteFile('success'))
              .thenAnswer((_) async => right(unit));
          final cubit = StorageFileMutationCubit(
            repository: repository,
            downloadTransport: downloadTransport,
          );
          addTearDown(cubit.close);
          await cubit.bulkDelete(
            fileIds: [if (partialSuccess) 'success', 'limited', 'conflict'],
          );
          final previous = cubit.state;
          if (previous case StorageFileMutationPartialSuccess()) {
            expect(previous.succeededIds, ['success']);
            expect(previous.failedIds, ['limited']);
            expect(previous.notAttemptedIds, ['conflict']);
            expect(previous.apiErrorsById, {'limited': limited});
          } else {
            final failure = previous as StorageFileMutationFailure;
            expect(failure.notAttemptedIds, ['conflict']);
            expect(failure.apiErrorsById, {'limited': limited});
          }
          verifyNever(() => repository.deleteFile('conflict'));
          await cubit.deleteFile('success');
          expect(cubit.state, same(previous));
          final feedback = await cubit.downloadFileWithFeedback(sampleFile);
          expect(feedback, same(limited));
          verifyNever(() => repository.getDownloadTicket(any()));
          if (partialSuccess) {
            verify(() => repository.deleteFile('success')).called(1);
          } else {
            verifyNever(() => repository.deleteFile('success'));
          }
        },
      );
    }

    for (final status in [429, 503]) {
      test('folder backpressure stops folders and files ($status)', () async {
        final error = ApiError(
          type: ApiErrorType.badResponse,
          message: 'Wait',
          statusCode: status,
          retryAfterUtc: status == 503
              ? DateTime.now().toUtc().add(const Duration(minutes: 5))
              : null,
        );
        when(() => repository.deleteFolder('first'))
            .thenAnswer((_) async => left(error));
        final cubit = StorageFileMutationCubit(
          repository: repository,
          downloadTransport: downloadTransport,
        );
        addTearDown(cubit.close);
        await cubit.bulkDelete(
          folderIds: const ['first', 'second'],
          fileIds: const ['file'],
        );
        final failure = cubit.state as StorageFileMutationFailure;
        expect(failure.apiErrorsById, {'first': error});
        expect(failure.notAttemptedIds, ['second', 'file']);
        verifyNever(() => repository.deleteFolder('second'));
        verifyNever(() => repository.deleteFile(any()));
      });
    }

    test('ordinary per-file conflict allows remaining deletes', () async {
      const error = ApiError(
        type: ApiErrorType.badResponse,
        message: 'Conflict',
        statusCode: 409,
      );
      when(() => repository.deleteFile('conflict'))
          .thenAnswer((_) async => left(error));
      when(() => repository.deleteFile('success'))
          .thenAnswer((_) async => right(unit));
      final cubit = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: downloadTransport,
      );
      addTearDown(cubit.close);
      await cubit.bulkDelete(fileIds: const ['conflict', 'success']);
      final partial = cubit.state as StorageFileMutationPartialSuccess;
      expect(partial.succeededIds, ['success']);
      expect(partial.failedIds, ['conflict']);
      expect(partial.notAttemptedIds, isEmpty);
      verify(() => repository.deleteFile('success')).called(1);
    });

    test(
      'unexpected mutation failure leaves a recoverable typed state',
      () async {
        when(
          () => repository.setFileFavorite(
            fileId: 'file-1',
            isFavorite: true,
          ),
        ).thenThrow(StateError('transport adapter failed'));
        final cubit = StorageFileMutationCubit(
          repository: repository,
          downloadTransport: downloadTransport,
        );

        await cubit.toggleFavorite(sampleFile);

        final failure = cubit.state as StorageFileMutationFailure;
        expect(failure.apiCode, 'storage.action_failed');
        expect(failure.message, 'storage.action_failed');
        expect(cubit.isClosed, isFalse);
        await cubit.close();
      },
    );

    test('download feedback reports busy and reset as typed errors', () async {
      final response =
          Completer<Either<ApiError, StorageFileUserStateResponse>>();
      final ticket =
          Completer<Either<ApiError, StorageDownloadTicketResponse>>();
      when(
        () => repository.setFileFavorite(
          fileId: 'file-1',
          isFavorite: true,
        ),
      ).thenAnswer((_) => response.future);
      when(() => repository.getDownloadTicket('file-1'))
          .thenAnswer((_) => ticket.future);
      final cubit = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: downloadTransport,
      );

      final pending = cubit.toggleFavorite(sampleFile);
      await Future<void>.delayed(Duration.zero);
      final busyError = await cubit.downloadFileWithFeedback(sampleFile);
      expect(busyError?.apiCode, 'storage.action_busy');
      cubit.reset();
      response.complete(
        const Right(
          StorageFileUserStateResponse(fileId: 'file-1', isFavorite: true),
        ),
      );
      await pending;
      final download = cubit.downloadFileWithFeedback(sampleFile);
      await Future<void>.delayed(Duration.zero);
      cubit.reset();
      ticket.complete(
        Right(
          StorageDownloadTicketResponse(
            fileId: 'file-1',
            originalFileName: 'report.pdf',
            mimeType: 'application/pdf',
            fileSizeBytes: 1024,
            downloadUrl: 'https://download.invalid/ticket',
            expiresAtUtc: now.add(const Duration(hours: 1)),
          ),
        ),
      );
      final canceledError = await download;
      expect(canceledError?.apiCode, 'storage.action_canceled');
      await cubit.close();
    });

    test('closed mutation cubit does not start a request or emit', () async {
      final cubit = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: downloadTransport,
      );
      await cubit.close();

      await cubit.toggleFavorite(sampleFile);

      verifyNever(
        () => repository.setFileFavorite(
          fileId: any(named: 'fileId'),
          isFavorite: any(named: 'isFavorite'),
        ),
      );
    });

    test(
      'close while waiting for ticket prevents the download transport',
      () async {
        final ticket =
            Completer<Either<ApiError, StorageDownloadTicketResponse>>();
        when(() => repository.getDownloadTicket('file-1'))
            .thenAnswer((_) => ticket.future);
        final cubit = StorageFileMutationCubit(
          repository: repository,
          downloadTransport: downloadTransport,
        );

        final download = cubit.downloadFile(sampleFile);
        await Future<void>.delayed(Duration.zero);
        await cubit.close();
        ticket.complete(
          Right<ApiError, StorageDownloadTicketResponse>(
            StorageDownloadTicketResponse(
              fileId: 'file-1',
              originalFileName: 'raport.pdf',
              mimeType: 'application/pdf',
              fileSizeBytes: 1024,
              downloadUrl: 'https://download.invalid/ticket',
              expiresAtUtc: now.add(const Duration(hours: 1)),
            ),
          ),
        );
        await download;

        verifyNever(
          () => downloadTransport.downloadUrl(
            downloadUrl: any(named: 'downloadUrl'),
            fileName: any(named: 'fileName'),
            headers: any(named: 'headers'),
          ),
        );
      },
    );

    test(
      'busy mutation rejects duplicates and reset ignores late response',
      () async {
        final response =
            Completer<Either<ApiError, StorageFileUserStateResponse>>();
        when(
          () => repository.setFileFavorite(
            fileId: 'file-1',
            isFavorite: true,
          ),
        ).thenAnswer((_) => response.future);
        final cubit = StorageFileMutationCubit(
          repository: repository,
          downloadTransport: downloadTransport,
        );

        final first = cubit.toggleFavorite(sampleFile);
        await cubit.toggleFavorite(sampleFile);
        expect(cubit.state, isA<StorageFileMutationLoading>());
        verify(
          () => repository.setFileFavorite(
            fileId: 'file-1',
            isFavorite: true,
          ),
        ).called(1);

        cubit.reset();
        response.complete(
          Right<ApiError, StorageFileUserStateResponse>(
            StorageFileUserStateResponse(
              fileId: 'file-1',
              isFavorite: true,
              favoritedAtUtc: now,
            ),
          ),
        );
        await first;
        expect(cubit.state, isA<StorageFileMutationInitial>());
        await cubit.close();
      },
    );
  });

  group('StorageUploadCubit', () {
    test(
      'enqueue dodaje plik do kolejki i wykonuje pełny cykl uploadu',
      () async {
        final ticket = StorageUploadTicketResponse(
          fileId: 'file-99',
          storageObjectKey: 'k99',
          uploadUrl: 'https://minio.local/upload',
          expiresAtUtc: DateTime.utc(2026, 9, 9, 13),
          isAlreadyUploaded: false,
        );

        when(() => repository.requestUploadTicket(any()))
            .thenAnswer((_) async => right(ticket));

        when(
          () => uploadTransport.upload(
            ticket: any(named: 'ticket'),
            input: any(named: 'input'),
            cancelToken: any(named: 'cancelToken'),
            onProgress: any(named: 'onProgress'),
          ),
        ).thenAnswer((_) async => right(unit));

        when(
          () => repository.completeUpload(
            fileId: 'file-99',
            fileSizeBytes: 100,
          ),
        ).thenAnswer((_) async => right(sampleFile));

        final cubit = StorageUploadCubit(
          repository: repository,
          uploadTransport: uploadTransport,
        );

        expect(cubit.state.items.isEmpty, isTrue);

        cubit.enqueue(
          [
            StorageUploadInput(
              name: 'plik.pdf',
              size: 100,
              bytes: Uint8List.fromList([1, 2, 3]),
            ),
          ],
          const StorageScope.personal(),
        );

        // Poczekaj na asynchroniczne zakończenie przetwarzania kolejki
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(cubit.state.items.length, equals(1));
        expect(
          cubit.state.items.first.status,
          equals(StorageUploadItemStatus.done),
        );
        expect(cubit.state.completedCount, equals(1));

        await cubit.close();
      },
    );

    test('upload prywatny używa typu Private, nie Document', () async {
      final ticket = StorageUploadTicketResponse(
        fileId: 'file-private',
        storageObjectKey: 'private',
        uploadUrl: 'https://minio.local/upload',
        expiresAtUtc: now.add(const Duration(hours: 1)),
        isAlreadyUploaded: false,
      );
      when(() => repository.requestUploadTicket(any()))
          .thenAnswer((_) async => right(ticket));
      when(
        () => uploadTransport.upload(
          ticket: any(named: 'ticket'),
          input: any(named: 'input'),
          cancelToken: any(named: 'cancelToken'),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((_) async => right(unit));
      when(
        () => repository.completeUpload(
          fileId: 'file-private',
          fileSizeBytes: 3,
        ),
      ).thenAnswer((_) async => right(sampleFile));
      final cubit = StorageUploadCubit(
        repository: repository,
        uploadTransport: uploadTransport,
      );

      cubit.enqueue(
        [
          StorageUploadInput(
            name: 'private.txt',
            size: 3,
            bytes: Uint8List.fromList([1, 2, 3]),
          ),
        ],
        const StorageScope.personal(),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final captured =
          verify(
                () => repository.requestUploadTicket(captureAny()),
              ).captured.single
              as StorageUploadTicketPayload;
      expect(captured.resourceType, StorageResourceType.privateFile);
      await cubit.close();
    });
  });
}
