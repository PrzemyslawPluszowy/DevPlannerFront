import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_list_command_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final width in [360.0, 768.0, 1000.0, 1250.0]) {
    testWidgets('columns and clear stay visible at $width px', (tester) async {
      tester.view.physicalSize = Size(width, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().dark(),
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: TaskListCommandBar(
                listState: ProjectTasksListReady(
                  tasks: [],
                  status: ProjectTaskStatus.done,
                  priority: TaskPriority.critical,
                  assigneeUserId: null,
                  myInvolvement: null,
                  unassignedOnly: false,
                  nextCursor: null,
                ),
                preferencesState: TaskListPreferencesLoading(),
                memberProfiles: {},
                hasCustomWorkflow: false,
              ),
            ),
          ),
        ),
      );
      final columns = find.byKey(const ValueKey('command_columns'));
      final clear = find.byKey(const ValueKey('command_clear_filters'));
      final initialColumns = tester.getRect(columns);
      final initialClear = tester.getRect(clear);
      expect(initialColumns.left, greaterThanOrEqualTo(0));
      expect(initialColumns.right, lessThanOrEqualTo(width));
      expect(initialClear.right, lessThanOrEqualTo(width));
      expect(clear.hitTestable(), findsOneWidget);
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(-300, 0),
      );
      await tester.pumpAndSettle();
      expect(tester.getRect(columns), initialColumns);
      expect(tester.getRect(clear), initialClear);
      expect(tester.takeException(), isNull);
    });
  }
}
