import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  final now = DateTime.utc(2026, 9, 9, 12);

  StorageFileResponse file({
    required String name,
    required String extension,
    required String mimeType,
    bool canPreview = true,
  }) => StorageFileResponse(
    id: 'file-${name.hashCode}',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: name,
    extension: extension,
    mimeType: mimeType,
    fileSizeBytes: 100,
    version: 1,
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    createdAtUtc: now,
    updatedAtUtc: now,
    isDeleted: false,
    processingStatus: StorageProcessingStatus.ready,
    scanStatus: StorageScanStatus.clean,
    aiStatus: StorageAiStatus.none,
    canRead: true,
    canPreview: canPreview,
  );

  group('StoragePreviewCubit.resolveKind', () {
    test('rozpoznaje obrazy JPEG po rozszerzeniu przy generycznym MIME', () {
      expect(
        StoragePreviewCubit.resolveKind(
          file(
            name: 'photo.jpg',
            extension: '.jpg',
            mimeType: 'application/octet-stream',
          ),
        ),
        StoragePreviewKind.image,
      );
      expect(
        StoragePreviewCubit.resolveKind(
          file(
            name: 'photo.jpeg',
            extension: 'jpeg',
            mimeType: 'application/octet-stream',
          ),
        ),
        StoragePreviewKind.image,
      );
    });

    test('rozpoznaje PDF oraz MP3 po rozszerzeniu przy generycznym MIME', () {
      expect(
        StoragePreviewCubit.resolveKind(
          file(
            name: 'report.pdf',
            extension: 'pdf',
            mimeType: 'application/octet-stream',
          ),
        ),
        StoragePreviewKind.pdf,
      );
      expect(
        StoragePreviewCubit.resolveKind(
          file(
            name: 'recording.mp3',
            extension: '.mp3',
            mimeType: 'application/octet-stream',
          ),
        ),
        StoragePreviewKind.audio,
      );
    });

    test('ignoruje parametry MIME i respektuje brak uprawnienia preview', () {
      expect(
        StoragePreviewCubit.resolveKind(
          file(
            name: 'photo.jpg',
            extension: 'bin',
            mimeType: 'image/jpeg; charset=binary',
          ),
        ),
        StoragePreviewKind.image,
      );
      expect(
        StoragePreviewCubit.resolveKind(
          file(
            name: 'photo.jpg',
            extension: 'jpg',
            mimeType: 'application/octet-stream',
            canPreview: false,
          ),
        ),
        StoragePreviewKind.unsupported,
      );
    });
  });

  blocTest<StoragePreviewCubit, StoragePreviewState>(
    'używa inline previewUrl zamiast URL-u wymuszającego pobieranie',
    build: () {
      final repository = _MockStorageRepository();
      final previewFile = file(
        name: 'report.pdf',
        extension: 'pdf',
        mimeType: 'application/pdf',
      );
      when(() => repository.getDownloadTicket(previewFile.id)).thenAnswer(
        (_) async => right(
          StorageDownloadTicketResponse(
            fileId: previewFile.id,
            originalFileName: previewFile.originalFileName,
            mimeType: previewFile.mimeType,
            fileSizeBytes: previewFile.fileSizeBytes,
            downloadUrl: 'https://storage.test/report.pdf?attachment=1',
            previewUrl: 'https://storage.test/report.pdf?inline=1',
            expiresAtUtc: now.add(const Duration(hours: 2)),
          ),
        ),
      );
      return StoragePreviewCubit(repository: repository);
    },
    act: (cubit) => cubit.preparePreview(
      file(name: 'report.pdf', extension: 'pdf', mimeType: 'application/pdf'),
    ),
    expect: () => [
      isA<StoragePreviewLoading>(),
      isA<StoragePreviewReady>()
          .having((state) => state.kind, 'kind', StoragePreviewKind.pdf)
          .having(
            (state) => state.previewUrl,
            'previewUrl',
            'https://storage.test/report.pdf?inline=1',
          ),
    ],
  );
}
