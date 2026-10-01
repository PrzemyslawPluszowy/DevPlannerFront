import 'dart:async';
import 'dart:typed_data';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/services/task_attachment_presigned_upload_transport.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PUT sends only bytes and reports progress without app credentials', () async {
    final adapter = _RecordingAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final progress = <(int, int)>[];
    final transport = TaskAttachmentPresignedUploadTransport(dio: dio);

    final result = await transport.upload(
      ticket: _ticket(),
      bytes: Uint8List.fromList([1, 2, 3, 4]),
      mimeType: 'image/png',
      onProgress: (sent, total) => progress.add((sent, total)),
    );

    expect(result.isRight(), isTrue);
    expect(adapter.request, isNotNull);
    expect(adapter.request!.method, 'PUT');
    expect(adapter.request!.headers.keys.map((key) => key.toLowerCase()), isNot(contains('authorization')));
    expect(adapter.request!.headers.keys.map((key) => key.toLowerCase()), isNot(contains('cookie')));
    expect(adapter.request!.headers.keys.map((key) => key.toLowerCase()), isNot(contains('x-csrf-token')));
    expect(adapter.requestBody, [1, 2, 3, 4]);
    expect(progress.last, (4, 4));
  });

  test('cancellation reaches PUT and returns typed canceled error', () async {
    final adapter = _BlockingAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final cancellation = UploadCancellationToken();
    final transport = TaskAttachmentPresignedUploadTransport(dio: dio);

    final pending = transport.upload(
      ticket: _ticket(),
      bytes: Uint8List.fromList([1, 2, 3]),
      cancelToken: cancellation,
    );
    await adapter.started.future;
    cancellation.cancel();

    final result = await pending;
    expect(result.isLeft(), isTrue);
    result.fold(
      (error) => expect(error.type, ApiErrorType.canceled),
      (_) => fail('Anulowany PUT nie może zwrócić sukcesu.'),
    );
  });

  test('already uploaded ticket skips PUT and reports completion progress', () async {
    final adapter = _RecordingAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final progress = <(int, int)>[];
    final transport = TaskAttachmentPresignedUploadTransport(dio: dio);

    final result = await transport.upload(
      ticket: _ticket(isAlreadyUploaded: true, uploadUrl: ''),
      bytes: Uint8List.fromList([1, 2, 3]),
      onProgress: (sent, total) => progress.add((sent, total)),
    );

    expect(result.isRight(), isTrue);
    expect(adapter.request, isNull);
    expect(progress, [(3, 3)]);
  });
}

StorageUploadTicketResponse _ticket({
  bool isAlreadyUploaded = false,
  String uploadUrl = 'https://storage.example/upload/ticket',
}) => StorageUploadTicketResponse(
  fileId: '5efda348-8d0b-4a5f-9df0-061d1433e701',
  storageObjectKey: 'workspaces/task/file.png',
  uploadUrl: uploadUrl,
  expiresAtUtc: DateTime.utc(2026, 9, 30, 12),
  isAlreadyUploaded: isAlreadyUploaded,
);

class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? request;
  List<int> requestBody = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    if (requestStream != null) {
      await requestStream.forEach(requestBody.addAll);
    }
    return ResponseBody.fromString('', 200);
  }

  @override
  void close({bool force = false}) {}
}

class _BlockingAdapter implements HttpClientAdapter {
  final Completer<void> started = Completer<void>();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    started.complete();
    await cancelFuture;
    throw DioException(
      requestOptions: options,
      type: DioExceptionType.cancel,
    );
  }

  @override
  void close({bool force = false}) {}
}
