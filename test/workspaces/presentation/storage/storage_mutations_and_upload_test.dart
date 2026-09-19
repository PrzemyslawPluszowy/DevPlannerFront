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
        await cubit.retry();
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
