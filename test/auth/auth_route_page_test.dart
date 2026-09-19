import 'package:devplanner/auth/data/adapters/desktop_pkce_auth_adapter.dart';
import 'package:devplanner/auth/data/adapters/web_bff_auth_adapter.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_client_ports.dart';
import 'package:devplanner/auth/presentation/auth_route_page.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('desktop PKCE CTA invokes interactive browser flow', (
    tester,
  ) async {
    final transport = _FakeDesktopTransport();
    final auth = AuthComposition.desktopPkce(
      transport: transport,
      vault: _MemoryVault(),
    );
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, _) => AuthRoutePage(
            kind: AuthRouteKind.login,
            useCases: auth.useCases,
            session: auth.session,
          ),
        ),
        GoRoute(path: '/workspaces', builder: (_, _) => const SizedBox()),
      ],
    );
    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pl')],
        routerConfig: router,
      ),
    );
    addTearDown(router.dispose);
    expect(
      find.byKey(const ValueKey('auth-desktop-pkce-login-cta-semantics')),
      findsOneWidget,
    );
    expect(find.text('Zaloguj'), findsOneWidget);
    await tester.tap(find.text('Zaloguj'));
    await tester.pumpAndSettle();
    expect(transport.interactiveCalls, 1);
    expect(auth.session.snapshot.isAuthenticated, isTrue);
  });

  testWidgets('login button starts the BFF redirect lifecycle', (tester) async {
    final semantics = tester.ensureSemantics();
    final transport = _FakeWebBffTransport();
    final auth = AuthComposition.fromWebBff(transport);
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, state) => AuthRoutePage(
            kind: AuthRouteKind.login,
            useCases: auth.useCases,
            session: auth.session,
            returnTo: state.uri.queryParameters['returnTo'],
          ),
        ),
        GoRoute(path: '/workspaces', builder: (_, _) => const SizedBox()),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pl')],
        routerConfig: router,
      ),
    );

    addTearDown(router.dispose);

    expect(find.byType(TextFormField), findsNothing);
    final ctaSemantics = tester.getSemantics(
      find.byKey(const ValueKey('auth-bff-login-cta-semantics')),
    );
    expect(ctaSemantics.label, 'Przejdź do bezpiecznego logowania');
    expect(ctaSemantics.flagsCollection.isButton, isTrue);
    expect(ctaSemantics.flagsCollection.isEnabled.toBoolOrNull(), isTrue);
    await tester.tap(find.text('Przejdź do bezpiecznego logowania'));
    await tester.pumpAndSettle();

    expect(transport.signInCalls, 1);
    expect(auth.session.snapshot.isAuthenticated, isTrue);
    semantics.dispose();
  });

  testWidgets('redirect-start does not flash an error', (tester) async {
    final transport = _FakeWebBffTransport(
      failure: const AuthFailure(
        'Redirect started',
        code: 'auth.bff.redirect_started',
      ),
    );
    final auth = AuthComposition.fromWebBff(transport);
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, state) => AuthRoutePage(
            kind: AuthRouteKind.login,
            useCases: auth.useCases,
            session: auth.session,
            returnTo: state.uri.queryParameters['returnTo'],
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pl')],
        routerConfig: router,
      ),
    );
    addTearDown(router.dispose);

    await tester.tap(find.text('Przejdź do bezpiecznego logowania'));
    await tester.pump();

    expect(find.text('Redirect started'), findsNothing);
    expect(
      find.text('Przekierowywanie do bezpiecznego logowania...'),
      findsOneWidget,
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });
}

final class _FakeWebBffTransport implements WebBffSessionTransport {
  _FakeWebBffTransport({this.failure});

  final AuthFailure? failure;
  int signInCalls = 0;

  @override
  Future<AuthUser?> restoreSession() async => null;

  @override
  Future<AuthUser> signIn(LoginCredentials credentials) async {
    signInCalls++;
    if (failure case final error?) throw error;
    return const AuthUser(
      userId: '11111111-1111-4111-8111-111111111111',
      login: 'anna',
      displayName: 'Anna',
    );
  }

  @override
  Future<void> signOut() async {}
}

final class _FakeDesktopTransport implements DesktopPkceSessionTransport {
  int interactiveCalls = 0;

  @override
  Future<DesktopTokenResult> authorizeInteractively() async {
    interactiveCalls++;
    return const DesktopTokenResult(
      accessToken: 'access',
      refreshToken: 'refresh',
      expiresIn: Duration(minutes: 10),
    );
  }

  @override
  Future<Uri> beginAuthorization({required Uri callbackUri}) async =>
      callbackUri;
  @override
  Future<DesktopTokenResult> completeAuthorization({
    required String code,
    required String state,
  }) async => authorizeInteractively();
  @override
  Future<DesktopTokenResult?> restoreSession({
    required String refreshToken,
  }) async => null;
  @override
  Future<AuthUser> fetchCurrentUser({required String accessToken}) async =>
      const AuthUser(
        userId: 'desktop-user',
        login: 'desktop',
        displayName: 'Desktop',
      );
  @override
  Future<void> revoke({required String refreshToken}) async {}
}

final class _MemoryVault implements SecureRefreshTokenVault {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String refreshToken) async => value = refreshToken;
  @override
  Future<void> clear() async => value = null;
}
