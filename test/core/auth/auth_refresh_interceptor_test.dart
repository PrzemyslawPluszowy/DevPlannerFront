import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/auth/auth_refresh_interceptor.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/network/app_api_factory.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

/// Adapter zwracajacy odpowiedzi na podstawie konfigurowalnych handlerow.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter();

  final requests = <RequestOptions>[];

  /// Domyslny handler zwracajacy odpowiedz na podstawie requestu.
  Future<ResponseBody> Function(RequestOptions options)? handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (handler case final h?) {
      return h(options);
    }
    return _json401();
  }

  @override
  void close({bool force = false}) {}

  static ResponseBody _json401() => ResponseBody.fromString(
    jsonEncode({'error': 'unauthorized'}),
    401,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

ResponseBody _jsonOk([Map<String, dynamic>? data]) => ResponseBody.fromString(
  jsonEncode(data ?? {'ok': true}),
  200,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

ResponseBody _json401() => ResponseBody.fromString(
  jsonEncode({'error': 'unauthorized'}),
  401,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  late Dio dio;
  late _ScriptedAdapter adapter;
  late _MockAuthRepository authRepository;
  late int logoutCalls;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
    adapter = _ScriptedAdapter();
    dio.httpClientAdapter = adapter;
    authRepository = _MockAuthRepository();
    logoutCalls = 0;

    when(() => authRepository.sessionGeneration).thenReturn(1);

    dio.interceptors.add(
      AuthRefreshInterceptor(
        dio: dio,
        authRepository: authRepository,
        onLogout: () async {
          logoutCalls += 1;
        },
      ),
    );
  });

  /// Pomaga stemplowac generacje sesji w extra requestu,
  /// tak jak robi to [AppApiFactory.createDio].
  Options optionsWithGeneration(int generation) => Options(
    extra: {AppApiFactory.sessionGenerationKey: generation},
  );

  group('AuthRefreshInterceptor', () {
    test(
      'retryuje request raz po udanym refresh i dokleja nowy Authorization',
      () async {
        when(
          () => authRepository.tryRefreshSession(),
        ).thenAnswer((_) async => true);
        when(() => authRepository.accessToken).thenReturn('new-access-token');

        adapter.handler = (options) {
          if (options.extra[AuthRefreshInterceptor.retryAfterRefreshKey] ==
              true) {
            return Future.value(_jsonOk());
          }
          return Future.value(_json401());
        };

        final response = await dio.get<Map<String, dynamic>>(
          '/inventory',
          options: optionsWithGeneration(1),
        );

        expect(response.statusCode, 200);
        expect(adapter.requests, hasLength(2));
        expect(
          adapter.requests.last.extra[AuthRefreshInterceptor
              .retryAfterRefreshKey],
          isTrue,
        );
        expect(
          adapter.requests.last.headers['Authorization'],
          'Bearer new-access-token',
        );
        verify(() => authRepository.tryRefreshSession()).called(1);
        expect(logoutCalls, 0);
      },
    );

    test('wylogowuje gdy refresh sesji nie powiedzie sie', () async {
      when(
        () => authRepository.tryRefreshSession(),
      ).thenAnswer((_) async => false);

      await expectLater(
        () => dio.get<Map<String, dynamic>>(
          '/inventory',
          options: optionsWithGeneration(1),
        ),
        throwsA(isA<DioException>()),
      );

      expect(adapter.requests, hasLength(1));
      verify(() => authRepository.tryRefreshSession()).called(1);
      expect(logoutCalls, 1);
    });

    test(
      'wylogowuje gdy request ponowiony po refreshu nadal zwraca 401',
      () async {
        when(
          () => authRepository.tryRefreshSession(),
        ).thenAnswer((_) async => true);
        when(() => authRepository.accessToken).thenReturn('new-access-token');

        await expectLater(
          dio
              .get<Map<String, dynamic>>(
                '/inventory',
                options: optionsWithGeneration(1),
              )
              .timeout(const Duration(seconds: 2)),
          throwsA(isA<DioException>()),
        );

        expect(adapter.requests, hasLength(2));
        expect(logoutCalls, 1);
      },
    );

    test(
      'odrzuca request bez retry gdy generacja sesji sie zmienila '
      '(login/logout innego uzytkownika)',
      () async {
        // Request wyslany z generacja 1, ale sesja jest juz w generacji 2
        when(() => authRepository.sessionGeneration).thenReturn(2);

        await expectLater(
          () => dio.get<Map<String, dynamic>>(
            '/inventory',
            options: optionsWithGeneration(1),
          ),
          throwsA(isA<DioException>()),
        );

        expect(adapter.requests, hasLength(1));
        verifyNever(() => authRepository.tryRefreshSession());
        expect(logoutCalls, 0);
      },
    );

    test(
      'pomija refresh gdy token juz sie zmienil przez wczesniejszy '
      'request z kolejki (ta sama generacja)',
      () async {
        // Symulacja: request wyslany ze starym tokenem, ale repo ma juz nowy
        when(() => authRepository.accessToken).thenReturn('new-token');

        adapter.handler = (options) {
          if (options.extra[AuthRefreshInterceptor.retryAfterRefreshKey] ==
              true) {
            return Future.value(_jsonOk());
          }
          return Future.value(_json401());
        };

        final response = await dio.get<Map<String, dynamic>>(
          '/inventory',
          options: Options(
            headers: {'Authorization': 'Bearer old-token'},
            extra: {AppApiFactory.sessionGenerationKey: 1},
          ),
        );

        expect(response.statusCode, 200);
        // Nie powinno byc wywolania refresh — token juz aktualny
        verifyNever(() => authRepository.tryRefreshSession());
        expect(logoutCalls, 0);
      },
    );

    test(
      'rozpoznaje naglowek bearer niezaleznie od wielkosci liter',
      () async {
        when(() => authRepository.accessToken).thenReturn('new-token');

        adapter.handler = (options) {
          if (options.extra[AuthRefreshInterceptor.retryAfterRefreshKey] ==
              true) {
            return Future.value(_jsonOk());
          }
          return Future.value(_json401());
        };

        final response = await dio.get<Map<String, dynamic>>(
          '/inventory',
          options: Options(
            headers: {'Authorization': 'bearer old-token'},
            extra: {AppApiFactory.sessionGenerationKey: 1},
          ),
        );

        expect(response.statusCode, 200);
        verifyNever(() => authRepository.tryRefreshSession());
        expect(logoutCalls, 0);
      },
    );

    test(
      'nie retryuje z pustym tokenem po refresh sukcesie',
      () async {
        when(
          () => authRepository.tryRefreshSession(),
        ).thenAnswer((_) async => true);
        when(() => authRepository.accessToken).thenReturn(null);

        await expectLater(
          () => dio.get<Map<String, dynamic>>(
            '/inventory',
            options: optionsWithGeneration(1),
          ),
          throwsA(isA<DioException>()),
        );

        expect(adapter.requests, hasLength(1));
        verify(() => authRepository.tryRefreshSession()).called(1);
        expect(logoutCalls, 1);
      },
    );

    test(
      'wielokrotne rownolegle 401 — refresh jest wolany raz, '
      'kolejne requesty retryuja z nowym tokenem',
      () async {
        var refreshCallCount = 0;

        // Poczatkowo token jest taki sam jak w naglowku requestow
        when(() => authRepository.accessToken).thenReturn('old-token');

        when(() => authRepository.tryRefreshSession()).thenAnswer((_) async {
          refreshCallCount++;
          // Po refresh token sie zmienia — kolejne requesty z kolejki
          // zobacza roznice i pomina zbedny refresh
          when(() => authRepository.accessToken).thenReturn('refreshed-token');
          return true;
        });

        adapter.handler = (options) {
          if (options.extra[AuthRefreshInterceptor.retryAfterRefreshKey] ==
              true) {
            return Future.value(_jsonOk());
          }
          return Future.value(_json401());
        };

        // Wysylamy 3 requesty rownolegle — wszystkie dostana 401
        final futures = List.generate(
          3,
          (i) => dio.get<Map<String, dynamic>>(
            '/inventory/$i',
            options: Options(
              headers: {'Authorization': 'Bearer old-token'},
              extra: {AppApiFactory.sessionGenerationKey: 1},
            ),
          ),
        );

        final responses = await Future.wait(futures);

        // Wszystkie powinny byc pomyslne po retry
        for (final response in responses) {
          expect(response.statusCode, 200);
        }

        // QueuedInterceptor przetwarza sekwencyjnie:
        // - pierwszy request wola tryRefreshSession()
        // - kolejne widza zmieniony token i pomijaja refresh
        expect(refreshCallCount, 1);
        expect(logoutCalls, 0);
      },
    );

    test('_safeLogout lapie wyjatki z onLogout i nie przerywa flow', () async {
      when(
        () => authRepository.tryRefreshSession(),
      ).thenAnswer((_) async => false);

      // Nadpisujemy interceptor z rzucajacym logout
      dio.interceptors.clear();
      dio.interceptors.add(
        AuthRefreshInterceptor(
          dio: dio,
          authRepository: authRepository,
          onLogout: () async {
            throw StateError('Cubit already closed');
          },
        ),
      );

      // Powinien propagowac blad 401 mimo wyjatku z logout
      await expectLater(
        () => dio.get<Map<String, dynamic>>(
          '/inventory',
          options: optionsWithGeneration(1),
        ),
        throwsA(isA<DioException>()),
      );

      verify(() => authRepository.tryRefreshSession()).called(1);
    });
  });
}
