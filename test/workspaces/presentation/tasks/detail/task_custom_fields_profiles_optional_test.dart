import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_detail_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
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

void main() {
  testWidgets('does not require the optional profile port for text fields', (
    tester,
  ) async {
    await _pumpEditor(tester, [_field(TaskCustomFieldType.text)]);

    await tester.tap(find.text('Open editor'));
    await tester.pumpAndSettle();

    expect(find.byType(EditCustomFieldsDialog), findsOneWidget);
    expect(find.text('Nazwa własna'), findsOneWidget);
    expect(
      find.text('Katalog użytkowników jest niedostępny w tym widoku.'),
      findsNothing,
    );
  });

  testWidgets('shows unavailable profiles when user field has no port', (
    tester,
  ) async {
    await _pumpEditor(tester, [_field(TaskCustomFieldType.user)]);

    await tester.tap(find.text('Open editor'));
    await tester.pumpAndSettle();

    expect(find.byType(EditCustomFieldsDialog), findsOneWidget);
    expect(
      find.text('Katalog użytkowników jest niedostępny w tym widoku.'),
      findsOneWidget,
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}

Future<void> _pumpEditor(
  WidgetTester tester,
  List<TaskCustomFieldDefinitionValueResponse> fields,
) async {
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
    BlocProvider.value(
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
                    builder: (_) => EditCustomFieldsDialog(fields: fields),
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
}

TaskCustomFieldDefinitionValueResponse _field(TaskCustomFieldType type) =>
    TaskCustomFieldDefinitionValueResponse(
      id: 'field-1',
      name: 'Nazwa własna',
      type: type,
      isRequired: false,
      position: 0,
      options: type == TaskCustomFieldType.user ? null : const [],
    );
