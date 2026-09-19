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

  test('global diagnostics logs requests and errors without secrets', () async {
    final logs = <String>[];
    final adapter = _RecordingAdapter(
      statusCode: 400,
      body: const {
        'code': 'request.invalid',
        'message': 'Nieprawidłowy status.',
        'traceId': 'trace-123',
        'fields': {
          'status': ['Nieprawidłowa wartość.'],
        },
      },
    );
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter;
    final transport = DevPlannerHttpTransport(
      dio: dio,
      isWeb: false,
      tokenProvider: () => 'super-secret-access-token',
      diagnosticLog: logs.add,
    );

    await expectLater(
      transport.apiDio.get<void>(
        '/api/v1/tasks/groups',
        queryParameters: const {
          'status': 'InProgress',
          'search': 'tajna fraza użytkownika',
        },
      ),
      throwsA(isA<DioException>()),
    );

    final output = logs.join('\n');
    expect(output, contains('[HTTP][REQUEST]'));
    expect(output, contains('[HTTP][ERROR]'));
    expect(output, contains('status=InProgress'));
    expect(output, contains('request.invalid'));
    expect(output, contains('trace-123'));
    expect(output, isNot(contains('super-secret-access-token')));
    expect(output, isNot(contains('tajna fraza użytkownika')));
    expect(output, isNot(contains('Nieprawidłowa wartość.')));
  });

  test('desktop retries one 401 with a recovered access token', () async {
    final adapter = _SequenceAdapter(<int>[401, 200]);
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter;
    var token = 'old-access';
    var recoveries = 0;
    final transport = DevPlannerHttpTransport(
      dio: dio,
      isWeb: false,
      tokenProvider: () => token,
      unauthorizedRecovery: (failed) async {
        expect(failed, 'old-access');
        recoveries++;
        token = 'new-access';
        return 'new-access';
      },
    );

    final response = await transport.execute(
      const DevPlannerHttpRequest(
        method: DevPlannerHttpMethod.post,
        path: '/api/v1/tasks',
        body: {'title': 'A'},
      ),
    );

    expect(response.statusCode, 200);
    expect(recoveries, 1);
    expect(adapter.requests, hasLength(2));
    expect(
      adapter.requests.first.headers['Authorization'],
      'Bearer old-access',
    );
    expect(adapter.requests.last.headers['Authorization'], 'Bearer new-access');
    expect(adapter.requests.last.data, {'title': 'A'});
  });

  test(
    'successful desktop response is never refreshed or replayed',
    () async {
      // Audyt P0: odzyskiwanie sesji wołane dla każdej odpowiedzi powtarzało
      // także udany zapis. Dla wersjonowanej mutacji replay zużywa już
      // wykorzystane `expectedVersion`, więc Backend słusznie odpowiadał 409,
      // a klient raportował konflikt na żądaniu, które się udało.
      final adapter = _SequenceAdapter(<int>[200, 200]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      final transport = DevPlannerHttpTransport(
        dio: dio,
        isWeb: false,
        tokenProvider: () => 'access',
        unauthorizedRecovery: (_) async =>
            fail('udana odpowiedź nie może odzyskiwać sesji'),
      );

      final response = await transport.execute(
        const DevPlannerHttpRequest(
          method: DevPlannerHttpMethod.put,
          path: '/api/v1/workspaces/w/projects/p/kanban/preferences',
          body: {'quickFilter': 'Mine', 'expectedVersion': 1},
        ),
      );

      expect(response.statusCode, 200);
      expect(
        adapter.requests,
        hasLength(1),
        reason: 'jedna mutacja użytkownika to jedno żądanie',
      );
    },
  );

  test('non-401 error response is not refreshed or replayed', () async {
    final adapter = _SequenceAdapter(<int>[409, 200]);
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter;
    final transport = DevPlannerHttpTransport(
      dio: dio,
      isWeb: false,
      tokenProvider: () => 'access',
      unauthorizedRecovery: (_) async =>
          fail('konflikt wersji nie jest brakiem sesji'),
    );

    final response = await transport.execute(
      const DevPlannerHttpRequest(
        method: DevPlannerHttpMethod.put,
        path: '/api/v1/workspaces/w/projects/p/task-list/preferences',
        body: {'expectedVersion': 1},
      ),
    );

    expect(response.statusCode, 409);
    expect(adapter.requests, hasLength(1));
  });

  test('typed apiDio has the same one-retry desktop policy', () async {
    final adapter = _SequenceAdapter(<int>[401, 200]);
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter;
    var token = 'old-access';
    final transport = DevPlannerHttpTransport(
      dio: dio,
      isWeb: false,
      tokenProvider: () => token,
      unauthorizedRecovery: (_) async {
        return token = 'new-access';
      },
    );

    final response = await transport.apiDio.get<dynamic>('/api/v1/tasks');

    expect(response.statusCode, 200);
    expect(adapter.requests, hasLength(2));
    expect(adapter.requests.last.headers['Authorization'], 'Bearer new-access');
  });

  test('does not replay a second 401 or multipart upload', () async {
    final repeated401 = _SequenceAdapter(<int>[401, 401]);
    final repeatedDio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = repeated401;
    var recoveries = 0;
    final retrying = DevPlannerHttpTransport(
      dio: repeatedDio,
      isWeb: false,
      tokenProvider: () => 'access',
      unauthorizedRecovery: (_) async {
        recoveries++;
        return 'replacement';
      },
    );
    final repeatedResponse = await retrying.execute(
      const DevPlannerHttpRequest(
        method: DevPlannerHttpMethod.delete,
        path: '/api/v1/tasks/1',
      ),
    );
    expect(repeatedResponse.statusCode, 401);
    expect(recoveries, 1);
    expect(repeated401.requests, hasLength(2));

    final upload = _SequenceAdapter(<int>[401]);
    final uploadDio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = upload;
    final uploadTransport = DevPlannerHttpTransport(
      dio: uploadDio,
      isWeb: false,
      tokenProvider: () => 'access',
      unauthorizedRecovery: (_) async => fail('upload must not refresh'),
    );
    final uploadResponse = await uploadTransport.execute(
      DevPlannerHttpRequest(
        method: DevPlannerHttpMethod.post,
        path: '/api/v1/me/avatar',
        rawBytes: Uint8List.fromList(<int>[1, 2]),
        filename: 'avatar.png',
        contentType: 'image/png',
      ),
    );
    expect(uploadResponse.statusCode, 401);
    expect(upload.requests, hasLength(1));
  });

  test(
    'twenty concurrent 401 responses share one recovery operation',
    () async {
      final adapter = _SequenceAdapter(<int>[
        ...List<int>.filled(20, 401),
        ...List<int>.filled(20, 200),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      var token = 'old-access';
      Future<String?>? recovery;
      var recoveryStarts = 0;
      final transport = DevPlannerHttpTransport(
        dio: dio,
        isWeb: false,
        tokenProvider: () => token,
        unauthorizedRecovery: (_) {
          final active = recovery;
          if (active != null) return active;
          recoveryStarts++;
          final next = Future<String?>.delayed(
            const Duration(milliseconds: 1),
            () => token = 'new-access',
          );
          recovery = next;
          return next;
        },
      );

      final responses = await Future.wait(
        List<Future<DevPlannerHttpResponse>>.generate(
          20,
          (_) => transport.execute(
            const DevPlannerHttpRequest(
              method: DevPlannerHttpMethod.get,
              path: '/api/v1/tasks',
            ),
          ),
        ),
      );

      expect(
        responses.map((response) => response.statusCode),
        everyElement(200),
      );
      expect(recoveryStarts, 1);
      expect(adapter.requests, hasLength(40));
    },
  );
}

final class _SequenceAdapter implements HttpClientAdapter {
  _SequenceAdapter(this.statuses);

  final List<int> statuses;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final status = statuses.removeAt(0);
    return ResponseBody.fromString(
      jsonEncode(const {'ok': true}),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
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
