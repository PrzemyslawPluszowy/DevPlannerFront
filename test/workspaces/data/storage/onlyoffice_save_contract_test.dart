import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:devplanner/workspaces/data/storage/models/onlyoffice_save_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const operationId = '74e6e6b4-e49f-4b16-8d70-b78d18cc9a88';
  test('pending and confirmed exact-operation responses decode', () {
    expect(
      OnlyOfficeSaveResponse.fromJson({
        'operationId': operationId,
        'confirmed': false,
        'version': null,
      }).version,
      isNull,
    );
    final confirmed = OnlyOfficeSaveResponse.fromJson({
      'operationId': operationId,
      'confirmed': true,
      'version': 4,
    });
    expect(confirmed.operationId, operationId);
    expect(confirmed.version, 4);
  });
  test('inconsistent confirmation never becomes Saved', () {
    for (final json in [
      {'operationId': operationId, 'confirmed': true, 'version': null},
      {'operationId': operationId, 'confirmed': true, 'version': 0},
      {'operationId': operationId, 'confirmed': true, 'version': '4'},
      {'operationId': operationId, 'confirmed': false, 'version': 4},
      {'operationId': '', 'confirmed': false},
      {'operationId': operationId, 'confirmed': 'true', 'version': 4},
    ]) {
      expect(
        () => OnlyOfficeSaveResponse.fromJson(json),
        throwsFormatException,
      );
    }
  });
  test('generated API sends exact operation and session key in body and polls path', () async {
    final adapter = _SaveAdapter(operationId);
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter;
    final api = StorageApi(dio);
    final accepted = await api.requestOfficeSave('file-id', {
      'documentKey': 'current-document-key',
      'operationId': operationId,
    });
    expect(accepted.confirmed, isFalse);
    final result = await api.getOfficeSaveResult('file-id', operationId);
    expect(result.confirmed, isTrue);
    expect(result.version, 4);
    expect(adapter.requests.first.method, 'POST');
    expect(
      adapter.requests.first.path,
      '/api/v1/storage/files/file-id/office-save',
    );
    expect(adapter.requests.first.data, {
      'documentKey': 'current-document-key',
      'operationId': operationId,
    });
    expect(adapter.requests.last.method, 'GET');
    expect(
      adapter.requests.last.path,
      '/api/v1/storage/files/file-id/office-save/$operationId',
    );
    dio.close();
  });
}

final class _SaveAdapter implements HttpClientAdapter {
  _SaveAdapter(this.operationId);
  final String operationId;
  final requests = <RequestOptions>[];
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final confirmed = options.method == 'GET';
    return ResponseBody.fromString(
      jsonEncode({
        'operationId': operationId,
        'confirmed': confirmed,
        'version': confirmed ? 4 : null,
      }),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
