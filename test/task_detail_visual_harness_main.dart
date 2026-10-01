import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/shell/overlays/devplanner_global_panels_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'test_support/task_detail_visual_fixture.dart';
import 'test_support/tasks_board_route_fixture.dart';

/// Isolated Flutter runtime entrypoint for the task modal fixture.
///
/// Uses only in-memory typed repositories and a typed details response. It does
/// not connect to staging, perform auth, or modify server data.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerTasksBoardRouteFallbacks();
  const modeName = String.fromEnvironment(
    'TASK_DETAIL_VISUAL_MODE',
    defaultValue: 'editable',
  );
  const themeName = String.fromEnvironment(
    'TASK_DETAIL_VISUAL_THEME',
    defaultValue: 'light',
  );
  final fixture = TaskDetailVisualFixture(_modeFrom(modeName));
  runApp(_HarnessApp(fixture: fixture, isDark: themeName == 'dark'));
}

TaskDetailVisualMode _modeFrom(String value) => switch (value) {
  'readOnly' => TaskDetailVisualMode.readOnly,
  'archived' => TaskDetailVisualMode.archived,
  'denied' => TaskDetailVisualMode.denied,
  'conflict' => TaskDetailVisualMode.conflict,
  _ => TaskDetailVisualMode.editable,
};

final class _HarnessApp extends StatefulWidget {
  const _HarnessApp({required this.fixture, required this.isDark});

  final TaskDetailVisualFixture fixture;
  final bool isDark;

  @override
  State<_HarnessApp> createState() => _HarnessAppState();
}

final class _HarnessAppState extends State<_HarnessApp> {
  final MaterialTheme _theme = MaterialTheme.crm();

  @override
  void dispose() {
    widget.fixture.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: widget.fixture.router.config,
    supportedLocales: const [Locale('pl'), Locale('en')],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      FlutterQuillLocalizations.delegate,
    ],
    theme: _theme.light(),
    darkTheme: _theme.dark(),
    themeMode: widget.isDark ? ThemeMode.dark : ThemeMode.light,
    builder: (context, child) => DevPlannerGlobalPanelsHost(
      navigation: DevPlannerNavigation(widget.fixture.router.config),
      authSession: widget.fixture.authSession,
      child: child ?? const SizedBox.shrink(),
    ),
  );
}
