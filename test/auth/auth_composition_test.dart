import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/auth/auth.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/foundation/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'web composition reads the BFF session and authoritative /me profile',
    () async {
      final adapter = _SequenceAdapter([
        const _Response(200, {
          'authenticated': true,
          'csrfTokenAvailable': true,
        }),
        const _Response(200, {
          'userId': 'user-1',
          'login': 'anna',
          'email': 'anna@example.test',
          'displayName': 'Anna',
          'roles': ['User'],
          'permissions': ['users.read'],
        }),
      ]);
      final http = _webTransport(adapter);
      final launcher = _FakeBrowserLauncher();
      final auth = AuthComposition.webBff(
        httpTransport: http,
        browserLauncher: launcher,
        returnTo: '/admin',
      );

      await auth.useCases.restoreSession();

      expect(auth.session.snapshot.isAuthenticated, isTrue);
      expect(auth.session.snapshot.clientKind, AuthClientKind.webBff);
      expect(auth.session.snapshot.user?.userId, 'user-1');
      expect(auth.session.snapshot.user?.permissions, {'users.read'});
      expect(adapter.requests.map((request) => request.path), [
        '/bff/session',
        '/api/v1/me',
      ]);
      expect(
        adapter.requests.every(
          (request) => !request.headers.containsKey('Authorization'),
        ),
        isTrue,
      );
    },
  );

  test('web composition fails closed when BFF has no CSRF cookie', () async {
    final adapter = _SequenceAdapter([
      const _Response(200, {
        'authenticated': true,
        'csrfTokenAvailable': false,
      }),
    ]);
    final auth = AuthComposition.webBff(
      httpTransport: _webTransport(adapter),
      browserLauncher: _FakeBrowserLauncher(),
    );

    await auth.useCases.restoreSession();

    expect(auth.session.snapshot.status, AuthSessionStatus.signedOut);
    expect(adapter.requests, hasLength(1));
  });

  test(
    'BFF sign-in starts the backend redirect without sending credentials',
    () async {
      final adapter = _SequenceAdapter([
        const _Response(200, {
          'authenticated': true,
          'csrfTokenAvailable': true,
        }),
        const _Response(200, {
          'userId': 'user-1',
          'login': 'anna',
          'email': 'anna@example.test',
          'displayName': 'Anna',
          'permissions': <String>[],
        }),
      ]);
      final launcher = _FakeBrowserLauncher();
      final transport = HttpWebBffSessionTransport(
        httpTransport: _webTransport(adapter),
        browserLauncher: launcher,
        returnTo: 'https://evil.example/steal',
      );

      final user = await transport.signIn(
        const LoginCredentials(login: 'ignored', password: 'never-sent'),
      );

      expect(user.userId, 'user-1');
      expect(launcher.opened, hasLength(1));
      expect(launcher.opened.single.path, '/bff/auth/start');
      expect(launcher.opened.single.queryParameters['returnTo'], '/workspaces');
    },
  );

  test(
    'desktop composition keeps refresh credentials in the injected vault',
    () async {
      final store = _MemorySecretStore();
      final auth = AuthComposition.desktopPkce(
        transport: _FakeDesktopTransport(),
        vault: PlatformSecureRefreshTokenVault(store: store),
      );

      await auth.useCases.restoreSession();

      expect(auth.useCases.clientKind, AuthClientKind.desktopPkce);
      expect(store.values, isEmpty);
    },
  );

  test('web composition rejects a desktop bearer transport', () {
    final http = DevPlannerHttpTransport(
      dio: Dio(),
      isWeb: true,
      tokenProvider: () async => 'desktop-bearer',
    );

    expect(
      () => AuthComposition.webBff(
        httpTransport: http,
        browserLauncher: _FakeBrowserLauncher(),
      ),
      throwsStateError,
    );
  });
}

DevPlannerHttpTransport _webTransport(_SequenceAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://planner.example.test'))
    ..httpClientAdapter = adapter;
  return DevPlannerHttpTransport(
    dio: dio,
    isWeb: true,
    csrfTokenProvider: () async => 'csrf-token',
  );
}

final class _FakeBrowserLauncher implements WebBffBrowserLauncher {
  final opened = <Uri>[];

  @override
  bool get returnsAfterNavigation => true;

  @override
  Future<void> open(Uri authorizationUri) async => opened.add(authorizationUri);
}

final class _SequenceAdapter implements HttpClientAdapter {
  _SequenceAdapter(this.responses);

  final List<_Response> responses;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final response = responses.removeAt(0);
    return ResponseBody.fromString(
      jsonEncode(response.body),
      response.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

final class _Response {
  const _Response(this.statusCode, this.body);

  final int statusCode;
  final Object body;
}

final class _FakeDesktopTransport implements DesktopPkceSessionTransport {
  @override
  Future<DesktopAuthorizationResult> authorizeInteractively() async =>
      completeAuthorization(code: 'code', state: 'state');

  @override
  Future<Uri> beginAuthorization({required Uri callbackUri}) async =>
      callbackUri;

  @override
  Future<DesktopAuthorizationResult> completeAuthorization({
    required String code,
    required String state,
  }) async {
    return const DesktopAuthorizationResult(
      user: AuthUser(userId: 'user-1', login: 'anna', displayName: 'Anna'),
      refreshToken: 'refresh-token',
    );
  }

  @override
  Future<DesktopAuthorizationResult?> restoreSession({
    required String refreshToken,
  }) async => null;

  @override
  Future<void> revoke({required String refreshToken}) async {}
}

final class _MemorySecretStore implements SecureSecretStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}
