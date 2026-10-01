import 'dart:async';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/cubit/storage_versions_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/cubit/storage_versions_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _RepositoryMock extends Mock implements StorageRepository {}

final class _DownloadTransportFake implements DownloadTransport {
  String? downloadedUrl;

  @override
  Future<Either<ApiError, Unit>> downloadUrl({
    required String downloadUrl,
    required String fileName,
    Map<String, String>? headers,
  }) async {
    downloadedUrl = downloadUrl;
    return right(unit);
  }

  @override
  Future<Either<ApiError, Uint8List>> fetchBytes({
    required String downloadUrl,
    Map<String, String>? headers,
  }) async => right(Uint8List(0));

  @override
  Future<Either<ApiError, Unit>> saveBytes({
    required List<int> bytes,
    required String fileName,
  }) async => right(unit);
}

StorageFileResponse _file({bool canManageVersions = true}) {
  final now = DateTime.utc(2026, 9, 18);
  return StorageFileResponse(
    id: 'file-1',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'raport.pdf',
    extension: 'pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 10,
    version: 3,
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    createdAtUtc: now,
    updatedAtUtc: now,
    isDeleted: false,
    processingStatus: StorageProcessingStatus.ready,
    scanStatus: StorageScanStatus.clean,
    aiStatus: StorageAiStatus.none,
    canRead: true,
    canManageVersions: canManageVersions,
  );
}

StorageFileVersionResponse _version(int number) => StorageFileVersionResponse(
  id: 'version-$number',
  version: number,
  fileSizeBytes: 10,
  createdByUserId: 'user-1',
  createdAtUtc: DateTime.utc(2026, 9, 18, number),
  isCurrent: number == 3,
);

