import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/shell/overlays/devplanner_global_panels_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_registry.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_modal_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../test_support/task_detail_visual_fixture.dart';
import '../../../../../../test_support/tasks_board_route_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerTasksBoardRouteFallbacks();
    SharedPreferences.setMockInitialValues({});
  });

  for (final tab in ['conversation', 'files']) {
    testWidgets('deep link taskTab=$tab selects the requested task tab', (
      tester,
    ) async {
      final fixture = TaskDetailVisualFixture(
        TaskDetailVisualMode.editable,
        initialTaskTab: tab,
      );
      addTearDown(fixture.dispose);
      await _mountAndLoad(tester, fixture);

      final l10n = AppLocalizations.of(
        tester.element(find.byType(TaskDetailsContent)),
      )!;
      final label = tab == 'conversation'
          ? l10n.taskDetailsTabConversation
          : l10n.taskDetailsTabFiles;
      expect(_isSelected(tester, label), isTrue);
    });
  }

  testWidgets('same-task tab changes preserve Cubit and dirty draft', (
    tester,
  ) async {
    final fixture = TaskDetailVisualFixture(TaskDetailVisualMode.editable);
    addTearDown(fixture.dispose);
    await _mountAndLoad(tester, fixture);

    final content = find.byType(TaskDetailsContent);
    final contentState = tester.state(content);
    final contentContext = tester.element(content);
    final cubit = contentContext.read<TaskDetailsCubit>();
    final draft = TaskDetailDraftScope.maybeOf(contentContext)!
        .registerDraft(label: 'tab-regression');
    draft.markDirty();
    final l10n = AppLocalizations.of(contentContext)!;

    fixture.router.config.go(_taskLocation('conversation'));
    await tester.pumpAndSettle();
    expect(_isSelected(tester, l10n.taskDetailsTabConversation), isTrue);
    _expectModalStateUnchanged(tester, content, contentState, cubit, draft);

    fixture.router.config.go(_taskLocation('files'));
    await tester.pumpAndSettle();
    expect(_isSelected(tester, l10n.taskDetailsTabFiles), isTrue);
    _expectModalStateUnchanged(tester, content, contentState, cubit, draft);

    fixture.router.config.go(_taskLocation(null));
    await tester.pumpAndSettle();
    expect(_isSelected(tester, l10n.taskDetailsTabWork), isTrue);
    _expectModalStateUnchanged(tester, content, contentState, cubit, draft);
    draft.dispose();
  });

  testWidgets(
    'an explicitly removed task return is not restored from board history',
    (
      tester,
    ) async {
      final fixture = TaskDetailVisualFixture(TaskDetailVisualMode.editable);
      addTearDown(fixture.dispose);
      await _mountAndLoad(tester, fixture);
      final current = Uri.parse(_taskLocation(null));
      fixture.router.config.go(
        current
            .replace(
              queryParameters: {
                ...current.queryParameters,
                'taskReturn': '/me/tasks',
              },
            )
            .toString(),
      );
      await _pumpRouteUpdate(tester);
      expect(
        fixture
            .router
            .config
            .routerDelegate
            .currentConfiguration
            .uri
            .queryParameters['taskReturn'],
        '/me/tasks',
      );

      fixture.router.config.go(current.toString());
      await _pumpRouteUpdate(tester);
      final actual =
          fixture.router.config.routerDelegate.currentConfiguration.uri;
      expect(actual.queryParameters['taskReturn'], isNull);
      expect(actual.queryParameters['view'], 'kanban');
      expect(actual.queryParameters['filter'], 'mine');
    },
  );

  testWidgets('user tab selection updates only taskTab in the URL', (
    tester,
  ) async {
    final fixture = TaskDetailVisualFixture(TaskDetailVisualMode.editable);
    addTearDown(fixture.dispose);
    await _mountAndLoad(tester, fixture);
    fixture.router.config.go(_taskLocation(null));
    await _pumpRouteUpdate(tester);
    final content = find.byType(TaskDetailsContent);
    final contentState = tester.state(content);
    final cubit = tester.element(content).read<TaskDetailsCubit>();
    final l10n = AppLocalizations.of(tester.element(content))!;

    await tester.tap(
      find.descendant(
        of: find.byType(TaskDetailsModalTabs),
        matching: find.text(l10n.taskDetailsTabConversation),
      ),
    );
    await tester.pumpAndSettle();

    final uri = fixture.router.config.routerDelegate.currentConfiguration.uri;
    expect(uri.queryParameters['taskTab'], 'conversation');
    expect(uri.queryParameters['task'], visualTaskId);
    expect(uri.queryParameters['view'], 'kanban');
    expect(uri.queryParameters['filter'], 'mine');
    expect(tester.state(content), same(contentState));
    expect(tester.element(content).read<TaskDetailsCubit>(), same(cubit));

    await tester.tap(
      find.descendant(
        of: find.byType(TaskDetailsModalTabs),
        matching: find.text(l10n.taskDetailsTabWork),
      ),
    );
    await tester.pumpAndSettle();
    final workUri =
        fixture.router.config.routerDelegate.currentConfiguration.uri;
    expect(workUri.queryParameters['taskTab'], isNull);
    expect(workUri.queryParameters['task'], visualTaskId);
    expect(workUri.queryParameters['view'], 'kanban');
    expect(workUri.queryParameters['filter'], 'mine');
    expect(tester.state(content), same(contentState));
    expect(tester.element(content).read<TaskDetailsCubit>(), same(cubit));
  });
}

