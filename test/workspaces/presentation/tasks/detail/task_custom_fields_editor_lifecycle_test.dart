import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_detail_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_custom_fields_editor.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mocktail/mocktail.dart';

final class _TasksRepository extends Mock implements TasksRepository {}

final class _AcceptanceRepository extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _ChecklistRepository extends Mock
    implements TaskChecklistRepository {}

TaskDetailsCubit _taskCubit() => TaskDetailsCubit(
  repository: _TasksRepository(),
  acceptanceCriteriaRepository: _AcceptanceRepository(),
  checklistRepository: _ChecklistRepository(),
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  taskId: 'task-1',
);

void main() {
  testWidgets('discards a date picked from a stale field value', (
    tester,
  ) async {
    final cubit = _taskCubit();
    addTearDown(cubit.close);
    final key = GlobalKey<_DateHarnessState>();

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(child: _DateHarness(key: key)),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Symbols.calendar_today));
    await tester.pumpAndSettle();
    expect(find.byType(CompactWebDatePickerPanel), findsOneWidget);
    await tester.tap(find.text('20').last);
    key.currentState!.setValue('2026-02-01T00:00:00.000Z');
    await tester.pump();
    final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)))!;
    await tester.tap(find.text(l10n.tasksListSaveButton));
    await tester.pumpAndSettle();

    expect(key.currentState!.changes, isEmpty);
  });

  testWidgets('does not apply an open choice over a newer field value', (
    tester,
  ) async {
    final cubit = _taskCubit();
    addTearDown(cubit.close);
    final key = GlobalKey<_MultiSelectHarnessState>();

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: _MultiSelectHarness(key: key),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('custom_field_values_menu')));
    await tester.pumpAndSettle();
    expect(find.text('beta'), findsOneWidget);

    key.currentState!.setValue(['alpha']);
    await tester.pump();
    await tester.tap(find.text('beta'));
    await tester.pumpAndSettle();

    expect(key.currentState!.changes, isEmpty);
  });
}

final class _DateHarness extends StatefulWidget {
  const _DateHarness({super.key});

  @override
  State<_DateHarness> createState() => _DateHarnessState();
}

final class _DateHarnessState extends State<_DateHarness> {
  static const _field = TaskCustomFieldDefinitionValueResponse(
    id: 'date-field',
    name: 'Termin',
    type: TaskCustomFieldType.date,
    isRequired: false,
    position: 0,
  );

  dynamic _value;
  final changes = <dynamic>[];

  void setValue(dynamic value) => setState(() => _value = value);

  void _recordChange(dynamic value) => changes.add(value);

  @override
  Widget build(BuildContext context) => DateCustomFieldEditor(
    field: _field,
    value: _value,
    enabled: true,
    onChanged: _recordChange,
  );
}

final class _MultiSelectHarness extends StatefulWidget {
  const _MultiSelectHarness({super.key});

  @override
  State<_MultiSelectHarness> createState() => _MultiSelectHarnessState();
}

final class _MultiSelectHarnessState extends State<_MultiSelectHarness> {
  static const _field = TaskCustomFieldDefinitionValueResponse(
    id: 'field-1',
    name: 'Wybór',
    type: TaskCustomFieldType.multiSelect,
    isRequired: false,
    position: 0,
    options: ['alpha', 'beta'],
  );

  dynamic _value;
  final changes = <dynamic>[];

  void setValue(dynamic value) => setState(() => _value = value);

  void _recordChange(dynamic value) => changes.add(value);

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextButton(
        onPressed: () => setValue(['alpha']),
        child: const Text('Aktualizuj wartość'),
      ),
      MultiSelectCustomFieldEditor(
        field: _field,
        value: _value,
        enabled: true,
        onChanged: _recordChange,
      ),
    ],
  );
}
