import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/workspaces/data/storage/transport/text_preview_loader_impl.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  test('TextPreviewLoader streamuje UTF-8 i respektuje limit bajtów', () async {
    final dio = _MockDio();
    when(
      () => dio.get<ResponseBody>(
        'https://storage.example/preview',
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(
          path: 'https://storage.example/preview',
        ),
        data: ResponseBody(
          Stream.fromIterable([
            utf8.encode('ab'),
            utf8.encode('cdef'),
          ]),
          200,
        ),
      ),
    );

    final result = await TextPreviewLoaderImpl(dio: dio).load(
      'https://storage.example/preview',
      maxBytes: 4,
    );

    expect(result.getOrElse(() => ''), 'abcd');
    final options =
        verify(
              () => dio.get<ResponseBody>(
                'https://storage.example/preview',
                options: captureAny(named: 'options'),
              ),
            ).captured.single
            as Options;
    expect(options.responseType, ResponseType.stream);
  });
}
