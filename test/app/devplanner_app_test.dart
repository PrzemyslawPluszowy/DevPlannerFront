import 'package:devplanner/app/devplanner_app.dart';
import 'package:devplanner/app/shell/devplanner_shell.dart';
import 'package:devplanner/app/theme/theme_preference.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/presentation/auth_route_page.dart';
import 'package:devplanner/bootstrap/host_launch_context.dart';
import 'package:devplanner/workspaces/presentation/devplanner_workspaces_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DevPlannerApp standalone root', () {
    testWidgets('renderuje samodzielny shell i root workspace sesji', (
      tester,
    ) async {
      await tester.pumpWidget(
        DevPlannerApp(
          launchContext: const HostLaunchContext(
            initialRoute: '/workspaces',
            userId: 'test-user-id',
            userDisplayName: 'Test User',
          ),
          auth: _authenticatedAuth(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DevPlannerShellRoute), findsOneWidget);
      expect(find.byType(DevPlannerWorkspacesPage), findsOneWidget);
      expect(find.byType(AuthRoutePage), findsNothing);
    });

    testWidgets('fail-closed kieruje nieuwierzytelnioną sesję na logowanie', (
      tester,
    ) async {
      await tester.pumpWidget(
        const DevPlannerApp(
          launchContext: HostLaunchContext(
            initialRoute: '/workspaces',
            userId: null,
            userDisplayName: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AuthRoutePage), findsOneWidget);
      expect(find.byType(DevPlannerShellRoute), findsNothing);
    });

    testWidgets('nie udostępnia dawnej trasy globalnego overlayu Chat', (
      tester,
    ) async {
      await tester.pumpWidget(
        DevPlannerApp(
          launchContext: const HostLaunchContext(
            initialRoute: '/chat',
            userId: 'test-user-id',
            userDisplayName: 'Test User',
          ),
          auth: _authenticatedAuth(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DevPlannerShellRoute), findsOneWidget);
      expect(find.byType(DevPlannerWorkspacesPage), findsOneWidget);
      expect(find.byType(AuthRoutePage), findsNothing);
    });

    testWidgets(
      'zapamiętany motyw i belka przełączają tylko jasny oraz ciemny',
      (
        tester,
      ) async {
        final store = _ThemePreferenceStore(DevPlannerThemePreference.dark);
        await tester.pumpWidget(
          DevPlannerApp(
            launchContext: const HostLaunchContext(
              initialRoute: '/workspaces',
              userId: 'test-user-id',
              userDisplayName: 'Test User',
            ),
            auth: _authenticatedAuth(),
            themePreferenceStore: store,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          Theme.of(tester.element(find.byType(DevPlannerShellRoute)))
              .brightness,
          Brightness.dark,
        );

        await tester.tap(find.byKey(const ValueKey('devplanner-toggle-theme')));
        await tester.pumpAndSettle();

        expect(store.preference, DevPlannerThemePreference.light);
        expect(
          Theme.of(tester.element(find.byType(DevPlannerShellRoute)))
              .brightness,
          Brightness.light,
        );
      },
    );
  });
}

AuthComposition _authenticatedAuth() {
  final auth = AuthComposition.unavailable();
  auth.session.setSignedIn(
    const AuthUser(
      userId: 'test-user-id',
      login: 'testuser',
      displayName: 'Test User',
    ),
  );
  return auth;
}

final class _ThemePreferenceStore implements ThemePreferenceStore {
  _ThemePreferenceStore(this.preference);

  DevPlannerThemePreference preference;

  @override
  Future<DevPlannerThemePreference> read() async => preference;

  @override
  Future<void> write(DevPlannerThemePreference value) async {
    preference = value;
  }
}
