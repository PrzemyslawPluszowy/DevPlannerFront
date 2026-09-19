import 'dart:async';

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
    for (final phase in ['authorization', 'profile']) {
      test('logout wins while $phase is pending', () async {
        final entered = Completer<void>();
        final release = Completer<void>();
        Future<void> pause() {
          entered.complete();
          return release.future;
        }

        final store = _FakeSecretStore();
        final adapter = DesktopPkceAuthAdapter(
          transport: _FakeDesktopTransport(
            beforeAuthorization: phase == 'authorization' ? pause : null,
            beforeProfile: phase == 'profile' ? pause : null,
          ),
          vault: PlatformSecureRefreshTokenVault(store: store),
        );
        final login = adapter.authorizeInteractively();
        final rejected = expectLater(login, throwsA(isA<AuthFailure>()));
        await entered.future;
        await adapter.signOut();
        release.complete();
        await rejected;
        expect(await adapter.validAccessToken(), isNull);
        expect(store.values, isEmpty);
      });
    }
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
      expect(await vault.read(), 'refresh-token');
      expect(transport.restoreCalls, 0);
      await adapter.signOut();
      expect(await vault.read(), isNull);
      expect(transport.revokedToken, 'refresh-token');
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

    test('persists a rotated credential before fetching the profile', () async {
      final events = <String>[];
      final store = _FakeSecretStore(
        values: <String, String>{
          DevPlannerAuthSecretKeys.refreshToken: 'old-token',
        },
        onWrite: (value) => events.add('vault:$value'),
      );
      final transport = _FakeDesktopTransport(events: events);
      final adapter = DesktopPkceAuthAdapter(
        transport: transport,
        vault: PlatformSecureRefreshTokenVault(store: store),
      );

      expect(await adapter.restoreSession(), transport.user);
      expect(events, ['vault:rotated-token', 'profile:rotated-access-token']);
    });

    test(
      'keeps a persisted rotated credential when profile loading fails',
      () async {
        final store = _FakeSecretStore(
          values: <String, String>{
            DevPlannerAuthSecretKeys.refreshToken: 'old-token',
          },
        );
        final adapter = DesktopPkceAuthAdapter(
          transport: _FakeDesktopTransport(profileError: Exception('offline')),
          vault: PlatformSecureRefreshTokenVault(store: store),
        );

        await expectLater(adapter.restoreSession(), throwsA(isA<Exception>()));

        expect(
          await store.read(DevPlannerAuthSecretKeys.refreshToken),
          'rotated-token',
        );
      },
    );

    test(
      'revokes a newly issued credential when the vault cannot persist it',
      () async {
        final transport = _FakeDesktopTransport();
        final adapter = DesktopPkceAuthAdapter(
          transport: transport,
          vault: PlatformSecureRefreshTokenVault(
            store: _FakeSecretStore(
              writeError: Exception('keychain unavailable'),
            ),
          ),
        );

        await expectLater(
          adapter.authorizeInteractively(),
          throwsA(isA<Exception>()),
        );

        expect(transport.revokedToken, 'refresh-token');
      },
    );

    test(
      'shares one refresh-token rotation between concurrent callers',
      () async {
        final gate = Completer<void>();
        var restoreAttempt = 0;
        var now = DateTime.utc(2026);
        final transport = _FakeDesktopTransport(
          restoreExpiresIn: const Duration(seconds: 1),
          beforeRestore: () {
            restoreAttempt++;
            return restoreAttempt == 1 ? Future<void>.value() : gate.future;
          },
        );
        final adapter = DesktopPkceAuthAdapter(
          transport: transport,
          vault: PlatformSecureRefreshTokenVault(
            store: _FakeSecretStore(
              values: <String, String>{
                DevPlannerAuthSecretKeys.refreshToken: 'old-token',
              },
            ),
          ),
          now: () => now,
        );

        await adapter.restoreSession();
        now = now.add(const Duration(seconds: 1));
        transport.restoreCalls = 0;
        final tokens = List<Future<String?>>.generate(
          100,
          (_) => adapter.validAccessToken(),
        );
        await Future<void>.delayed(Duration.zero);
        expect(transport.restoreCalls, 1);
        gate.complete();

        expect(await Future.wait(tokens), everyElement('rotated-access-token'));
        expect(transport.restoreCalls, 1);
      },
    );

    test('restore and runtime share the same rotation', () async {
      final gate = Completer<void>();
      final transport = _FakeDesktopTransport(beforeRestore: () => gate.future);
      final adapter = DesktopPkceAuthAdapter(
        transport: transport,
        vault: PlatformSecureRefreshTokenVault(
          store: _FakeSecretStore(
            values: {
              DevPlannerAuthSecretKeys.refreshToken: 'old-token',
            },
          ),
        ),
      );
      final restore = adapter.restoreSession();
      final token = adapter.validAccessToken();
      await Future<void>.delayed(Duration.zero);
      expect(transport.restoreCalls, 1);
      gate.complete();
      expect(await restore, transport.user);
      expect(await token, 'rotated-access-token');
    });

    test('logout during vault write cannot publish or retain tokens', () async {
      final entered = Completer<void>();
      final release = Completer<void>();
      final store = _FakeSecretStore(
        values: {DevPlannerAuthSecretKeys.refreshToken: 'old-token'},
        beforeWrite: () {
          entered.complete();
          return release.future;
        },
      );
      final adapter = DesktopPkceAuthAdapter(
        transport: _FakeDesktopTransport(),
        vault: PlatformSecureRefreshTokenVault(store: store),
      );
      final refresh = adapter.validAccessToken();
      await entered.future;
      final logout = adapter.signOut();
      expect(await adapter.validAccessToken(), isNull);
      release.complete();
      await logout;
      expect(await refresh, isNull);
      expect(store.values, isEmpty);
    });

    test('permanent refresh rejection notifies lifecycle only once', () async {
      var expired = 0;
      final transport = _FakeDesktopTransport(rejectRestore: true);
      final adapter = DesktopPkceAuthAdapter(
        transport: transport,
        onSessionExpired: () => expired++,
        vault: PlatformSecureRefreshTokenVault(
          store: _FakeSecretStore(
            values: {
              DevPlannerAuthSecretKeys.refreshToken: 'old-token',
            },
          ),
        ),
      );
      expect(await adapter.validAccessToken(), isNull);
      expect(await adapter.validAccessToken(), isNull);
      expect(expired, 1);
      expect(transport.restoreCalls, 1);
    });

    test(
      'does not resurrect a session when logout wins a refresh race',
      () async {
        final gate = Completer<void>();
        final transport = _FakeDesktopTransport(
          beforeRestore: () => gate.future,
        );
        final store = _FakeSecretStore(
          values: <String, String>{
            DevPlannerAuthSecretKeys.refreshToken: 'old-token',
          },
        );
        final adapter = DesktopPkceAuthAdapter(
          transport: transport,
          vault: PlatformSecureRefreshTokenVault(store: store),
        );

        final refresh = adapter.validAccessToken();
        await Future<void>.delayed(Duration.zero);
        await adapter.signOut();
        gate.complete();

        expect(await refresh, isNull);
        expect(await adapter.validAccessToken(), isNull);
        expect(store.values, isEmpty);
        expect(transport.revokedToken, 'rotated-token');
      },
    );
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
    this.profileError,
    this.restoreExpiresIn = const Duration(minutes: 10),
    this.beforeRestore,
    this.beforeAuthorization,
    this.beforeProfile,
    List<String>? events,
  }) : events = events ?? <String>[];

  final AuthUser user = const AuthUser(
    userId: 'user-1',
    login: 'anna',
    displayName: 'Anna',
  );
  final Exception? revokeError;
  final Exception? profileError;
  final Duration restoreExpiresIn;
  final Future<void> Function()? beforeRestore;
  final Future<void> Function()? beforeAuthorization;
  final Future<void> Function()? beforeProfile;
  final bool missingRefreshToken;
  final bool rejectRestore;
  final List<String> events;
  String? lastCode;
  String? revokedToken;
  int restoreCalls = 0;

  @override
  Future<DesktopTokenResult> authorizeInteractively() async =>
      completeAuthorization(code: 'code', state: 'state');

  @override
  Future<Uri> beginAuthorization({required Uri callbackUri}) async =>
      callbackUri;

  @override
  Future<DesktopTokenResult> completeAuthorization({
    required String code,
    required String state,
  }) async {
    lastCode = code;
    await beforeAuthorization?.call();
    return DesktopTokenResult(
      accessToken: 'access-token',
      refreshToken: missingRefreshToken ? '' : 'refresh-token',
      expiresIn: const Duration(minutes: 10),
    );
  }

  @override
  Future<DesktopTokenResult?> restoreSession({
    required String refreshToken,
  }) async {
    restoreCalls++;
    await beforeRestore?.call();
    return rejectRestore
        ? null
        : DesktopTokenResult(
            accessToken: 'rotated-access-token',
            refreshToken: 'rotated-token',
            expiresIn: restoreExpiresIn,
          );
  }

  @override
  Future<AuthUser> fetchCurrentUser({required String accessToken}) async {
    await beforeProfile?.call();
    events.add('profile:$accessToken');
    final error = profileError;
    if (error != null) throw error;
    return user;
  }

  @override
  Future<void> revoke({required String refreshToken}) async {
    revokedToken = refreshToken;
    final error = revokeError;
    if (error != null) throw error;
  }
}

final class _FakeSecretStore implements SecureSecretStore {
  _FakeSecretStore({
    Map<String, String>? values,
    this.writeError,
    this.onWrite,
    this.beforeWrite,
  }) : values = values ?? <String, String>{};

  final Map<String, String> values;
  final List<String> deletedKeys = <String>[];
  final Exception? writeError;
  final void Function(String value)? onWrite;
  final Future<void> Function()? beforeWrite;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    await beforeWrite?.call();
    final error = writeError;
    if (error != null) throw error;
    onWrite?.call(value);
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    deletedKeys.add(key);
    values.remove(key);
  }
}
