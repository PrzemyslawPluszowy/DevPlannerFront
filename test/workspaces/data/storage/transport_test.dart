import 'dart:typed_data';

import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/transport/presigned_upload_transport.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late PresignedUploadTransport transport;

  setUp(() {
    dio = _MockDio();
    transport = PresignedUploadTransport(dio: dio);
  });

  final sampleTicket = StorageUploadTicketResponse(
    fileId: 'file-1',
    storageObjectKey: 'workspaces/file-1.png',
    uploadUrl: 'https://storage.local/upload/file-1',
    expiresAtUtc: DateTime.utc(2026, 9, 9, 12),
    isAlreadyUploaded: false,
  );

  final sampleInput = StorageUploadInput(
    name: 'photo.png',
    bytes: Uint8List.fromList([1, 2, 3, 4]),
    size: 4,
    mimeType: 'image/png',
  );

  test('PresignedUploadTransport wysyła plik przez PUT na uploadUrl', () async {
    when(
      () => dio.put<void>(
        'https://storage.local/upload/file-1',
        data: any(named: 'data'),
        cancelToken: any(named: 'cancelToken'),
        onSendProgress: any(named: 'onSendProgress'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(
          path: 'https://storage.local/upload/file-1',
        ),
        statusCode: 200,
      ),
    );

    var progressReported = false;
    final result = await transport.upload(
      ticket: sampleTicket,
      input: sampleInput,
      onProgress: (sent, total) {
        progressReported = true;
      },
    );

    expect(result.isRight(), isTrue);
    expect(progressReported, isTrue);
    verify(
      () => dio.put<void>(
        'https://storage.local/upload/file-1',
        data: any(named: 'data'),
        cancelToken: any(named: 'cancelToken'),
        onSendProgress: any(named: 'onSendProgress'),
        options: any(named: 'options'),
      ),
    ).called(1);
  });

  test(
    'PresignedUploadTransport pomija wysyłkę jeśli plik isAlreadyUploaded',
    () async {
      final uploadedTicket = StorageUploadTicketResponse(
        fileId: 'file-1',
        storageObjectKey: 'workspaces/file-1.png',
        uploadUrl: 'https://storage.local/upload/file-1',
        expiresAtUtc: DateTime.utc(2026, 9, 9, 12),
        isAlreadyUploaded: true,
      );

      final result = await transport.upload(
        ticket: uploadedTicket,
        input: sampleInput,
      );

      expect(result.isRight(), isTrue);
      verifyZeroInteractions(dio);
    },
  );
}
