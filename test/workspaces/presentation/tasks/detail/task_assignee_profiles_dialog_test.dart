import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_collaboration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _TasksRepository extends Mock implements TasksRepository {}

final class _AcceptanceRepository extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _ChecklistRepository extends Mock
    implements TaskChecklistRepository {}

final class _ProfilesRepository extends Mock
    implements ProjectMemberProfilesRepository {}

void main() {
  testWidgets('profile API failure is shown and retry loads assignees', (
    tester,
  ) async {
    final profiles = _ProfilesRepository();
    const apiError = ApiError(
      type: ApiErrorType.forbidden,
      message: 'Nie można pobrać członków projektu.',
      contractCode: 'project_members_forbidden',
      traceId: 'profile-trace',
    );
    var attempts = 0;
    when(
      () => profiles.listProfiles(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer((_) async {
      attempts++;
      if (attempts == 1) return const Left(apiError);
      return const Right<ApiError, List<ProjectMemberProfile>>([
        ProjectMemberProfile(
          userId: 'member-1',
          role: ProjectRole.member,
          displayName: 'Ala',
        ),
      ]);
    });
    final cubit = TaskDetailsCubit(
      repository: _TasksRepository(),
      acceptanceCriteriaRepository: _AcceptanceRepository(),
      checklistRepository: _ChecklistRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    addTearDown(cubit.close);

    await tester.pumpWidget(
      RepositoryProvider<ProjectMemberProfilesRepository>.value(
        value: profiles,
        child: BlocProvider.value(
          value: cubit,
          child: MaterialApp(
            locale: const Locale('pl'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: MaterialTheme.crm().light(),
            home: Builder(
              builder: (context) => TaskDetailsModalTheme(
                child: Scaffold(
                  body: Center(
                    child: TextButton(
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (_) => EditAssigneesDialog(task: _task()),
                      ),
                      child: const Text('Otwórz przypisania'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Otwórz przypisania'));
    await tester.pumpAndSettle();

    expect(find.text('Nie można pobrać członków projektu.'), findsOneWidget);
    expect(find.textContaining('project_members_forbidden'), findsOneWidget);
    expect(find.textContaining('profile-trace'), findsOneWidget);
    await tester.tap(find.text('Ponów próbę'));
    await tester.pumpAndSettle();

    expect(find.text('Ala'), findsOneWidget);
    verify(
      () => profiles.listProfiles(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).called(2);
  });
}

ProjectTaskResponse _task() => ProjectTaskResponse(
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
);
