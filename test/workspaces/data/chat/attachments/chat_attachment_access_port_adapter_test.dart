import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/attachments/chat_attachment_access_port_adapter.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retrofit/dio.dart';

final class _MockStorageRepository extends Mock implements StorageRepository {}

final class _MockDownloadTransport extends Mock implements DownloadTransport {}

final class _MockChatApi extends Mock implements ChatApi {}

void main() {
  late _MockStorageRepository storageRepository;
  late _MockDownloadTransport downloadTransport;
  late _MockChatApi chatApi;
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
    chatApi = _MockChatApi();
    adapter = ChatAttachmentAccessPortAdapter(
      storageRepository: storageRepository,
      downloadTransport: downloadTransport,
      chatApi: chatApi,
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
    'zapisuje kopię przez kontrakt Chat i zwraca możliwości edycji',
    () async {
      when(
        () => chatApi.saveAttachmentToStorage('message-1', 'file-1'),
      ).thenAnswer(
        (_) async => const SaveChatAttachmentToStorageResponse(
          storageFileId: 'private-copy',
          fileName: 'brief.pdf',
          mimeType: 'application/pdf',
          fileSizeBytes: 3,
          canEditOnline: true,
        ),
      );

      final result = await adapter.saveToStorage(
        messageId: 'message-1',
        storageFileId: 'file-1',
      );

      expect(result.succeeded, isTrue);
      expect(result.storageFileId, 'private-copy');
      expect(result.canEditOnline, isTrue);
      verify(
        () => chatApi.saveAttachmentToStorage('message-1', 'file-1'),
      ).called(1);
    },
  );

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

  test(
    'wyjątek transportu otwierania zamienia się w stabilny błąd portu',
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
      ).thenThrow(UnsupportedError('platform transport unavailable'));

      final failure = await adapter.open('file-1');

      expect(failure?.code, 'chat.attachment.open_failed');
      expect(failure?.message, isEmpty);
    },
  );

  test('wyjątek podczas pobierania biletu nie wydostaje się z portu', () async {
    when(
      () => storageRepository.getDownloadTicket('file-1'),
    ).thenThrow(StateError('unexpected repository failure'));

    final failure = await adapter.open('file-1');

    expect(failure?.code, 'chat.attachment.open_failed');
    verifyNever(
      () => downloadTransport.downloadUrl(
        downloadUrl: any(named: 'downloadUrl'),
        fileName: any(named: 'fileName'),
        headers: any(named: 'headers'),
      ),
    );
  });

  test('miniatura obrazu wraca z autoryzowanego endpointu Chat', () async {
    when(
      () => chatApi.getAttachmentThumbnail('message-1', 'file-1'),
    ).thenAnswer(
      (_) async => HttpResponse<List<int>>(
        [1, 2, 3],
        Response<List<int>>(
          requestOptions: RequestOptions(path: '/thumbnail'),
        ),
      ),
    );

    final bytes = await adapter.thumbnail(
      messageId: 'message-1',
      storageFileId: 'file-1',
    );

    expect(bytes, [1, 2, 3]);
    verify(() => chatApi.getAttachmentThumbnail('message-1', 'file-1'))
        .called(1);
  });

  test('błąd miniatury nie pobiera oryginału przez Storage', () async {
    when(() => chatApi.getAttachmentThumbnail('message-1', 'file-1')).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/thumbnail')),
    );

    expect(
      await adapter.thumbnail(messageId: 'message-1', storageFileId: 'file-1'),
      isNull,
    );
    verifyNever(() => storageRepository.getDownloadTicket('file-1'));
  });

  test('błąd HTTP miniatury zwraca brak podglądu', () async {
    when(() => chatApi.getAttachmentThumbnail('message-1', 'file-1')).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/thumbnail'),
        type: DioExceptionType.connectionError,
      ),
    );

    expect(
      await adapter.thumbnail(messageId: 'message-1', storageFileId: 'file-1'),
      isNull,
    );
  });

  test(
    'pełny obraz jest pobierany z Storage dopiero na żądanie podglądu',
    () async {
      when(
        () => storageRepository.getDownloadTicket('file-1'),
      ).thenAnswer((_) async => Right(ticket));
      when(
        () => downloadTransport.fetchBytes(
          downloadUrl: any(named: 'downloadUrl'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => Right(Uint8List.fromList([9, 8, 7])));

      final bytes = await adapter.fullImage('file-1');

      expect(bytes, [9, 8, 7]);
      verify(
        () => storageRepository.getDownloadTicket('file-1'),
      ).called(1);
      verify(
        () => downloadTransport.fetchBytes(
          downloadUrl: ticket.downloadUrl,
          headers: any(named: 'headers'),
        ),
      ).called(1);
    },
  );
}
