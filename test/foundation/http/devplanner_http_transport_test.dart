import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'serializes query/body and forwards CSRF for mutating BFF calls',
    () async {
      final adapter = _RecordingAdapter(
        statusCode: 200,
        body: const {'ok': true},
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      final transport = DevPlannerHttpTransport(
        dio: dio,
        isWeb: true,
        csrfTokenProvider: () async => 'csrf-123',
      );

      final response = await transport.execute(
        const DevPlannerHttpRequest(
          method: DevPlannerHttpMethod.post,
          path: '/api/v1/admin/users',
          query: {'limit': '25'},
          body: {'login': 'ada'},
        ),
      );

      expect(transport.isBffCookieTransport, isTrue);
      expect(transport.asAdminTransport, isNotNull);
      expect(response.statusCode, 200);
      expect(adapter.requests.single.queryParameters, {'limit': '25'});
      expect(adapter.requests.single.data, {'login': 'ada'});
      expect(adapter.requests.single.headers['X-DevPlanner-CSRF'], 'csrf-123');
      expect(adapter.requests.single.extra['withCredentials'], isTrue);
    },
  );

  test(
    'normalizes JSON error bodies with a trace id without bearer access',
    () async {
      final adapter = _RecordingAdapter(
        statusCode: 403,
        body: const {
          'code': 'users.forbidden',
          'message': 'Brak uprawnień.',
        },
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      final transport = DevPlannerHttpTransport(
        dio: dio,
        isWeb: true,
        tokenProvider: () async => 'must-not-be-used-on-web',
      );

      final response = await transport.execute(
        const DevPlannerHttpRequest(
          method: DevPlannerHttpMethod.get,
          path: '/api/v1/admin/users',
          headers: {'Authorization': 'Bearer caller-supplied'},
        ),
      );

      expect(transport.isBffCookieTransport, isFalse);
      expect(transport.asAdminTransport, isNull);
      expect(response.body, {
        'code': 'users.forbidden',
        'message': 'Brak uprawnień.',
        'traceId': isA<String>(),
      });
      expect(
        adapter.requests.single.headers.containsKey('Authorization'),
        isFalse,
      );
    },
  );

  test(
    'does not construct an admin adapter around a desktop bearer transport',
    () {
      final transport = DevPlannerHttpTransport(
        dio: Dio(),
        isWeb: false,
        tokenProvider: () async => 'desktop-access-token',
      );

      expect(
        () => DevPlannerAdminUserApiTransport(transport),
        throwsStateError,
      );
    },
  );

  test('Retrofit client Dio strips a caller-supplied Web bearer', () async {
    final adapter = _RecordingAdapter(
      statusCode: 200,
      body: const {'ok': true},
    );
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter;
    final transport = DevPlannerHttpTransport(dio: dio, isWeb: true);

    await transport.apiDio.get<void>(
      '/api/v1/chat/conversations',
      options: Options(headers: {'Authorization': 'Bearer must-not-leak'}),
    );

    expect(
      adapter.requests.single.headers.containsKey('Authorization'),
      isFalse,
    );
    expect(adapter.requests.single.extra['withCredentials'], isTrue);
  });
}

final class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter({required this.statusCode, required this.body});

  final int statusCode;
  final Object body;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
