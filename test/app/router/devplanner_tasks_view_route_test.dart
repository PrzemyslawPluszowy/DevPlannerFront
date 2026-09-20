import 'dart:async';

import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/devplanner_workspaces_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_columns_viewport.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/project_tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_support/tasks_board_route_fixture.dart';

const _workspaceId = '550e8400-e29b-41d4-a716-446655440000';
const _projectId = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
const _tasksPath =
    '/workspaces/$_workspaceId/projects/$_projectId/tasks';

/// Symuluje powrót do zapisanego adresu: nowy router i ta sama lokalizacja.
DevPlannerRouter _routerAt(String location) {
  final auth = AuthComposition.unavailable();
  auth.session.setSignedIn(
    const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
  );
  final fixture = TasksBoardRouteFixture(
    workspaceId: _workspaceId,
    projectId: _projectId,
    boardResult: kanbanBoardResultWithColumns,
  );
  return DevPlannerRouter(
    initialLocation: location,
    auth: auth,
    tasksBoardComposition: fixture.composition,
    projectSettingsComposition: fixture.settings.composition,
  );
}

Widget _app(DevPlannerRouter router) => MaterialApp.router(
  routerConfig: router.config,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('pl'),
);

String _currentUrl(DevPlannerRouter router) =>
    router.config.routerDelegate.currentConfiguration.uri.toString();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  registerTasksBoardRouteFallbacks();

  testWidgets('canonical Tasks deep link opens the List, not the board', (
    tester,
  ) async {
    final router = _routerAt(_tasksPath);
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectTasksList), findsOneWidget);
    expect(find.byType(KanbanColumnsViewport), findsNothing);
    expect(_currentUrl(router), _tasksPath);
  });

  testWidgets('kanban query survives deep link and restart', (tester) async {
    final location = DevPlannerRouteCatalog.projectTasksView(
      _workspaceId,
      _projectId,
      'kanban',
    );
    final first = _routerAt(location);
    addTearDown(first.dispose);

    await tester.pumpWidget(_app(first));
    await tester.pumpAndSettle();

    expect(find.byType(KanbanColumnsViewport), findsOneWidget);
    expect(find.byType(ProjectTasksList), findsNothing);
    expect(_currentUrl(first), location);

    // Restart klienta: ten sam zapisany adres musi odtworzyć ten sam widok.
    final restarted = _routerAt(
      DevPlannerRouteCatalog.safeInitialLocation(_currentUrl(first)),
    );
    addTearDown(restarted.dispose);

    await tester.pumpWidget(_app(restarted));
    await tester.pumpAndSettle();

    expect(find.byType(KanbanColumnsViewport), findsOneWidget);
    expect(_currentUrl(restarted), location);
  });

  testWidgets('legacy view links redirect to the canonical Tasks query', (
    tester,
  ) async {
    final router = _routerAt('$_tasksPath/kanban');
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    expect(
      _currentUrl(router),
      DevPlannerRouteCatalog.projectTasksView(
        _workspaceId,
        _projectId,
        'kanban',
      ),
    );
    expect(find.byType(KanbanColumnsViewport), findsOneWidget);

    router.config.go('$_tasksPath/list');
    await tester.pumpAndSettle();

    expect(
      _currentUrl(router),
      DevPlannerRouteCatalog.projectTasksView(_workspaceId, _projectId, 'list'),
    );
    expect(find.byType(ProjectTasksList), findsOneWidget);
  });

  testWidgets('board stays an accepted input alias for the kanban query', (
    tester,
  ) async {
    final router = _routerAt('$_tasksPath?view=board');
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    expect(find.byType(KanbanColumnsViewport), findsOneWidget);
  });

  testWidgets('changing the URL switches the view in both directions', (
    tester,
  ) async {
    final kanbanUrl = DevPlannerRouteCatalog.projectTasksView(
      _workspaceId,
      _projectId,
      'kanban',
    );
    final listUrl = DevPlannerRouteCatalog.projectTasksView(
      _workspaceId,
      _projectId,
      'list',
    );
    final router = _routerAt(_tasksPath);
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectTasksList), findsOneWidget);

    router.config.go(kanbanUrl);
    await tester.pumpAndSettle();
    expect(find.byType(KanbanColumnsViewport), findsOneWidget);

    // Jawny `?view=` rozstrzyga widok w obie strony. Adres bez zapytania
    // (`/tasks`) znaczy „ostatnio używany widok” — patrz osobny przypadek.
    router.config.go(listUrl);
    await tester.pumpAndSettle();
    expect(find.byType(ProjectTasksList), findsOneWidget);
  });

  testWidgets('the canonical URL reopens the last used view', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = _routerAt(_tasksPath);
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectTasksList), findsOneWidget);

    // Użytkownik wybiera Kanban w nagłówku modułu...
    await tester.tap(find.text('Tablica'));
    await tester.pumpAndSettle();
    expect(find.byType(KanbanColumnsViewport), findsOneWidget);

    // ...a adres kanoniczny `/tasks` bez `?view=` wraca do tego wyboru, bo
    // pozycja „Zadania” w drzewie prowadzi dokładnie tutaj.
    router.config.go(_tasksPath);
    await tester.pumpAndSettle();
    expect(find.byType(KanbanColumnsViewport), findsOneWidget);
    expect(find.byType(ProjectTasksList), findsNothing);
  });

  testWidgets('switching the view writes the canonical Tasks query', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = _routerAt(_tasksPath);
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectTasksList), findsOneWidget);

    await tester.tap(find.text('Tablica'));
    await tester.pumpAndSettle();

    expect(
      _currentUrl(router),
      DevPlannerRouteCatalog.projectTasksView(
        _workspaceId,
        _projectId,
        'kanban',
      ),
    );
    expect(find.byType(KanbanColumnsViewport), findsOneWidget);

    await tester.tap(find.text('Lista'));
    await tester.pumpAndSettle();

    expect(
      _currentUrl(router),
      DevPlannerRouteCatalog.projectTasksView(_workspaceId, _projectId, 'list'),
    );
    expect(find.byType(ProjectTasksList), findsOneWidget);
  });

  testWidgets('root still lands on the Workspaces fallback', (tester) async {
    final router = _routerAt('/');
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    expect(_currentUrl(router), DevPlannerRouteCatalog.workspaces);
    expect(find.byType(DevPlannerWorkspacesPage), findsOneWidget);
  });

  testWidgets('returning to a saved Tasks URL restores its view', (
    tester,
  ) async {
    // Historia przeglądarki i restart desktopu wracają wyłącznie z adresem, więc
    // ten sam URL musi odtworzyć ten sam widok także po ponownym montażu.
    final kanbanUrl = DevPlannerRouteCatalog.projectTasksView(
      _workspaceId,
      _projectId,
      'kanban',
    );
    final first = _routerAt(_tasksPath);
    addTearDown(first.dispose);

    await tester.pumpWidget(_app(first));
    await tester.pumpAndSettle();
    first.config.go(kanbanUrl);
    await tester.pumpAndSettle();
    expect(find.byType(KanbanColumnsViewport), findsOneWidget);

    final restored = _routerAt(
      DevPlannerRouteCatalog.safeInitialLocation(_currentUrl(first)),
    );
    addTearDown(restored.dispose);

    await tester.pumpWidget(_app(restored));
    await tester.pumpAndSettle();

    expect(find.byType(KanbanColumnsViewport), findsOneWidget);
    expect(find.byType(ProjectTasksList), findsNothing);
  });

  testWidgets('browser history returns to the previous Tasks URL', (
    tester,
  ) async {
    final kanbanUrl = DevPlannerRouteCatalog.projectTasksView(
      _workspaceId,
      _projectId,
      'kanban',
    );
    final router = _routerAt(kanbanUrl);
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await _settle(tester);
    expect(find.byType(KanbanColumnsViewport), findsOneWidget);

    // Nowy wpis historii (np. otwarcie zadania) wybiera widok wyłącznie adresem.
    unawaited(router.config.push(_tasksPath));
    await _settle(tester);
    expect(find.byType(ProjectTasksList), findsOneWidget);

    expect(router.config.canPop(), isTrue);
    router.config.pop();
    await _settle(tester);

    expect(_currentUrl(router), kanbanUrl);
    expect(find.byType(KanbanColumnsViewport), findsOneWidget);
    expect(find.byType(ProjectTasksList), findsNothing);
  });
}

/// Rozstrzyga klatki bez czekania na animacje, które mogą trwać w tle.
Future<void> _settle(WidgetTester tester) async {
  for (var frame = 0; frame < 12; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
