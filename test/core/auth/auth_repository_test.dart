import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/auth/auth_api.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/auth/auth_session_storage.dart';

class _MockAuthApi extends Mock implements AuthApi {}

class _FakeLoginRequest extends Fake implements LoginRequest {}

class _MemoryAuthSessionStorage implements AuthSessionStorage {
  StoredAuthSession? session;
  String? rememberedUsername;

  @override
  Future<void> clear() async {
    session = null;
  }

  @override
  Future<StoredAuthSession?> read() async => session;

  @override
  Future<String?> readRememberedUsername() async => rememberedUsername;

  @override
  Future<void> write({
    required String accessToken,
    required String refreshToken,
    String? userJson,
  }) async {
    session = StoredAuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userJson: userJson,
      rememberedUsername: rememberedUsername,
    );
  }

  @override
  Future<void> writeRememberedUsername(String username) async {
    rememberedUsername = username.trim();
    session = switch (session) {
      final current? => StoredAuthSession(
        accessToken: current.accessToken,
        refreshToken: current.refreshToken,
        userJson: current.userJson,
        rememberedUsername: rememberedUsername,
      ),
      null => StoredAuthSession(
        accessToken: '',
        refreshToken: '',
        rememberedUsername: rememberedUsername,
      ),
    };
  }
}

