import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'explicit no-template disables the default in the create request',
    (tester) async {
      final templates = TaskTemplatePickerCubit(
        repository: _DefaultTemplateRepo(),
        workspaceId: 'workspace',
      );
      addTearDown(templates.close);
      await templates.load();
      var calls = 0;
      String? selectedId = 'not-called';
      var defaultChoice = true;
      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().dark(),
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider.value(
            value: templates,
            child: Scaffold(
              body: TaskQuickCreateDialog(
                columns: const [
                  KanbanColumnResponse(
                    status: ProjectTaskStatus.todo,
                    displayName: 'Do zrobienia',
                    color: '#2563EB',
                    totalTaskCount: 0,
                    isWipLimitExceeded: false,
                    tasks: [],
                  ),
                ],
                onCreate:
                    ({
                      required title,
                      required column,
                      taskTemplateId,
                      useDefaultTemplate = true,
                    }) async {
                      calls++;
                      selectedId = taskTemplateId;
                      defaultChoice = useDefaultTemplate;
                      return false;
                    },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField),
        'QA bez domyślnego szablonu',
      );
      await tester.tap(find.textContaining('Plan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bez szablonu'));
      await tester.pumpAndSettle();
      expect(find.text('Bez szablonu'), findsOneWidget);
      await tester.tap(find.text('Utwórz'));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(selectedId, isNull);
      expect(defaultChoice, isFalse);
    },
  );

  testWidgets(
    'status menu selection and nested Escape preserve the dialog boundary',
    (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().dark(),
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                child: const Text('Open QA'),
                onPressed: () => showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => TaskQuickCreateDialog(
                    columns: const [
                      KanbanColumnResponse(
                        status: ProjectTaskStatus.backlog,
                        displayName: 'Backlog',
                        color: '#64748B',
                        totalTaskCount: 0,
                        isWipLimitExceeded: false,
                        tasks: [],
                      ),
                      KanbanColumnResponse(
                        status: ProjectTaskStatus.todo,
                        displayName: 'Do zrobienia',
                        color: '#2563EB',
                        totalTaskCount: 0,
                        isWipLimitExceeded: false,
                        tasks: [],
                      ),
                    ],
                    onCreate:
                        ({
                          required title,
                          required column,
                          taskTemplateId,
                          useDefaultTemplate = true,
                        }) async {
                          calls++;
                          return true;
                        },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open QA'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Utwórz'));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Do zrobienia'), findsOneWidget);
      expect(find.byType(TaskQuickCreateDialog), findsOneWidget);
      await tester.tap(find.text('Do zrobienia'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(TaskQuickCreateDialog), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(TaskQuickCreateDialog), findsNothing);
      expect(find.text('Open QA'), findsOneWidget);
      expect(calls, 0);
    },
  );

  testWidgets(
    'empty and whitespace title show error and return focus without creating',
    (tester) async {
      var calls = 0;
      String? receivedTitle;
      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().dark(),
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskQuickCreateDialog(
              columns: const [
                KanbanColumnResponse(
                  status: ProjectTaskStatus.todo,
                  displayName: 'Do zrobienia',
                  color: '#2563EB',
                  totalTaskCount: 0,
                  isWipLimitExceeded: false,
                  tasks: [],
                ),
              ],
              onCreate:
                  ({
                    required title,
                    required column,
                    taskTemplateId,
                    useDefaultTemplate = true,
                  }) async {
                    calls++;
                    receivedTitle = title;
                    return false;
                  },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Nadaj zadaniu tytuł i wybierz jego początkowy status.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Utwórz'));
      await tester.pumpAndSettle();
      expect(calls, 0);
      expect(find.text('Wprowadź tytuł zadania'), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.focusNode!.hasFocus, isTrue);
      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.text('Utwórz'));
      await tester.pumpAndSettle();
      expect(calls, 0);
      await tester.enterText(find.byType(TextField), '  Przegląd projektu  ');
      await tester.pump();
      expect(find.text('Wprowadź tytuł zadania'), findsNothing);
      await tester.tap(find.text('Utwórz'));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(receivedTitle, 'Przegląd projektu');
      expect(tester.takeException(), isNull);
    },
  );
}

final class _DefaultTemplateRepo implements TaskTemplateRepository {
  @override
  Future<Either<ApiError, List<TaskTemplateResponse>>> list(
    String workspaceId,
  ) async => Right([
    TaskTemplateResponse(
      id: 'template',
      workspaceId: workspaceId,
      name: 'Plan',
      updatedAtUtc: DateTime.utc(2026),
      version: 1,
    ),
  ]);
  @override
  Future<Either<ApiError, DefaultTaskTemplateResponse>> getDefault(
    String workspaceId,
  ) async =>
      const Right(DefaultTaskTemplateResponse(taskTemplateId: 'template'));
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
