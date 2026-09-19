import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_read_only_file_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _RepositoryMock extends Mock implements StorageRepository {}

final class _DownloadTransportFake implements DownloadTransport {
  String? url;
  String? fileName;

  @override
  Future<Either<ApiError, Unit>> downloadUrl({
    required String downloadUrl,
    required String fileName,
    Map<String, String>? headers,
  }) async {
    url = downloadUrl;
    this.fileName = fileName;
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

StorageFileResponse _file({bool canDownload = true}) {
  final now = DateTime.utc(2026, 9, 18);
  return StorageFileResponse(
    id: 'file-1',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'raport.pdf',
    extension: 'pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 10,
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
    canDownload: canDownload,
  );
}

void main() {
  testWidgets('desktopowy przycisk pobiera bilet i zapisuje plik', (
    tester,
  ) async {
    final repository = _RepositoryMock();
    final transport = _DownloadTransportFake();
    when(() => repository.getDownloadTicket('file-1')).thenAnswer(
      (_) async => right(
        StorageDownloadTicketResponse(
          fileId: 'file-1',
          originalFileName: 'raport.pdf',
          mimeType: 'application/pdf',
          fileSizeBytes: 10,
          downloadUrl: 'https://minio.test/report',
          expiresAtUtc: DateTime.utc(2026, 9, 18, 12),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (_) => StorageFileMutationCubit(
            repository: repository,
            downloadTransport: transport,
          ),
          child: Scaffold(
            body: StorageReadOnlyFileTile(
              file: _file(),
              canDelete: false,
              canDownload: true,
              onOpen: () {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('download-file-file-1')));
    await tester.pump();

    verify(() => repository.getDownloadTicket('file-1')).called(1);
    expect(transport.url, 'https://minio.test/report');
    expect(transport.fileName, 'raport.pdf');
  });

  testWidgets('BFF/read-only nie renderuje akcji pobierania', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StorageReadOnlyFileTile(
            file: _file(),
            canDelete: false,
            canDownload: false,
            onOpen: () {},
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('download-file-file-1')), findsNothing);
  });

  test('odmowa biletu pozostaje typowanym stanem błędu', () async {
    final repository = _RepositoryMock();
    final transport = _DownloadTransportFake();
    when(() => repository.getDownloadTicket('file-1')).thenAnswer(
      (_) async => left(
        const ApiError(
          type: ApiErrorType.forbidden,
          message: 'Brak uprawnień',
          statusCode: 403,
        ),
      ),
    );
    final cubit = StorageFileMutationCubit(
      repository: repository,
      downloadTransport: transport,
    );
    await cubit.downloadFile(_file());

    expect(cubit.state, isA<StorageFileMutationFailure>());
    expect((cubit.state as StorageFileMutationFailure).statusCode, 403);
    expect(transport.url, isNull);
    await cubit.close();
  });
}