void main() {
  test('cubit listuje, pobiera i przywraca przez repozytorium', () async {
    final repository = _RepositoryMock();
    final transport = _DownloadTransportFake();
    when(() => repository.listFileVersions('file-1')).thenAnswer(
      (_) async => right([_version(3), _version(2)]),
    );
    when(
      () => repository.getFileVersionDownloadTicket(
        fileId: 'file-1',
        version: 2,
      ),
    ).thenAnswer(
      (_) async => right(
        StorageFileVersionDownloadTicketResponse(
          fileId: 'file-1',
          version: 2,
          originalFileName: 'raport.pdf',
          mimeType: 'application/pdf',
          fileSizeBytes: 10,
          downloadUrl: 'https://minio.test/v2',
          expiresAtUtc: DateTime.utc(2026, 9, 18, 12),
        ),
      ),
    );
    when(
      () => repository.restoreFileVersion(
        fileId: 'file-1',
        version: 2,
        expectedVersion: 3,
      ),
    ).thenAnswer((_) async => right(_file()));

    final cubit = StorageVersionsCubit(
      fileId: 'file-1',
      fileName: 'raport.pdf',
      expectedVersion: 3,
      repository: repository,
      downloadTransport: transport,
    );
    await cubit.load();
    expect(cubit.state, isA<StorageVersionsReady>());
    await cubit.download(2);
    expect(transport.downloadedUrl, 'https://minio.test/v2');
    expect(await cubit.restore(2), isTrue);
    verify(() => repository.listFileVersions('file-1')).called(1);
    verify(
      () => repository.restoreFileVersion(
        fileId: 'file-1',
        version: 2,
        expectedVersion: 3,
      ),
    ).called(1);
    await cubit.close();
  });

  test('cubit zachowuje typowany błąd ACL i nie pobiera transportem', () async {
    final repository = _RepositoryMock();
    final transport = _DownloadTransportFake();
    when(() => repository.listFileVersions('file-1')).thenAnswer(
      (_) async => left(
        const ApiError(
          type: ApiErrorType.forbidden,
          statusCode: 403,
          message: 'Brak uprawnień',
        ),
      ),
    );
    final cubit = StorageVersionsCubit(
      fileId: 'file-1',
      fileName: 'raport.pdf',
      expectedVersion: 3,
      repository: repository,
      downloadTransport: transport,
    );
    await cubit.load();
    expect(cubit.state, isA<StorageVersionsFailure>());
    expect((cubit.state as StorageVersionsFailure).message, 'Brak uprawnień');
    expect(transport.downloadedUrl, isNull);
    await cubit.close();
  });

  test('restore i delete zachowują pełny błąd oraz historię wersji', () async {
    final repository = _RepositoryMock();
    final transport = _DownloadTransportFake();
    final error = ApiError(
      type: ApiErrorType.conflict,
      message: 'Wersja zmieniła się na serwerze.',
      statusCode: 409,
      backendCode: 83,
      apiCode: 'storage.version_conflict',
      contractCode: 'storage.version_conflict',
      fields: const {
        'expectedVersion': ['Odśwież historię.'],
      },
      traceId: 'version-mutation-trace',
      retryAfterUtc: DateTime.utc(2026, 1, 2),
    );
    when(() => repository.listFileVersions('file-1')).thenAnswer(
      (_) async => right([_version(3), _version(2)]),
    );
    when(
      () => repository.restoreFileVersion(
        fileId: 'file-1',
        version: 2,
        expectedVersion: 3,
      ),
    ).thenAnswer((_) async => left(error));
    when(
      () => repository.deleteFileVersion(
        fileId: 'file-1',
        version: 2,
        expectedVersion: 3,
      ),
    ).thenAnswer((_) async => left(error));

    final cubit = StorageVersionsCubit(
      fileId: 'file-1',
      fileName: 'raport.pdf',
      expectedVersion: 3,
      repository: repository,
      downloadTransport: transport,
    );
    await cubit.load();

    expect(await cubit.restore(2), isFalse);
    var ready = cubit.state as StorageVersionsReady;
    expect(ready.apiError, error);
    expect(ready.errorOperation, StorageVersionsErrorOperation.restore);
    expect(ready.busyVersion, isNull);
    expect(ready.versions, [_version(3), _version(2)]);

    expect(await cubit.delete(2), isFalse);
    ready = cubit.state as StorageVersionsReady;
    expect(ready.apiError, error);
    expect(ready.errorOperation, StorageVersionsErrorOperation.delete);
    expect(ready.busyVersion, isNull);
    expect(ready.versions, [_version(3), _version(2)]);
    verify(
      () => repository.restoreFileVersion(
        fileId: 'file-1',
        version: 2,
        expectedVersion: 3,
      ),
    ).called(1);
    verify(
      () => repository.deleteFileVersion(
        fileId: 'file-1',
        version: 2,
        expectedVersion: 3,
      ),
    ).called(1);
    await cubit.close();
  });

  test(
    'busy version blocks duplicate restore and close drops stale result',
    () async {
      final repository = _RepositoryMock();
      final transport = _DownloadTransportFake();
      final response = Completer<Either<ApiError, StorageFileResponse>>();
      when(() => repository.listFileVersions('file-1')).thenAnswer(
        (_) async => right([_version(3), _version(2)]),
      );
      when(
        () => repository.restoreFileVersion(
          fileId: 'file-1',
          version: 2,
          expectedVersion: 3,
        ),
      ).thenAnswer((_) => response.future);

      final cubit = StorageVersionsCubit(
        fileId: 'file-1',
        fileName: 'raport.pdf',
        expectedVersion: 3,
        repository: repository,
        downloadTransport: transport,
      );
      await cubit.load();
      final first = cubit.restore(2);
      expect(await cubit.restore(2), isFalse);
      expect((cubit.state as StorageVersionsReady).busyVersion, 2);
      await cubit.load();
      verify(
        () => repository.restoreFileVersion(
          fileId: 'file-1',
          version: 2,
          expectedVersion: 3,
        ),
      ).called(1);
      verify(() => repository.listFileVersions('file-1')).called(1);

      await cubit.close();
      response.complete(
        left(
          const ApiError(
            type: ApiErrorType.conflict,
            message: 'Stale response after close.',
            statusCode: 409,
          ),
        ),
      );
      expect(await first, isFalse);
    },
  );

  test('Retry-After blocks mutation, download, and refresh requests', () async {
    final repository = _RepositoryMock();
    final transport = _DownloadTransportFake();
    final retryError = ApiError(
      type: ApiErrorType.badResponse,
      message: 'Wait before retrying.',
      statusCode: 429,
      apiCode: 'storage.rate_limited',
      retryAfterUtc: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );
    when(() => repository.listFileVersions('file-1')).thenAnswer(
      (_) async => right([_version(3), _version(2)]),
    );
    when(
      () => repository.restoreFileVersion(
        fileId: 'file-1',
        version: 2,
        expectedVersion: 3,
      ),
    ).thenAnswer((_) async => left(retryError));

    final cubit = StorageVersionsCubit(
      fileId: 'file-1',
      fileName: 'raport.pdf',
      expectedVersion: 3,
      repository: repository,
      downloadTransport: transport,
    );
    await cubit.load();
    expect(await cubit.restore(2), isFalse);
    expect(await cubit.delete(2), isFalse);
    expect(await cubit.downloadWithFeedback(2), retryError);
    await cubit.load();

    final ready = cubit.state as StorageVersionsReady;
    expect(ready.apiError, retryError);
    expect(ready.isRefreshing, isFalse);
    verify(() => repository.listFileVersions('file-1')).called(1);
    verifyNever(
      () => repository.deleteFileVersion(
        fileId: any(named: 'fileId'),
        version: any(named: 'version'),
        expectedVersion: any(named: 'expectedVersion'),
      ),
    );
    verifyNever(
      () => repository.getFileVersionDownloadTicket(
        fileId: any(named: 'fileId'),
        version: any(named: 'version'),
      ),
    );
    await cubit.close();
  });
  test('thrown load error leaves a typed recoverable state', () async {
    final repository = _RepositoryMock();
    const error = ApiError(
      type: ApiErrorType.server,
      message: 'Versions unavailable',
      statusCode: 503,
      contractCode: 'storage.versions_unavailable',
      traceId: 'versions-load-trace',
    );
    when(() => repository.listFileVersions('file-1')).thenAnswer(
      (_) => Future.error(error),
    );
    final cubit = StorageVersionsCubit(
      fileId: 'file-1',
      fileName: 'file.pdf',
      expectedVersion: 3,
      repository: repository,
      downloadTransport: _DownloadTransportFake(),
    );
    addTearDown(cubit.close);
    await cubit.load();
    expect(cubit.state, isA<StorageVersionsFailure>());
    expect((cubit.state as StorageVersionsFailure).apiError, error);
    when(() => repository.listFileVersions('file-1')).thenAnswer(
      (_) async => right([_version(3)]),
    );
    await cubit.load();
    expect(cubit.state, isA<StorageVersionsReady>());
  });

  for (final restore in [true, false]) {
    test(
      'thrown mutation retains history and clears busy (restore=$restore)',
      () async {
        final repository = _RepositoryMock();
        const error = ApiError(
          type: ApiErrorType.conflict,
          message: 'Version changed',
          statusCode: 409,
          contractCode: 'storage.version_conflict',
          traceId: 'versions-mutation-trace',
          fields: {
            'expectedVersion': ['Refresh history'],
          },
        );
        when(() => repository.listFileVersions('file-1')).thenAnswer(
          (_) async => right([_version(3), _version(2)]),
        );
        when(
          () => repository.restoreFileVersion(
            fileId: 'file-1',
            version: 2,
            expectedVersion: 3,
          ),
        ).thenAnswer((_) => Future.error(error));
        when(
          () => repository.deleteFileVersion(
            fileId: 'file-1',
            version: 2,
            expectedVersion: 3,
          ),
        ).thenAnswer((_) => Future.error(error));
        final cubit = StorageVersionsCubit(
          fileId: 'file-1',
          fileName: 'file.pdf',
          expectedVersion: 3,
          repository: repository,
          downloadTransport: _DownloadTransportFake(),
        );
        addTearDown(cubit.close);
        await cubit.load();
        expect(await (restore ? cubit.restore(2) : cubit.delete(2)), false);
        final state = cubit.state as StorageVersionsReady;
        expect(state.versions.map((version) => version.version), [3, 2]);
        expect(state.busyVersion, isNull);
        expect(state.apiError, error);
        expect(
          state.errorOperation,
          restore
              ? StorageVersionsErrorOperation.restore
              : StorageVersionsErrorOperation.delete,
        );
      },
    );
  }
  test(
    'version download reports busy and canceled instead of success',
    () async {
      final repository = _RepositoryMock();
      final transport = _DownloadTransportFake();
      final pending =
          Completer<
            Either<ApiError, StorageFileVersionDownloadTicketResponse>
          >();
      when(() => repository.listFileVersions('file-1')).thenAnswer(
        (_) async => right([_version(3), _version(2)]),
      );
      when(
        () => repository.getFileVersionDownloadTicket(
          fileId: 'file-1',
          version: 2,
        ),
      ).thenAnswer((_) => pending.future);
      final cubit = StorageVersionsCubit(
        fileId: 'file-1',
        fileName: 'file.pdf',
        expectedVersion: 3,
        repository: repository,
        downloadTransport: transport,
      );
      await cubit.load();
      final first = cubit.downloadWithFeedback(2);
      final busy = await cubit.downloadWithFeedback(2);
      await cubit.close();
      pending.complete(
        right(
          StorageFileVersionDownloadTicketResponse(
            fileId: 'file-1',
            version: 2,
            originalFileName: 'file.pdf',
            mimeType: 'application/pdf',
            fileSizeBytes: 10,
            downloadUrl: 'https://minio.test/late',
            expiresAtUtc: DateTime.utc(2026, 10, 2),
          ),
        ),
      );
      final canceled = await first;
      expect(busy?.apiCode, 'storage.action_busy');
      expect(canceled?.apiCode, 'storage.action_canceled');
      expect(transport.downloadedUrl, isNull);
      verify(
        () => repository.getFileVersionDownloadTicket(
          fileId: 'file-1',
          version: 2,
        ),
      ).called(1);
    },
  );

  test('closed version owner returns cancellation without a request', () async {
    final repository = _RepositoryMock();
    final cubit = StorageVersionsCubit(
      fileId: 'file-1',
      fileName: 'file.pdf',
      expectedVersion: 3,
      repository: repository,
      downloadTransport: _DownloadTransportFake(),
    );
    await cubit.close();
    final error = await cubit.downloadWithFeedback(2);
    expect(error?.apiCode, 'storage.action_canceled');
    verifyNever(
      () => repository.getFileVersionDownloadTicket(
        fileId: 'file-1',
        version: 2,
      ),
    );
  });
}
