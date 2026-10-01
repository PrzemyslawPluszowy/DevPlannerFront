import 'dart:async';

import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/devplanner_workspaces_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_columns_viewport.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_open_intent.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/project_tasks_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_support/tasks_board_route_fixture.dart';

const _workspaceId = '550e8400-e29b-41d4-a716-446655440000';
const _projectId = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
const _taskId = '550e8400-e29b-41d4-a716-446655440002';
const _tasksPath = '/workspaces/$_workspaceId/projects/$_projectId/tasks';

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

  testWidgets(
    'query tab change retains the HTTP task scope and failure state',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 720));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var taskReads = 0;
      final dio = Dio();
      addTearDown(dio.close);
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/tasks/$_taskId')) taskReads++;
            handler.resolve(
              Response<dynamic>(
                requestOptions: options,
                statusCode: 500,
                data: {'code': 'qa.read_failed', 'message': 'QA read failed'},
              ),
            );
          },
        ),
      );
      final transport = DevPlannerHttpTransport(
        dio: dio,
        baseUrl: 'https://qa.invalid',
        isWeb: true,
        enableDiagnosticLogging: false,
      );
      final auth = AuthComposition.unavailable();
      auth.session.setSignedIn(
        const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
      );
      final fixture = TasksBoardRouteFixture(
        workspaceId: _workspaceId,
        projectId: _projectId,
        boardResult: kanbanBoardResultWithColumns,
      );
      final router = DevPlannerRouter(
        initialLocation: '$_tasksPath?view=list&task=$_taskId',
        auth: auth,
        httpTransport: transport,
        tasksBoardComposition: fixture.composition,
        projectSettingsComposition: fixture.settings.composition,
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(_app(router));
      await tester.pumpAndSettle();
      expect(taskReads, 1);
      final failureBefore = tester.element(find.byType(TaskDetailsModalError));
      router.config.go('$_tasksPath?view=list&task=$_taskId&taskTab=planning');
      await tester.pumpAndSettle();
      expect(
        taskReads,
        1,
        reason: 'A query change must not recreate the task Cubit or retry a failed GET',
      );
      expect(
        tester.element(find.byType(TaskDetailsModalError)),
        same(failureBefore),
      );
      expect(tester.takeException(), isNull);
    },
  );

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

  testWidgets('legacy task link redirects while preserving view parameters', (
    tester,
  ) async {
    final router = _routerAt('$_tasksPath/$_taskId?view=kanban&filter=mine');
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    final current = router.config.routerDelegate.currentConfiguration.uri;
    expect(current.path, _tasksPath);
    expect(current.queryParameters['task'], _taskId);
    expect(current.queryParameters['view'], 'kanban');
    expect(current.queryParameters['filter'], 'mine');
    expect(find.byType(KanbanColumnsViewport), findsOneWidget);
  });

  testWidgets(
    'opening through the legacy route keeps the current board query',
    (
      tester,
    ) async {
      final router = _routerAt('$_tasksPath?view=kanban&filter=mine');
      addTearDown(router.dispose);

      await tester.pumpWidget(_app(router));
      await tester.pumpAndSettle();

      router.config.go(
        DevPlannerRouteCatalog.legacyTask(
          _workspaceId,
          _projectId,
          _taskId,
        ),
      );
      await tester.pumpAndSettle();

      final current = router.config.routerDelegate.currentConfiguration.uri;
      expect(current.path, _tasksPath);
      expect(current.queryParameters['task'], _taskId);
      expect(current.queryParameters['view'], 'kanban');
      expect(current.queryParameters['filter'], 'mine');
      expect(find.byType(KanbanColumnsViewport), findsOneWidget);
    },
  );

  testWidgets('task query opens and dismisses the modal over the same board', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = _routerAt('$_tasksPath?view=kanban&filter=mine');
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();
    final kanbanBefore = tester.element(find.byType(KanbanColumnsViewport));

    router.config.go('$_tasksPath?view=kanban&filter=mine&task=$_taskId');
    await tester.pumpAndSettle();

    expect(find.byType(KanbanColumnsViewport), findsOneWidget);
    expect(
      tester.element(find.byType(KanbanColumnsViewport)),
      same(kanbanBefore),
    );
    expect(find.text('Transport workspace niedostępny'), findsOneWidget);
    expect(
      router.config.routerDelegate.currentConfiguration.uri.queryParameters,
      containsPair('filter', 'mine'),
    );

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    final current = router.config.routerDelegate.currentConfiguration.uri;
    expect(current.path, _tasksPath);
    expect(current.queryParameters['task'], isNull);
    expect(current.queryParameters['view'], 'kanban');
    expect(current.queryParameters['filter'], 'mine');
    expect(
      tester.element(find.byType(KanbanColumnsViewport)),
      same(kanbanBefore),
    );
  });

  testWidgets(
    'task query keeps the same List mounted through close and reopen',
    (
      tester,
    ) async {
      final router = _routerAt('$_tasksPath?view=list&filter=mine');
      addTearDown(router.dispose);

      await tester.pumpWidget(_app(router));
      await tester.pumpAndSettle();
      final listBefore = tester.element(find.byType(ProjectTasksList));
      expect(listBefore, isNotNull);

      const taskLocation = '$_tasksPath?view=list&filter=mine&task=$_taskId';
      router.config.go(taskLocation);
      await tester.pumpAndSettle();
      expect(find.byType(ProjectTasksList), findsOneWidget);
      expect(tester.element(find.byType(ProjectTasksList)), same(listBefore));
      expect(find.text('Transport workspace niedostępny'), findsOneWidget);

      // Symuluje Back oraz Forward przeglądarki: ta sama trasa przyjmuje URL
      // bez task, a potem ponownie z task.
      router.config.go('$_tasksPath?view=list&filter=mine');
      await tester.pumpAndSettle();
      expect(find.byType(ProjectTasksList), findsOneWidget);
      expect(tester.element(find.byType(ProjectTasksList)), same(listBefore));
      expect(find.text('Transport workspace niedostępny'), findsNothing);

      router.config.go(taskLocation);
      await tester.pumpAndSettle();
      expect(find.byType(ProjectTasksList), findsOneWidget);
      expect(tester.element(find.byType(ProjectTasksList)), same(listBefore));
      expect(find.text('Transport workspace niedostępny'), findsOneWidget);
    },
  );

  testWidgets('invalid task query is removed without changing the view', (
    tester,
  ) async {
    final router = _routerAt('$_tasksPath?view=kanban&task=not-a-uuid');
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    final current = router.config.routerDelegate.currentConfiguration.uri;
    expect(current.path, _tasksPath);
    expect(current.queryParameters['task'], isNull);
    expect(current.queryParameters['view'], 'kanban');
    expect(find.byType(KanbanColumnsViewport), findsOneWidget);
  });

  testWidgets('task deep link without view defaults to the List', (
    tester,
  ) async {
    final router = _routerAt('$_tasksPath?task=$_taskId');
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    final current = router.config.routerDelegate.currentConfiguration.uri;
    expect(current.queryParameters['task'], _taskId);
    expect(current.queryParameters['view'], 'list');
    expect(find.byType(ProjectTasksList), findsOneWidget);
    expect(find.byType(KanbanColumnsViewport), findsNothing);
  });

  testWidgets('task opened from My Tasks returns there on close', (
    tester,
  ) async {
    final router = _routerAt('/me/tasks');
    addTearDown(router.dispose);

    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();
    router.config.go(
      DevPlannerRouteCatalog.task(
        _workspaceId,
        _projectId,
        _taskId,
        source: TaskDetailOpenSource.myTasks,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      router.config.routerDelegate.currentConfiguration.uri.path,
      _tasksPath,
    );
    expect(find.text('Transport workspace niedostępny'), findsOneWidget);

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    expect(
      router.config.routerDelegate.currentConfiguration.uri.path,
      '/me/tasks',
    );
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
