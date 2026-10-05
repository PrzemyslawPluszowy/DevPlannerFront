import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/error/api_error_response_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const contract = <String, Object?>{
    'code': 'storage.batch_download_failed',
    'message': 'Nie można pobrać wybranych plików. Spróbuj ponownie.',
    'fields': {
      'fileIds': ['Brak dostępu do pliku.', 'Plik został usunięty.'],
      'scope': 'Nieprawidłowy zakres.',
    },
    'traceId': 'qa-zip-trace',
  };
  for (final entry in <String, Object?>{
    'map': contract,
    'string': jsonEncode(contract),
    'int bytes': utf8.encode(jsonEncode(contract)).toList(),
    'Uint8List': Uint8List.fromList(utf8.encode(jsonEncode(contract))),
    'UTF8 BOM': [0xef, 0xbb, 0xbf, ...utf8.encode(jsonEncode(contract))],
  }.entries) {
    test('${entry.key} preserves full standalone error metadata', () {
      final result = ApiErrorResponseParser.parse(entry.value);
      expect(result.contract?.code, contract['code']);
      expect(result.message, contract['message']);
      expect(result.contract?.message, contract['message']);
      expect(result.contract?.traceId, contract['traceId']);
      expect(result.fields, {
        'fileIds': ['Brak dostępu do pliku.', 'Plik został usunięty.'],
        'scope': ['Nieprawidłowy zakres.'],
      });
    });
  }

  for (final raw in <Object?>[
    null,
    [],
    <int>[],
    utf8.encode('  '),
    [0xc3, 0x28], // Invalid UTF-8 continuation.
    [0xe2, 0x82], // Truncated UTF-8.
    [-1, 255],
    [256, 123],
    utf8.encode('{"code":'),
    utf8.encode('<html>Proxy error</html>'),
    'invalid JSON',
    '{"code":',
    42,
    [true, 'not bytes'],
    utf8.encode('null'),
    utf8.encode('[1,2,3]'),
  ]) {
    test('non-contract payload ${raw.runtimeType}: $raw is safe', () {
      expect(() => ApiErrorResponseParser.parse(raw), returnsNormally);
      final result = ApiErrorResponseParser.parse(raw);
      expect(result.contract, isNull);
      expect(result.fields, isEmpty);
      expect(result.message, isNull);
    });
  }

  test('byte JSON preserves legacy error and validation message behavior', () {
    final legacy = ApiErrorResponseParser.parse(
      utf8.encode(
        jsonEncode({
          'error': {'code': 1001, 'message': 'Legacy error'},
        }),
      ),
    );
    expect(legacy.message, 'Legacy error');
    final validation = ApiErrorResponseParser.parse(
      utf8.encode(
        jsonEncode({
          'errors': {
            'fileIds': ['Missing file', 'Forbidden file'],
          },
        }),
      ),
    );
    expect(validation.message, 'Missing file\nForbidden file');
  });

  test('Dio ZIP bytes bad response reaches ApiError with backend metadata', () {
    final request = RequestOptions(
      path: '/api/v1/storage/batch/download',
      responseType: ResponseType.bytes,
    );
    final error = DioException.badResponse(
      statusCode: 422,
      requestOptions: request,
      response: Response<List<int>>(
        requestOptions: request,
        statusCode: 422,
        data: utf8.encode(jsonEncode(contract)),
      ),
    );
    final parsed = ApiError.fromDioException(
      error,
      fallbackMessage: 'Generic fallback',
    );
    expect(parsed.type, ApiErrorType.validation);
    expect(parsed.contractCode, contract['code']);
    expect(parsed.apiCode, contract['code']);
    expect(parsed.message, contract['message']);
    expect(parsed.traceId, contract['traceId']);
    expect(parsed.fields['fileIds'], [
      'Brak dostępu do pliku.',
      'Plik został usunięty.',
    ]);
  });

  test('nullable fields and traceId preserve standalone shape', () {
    final parsed = ApiErrorResponseParser.parse(
      utf8.encode(
        jsonEncode({
          'code': 'storage.forbidden',
          'message': 'Brak dostępu.',
          'fields': null,
          'traceId': null,
        }),
      ),
    );
    expect(parsed.contract?.code, 'storage.forbidden');
    expect(parsed.contract?.traceId, isNull);
    expect(parsed.fields, isEmpty);
  });
}
