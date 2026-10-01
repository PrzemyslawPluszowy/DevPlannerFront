import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_route_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'tasks_board_route_fixture.dart';

/// Montuje prawdziwą trasę Tasks i pozwala wymieniać jej typowane porty.
final class TasksBoardRouteTestHarness extends StatefulWidget {
  const TasksBoardRouteTestHarness({
    required this.fixture,
    this.initialView = 'kanban',
    this.authSession,
    super.key,
  });

  final TasksBoardRouteFixture fixture;
  final String? initialView;
  final AuthSessionPort? authSession;

  @override
  State<TasksBoardRouteTestHarness> createState() =>
      _TasksBoardRouteTestHarnessState();
}

final class _TasksBoardRouteTestHarnessState
    extends State<TasksBoardRouteTestHarness> {
  late final AuthSessionController _ownedSession;
  late final ValueNotifier<_TasksBoardRouteTestConfig> _config;
  late final GoRouter _router;

  late TasksBoardComposition _composition;
  late ProjectSettingsComposition _projectSettings;

  AuthSessionPort get _session => widget.authSession ?? _ownedSession;

  @override
  void initState() {
    super.initState();
    _ownedSession = _createSession();
    _composition = widget.fixture.composition;
    _projectSettings = widget.fixture.settings.composition;
    _config = ValueNotifier(_currentConfig);
    _router = _createRouter();
  }

  _TasksBoardRouteTestConfig get _currentConfig => _TasksBoardRouteTestConfig(
    composition: _composition,
    projectSettings: _projectSettings,
    authSession: _session,
  );

  @override
  void didUpdateWidget(covariant TasksBoardRouteTestHarness oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.fixture, widget.fixture)) {
      _composition = widget.fixture.composition;
      _projectSettings = widget.fixture.settings.composition;
    }
    if (!identical(oldWidget.fixture, widget.fixture) ||
        !identical(oldWidget.authSession, widget.authSession)) {
      _config.value = _currentConfig;
    }
    if (oldWidget.initialView != widget.initialView) {
      _router.go(_location(widget.initialView));
    }
  }

  @override
  void dispose() {
    _router.dispose();
    _config.dispose();
    _ownedSession.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: _router,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('pl'),
  );

  GoRouter _createRouter() => GoRouter(
    initialLocation: _location(widget.initialView),
    routes: [
      GoRoute(
        path: '/workspaces/:workspaceId/projects/:projectId/tasks',
        builder: (context, routeState) => ValueListenableBuilder(
          valueListenable: _config,
          builder: (context, config, _) => Scaffold(
            body: TasksBoardRoutePage(
              composition: config.composition,
              projectSettings: config.projectSettings,
              workspaceId: routeState.pathParameters['workspaceId']!,
              projectId: routeState.pathParameters['projectId']!,
              authSession: config.authSession,
              initialView: routeState.uri.queryParameters['view'],
            ),
          ),
        ),
      ),
    ],
  );

  String _location(String? view) {
    const route = '/workspaces/workspace-1/projects/project-1/tasks';
    return view == null ? route : '$route?view=$view';
  }

  AuthSessionController _createSession() => AuthSessionController(
    initial: const AuthSessionSnapshot(
      status: AuthSessionStatus.signedIn,
      user: AuthUser(userId: 'user-1', login: 'tester', displayName: 'Tester'),
    ),
  );
}

final class _TasksBoardRouteTestConfig {
  const _TasksBoardRouteTestConfig({
    required this.composition,
    required this.projectSettings,
    required this.authSession,
  });

  final TasksBoardComposition composition;
  final ProjectSettingsComposition projectSettings;
  final AuthSessionPort authSession;
}
