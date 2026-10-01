import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_quick_create_trigger.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_quick_create.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_template_choice_button.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Enter on Cancel does not submit the quick-create form', (
    tester,
  ) async {
    final repository = _QuickCreateTasksRepository();
    final cubit = _boardCubit(repository);
    addTearDown(cubit.close);

    await tester.pumpWidget(_editorApp(cubit));
    await tester.tap(find.text('Dodaj zadanie'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Nowe zadanie');
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(repository.quickCreateCalls, 0);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('Enter in the title field starts one create request', (
    tester,
  ) async {
    final completer =
        Completer<
          Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>
        >();
    final repository = _QuickCreateTasksRepository(
      onQuickCreate: () => completer.future,
    );
    final cubit = _boardCubit(repository);
    addTearDown(cubit.close);

    await tester.pumpWidget(_editorApp(cubit));
    await tester.tap(find.text('Dodaj zadanie'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Nowe zadanie');
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(repository.quickCreateCalls, 1);
    completer.complete(_createFailure());
    await tester.pumpAndSettle();
  });

  testWidgets('Enter on the template control does not submit the title', (
    tester,
  ) async {
    final repository = _QuickCreateTasksRepository();
    final cubit = _boardCubit(repository);
    final templates = TaskTemplatePickerCubit(
      repository: _TemplateRepository(),
      workspaceId: 'workspace-1',
    );
    addTearDown(cubit.close);
    addTearDown(templates.close);
    await templates.load();

    await tester.pumpWidget(_editorApp(cubit, templatePicker: templates));
    await tester.tap(find.text('Dodaj zadanie'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Nie zapisuj z szablonu');
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(
      FocusManager.instance.primaryFocus?.context
          ?.findAncestorWidgetOfExactType<TaskBoardTemplateChoiceButton>(),
      isNotNull,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(repository.quickCreateCalls, 0);
  });

  testWidgets('wynik starego Cubita nie blokuje ani nie czyści draftu', (
    tester,
  ) async {
    final request =
        Completer<
          Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>
        >();
    final firstRepository = _QuickCreateTasksRepository(
      onQuickCreate: () => request.future,
    );
    final firstCubit = _boardCubit(firstRepository);
    final nextCubit = _boardCubit(_QuickCreateTasksRepository());
    addTearDown(firstCubit.close);
    addTearDown(nextCubit.close);

    await tester.pumpWidget(_editorApp(firstCubit));
    await tester.tap(find.text('Dodaj zadanie'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Draft dla pierwszego');
    await tester.tap(find.text('Utwórz'));
    await tester.pump();

    await tester.pumpWidget(_editorApp(nextCubit));
    request.complete(_createFailure());
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Draft dla pierwszego',
    );
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
  });

  testWidgets('zmiana kolumny odrzuca stare zakończenie i zachowuje draft', (
    tester,
  ) async {
    final request =
        Completer<
          Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>
        >();
    final repository = _QuickCreateTasksRepository(
      onQuickCreate: () => request.future,
    );
    final cubit = _boardCubit(repository);
    addTearDown(cubit.close);

    await tester.pumpWidget(_editorApp(cubit));
    await tester.tap(find.text('Dodaj zadanie'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Draft kolumny TODO');
    await tester.tap(find.text('Utwórz'));
    await tester.pump();

    await tester.pumpWidget(
      _editorApp(cubit, column: _column(ProjectTaskStatus.inProgress)),
    );
    request.complete(_createFailure());
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Draft kolumny TODO',
    );
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
  });

  testWidgets('wiersz szybkiego tworzenia rośnie przy skali tekstu 200%', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(180, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semantics = tester.ensureSemantics();

    try {
      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().light(),
          locale: const Locale('pl'),
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MediaQuery(
            data: MediaQueryData(
              size: Size(180, 400),
              textScaler: TextScaler.linear(2),
            ),
            child: Scaffold(
              body: SizedBox(
                width: 180,
                child: KanbanQuickCreateTrigger(
                  onActivate: _noop,
                  onManageTemplates: _noop,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.text('Dodaj zadanie')).height,
        greaterThan(34),
      );
      expect(find.byType(IconButton), findsOneWidget);
      expect(tester.getSemantics(find.text('Dodaj zadanie')), isNotNull);
    } finally {
      semantics.dispose();
    }
  });
}

Widget _editorApp(
  TasksBoardCubit cubit, {
  KanbanColumnResponse? column,
  TaskTemplatePickerCubit? templatePicker,
}) => MaterialApp(
  theme: MaterialTheme.crm().light(),
  locale: const Locale('pl'),
  localizationsDelegates: const [
    ...AppLocalizations.localizationsDelegates,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: templatePicker == null
      ? BlocProvider<TasksBoardCubit>.value(
          value: cubit,
          child: _quickCreateScaffold(column),
        )
      : MultiBlocProvider(
          providers: [
            BlocProvider<TasksBoardCubit>.value(value: cubit),
            BlocProvider<TaskTemplatePickerCubit>.value(value: templatePicker),
          ],
          child: _quickCreateScaffold(column),
        ),
);

Widget _quickCreateScaffold(KanbanColumnResponse? column) => Scaffold(
  body: Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      width: 280,
      child: KanbanQuickCreateTask(
        column: column ?? _column(ProjectTaskStatus.todo),
        onManageTemplates: (_) async {},
      ),
    ),
  ),
);

TasksBoardCubit _boardCubit(_QuickCreateTasksRepository tasks) {
  final cubit = TasksBoardCubit(
    _UnusedKanbanRepository(),
    _UnusedProjectRealtime(),
    tasks,
    workspaceId: 'workspace-1',
    projectId: 'project-1',
  );
  cubit.publish(
    const TasksBoardReady(
      board: KanbanBoardResponse(
        projectId: 'project-1',
        swimlaneMode: KanbanSwimlaneMode.none,
        settingsVersion: 1,
        hiddenColumns: [],
        visibleCardFields: [],
        defaultCardDensity: KanbanCardDensity.comfortable,
        columns: [],
      ),
      connectionState: WorkspaceSignalRConnectionState.disconnected,
      presence: [],
    ),
  );
  return cubit;
}

KanbanColumnResponse _column(ProjectTaskStatus status) => KanbanColumnResponse(
  status: status,
  displayName: status.name,
  color: '#2563EB',
  totalTaskCount: 0,
  isWipLimitExceeded: false,
  tasks: const [],
);

Either<ApiError, TaskMutationResponse<ProjectTaskResponse>> _createFailure() =>
    const Left(
      ApiError(type: ApiErrorType.unknown, message: 'Create failed'),
    );

final class _QuickCreateTasksRepository implements TasksRepository {
  _QuickCreateTasksRepository({this.onQuickCreate});

  final Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  Function()?
  onQuickCreate;
  int quickCreateCalls = 0;

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  quickCreateTask({
    required String workspaceId,
    required String projectId,
    required QuickCreateProjectTaskPayload payload,
  }) {
    quickCreateCalls++;
    return onQuickCreate?.call() ?? Future.value(_createFailure());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _TemplateRepository implements TaskTemplateRepository {
  @override
  Future<Either<ApiError, List<TaskTemplateResponse>>> list(
    String workspaceId,
  ) async => Right([
    TaskTemplateResponse(
      id: 'template-1',
      workspaceId: workspaceId,
      name: 'Plan',
      updatedAtUtc: DateTime.utc(2026),
      version: 1,
    ),
  ]);

  @override
  Future<Either<ApiError, DefaultTaskTemplateResponse>> getDefault(
    String workspaceId,
  ) async => const Left(
    ApiError(type: ApiErrorType.notFound, message: 'No default template'),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _UnusedKanbanRepository implements KanbanRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _UnusedProjectRealtime implements TaskProjectRealtime {
  @override
  Future<void> dispose() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void _noop() {}
