import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/attachments/chat_attachment_access_port_adapter.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockStorageRepository extends Mock implements StorageRepository {}

final class _MockDownloadTransport extends Mock implements DownloadTransport {}

void main() {
  late _MockStorageRepository storageRepository;
  late _MockDownloadTransport downloadTransport;
  late ChatAttachmentAccessPortAdapter adapter;

  final ticket = StorageDownloadTicketResponse(
    fileId: 'file-1',
    originalFileName: 'brief.pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 3,
    downloadUrl: 'https://storage.example/files/file-1',
    expiresAtUtc: DateTime.utc(2026, 9, 22, 12),
  );

  setUpAll(() {
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    storageRepository = _MockStorageRepository();
    downloadTransport = _MockDownloadTransport();
    adapter = ChatAttachmentAccessPortAdapter(
      storageRepository: storageRepository,
      downloadTransport: downloadTransport,
    );
  });

  test('bilet Storage jest przekazywany do transportu platformy', () async {
    when(
      () => storageRepository.getDownloadTicket('file-1'),
    ).thenAnswer((_) async => Right(ticket));
    when(
      () => downloadTransport.downloadUrl(
        downloadUrl: any(named: 'downloadUrl'),
        fileName: any(named: 'fileName'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) async => const Right(unit));

    final failure = await adapter.open('file-1');

    expect(failure, isNull);
    verify(
      () => downloadTransport.downloadUrl(
        downloadUrl: 'https://storage.example/files/file-1',
        fileName: 'brief.pdf',
      ),
    ).called(1);
  });

  test(
    'odmowa biletu nie uruchamia transportu i zwraca kod z serwera',
    () async {
      when(() => storageRepository.getDownloadTicket('file-1')).thenAnswer(
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.forbidden,
            message: 'Brak uprawnień do pliku.',
            apiCode: 'storage_file_forbidden',
            traceId: 'trace-7',
          ),
        ),
      );

      final failure = await adapter.open('file-1');

      expect(failure?.code, 'storage_file_forbidden');
      expect(failure?.message, 'Brak uprawnień do pliku.');
      expect(failure?.traceId, 'trace-7');
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
    'porażka zapisu na urządzeniu wraca jako porażka z komunikatem',
    () async {
      when(
        () => storageRepository.getDownloadTicket('file-1'),
      ).thenAnswer((_) async => Right(ticket));
      when(
        () => downloadTransport.downloadUrl(
          downloadUrl: any(named: 'downloadUrl'),
          fileName: any(named: 'fileName'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.connection,
            message: 'Nie można zapisać pliku.',
          ),
        ),
      );

      final failure = await adapter.open('file-1');

      expect(failure?.message, 'Nie można zapisać pliku.');
    },
  );

  test('miniatura obrazu wraca jako bajty pobrane z biletu', () async {
    when(
      () => storageRepository.getDownloadTicket('file-1'),
    ).thenAnswer((_) async => Right(ticket));
    when(
      () => downloadTransport.fetchBytes(
        downloadUrl: any(named: 'downloadUrl'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) async => Right(Uint8List.fromList([1, 2, 3])));

    final bytes = await adapter.thumbnail('file-1');

    expect(bytes, [1, 2, 3]);
  });

  test('brak biletu nie pobiera bajtów miniatury', () async {
    when(() => storageRepository.getDownloadTicket('file-1')).thenAnswer(
      (_) async => const Left(
        ApiError(type: ApiErrorType.notFound, message: 'Nie ma pliku.'),
      ),
    );

    expect(await adapter.thumbnail('file-1'), isNull);
    verifyNever(
      () => downloadTransport.fetchBytes(
        downloadUrl: any(named: 'downloadUrl'),
        headers: any(named: 'headers'),
      ),
    );
  });

  test('porażka pobrania bajtów wraca jako brak miniatury', () async {
    when(
      () => storageRepository.getDownloadTicket('file-1'),
    ).thenAnswer((_) async => Right(ticket));
    when(
      () => downloadTransport.fetchBytes(
        downloadUrl: any(named: 'downloadUrl'),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer(
      (_) async => const Left(
        ApiError(type: ApiErrorType.connection, message: 'Brak sieci.'),
      ),
    );

    expect(await adapter.thumbnail('file-1'), isNull);
  });
}