Widget _app(TaskDetailVisualFixture fixture) => MaterialApp.router(
  routerConfig: fixture.router.config,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('pl'),
  theme: MaterialTheme.crm().light(),
  darkTheme: MaterialTheme.crm().dark(),
  builder: (context, child) => DevPlannerGlobalPanelsHost(
    navigation: DevPlannerNavigation(fixture.router.config),
    authSession: fixture.authSession,
    child: child ?? const SizedBox.shrink(),
  ),
);

Future<void> _mountAndLoad(
  WidgetTester tester,
  TaskDetailVisualFixture fixture,
) async {
  tester.view.physicalSize = const Size(1440, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(_app(fixture));
  for (var frame = 0; frame < 30; frame++) {
    if (find.byType(TaskDetailsContent).evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 100));
  }
  fail('Task detail did not reach its ready content in the fixture.');
}

Future<void> _pumpRouteUpdate(WidgetTester tester) async {
  // The loaded task shell keeps scheduling unrelated frames; this route test
  // only needs the URL notification and one transition interval to complete.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

bool _isSelected(WidgetTester tester, String label) =>
    tester
        .widget<TaskDetailsModalTabs>(find.byType(TaskDetailsModalTabs))
        .selected ==
    _tabForLabel(tester, label);

TaskDetailsModalTab _tabForLabel(WidgetTester tester, String label) {
  final l10n = AppLocalizations.of(
    tester.element(find.byType(TaskDetailsModalTabs)),
  )!;
  if (label == l10n.taskDetailsTabWork) return TaskDetailsModalTab.work;
  if (label == l10n.taskDetailsTabConversation) {
    return TaskDetailsModalTab.conversation;
  }
  if (label == l10n.taskDetailsTabFiles) return TaskDetailsModalTab.files;
  if (label == l10n.taskDetailsTabPlanAndTime) {
    return TaskDetailsModalTab.planAndTime;
  }
  return TaskDetailsModalTab.history;
}

void _expectModalStateUnchanged(
  WidgetTester tester,
  Finder content,
  State contentState,
  TaskDetailsCubit cubit,
  TaskDetailDraftRegistration draft,
) {
  expect(tester.state(content), same(contentState));
  expect(tester.element(content).read<TaskDetailsCubit>(), same(cubit));
  expect(draft.isDirty, isTrue);
}

String _taskLocation(String? taskTab) {
  final query = <String, String>{
    'view': 'kanban',
    'filter': 'mine',
    'task': visualTaskId,
  };
  if (taskTab != null) query['taskTab'] = taskTab;
  return Uri(
    path: '/workspaces/$visualWorkspaceId/projects/$visualProjectId/tasks',
    queryParameters: query,
  ).toString();
}
