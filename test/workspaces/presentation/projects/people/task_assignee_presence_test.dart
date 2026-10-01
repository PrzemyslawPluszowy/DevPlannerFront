import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/projects/people/project_member_presence_dot.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'list exposes each assignee presence and does not overflow narrow cells',
    (tester) async {
      final task = ProjectTaskListItemResponse(
        id: 'task',
        number: 1,
        key: 'TASK-1',
        title: 'QA',
        status: ProjectTaskStatus.backlog,
        priority: TaskPriority.normal,
        assignees: [
          TaskAssigneeResponse(
            userId: 'online',
            isPrimary: true,
            createdAtUtc: DateTime.utc(2026),
          ),
          TaskAssigneeResponse(
            userId: 'offline',
            isPrimary: false,
            createdAtUtc: DateTime.utc(2026),
          ),
        ],
        checklistCompletedCount: 0,
        checklistTotalCount: 0,
        updatedAtUtc: DateTime.utc(2026),
        version: 1,
      );
      const profiles = {
        'online': ProjectMemberProfile(
          userId: 'online',
          role: ProjectRole.member,
          displayName: 'Długie imię i nazwisko osoby online',
          isOnline: true,
        ),
        'offline': ProjectMemberProfile(
          userId: 'offline',
          role: ProjectRole.member,
          displayName: 'Długie imię i nazwisko osoby offline',
          isOnline: false,
        ),
      };
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 160,
                child: TaskCellAssignees(task: task, profiles: profiles),
              ),
            ),
          ),
        ),
      );
      expect(
        tester
            .widgetList<ProjectMemberPresenceDot>(
              find.byType(ProjectMemberPresenceDot),
            )
            .map((dot) => dot.isOnline),
        [true, false],
      );
      expect(find.byTooltip('Online'), findsOneWidget);
      expect(find.byTooltip('Offline'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ProjectMemberPresenceDot(isOnline: null)),
        ),
      );
      expect(find.byTooltip('Brak aktualnego statusu'), findsOneWidget);
      expect(find.byTooltip('Offline'), findsNothing);
    },
  );
}
