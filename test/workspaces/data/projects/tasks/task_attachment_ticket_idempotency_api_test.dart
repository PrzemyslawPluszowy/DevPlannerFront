import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/workspaces/data/projects/tasks/api/task_operations_api.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bulk ticket API sends stable key as header and keeps file payload ordered', () async {
    final adapter = _RecordingAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final api = TaskOperationsApi(dio, baseUrl: 'https://api.example.test');

    await api.requestBulkAttachmentTickets(
      'workspace-1',
      'project-1',
      'task-1',
      '65af9058-d588-4b85-bc05-4c721a2dca4f',
      BulkTaskUploadTicketPayload(
        files: [
          StorageUploadTicketItemPayload(
            fileName: 'first.png',
            fileSizeBytes: 12,
            mimeType: 'image/png',
            contentSha256: List.filled(64, 'a').join(),
          ),
          const StorageUploadTicketItemPayload(
            fileName: 'second.pdf',
            fileSizeBytes: 34,
            mimeType: 'application/pdf',
          ),
        ],
      ),
    );

    expect(adapter.request?.headers['Idempotency-Key'], '65af9058-d588-4b85-bc05-4c721a2dca4f');
    final body = jsonDecode(utf8.decode(adapter.requestBody)) as Map<String, dynamic>;
    final files = body['files'] as List<dynamic>;
    expect(files.map((value) => (value as Map<String, dynamic>)['fileName']), ['first.png', 'second.pdf']);
    expect(body.containsKey('idempotencyKey'), isFalse);
  });
}

class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? request;
  final List<int> requestBody = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    if (requestStream != null) await requestStream.forEach(requestBody.addAll);
    return ResponseBody.fromString(
      '{"tickets":[{"fileId":"5efda348-8d0b-4a5f-9df0-061d1433e701","storageObjectKey":"workspaces/task/file.png","uploadUrl":"https://storage.example/upload/ticket","expiresAtUtc":"2026-10-01T00:00:00Z","isAlreadyUploaded":false}]}',
      201,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }

  @override
  void close({bool force = false}) {}
}
