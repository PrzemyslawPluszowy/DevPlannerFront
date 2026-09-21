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
}
