import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_models.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/domain/storage/ports/download_transport.dart';
import 'package:ready_next/workspaces/presentation/storage/public_share/cubit/storage_public_share_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/public_share/cubit/storage_public_share_state.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

class _MockDownloadTransport extends Mock implements DownloadTransport {}

void main() {
  late _MockStorageRepository repository;
  late _MockDownloadTransport downloadTransport;

  setUp(() {
    repository = _MockStorageRepository();
    downloadTransport = _MockDownloadTransport();
  });

  blocTest<StoragePublicShareCubit, StoragePublicShareState>(
    'exchanges trimmed password and downloads the issued ticket',
    setUp: () {
      when(
        () => repository.getPublicShareDownloadTicket(
          shareToken: 'share-token',
          password: 'secret',
        ),
      ).thenAnswer(
        (_) async => Right(
          StorageDownloadTicketResponse(
            fileId: 'file-1',
            originalFileName: 'report.pdf',
            mimeType: 'application/pdf',
            fileSizeBytes: 42,
            downloadUrl: 'https://files.example/ticket',
            expiresAtUtc: DateTime.utc(2030),
          ),
        ),
      );
      when(
        () => downloadTransport.downloadUrl(
          downloadUrl: 'https://files.example/ticket',
          fileName: 'report.pdf',
        ),
      ).thenAnswer((_) async => const Right(unit));
    },
    build: () => StoragePublicShareCubit(
      shareToken: 'share-token',
      repository: repository,
      downloadTransport: downloadTransport,
    ),
    act: (cubit) => cubit.download(password: '  secret  '),
    expect: () => const [
      StoragePublicShareLoading(),
      StoragePublicShareSuccess('report.pdf'),
    ],
  );

  blocTest<StoragePublicShareCubit, StoragePublicShareState>(
    'does not start a download when the public exchange fails',
    setUp: () {
      when(
        () => repository.getPublicShareDownloadTicket(
          shareToken: 'share-token',
        ),
      ).thenAnswer(
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.forbidden,
            message: 'Invalid password.',
            backendCode: 403,
          ),
        ),
      );
    },
    build: () => StoragePublicShareCubit(
      shareToken: 'share-token',
      repository: repository,
      downloadTransport: downloadTransport,
    ),
    act: (cubit) => cubit.download(password: '   '),
    expect: () => const [
      StoragePublicShareLoading(),
      StoragePublicShareFailure(message: 'Invalid password.', code: '403'),
    ],
    verify: (_) => verifyNever(
      () => downloadTransport.downloadUrl(
        downloadUrl: any(named: 'downloadUrl'),
        fileName: any(named: 'fileName'),
      ),
    ),
  );
}
