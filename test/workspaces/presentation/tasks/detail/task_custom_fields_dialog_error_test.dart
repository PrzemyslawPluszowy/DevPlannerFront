import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_custom_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _TasksRepository extends Mock implements TasksRepository {}

final class _AcceptanceRepository extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _ChecklistRepository extends Mock
    implements TaskChecklistRepository {}

final class _MetadataRepository extends Mock
    implements TaskMetadataRepository {}

final class _CustomFieldsPayloadFake extends Fake
    implements ReplaceTaskCustomFieldValuesPayload {}

void main() {
  setUpAll(() {
    registerFallbackValue(_CustomFieldsPayloadFake());
  });

  testWidgets('409 stays in custom fields editor and preserves its draft', (
    tester,
  ) async {
    final metadata = _MetadataRepository();
    const error = ApiError(
      type: ApiErrorType.conflict,
      message: 'Task changed on the server.',
      contractCode: 'task_version_conflict',
      traceId: 'custom-fields-trace',
    );
    final tasks = _TasksRepository();
    when(
      () => tasks.getTask(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      ),
    ).thenAnswer((_) async => Right(_details()));
    when(
      () => metadata.replaceCustomFieldValues(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async => const Left(error));
    final cubit = TaskDetailsCubit(
      repository: tasks,
      acceptanceCriteriaRepository: _AcceptanceRepository(),
      checklistRepository: _ChecklistRepository(),
      metadataRepository: metadata,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    cubit.emit(TaskDetailsReady(_details()));
    addTearDown(cubit.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: MaterialTheme.crm().light(),
          home: TaskDetailsModalTheme(
            child: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: TextButton(
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (_) => EditCustomFieldsDialog(
                        fields: [_field(value: 'Before')],
                      ),
                    ),
                    child: const Text('Open editor'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open editor'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Unsaved draft');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(EditCustomFieldsDialog), findsOneWidget);
    expect(find.byType(TaskDetailsModalError), findsOneWidget);
    expect(find.textContaining('task_version_conflict'), findsOneWidget);
    expect(find.textContaining('custom-fields-trace'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Unsaved draft',
    );
    verify(
      () => metadata.replaceCustomFieldValues(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
        payload: any(named: 'payload'),
      ),
    ).called(1);
  });
}

TaskCustomFieldDefinitionValueResponse _field({required String value}) =>
    TaskCustomFieldDefinitionValueResponse(
      id: 'field-1',
      name: 'Summary',
      type: TaskCustomFieldType.text,
      isRequired: false,
      position: 0,
      options: const [],
      value: value,
    );

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
