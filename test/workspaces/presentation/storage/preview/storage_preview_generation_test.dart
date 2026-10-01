import 'dart:async';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Repository extends Mock implements StorageRepository {}

void main() {
  final now = DateTime.utc(2026, 9, 20);

  final file = StorageFileResponse(
    id: 'file-1',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'raport.pdf',
    extension: 'pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 4096,
    version: 3,
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    createdAtUtc: now,
    updatedAtUtc: now,
    isDeleted: false,
    processingStatus: StorageProcessingStatus.ready,
    scanStatus: StorageScanStatus.clean,
    aiStatus: StorageAiStatus.none,
    accessLevel: StorageEffectiveAccessLevel.owner,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
    canPreview: true,
    canDownload: true,
    canManageVersions: true,
  );

  test('late ticket cannot replace a newer preview', () async {
    final repository = _Repository();
    final old = Completer<Either<ApiError, StorageDownloadTicketResponse>>();
    when(() => repository.getDownloadTicket('file-1'))
        .thenAnswer((_) => old.future);
    when(() => repository.getDownloadTicket('file-2')).thenAnswer(
      (_) async => const Left(
        ApiError(type: ApiErrorType.server, message: 'latest failure'),
      ),
    );
    final cubit = StoragePreviewCubit(repository: repository);
    final pending = cubit.preparePreview(file);
    await cubit.preparePreview(file.copyWith(id: 'file-2'));
    old.complete(
      const Left(ApiError(type: ApiErrorType.server, message: 'old failure')),
    );
    await pending;
    expect((cubit.state as StoragePreviewFailure).file.id, 'file-2');
    expect((cubit.state as StoragePreviewFailure).message, 'latest failure');
    await cubit.close();
  });

  test('late image bytes cannot replace a newer version failure', () async {
    final repository = _Repository();
    final bytes = Completer<Either<ApiError, Uint8List>>();
    final image = file.copyWith(mimeType: 'image/png', extension: 'png');
    when(() => repository.getDownloadTicket('file-1')).thenAnswer(
      (_) async => Right(
        StorageDownloadTicketResponse(
          fileId: 'file-1',
          originalFileName: 'image.png',
          mimeType: 'image/png',
          fileSizeBytes: 2,
          downloadUrl: 'https://files.example/image',
          expiresAtUtc: now,
        ),
      ),
    );
    when(() => repository.readPreviewImageBytes(fileId: 'file-1'))
        .thenAnswer((_) => bytes.future);
    when(
      () =>
          repository.getFileVersionDownloadTicket(fileId: 'file-1', version: 2),
    ).thenAnswer(
      (_) async => const Left(
        ApiError(type: ApiErrorType.notFound, message: 'version removed'),
      ),
    );
    final cubit = StoragePreviewCubit(repository: repository);
    final pending = cubit.preparePreview(image);
    await Future<void>.delayed(Duration.zero);
    verify(() => repository.readPreviewImageBytes(fileId: 'file-1')).called(1);
    await cubit.prepareVersionPreview(file: image, version: 2);
    bytes.complete(Right(Uint8List.fromList([1, 2])));
    await pending;
    expect(cubit.state, isA<StoragePreviewFailure>());
    expect((cubit.state as StoragePreviewFailure).message, 'version removed');
    await cubit.close();
  });

  test(
    'closed preview rejects new loads without touching repository',
    () async {
      final repository = _Repository();
      final cubit = StoragePreviewCubit(repository: repository);
      await cubit.close();
      await cubit.preparePreview(file);
      await cubit.prepareVersionPreview(file: file, version: 2);
      verifyNever(() => repository.getDownloadTicket(any()));
      verifyNever(
        () => repository.getFileVersionDownloadTicket(
          fileId: any(named: 'fileId'),
          version: any(named: 'version'),
        ),
      );
    },
  );
  test('retry keeps typed diagnostics and failed historical version', () async {
    final repository = _Repository();
    const failure = ApiError(
      type: ApiErrorType.server,
      message: 'version unavailable',
      statusCode: 503,
      apiCode: 'preview.busy',
      contractCode: 'storage.busy',
      traceId: 'trace-test',
      fields: {
        'version': ['retry later'],
      },
    );
    when(
      () =>
          repository.getFileVersionDownloadTicket(fileId: 'file-1', version: 2),
    ).thenAnswer((_) async => const Left(failure));
    final cubit = StoragePreviewCubit(repository: repository);
    await cubit.prepareVersionPreview(file: file, version: 2);
    expect((cubit.state as StoragePreviewFailure).error, same(failure));
    expect((cubit.state as StoragePreviewFailure).version, 2);
    await cubit.retry();
    verify(
      () =>
          repository.getFileVersionDownloadTicket(fileId: 'file-1', version: 2),
    ).called(2);
    verifyNever(() => repository.getDownloadTicket(any()));
    await cubit.close();
  });

  test('retry never bypasses server Retry-After', () async {
    final repository = _Repository();
    final failure = ApiError(
      type: ApiErrorType.badResponse,
      message: 'rate limit',
      statusCode: 429,
      retryAfterUtc: DateTime.now().toUtc().add(const Duration(minutes: 1)),
    );
    when(() => repository.getDownloadTicket('file-1'))
        .thenAnswer((_) async => Left(failure));
    final cubit = StoragePreviewCubit(repository: repository);
    await cubit.preparePreview(file);
    await cubit.retry();
    verify(() => repository.getDownloadTicket('file-1')).called(1);
    expect((cubit.state as StoragePreviewFailure).error, same(failure));
    await cubit.close();
  });
}