void main() {
  late AuthApi api;
  late AuthRepositoryImpl repository;
  late _MemoryAuthSessionStorage storage;

  const user = AuthUser(
    userId: 7,
    username: 'tester',
    displayName: 'Test User',
    email: 'tester@example.com',
  );

  const tokenPair = AuthTokenPair(
    token: 'access-token',
    refreshToken: 'refresh-token',
    user: user,
  );

  setUpAll(() {
    registerFallbackValue(_FakeLoginRequest());
  });

  setUp(() {
    api = _MockAuthApi();
    storage = _MemoryAuthSessionStorage();
    repository = AuthRepositoryImpl(api: api, storage: storage);
  });

  group('AuthRepositoryImpl', () {
    test('odczytuje i utrwala adres awatara z kontraktu sesji', () {
      final parsed = AuthUser.fromJson({
        'usr_id': 5,
        'username': 'anna',
        'name': 'Anna',
        'avatarUrl': ' https://cdn.example/avatar.png ',
      });

      expect(parsed.avatarUrl, 'https://cdn.example/avatar.png');
      expect(parsed.toJson()['avatarUrl'], 'https://cdn.example/avatar.png');
    });

    test('restoreSession odswieza i waliduje zapisana sesje', () async {
      storage.session = const StoredAuthSession(
        accessToken: 'stored-access',
        refreshToken: 'stored-refresh',
        userJson: '{"usr_id":5,"username":"anna","name":"Anna","email":"anna@example.com"}',
      );
      repository = AuthRepositoryImpl(api: api, storage: storage);
      when(
        () => api.refreshToken(refreshToken: 'stored-refresh'),
      ).thenAnswer(
        (_) async => const AuthTokenPair(
          token: 'fresh-access',
          refreshToken: 'fresh-refresh',
          user: AuthUser(
            userId: 5,
            username: 'anna',
            displayName: 'Anna',
            email: 'anna@example.com',
          ),
        ),
      );

      await repository.restoreSession();

      expect(repository.isAuthenticated, isTrue);
      expect(repository.accessToken, 'fresh-access');
      expect(repository.currentUser?.userId, 5);
      expect(repository.currentUser?.username, 'anna');
      expect(storage.session?.refreshToken, 'fresh-refresh');
    });

    test(
      'login zapisuje tokeny i usera oraz trimuje username w request',
      () async {
        when(
          () => api.login(any()),
        ).thenAnswer((_) async => tokenPair);

        await repository.login(username: '  tester  ', password: 'secret');

        final captured =
            verify(() => api.login(captureAny())).captured.single
                as LoginRequest;

        expect(captured.username, 'tester');
        expect(captured.password, 'secret');
        expect(repository.isAuthenticated, isTrue);
        expect(repository.accessToken, 'access-token');
        expect(repository.currentUser?.email, 'tester@example.com');
        expect(storage.session?.accessToken, 'access-token');
        expect(storage.session?.refreshToken, 'refresh-token');
        expect(storage.session?.userJson, isNotNull);
        expect(storage.rememberedUsername, 'tester');
      },
    );

    test('login odrzuca odpowiedz bez refresh tokenu', () async {
      when(
        () => api.login(any()),
      ).thenAnswer(
        (_) async => const AuthTokenPair(
          token: 'access-token',
          refreshToken: '',
        ),
      );

      await expectLater(
        () => repository.login(username: 'tester', password: 'secret'),
        throwsA(
          isA<AuthLoginException>().having(
            (e) => e.message,
            'message',
            'Brak refresh tokenu w odpowiedzi logowania.',
          ),
        ),
      );
      expect(storage.session, isNull);
    });

    test('login odrzuca odpowiedz bez identyfikatora uzytkownika', () async {
      when(
        () => api.login(any()),
      ).thenAnswer(
        (_) async => const AuthTokenPair(
          token: 'access-token',
          refreshToken: 'refresh-token',
        ),
      );

      await expectLater(
        () => repository.login(username: 'tester', password: 'secret'),
        throwsA(
          isA<AuthLoginException>().having(
            (e) => e.message,
            'message',
            'Brak identyfikatora uzytkownika w odpowiedzi logowania.',
          ),
        ),
      );
      expect(storage.session, isNull);
    });

    test(
      'login mapuje backendowy 403 na AuthLoginException z wiadomoscia',
      () async {
        when(
          () => api.login(any()),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/v1/auth/login'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: '/api/v1/auth/login'),
              statusCode: 403,
              data: {
                'error': {'message': 'Bledny login lub haslo.'},
              },
            ),
          ),
        );

        await expectLater(
          () => repository.login(username: 'tester', password: 'secret'),
          throwsA(
            isA<AuthLoginException>().having(
              (e) => e.message,
              'message',
              'Bledny login lub haslo.',
            ),
          ),
        );
      },
    );

    test(
      'login mapuje backendowy 401 na komunikat niepoprawnych danych',
      () async {
        when(
          () => api.login(any()),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/v1/auth/login'),
            response: Response<void>(
              requestOptions: RequestOptions(path: '/api/v1/auth/login'),
              statusCode: 401,
            ),
          ),
        );

        await expectLater(
          () => repository.login(username: 'tester', password: 'secret'),
          throwsA(
            isA<AuthLoginException>().having(
              (e) => e.message,
              'message',
              'Nieprawidlowy login lub haslo.',
            ),
          ),
        );
      },
    );

    test(
      'tryRefreshSession odswieza token i zachowuje poprzedniego usera gdy backend go nie zwraca',
      () async {
        storage.session = const StoredAuthSession(
          accessToken: 'stored-access',
          refreshToken: 'stored-refresh',
          userJson: '{"usr_id":7,"username":"tester","name":"Test User","email":"tester@example.com"}',
        );
        repository = AuthRepositoryImpl(api: api, storage: storage);
        when(
          () => api.refreshToken(refreshToken: 'stored-refresh'),
        ).thenAnswer(
          (_) async => const AuthTokenPair(
            token: 'new-access-token',
            refreshToken: 'new-refresh-token',
          ),
        );
        await repository.restoreSession();

        when(
          () => api.refreshToken(refreshToken: 'new-refresh-token'),
        ).thenAnswer(
          (_) async => const AuthTokenPair(
            token: 'newer-access-token',
            refreshToken: '',
          ),
        );

        final refreshed = await repository.tryRefreshSession();

        expect(refreshed, isTrue);
        expect(repository.accessToken, 'newer-access-token');
        expect(repository.currentUser?.username, 'tester');
        expect(storage.session?.accessToken, 'newer-access-token');
        expect(storage.session?.refreshToken, 'new-refresh-token');
        expect(storage.session?.userJson, isNotNull);
      },
    );

    test(
      'restoreSession czyści odrzuconą sesję gdy backend nie akceptuje refresh tokenu',
      () async {
        storage.session = const StoredAuthSession(
          accessToken: 'stored-access',
          refreshToken: 'stored-refresh',
        );
        repository = AuthRepositoryImpl(api: api, storage: storage);
        when(
          () => api.refreshToken(refreshToken: 'stored-refresh'),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/v1/auth/authorization'),
            response: Response<void>(
              requestOptions: RequestOptions(
                path: '/api/v1/auth/authorization',
              ),
              statusCode: 401,
            ),
          ),
        );

        await repository.restoreSession();

        expect(repository.isAuthenticated, isFalse);
        expect(repository.accessToken, isNull);
        expect(storage.session, isNull);
      },
    );

    test('logout czysci stan pamieci i storage', () async {
      storage.session = const StoredAuthSession(
        accessToken: 'stored-access',
        refreshToken: 'stored-refresh',
        userJson: '{"usr_id":7,"username":"tester","name":"Test User","email":"tester@example.com"}',
      );
      repository = AuthRepositoryImpl(api: api, storage: storage);
      when(
        () => api.refreshToken(refreshToken: 'stored-refresh'),
      ).thenAnswer(
        (_) async => const AuthTokenPair(
          token: 'new-access-token',
          refreshToken: 'new-refresh-token',
        ),
      );
      await repository.restoreSession();

      await repository.logout();

      expect(repository.isAuthenticated, isFalse);
      expect(repository.accessToken, isNull);
      expect(repository.currentUser, isNull);
      expect(storage.session, isNull);
    });

    group('sessionGeneration', () {
      test(
        'inkrementuje sie przy login i logout, nie zmienia sie przy refresh',
        () async {
          final initialGeneration = repository.sessionGeneration;

          // Login — nowa sesja, generacja sie zmienia
          when(
            () => api.login(any()),
          ).thenAnswer((_) async => tokenPair);
          await repository.login(username: 'tester', password: 'secret');
          expect(
            repository.sessionGeneration,
            greaterThan(initialGeneration),
          );

          final afterLoginGeneration = repository.sessionGeneration;

          // Refresh — ta sama sesja, generacja BEZ zmiany
          when(
            () => api.refreshToken(refreshToken: 'refresh-token'),
          ).thenAnswer(
            (_) async => const AuthTokenPair(
              token: 'refreshed-access',
              refreshToken: 'refreshed-refresh',
            ),
          );
          final refreshed = await repository.tryRefreshSession();
          expect(refreshed, isTrue);
          expect(repository.sessionGeneration, afterLoginGeneration);

          // Logout — sesja zamknieta, generacja sie zmienia
          await repository.logout();
          expect(
            repository.sessionGeneration,
            greaterThan(afterLoginGeneration),
          );
        },
      );
    });

    group('tryRefreshSession — retry po unavailable', () {
      setUp(() async {
        // Przygotuj sesje z tokenami
        when(
          () => api.login(any()),
        ).thenAnswer((_) async => tokenPair);
        await repository.login(username: 'tester', password: 'secret');
      });

      test(
        'pierwszy timeout, drugi sukces — zwraca true bez wylogowania',
        () async {
          var callCount = 0;
          when(
            () => api.refreshToken(refreshToken: 'refresh-token'),
          ).thenAnswer((_) async {
            callCount++;
            if (callCount == 1) {
              throw DioException(
                requestOptions: RequestOptions(
                  path: '/api/v1/auth/authorization',
                ),
                type: DioExceptionType.receiveTimeout,
              );
            }
            return const AuthTokenPair(
              token: 'retry-access',
              refreshToken: 'retry-refresh',
            );
          });

          final result = await repository.tryRefreshSession();

          expect(result, isTrue);
          expect(repository.accessToken, 'retry-access');
          expect(callCount, 2);
        },
      );

      test(
        'pierwszy timeout, drugi timeout — zwraca false',
        () async {
          when(
            () => api.refreshToken(refreshToken: 'refresh-token'),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(
                path: '/api/v1/auth/authorization',
              ),
              type: DioExceptionType.receiveTimeout,
            ),
          );

          final result = await repository.tryRefreshSession();

          expect(result, isFalse);
          verify(
            () => api.refreshToken(refreshToken: 'refresh-token'),
          ).called(2);
        },
      );

      test(
        'pierwszy 401 (rejected) — nie robi retry, zwraca false od razu',
        () async {
          when(
            () => api.refreshToken(refreshToken: 'refresh-token'),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(
                path: '/api/v1/auth/authorization',
              ),
              response: Response<void>(
                requestOptions: RequestOptions(
                  path: '/api/v1/auth/authorization',
                ),
                statusCode: 401,
              ),
            ),
          );

          final result = await repository.tryRefreshSession();

          expect(result, isFalse);
          // Tylko jedno wywolanie — rejected nie powoduje retry
          verify(
            () => api.refreshToken(refreshToken: 'refresh-token'),
          ).called(1);
        },
      );
    });

    group('restoreSession — retry po unavailable', () {
      test(
        'odtwarza sesje po retry gdy pierwszy refresh zwroci timeout',
        () async {
          storage.session = const StoredAuthSession(
            accessToken: 'stored-access',
            refreshToken: 'stored-refresh',
          );
          repository = AuthRepositoryImpl(api: api, storage: storage);

          var callCount = 0;
          when(
            () => api.refreshToken(refreshToken: 'stored-refresh'),
          ).thenAnswer((_) async {
            callCount++;
            if (callCount == 1) {
              throw DioException(
                requestOptions: RequestOptions(
                  path: '/api/v1/auth/authorization',
                ),
                type: DioExceptionType.connectionTimeout,
              );
            }
            return const AuthTokenPair(
              token: 'fresh-access',
              refreshToken: 'fresh-refresh',
              user: user,
            );
          });

          await repository.restoreSession();

          expect(repository.isAuthenticated, isTrue);
          expect(repository.accessToken, 'fresh-access');
          expect(callCount, 2);
        },
      );
    });
  });
}
