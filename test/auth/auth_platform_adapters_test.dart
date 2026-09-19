import 'package:devplanner/auth/data/adapters/desktop_pkce_auth_adapter.dart';
import 'package:devplanner/auth/data/adapters/secure_refresh_token_vault.dart';
import 'package:devplanner/auth/data/adapters/web_bff_auth_adapter.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/foundation/secure_storage/secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WebBffAuthAdapter', () {
    test(
      'delegates cookie-session operations without exposing tokens',
      () async {
        final transport = _FakeWebBffTransport(
          user: const AuthUser(
            userId: 'user-1',
            login: 'anna',
            displayName: 'Anna',
          ),
        );
        final adapter = WebBffAuthAdapter(transport: transport);

        expect(await adapter.restoreSession(), transport.user);
        expect(
          await adapter.signIn(
            const LoginCredentials(login: 'anna', password: 'password'),
          ),
          transport.user,
        );
        await adapter.signOut();

        expect(transport.signInCalls, 1);
        expect(transport.signOutCalls, 1);
      },
    );

    test('unavailable transport fails closed', () async {
      final adapter = WebBffAuthAdapter(
        transport: const UnavailableWebBffSessionTransport(),
      );

      expect(
        () => adapter.signIn(
          const LoginCredentials(login: 'anna', password: 'password'),
        ),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.code,
            'code',
            'auth.bff.unavailable',
          ),
        ),
      );
    });
  });

  group('PlatformSecureRefreshTokenVault', () {
    test('uses only the namespaced secure-store key', () async {
      final store = _FakeSecretStore();
      final vault = PlatformSecureRefreshTokenVault(store: store);

      await vault.write(' refresh-token ');
      expect(await vault.read(), 'refresh-token');
      expect(store.values.keys, contains('devplanner.auth.refresh_token.v1'));
      await vault.clear();
      expect(await vault.read(), isNull);
      expect(store.deletedKeys, contains('devplanner.auth.refresh_token.v1'));
    });

    test('rejects empty credentials before writing', () async {
      final store = _FakeSecretStore();
      final vault = PlatformSecureRefreshTokenVault(store: store);

      expect(() => vault.write('  '), throwsArgumentError);
      expect(store.values, isEmpty);
    });
  });

  group('DesktopPkceAuthAdapter', () {
    test('persists only the refresh token in the injected vault', () async {
      final store = _FakeSecretStore();
      final vault = PlatformSecureRefreshTokenVault(store: store);
      final transport = _FakeDesktopTransport();
      final adapter = DesktopPkceAuthAdapter(
        transport: transport,
        vault: vault,
      );

      final user = await adapter.completeAuthorization(
        code: 'authorization-code',
        state: 'validated-state',
      );
      expect(user.userId, 'user-1');
      expect(await vault.read(), 'refresh-token');
      expect(transport.lastCode, 'authorization-code');

      expect(await adapter.restoreSession(), user);
      expect(await vault.read(), 'rotated-token');
      await adapter.signOut();
      expect(await vault.read(), isNull);
      expect(transport.revokedToken, 'rotated-token');
    });

    test('clears the local vault when remote revoke fails', () async {
      final store = _FakeSecretStore(
        values: <String, String>{
          DevPlannerAuthSecretKeys.refreshToken: 'refresh-token',
        },
      );
      final adapter = DesktopPkceAuthAdapter(
        transport: _FakeDesktopTransport(revokeError: Exception('offline')),
        vault: PlatformSecureRefreshTokenVault(store: store),
      );

      await expectLater(adapter.signOut(), throwsA(isA<Exception>()));
      expect(store.values, isEmpty);
    });

    test('does not accept a missing refresh token', () async {
      final adapter = DesktopPkceAuthAdapter(
        transport: _FakeDesktopTransport(missingRefreshToken: true),
        vault: PlatformSecureRefreshTokenVault(store: _FakeSecretStore()),
      );

      expect(
        () => adapter.completeAuthorization(code: 'code', state: 'state'),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.code,
            'code',
            'auth.refresh_token.missing',
          ),
        ),
      );
    });

    test('removes a refresh token rejected by the transport', () async {
      final store = _FakeSecretStore(
        values: <String, String>{
          DevPlannerAuthSecretKeys.refreshToken: 'stale-token',
        },
      );
      final adapter = DesktopPkceAuthAdapter(
        transport: _FakeDesktopTransport(rejectRestore: true),
        vault: PlatformSecureRefreshTokenVault(store: store),
      );

      expect(await adapter.restoreSession(), isNull);
      expect(store.values, isEmpty);
      expect(
        store.deletedKeys,
        contains(DevPlannerAuthSecretKeys.refreshToken),
      );
    });
  });
}

final class _FakeWebBffTransport implements WebBffSessionTransport {
  _FakeWebBffTransport({required this.user});

  final AuthUser user;
  int signInCalls = 0;
  int signOutCalls = 0;

  @override
  Future<AuthUser?> restoreSession() async => user;

  @override
  Future<AuthUser> signIn(LoginCredentials credentials) async {
    signInCalls++;
    return user;
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
  }
}

final class _FakeDesktopTransport implements DesktopPkceSessionTransport {
  _FakeDesktopTransport({
    this.revokeError,
    this.missingRefreshToken = false,
    this.rejectRestore = false,
  });

  final AuthUser user = const AuthUser(
    userId: 'user-1',
    login: 'anna',
    displayName: 'Anna',
  );
  final Exception? revokeError;
  final bool missingRefreshToken;
  final bool rejectRestore;
  String? lastCode;
  String? revokedToken;

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
    lastCode = code;
    return DesktopAuthorizationResult(
      user: user,
      refreshToken: missingRefreshToken ? '' : 'refresh-token',
    );
  }

  @override
  Future<DesktopAuthorizationResult?> restoreSession({
    required String refreshToken,
  }) async => rejectRestore
      ? null
      : DesktopAuthorizationResult(user: user, refreshToken: 'rotated-token');

  @override
  Future<void> revoke({required String refreshToken}) async {
    revokedToken = refreshToken;
    final error = revokeError;
    if (error != null) throw error;
  }
}

final class _FakeSecretStore implements SecureSecretStore {
  _FakeSecretStore({Map<String, String>? values})
    : values = values ?? <String, String>{};

  final Map<String, String> values;
  final List<String> deletedKeys = <String>[];

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    deletedKeys.add(key);
    values.remove(key);
  }
}
