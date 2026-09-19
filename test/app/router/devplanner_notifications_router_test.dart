import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/app/shell/devplanner_shell.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/presentation/auth_route_page.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/devplanner_workspaces_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DevPlannerRouter bez globalnych powiadomień', () {
    test('nie uznaje dawnej ścieżki /notifications za trasę standalone', () {
      expect(
        DevPlannerRouteCatalog.isStandalonePath('/notifications'),
        isFalse,
      );
      expect(DevPlannerRouteCatalog.safeInitialLocation('/notifications'), '/');
    });

    testWidgets('zalogowana sesja trafia z /notifications do Workspace root', (
      tester,
    ) async {
      final router = DevPlannerRouter(
        initialLocation: '/notifications',
        auth: _RouterAuthFixture.authenticated(),
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(_RouterAuthFixture.app(router));
      await tester.pumpAndSettle();

      expect(find.byType(DevPlannerShellRoute), findsOneWidget);
      expect(find.byType(DevPlannerWorkspacesPage), findsOneWidget);
      expect(find.byType(AuthRoutePage), findsNothing);
    });

    testWidgets('niezalogowana sesja pozostaje fail-closed po /notifications', (
      tester,
    ) async {
      final router = DevPlannerRouter(initialLocation: '/notifications');
      addTearDown(router.dispose);

      await tester.pumpWidget(_RouterAuthFixture.app(router));
      await tester.pumpAndSettle();

      expect(find.byType(AuthRoutePage), findsOneWidget);
      expect(find.byType(DevPlannerShellRoute), findsNothing);
    });
  });
}

abstract final class _RouterAuthFixture {
  static AuthComposition authenticated() {
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    return auth;
  }

  static Widget app(DevPlannerRouter router) {
    final theme = MaterialTheme.crm();
    return MaterialApp.router(
      locale: const Locale('pl'),
      supportedLocales: const [Locale('pl'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: theme.light(),
      darkTheme: theme.dark(),
      routerConfig: router.config,
    );
  }
}
