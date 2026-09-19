import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_gateway.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/auth/domain/use_cases/auth_use_cases.dart';
import 'package:devplanner/auth/presentation/cubit/auth_login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthReturnTo', () {
    test('preserves an allowed internal route and its query', () {
      expect(
        AuthReturnTo.sanitize('/workspaces/ws-1?tab=tasks#board'),
        '/workspaces/ws-1?tab=tasks#board',
      );
    });

    test('rejects external and legacy routes', () {
      expect(AuthReturnTo.sanitize('https://example.com/workspaces'), isNull);
      expect(AuthReturnTo.sanitize('//example.com/workspaces'), isNull);
      expect(AuthReturnTo.sanitize('/dashboard'), isNull);
    });
  });

  test('session controller exposes typed state transitions', () {
    final session = AuthSessionController();
    expect(session.snapshot.status, AuthSessionStatus.signedOut);

    session.setRestoring();
    expect(session.snapshot.status, AuthSessionStatus.restoring);

    const user = AuthUser(
      userId: 'u-1',
      login: 'anna',
      displayName: 'Anna',
    );
    session.setSignedIn(user, clientKind: AuthClientKind.desktopPkce);
    expect(session.snapshot.isAuthenticated, isTrue);
    expect(session.snapshot.clientKind, AuthClientKind.desktopPkce);
  });

  test(
    'sign-out clears visible session even when remote revoke fails',
    () async {
      final session = AuthSessionController();
      session.setSignedIn(
        const AuthUser(userId: 'u-1', login: 'anna', displayName: 'Anna'),
        clientKind: AuthClientKind.desktopPkce,
      );
      final useCases = AuthUseCases(
        gateway: _FakeAuthGateway(
          user: const AuthUser(
            userId: 'u-1',
            login: 'anna',
            displayName: 'Anna',
          ),
          signOutFailure: const AuthFailure('Brak sieci.'),
        ),
        session: session,
        clientKind: AuthClientKind.desktopPkce,
      );

      await expectLater(useCases.signOut(), throwsA(isA<AuthFailure>()));

      expect(session.snapshot.status, AuthSessionStatus.signedOut);
    },
  );

  test('login cubit calls only the injected domain use case', () async {
    final session = AuthSessionController();
    final gateway = _FakeAuthGateway(
      user: const AuthUser(
        userId: 'u-1',
        login: 'anna',
        displayName: 'Anna',
      ),
    );
    final useCases = AuthUseCases(gateway: gateway, session: session);
    final cubit = AuthLoginCubit(useCases: useCases);
    addTearDown(cubit.close);

    final states = <AuthLoginState>[];
    final stateFuture = cubit.stream.take(2).forEach(states.add);
    await cubit.submit(login: ' anna ', password: 'secret');
    await stateFuture;

    expect(states, hasLength(2));
    expect(states[0], isA<AuthLoginSubmitting>());
    expect(states[1], isA<AuthLoginSucceeded>());
    expect(
      gateway.credentials,
      const LoginCredentials(login: 'anna', password: 'secret'),
    );
    expect(session.snapshot.isAuthenticated, isTrue);
  });

  test('login cubit treats the BFF redirect as a neutral state', () async {
    final gateway = _FakeAuthGateway(
      user: const AuthUser(userId: 'u-1', login: 'anna', displayName: 'Anna'),
      signInFailure: const AuthFailure(
        'Redirect started',
        code: 'auth.bff.redirect_started',
      ),
    );
    final cubit = AuthLoginCubit(
      useCases: AuthUseCases(
        gateway: gateway,
        session: AuthSessionController(),
      ),
    );
    addTearDown(cubit.close);

    final states = <AuthLoginState>[];
    final stateFuture = cubit.stream.take(2).forEach(states.add);
    await cubit.startInteractive();
    await stateFuture;

    expect(states[0], isA<AuthLoginSubmitting>());
    expect(states[1], isA<AuthLoginRedirecting>());
    expect(states.whereType<AuthLoginFailure>(), isEmpty);
  });

  test('login cubit keeps non-redirect auth failures visible', () async {
    final cubit = AuthLoginCubit(
      useCases: AuthUseCases(
        gateway: _FakeAuthGateway(
          user: const AuthUser(
            userId: 'u-1',
            login: 'anna',
            displayName: 'Anna',
          ),
          signInFailure: const AuthFailure('Invalid credentials'),
        ),
        session: AuthSessionController(),
      ),
    );
    addTearDown(cubit.close);

    final states = <AuthLoginState>[];
    final stateFuture = cubit.stream.take(2).forEach(states.add);
    await cubit.submit(login: 'anna', password: 'secret');
    await stateFuture;

    final failure = states[1];
    expect(failure, isA<AuthLoginFailure>());
    expect((failure as AuthLoginFailure).message, 'Invalid credentials');
  });
}

final class _FakeAuthGateway implements AuthGateway {
  _FakeAuthGateway({
    required this.user,
    this.signInFailure,
    this.signOutFailure,
  });

  final AuthUser user;
  final AuthFailure? signInFailure;
  final AuthFailure? signOutFailure;
  LoginCredentials? credentials;

  @override
  Future<AuthUser> signIn(LoginCredentials value) async {
    credentials = value;
    if (signInFailure case final failure?) throw failure;
    return user;
  }

  @override
  Future<AuthUser?> restoreSession() async => user;

  @override
  Future<void> signOut() async {
    if (signOutFailure case final failure?) throw failure;
  }

  @override
  Future<void> activate({
    required String token,
    required String password,
  }) async {}

  @override
  Future<void> requestPasswordReset(String loginOrEmail) async {}

  @override
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {}

  @override
  Future<void> verifyMfa(String code) async {}
}
