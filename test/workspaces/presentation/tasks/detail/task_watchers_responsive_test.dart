import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_collaboration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('watchers label remains whole in narrow scaled PL and EN rails', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(220, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final locale in const [Locale('pl'), Locale('en')]) {
      for (final isDark in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: MaterialTheme.crm().light(),
            darkTheme: MaterialTheme.crm().dark(),
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(2),
              ),
              child: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 210,
                    child: TaskDetailsModalTheme(
                      child: TaskWatchersSection(
                        details: _details(),
                        isSaving: false,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final l10n = AppLocalizations.of(
          tester.element(find.byType(TaskWatchersSection)),
        )!;
        final label = find.text(l10n.taskDetailsWatchers);
        expect(label, findsOneWidget);
        final labelContext = tester.element(label);
        final labelWidget = tester.widget<Text>(label);
        final labelPainter = TextPainter(
          text: TextSpan(
            text: labelWidget.data,
            style: labelWidget.style ?? DefaultTextStyle.of(labelContext).style,
          ),
          textDirection: Directionality.of(labelContext),
          textScaler: MediaQuery.textScalerOf(labelContext),
        )..layout(maxWidth: tester.getSize(label).width);
        expect(
          labelPainter.computeLineMetrics(),
          hasLength(1),
        );
        expect(find.text(l10n.taskDetailsWatch), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });
}

ProjectTaskDetailsResponse _details() => ProjectTaskDetailsResponse(
  task: ProjectTaskResponse(
    id: 'task-1',
    number: 1,
    key: 'TASK-1',
    workspaceId: 'workspace-1',
    projectId: 'project-1',
    title: 'Task',
    status: ProjectTaskStatus.todo,
    priority: TaskPriority.normal,
    taskType: 'Task',
    position: 1,
    createdByUserId: 'user-1',
    assignees: [],
    checklistItems: [],
    createdAtUtc: DateTime.utc(2026),
    updatedAtUtc: DateTime.utc(2026),
    version: 1,
  ),
  labels: [],
  customFields: [],
  acceptanceCriteria: [],
  dependencies: [],
  watchers: [],
  isWatchedByMe: false,
  isPinnedByMe: false,
  subtasks: [],
  workflow: const ProjectTaskWorkflowResponse(
    statuses: [],
    transitions: [],
    version: 1,
  ),
  includedUsers: [],
);
