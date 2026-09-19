import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/project_tasks_list_rows.dart';
import 'package:devplanner/workspaces/presentation/tasks/widgets/tasks_selection_checkbox.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';

void main() {
  testWidgets('wiersz listy renderuje dane i opis semantyczny', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final task = ProjectTaskListItemResponse(
      id: 'task-1',
      number: 1,
      key: 'TASK-1',
      title: 'Przygotuj ofertę',
      status: ProjectTaskStatus.inProgress,
      priority: TaskPriority.high,
      dueAtUtc: DateTime.utc(2026, 8, 30),
      assignees: const [],
      checklistCompletedCount: 2,
      checklistTotalCount: 4,
      updatedAtUtc: DateTime.utc(2026, 8, 27),
      version: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 2000,
              child: TaskListRow(
                task: task,
                memberProfilesByUserId: const {},
                columns: const [
                  TaskSavedViewColumn.key,
                  TaskSavedViewColumn.title,
                  TaskSavedViewColumn.checklistProgress,
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('TASK-1'), findsNWidgets(2));
    expect(find.text('Przygotuj ofertę'), findsOneWidget);
    expect(find.text('2/4'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('TASK-1')), findsOneWidget);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await gesture.moveTo(tester.getCenter(find.text('Przygotuj ofertę')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Symbols.more_horiz_rounded), findsOneWidget);
  });

  testWidgets('wiersz otwiera zadanie klawiszem Enter', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    var opened = 0;
    final task = ProjectTaskListItemResponse(
      id: 'task-enter',
      number: 2,
      key: 'TASK-2',
      title: 'Zadanie do otwarcia',
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      assignees: const [],
      checklistCompletedCount: 0,
      checklistTotalCount: 0,
      updatedAtUtc: DateTime.utc(2026, 8, 27),
      version: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TaskListRow(
              task: task,
              memberProfilesByUserId: const {},
              focusNode: focusNode,
              onOpen: () => opened++,
            ),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(opened, 1);
  });

  testWidgets('wiersz pokazuje tooltip aktywnej cykliczności', (tester) async {
    final task = ProjectTaskListItemResponse(
      id: 'task-recurrence',
      number: 2,
      key: 'TASK-2',
      title: 'Cykliczny przegląd',
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      assignees: const [],
      checklistCompletedCount: 0,
      checklistTotalCount: 0,
      updatedAtUtc: DateTime.utc(2026, 8, 27),
      version: 1,
      recurrence: const TaskRecurrenceSummaryResponse(
        id: 'rule-1',
        sourceTaskId: 'task-recurrence',
        frequency: TaskRecurrenceFrequency.weekly,
        interval: 2,
        mode: TaskRecurrenceMode.scheduled,
        timeZoneId: 'Europe/Warsaw',
        occurrenceStatus: ProjectTaskStatus.todo,
        skipIfPreviousOpen: true,
        isActive: true,
        isSourceTask: false,
        version: 1,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TaskListRow(
              task: task,
              memberProfilesByUserId: const {},
              columns: const [TaskSavedViewColumn.title],
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Symbols.repeat_rounded), findsOneWidget);
    await tester.longPress(find.byIcon(Symbols.repeat_rounded));
    await tester.pumpAndSettle();
    expect(
      find.text('Cykliczność aktywna: co 2 tydzień (według harmonogramu)'),
      findsOneWidget,
    );
  });

  testWidgets('termin otwiera zakotwiczony kalendarz i pozwala go wyczyścić', (
    tester,
  ) async {
    DateTime? savedDate = DateTime.utc(2026, 8, 31);
    final task = ProjectTaskListItemResponse(
      id: 'task-date',
      number: 3,
      key: 'TASK-3',
      title: 'Zadanie z terminem',
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      dueAtUtc: savedDate,
      assignees: const [],
      checklistCompletedCount: 0,
      checklistTotalCount: 0,
      updatedAtUtc: DateTime.utc(2026, 8, 27),
      version: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TaskListRow(
            task: task,
            columns: const [TaskSavedViewColumn.dueAtUtc],
            memberProfilesByUserId: const {},
            onDueDateChanged: (value) async {
              savedDate = value;
              return true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Symbols.event));
    await tester.pumpAndSettle();

    expect(find.text('Dzisiaj'), findsOneWidget);
    await tester.tap(find.text('Wyczyść'));
    await tester.pumpAndSettle();
    expect(savedDate, isNull);
  });

  testWidgets(
    'nagłówek opisuje uchwyt zmiany szerokości dla czytnika i tooltipa',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskListTableHeader(
              columns: const [TaskSavedViewColumn.title],
              selectionTooltip: 'Zaznacz zadania w grupie',
              onColumnWidthDelta: (_, _) {},
            ),
          ),
        ),
      );

      expect(
        find.byTooltip('Zmień szerokość kolumny: Zadanie'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Zmień szerokość kolumny: Zadanie'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Zaznacz zadania w grupie'), findsOneWidget);
    },
  );

  testWidgets(
    'przeciągnięcie nagłówka kolumny wywołuje onReorderColumns z indeksami',
    (tester) async {
      int? reorderOldIndex;
      int? reorderNewIndex;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskListTableHeader(
              columns: const [
                TaskSavedViewColumn.title,
                TaskSavedViewColumn.status,
              ],
              onReorderColumns: (oldIndex, newIndex) {
                reorderOldIndex = oldIndex;
                reorderNewIndex = newIndex;
              },
            ),
          ),
        ),
      );

      final titleHeader = find.text('Zadanie');
      final statusHeader = find.text('Status');
      expect(titleHeader, findsOneWidget);
      expect(statusHeader, findsOneWidget);

      final firstLocation = tester.getCenter(titleHeader);
      final targetLocation = tester.getCenter(statusHeader);

      final gesture = await tester.startGesture(firstLocation);
      await tester.pump(const Duration(milliseconds: 400));
      await gesture.moveTo(targetLocation);
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(reorderOldIndex, 0);
      expect(reorderNewIndex, 1);
    },
  );

  test('widoczne kolumny usuwają duplikaty i zachowują tytuł', () {
    final columns = TaskListGrid.visibleColumns([
      TaskSavedViewColumn.startAtUtc,
      TaskSavedViewColumn.key,
      TaskSavedViewColumn.key,
    ]);

    expect(columns, [
      TaskSavedViewColumn.title,
      TaskSavedViewColumn.startAtUtc,
      TaskSavedViewColumn.key,
    ]);
  });

  test('domyślne kolumny nie zawierają zduplikowanych osób', () {
    expect(
      defaultTaskListColumns.toSet().length,
      defaultTaskListColumns.length,
    );
    expect(defaultTaskListColumns, contains(TaskSavedViewColumn.owner));
    expect(defaultTaskListColumns, contains(TaskSavedViewColumn.collaborators));
  });

  testWidgets('kolumna systemowa udostępnia pełną wartość w tooltipie', (
    tester,
  ) async {
    final task = ProjectTaskListItemResponse(
      id: 'system-tooltip',
      number: 4,
      key: 'TASK-4',
      title: 'Systemowe',
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      taskType: 'Bardzo długi typ zadania do sprawdzenia tooltipa',
      assignees: const [],
      checklistCompletedCount: 0,
      checklistTotalCount: 0,
      updatedAtUtc: DateTime.utc(2026),
      version: 1,
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TaskListRow(
            task: task,
            columns: const [TaskSavedViewColumn.taskType],
            memberProfilesByUserId: const {},
          ),
        ),
      ),
    );
    expect(find.byTooltip(task.taskType!), findsOneWidget);
  });

  testWidgets('typ zadania otwiera zakotwiczony edytor i wysyła zmianę', (
    tester,
  ) async {
    String? savedType;
    final task = ProjectTaskListItemResponse(
      id: 'editable-type',
      number: 5,
      key: 'TASK-5',
      title: 'Edytowalny typ',
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      taskType: 'Task',
      assignees: const [],
      checklistCompletedCount: 0,
      checklistTotalCount: 0,
      updatedAtUtc: DateTime.utc(2026),
      version: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TaskListRow(
            task: task,
            columns: const [TaskSavedViewColumn.taskType],
            memberProfilesByUserId: const {},
            onTaskTypeChanged: (value) async {
              savedType = value;
              return true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Zadanie'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Błąd'));
    await tester.pumpAndSettle();

    expect(savedType, 'Bug');
  });

  testWidgets(
    'metryka systemowa zapisuje liczbę i ma jawną akcję czyszczenia',
    (
      tester,
    ) async {
      final savedValues = <int?>[];
      final task = ProjectTaskListItemResponse(
        id: 'editable-metric',
        number: 6,
        key: 'TASK-6',
        title: 'Edytowalna metryka',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.normal,
        size: 8,
        assignees: const [],
        checklistCompletedCount: 0,
        checklistTotalCount: 0,
        updatedAtUtc: DateTime.utc(2026),
        version: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskListRow(
              task: task,
              columns: const [TaskSavedViewColumn.size],
              memberProfilesByUserId: const {},
              onSystemMetricChanged: (_, value) async {
                savedValues.add(value);
                return true;
              },
            ),
          ),
        ),
      );

      // Rozmiar 8 odpowiada koszulce 'M'
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();

      // Wybierz rozmiar 'L' (wartość 4)
      await tester.tap(find.textContaining('Duży'));
      await tester.pumpAndSettle();
      expect(savedValues, [4]);

      // Otwórz ponownie i wyczyść
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Wyczyść rozmiar'));
      await tester.pumpAndSettle();
      expect(savedValues, [4, null]);
    },
  );

  test('TaskTShirtSize mapuje poprawnie skalę 1-5 oraz XL', () {
    expect(TaskTShirtSize.fromValue(1), TaskTShirtSize.xs);
    expect(TaskTShirtSize.fromValue(2), TaskTShirtSize.s);
    expect(TaskTShirtSize.fromValue(3), TaskTShirtSize.m);
    expect(TaskTShirtSize.fromValue(4), TaskTShirtSize.l);
    expect(TaskTShirtSize.fromValue(5), TaskTShirtSize.xl);
    expect(TaskTShirtSize.fromValue(21), TaskTShirtSize.xl);
    for (final size in TaskTShirtSize.values) {
      expect(TaskTShirtSize.fromValue(size.value), size);
    }
  });

  testWidgets('metryka bez callbacku zapisu pozostaje tylko do odczytu', (
    tester,
  ) async {
    final task = ProjectTaskListItemResponse(
      id: 'read-only-metric',
      number: 7,
      key: 'TASK-7',
      title: 'Metryka tylko do odczytu',
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      risk: 3,
      assignees: const [],
      checklistCompletedCount: 0,
      checklistTotalCount: 0,
      updatedAtUtc: DateTime.utc(2026),
      version: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TaskListRow(
            task: task,
            columns: const [TaskSavedViewColumn.risk],
            memberProfilesByUserId: const {},
            onOpen: () {},
          ),
        ),
      ),
    );

    // Ryzyko 3 odpowiada poziomowi 'Wysokie'
    await tester.tap(find.text('Wysokie'));
    await tester.pumpAndSettle();
    expect(find.text('Krytyczne'), findsNothing);
  });

  test('odczytuje datę rozpoczęcia z lekkiego kontraktu listy', () {
    final task = ProjectTaskListItemResponse.fromJson({
      'id': 'task-start',
      'number': 1,
      'key': 'TASK-START',
      'title': 'Zadanie z początkiem',
      'status': 'Todo',
      'priority': 'Normal',
      'startAtUtc': '2026-08-29T00:00:00.000Z',
      'assignees': const <dynamic>[],
      'checklistCompletedCount': 0,
      'checklistTotalCount': 0,
      'updatedAtUtc': '2026-08-30T00:00:00.000Z',
      'version': 1,
    });

    expect(task.startAtUtc, DateTime.utc(2026, 8, 29));
  });

  testWidgets(
    'postęp checklisty renderuje wskaźnik pusty gdy 0 pozycji i licznik z paskiem gdy > 0',
    (tester) async {
      final emptyTask = ProjectTaskListItemResponse(
        id: 'task-empty-check',
        number: 10,
        key: 'TASK-10',
        title: 'Bez checklisty',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.normal,
        assignees: const [],
        checklistCompletedCount: 0,
        checklistTotalCount: 0,
        updatedAtUtc: DateTime.utc(2026),
        version: 1,
      );

      final withChecklistTask = ProjectTaskListItemResponse(
        id: 'task-with-check',
        number: 11,
        key: 'TASK-11',
        title: 'Z checklistą',
        status: ProjectTaskStatus.inProgress,
        priority: TaskPriority.high,
        assignees: const [],
        checklistCompletedCount: 2,
        checklistTotalCount: 4,
        updatedAtUtc: DateTime.utc(2026),
        version: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Column(
              children: [
                TaskListRow(
                  task: emptyTask,
                  columns: const [TaskSavedViewColumn.checklistProgress],
                  memberProfilesByUserId: const {},
                ),
                TaskListRow(
                  task: withChecklistTask,
                  columns: const [TaskSavedViewColumn.checklistProgress],
                  memberProfilesByUserId: const {},
                ),
              ],
            ),
          ),
        ),
      );

      // Pusty stan renderuje placeholder z ikoną checklist_rounded, stan z pozycjami renderuje badge i ikonę
      expect(find.byIcon(Symbols.checklist_rounded), findsNWidgets(2));
      // Stan z pozycjami renderuje badge 2/4 i progress bar
      expect(find.text('2/4'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'wybór statusu otwiera zunifikowane AppContextMenu i pozwala zmienić wartość',
    (tester) async {
      ProjectTaskStatus? newStatus;
      final task = ProjectTaskListItemResponse(
        id: 'task-status',
        number: 12,
        key: 'TASK-12',
        title: 'Zadanie test status',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.normal,
        assignees: const [],
        checklistCompletedCount: 0,
        checklistTotalCount: 0,
        updatedAtUtc: DateTime.utc(2026),
        version: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskListRow(
              task: task,
              columns: const [TaskSavedViewColumn.status],
              memberProfilesByUserId: const {},
              onStatusChanged: (val) async {
                newStatus = val;
                return true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Do zrobienia'));
      await tester.pumpAndSettle();

      // Powinno otworzyć menu ze wszystkimi statusami
      expect(find.text('W toku'), findsOneWidget);
      expect(find.text('Gotowe'), findsOneWidget);

      await tester.tap(find.text('W toku'));
      await tester.pumpAndSettle();

      expect(newStatus, ProjectTaskStatus.inProgress);
    },
  );

  testWidgets('prawy klik na wierszu listy otwiera menu kontekstowe zadania', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final task = ProjectTaskListItemResponse(
      id: 'task-context-1',
      number: 1,
      key: 'TASK-1',
      title: 'Zadanie prawy klik',
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      assignees: const [],
      checklistCompletedCount: 0,
      checklistTotalCount: 0,
      updatedAtUtc: DateTime.utc(2026),
      version: 1,
    );

    var duplicated = false;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TaskListRow(
            task: task,
            columns: const [TaskSavedViewColumn.title],
            memberProfilesByUserId: const {},
            onDuplicate: () async {
              duplicated = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(
      find.text('Zadanie prawy klik'),
      buttons: kSecondaryMouseButton,
    );
    await tester.pumpAndSettle();

    expect(find.text('Duplikuj zadanie'), findsOneWidget);

    await tester.tap(find.text('Duplikuj zadanie'));
    await tester.pumpAndSettle();

    expect(duplicated, isTrue);
  });

  testWidgets(
    'picker statusu ukrywa zarzadzanie workflow dla uzytkownika bez canManage',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskCellStatus(
              status: ProjectTaskStatus.todo,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Do zrobienia'));
      await tester.pumpAndSettle();

      expect(find.text('Zarządzaj workflow projektu...'), findsNothing);
    },
  );

  testWidgets(
    'picker statusu wyswietla opcje zarzadzania workflow dla canManage == true',
    (tester) async {
      var workflowConfigured = false;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskCellStatus(
              status: ProjectTaskStatus.todo,
              canManage: true,
              onChanged: (_) async => true,
              onConfigureWorkflow: () {
                workflowConfigured = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Do zrobienia'));
      await tester.pumpAndSettle();

      expect(find.text('Konfiguruj workflow...'), findsOneWidget);
      expect(find.byIcon(Symbols.settings_rounded), findsOneWidget);

      await tester.tap(find.text('Konfiguruj workflow...'));
      await tester.pumpAndSettle();

      expect(workflowConfigured, isTrue);
    },
  );

  testWidgets(
    'picker typu zadania blokuje dodawanie i ukrywa zebatke dla canManage == false',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskCellTaskType(
              taskType: 'feature',
              onChanged: (_) async => true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Funkcja'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNothing);
      expect(find.byIcon(Symbols.settings_rounded), findsNothing);
    },
  );

  testWidgets(
    'picker typu zadania wyswietla zebatke dla canManage == true i wywoluje konfiguracje',
    (tester) async {
      var typesConfigured = false;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskCellTaskType(
              taskType: 'feature',
              canManage: true,
              onChanged: (_) async => true,
              onConfigureTypes: () {
                typesConfigured = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Funkcja'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Symbols.settings_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Symbols.settings_rounded));
      await tester.pumpAndSettle();

      expect(typesConfigured, isTrue);
    },
  );

  testWidgets(
    'pusta komórka rozmiaru pozwala otworzyć picker i wybrać rozmiar',
    (tester) async {
      int? savedSize;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskCellSize(
              size: null,
              onChanged: (val) async {
                savedSize = val;
                return true;
              },
            ),
          ),
        ),
      );

      // Kliknięcie w pusty placeholder z ikoną straighten_rounded
      expect(find.byIcon(Symbols.straighten_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Symbols.straighten_rounded));
      await tester.pumpAndSettle();

      expect(find.text('ROZMIAR ZADANIA'), findsOneWidget);

      // Wybór opcji rozmiaru M
      final mOption = find.textContaining('M –');
      expect(mOption, findsOneWidget);
      await tester.tap(mOption);
      await tester.pumpAndSettle();

      expect(savedSize, equals(3));
    },
  );

  testWidgets(
    'nagłówek tabeli wyświetla wyszarzoną ikonę swap_vert_rounded dla kolumny nieposortowanej oraz niebieską dla posortowanej',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskListTableHeader(
              columns: const [TaskSavedViewColumn.priority],
              onSortField: (_) {},
            ),
          ),
        ),
      );

      // Kolumna sortowalna nieposortowana ma widoczną wyszarzoną ikonę swap_vert_rounded
      expect(find.byIcon(Symbols.swap_vert_rounded), findsOneWidget);
      expect(find.byIcon(Symbols.arrow_downward_alt_rounded), findsNothing);

      // Po włączeniu sortowania malejącego ikona zmienia się na strzałkę w dół
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskListTableHeader(
              columns: const [TaskSavedViewColumn.priority],
              activeSortField: TaskSavedViewSortField.priority,
              sortDirection: TaskSavedViewSortDirection.descending,
              onSortField: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Symbols.swap_vert_rounded), findsNothing);
      expect(find.byIcon(Symbols.arrow_downward_alt_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'pusta komórka złożoności i ryzyka otwiera modal wyboru po kliknięciu',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Column(
              children: [
                TaskCellComplexity(
                  complexity: null,
                  onChanged: (_) async => true,
                ),
                TaskCellRisk(
                  risk: null,
                  onChanged: (_) async => true,
                ),
              ],
            ),
          ),
        ),
      );

      // Kliknięcie w pustą złożoność
      await tester.tap(find.byIcon(Symbols.tune_rounded));
      await tester.pumpAndSettle();

      expect(find.text('1 – Bardzo niska'), findsOneWidget);

      // Zamknięcie dialogu kliknięciem w tło
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Kliknięcie w puste ryzyko
      await tester.tap(find.byIcon(Symbols.shield));
      await tester.pumpAndSettle();

      expect(find.text('Krytyczne'), findsOneWidget);
    },
  );

  testWidgets('wiersz zaznacza zadanie wspólnym, mniejszym checkboxem Listy', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final task = ProjectTaskListItemResponse(
      id: 'task-select',
      number: 3,
      key: 'TASK-3',
      title: 'Zadanie do zaznaczenia',
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      assignees: const [],
      checklistCompletedCount: 0,
      checklistTotalCount: 0,
      updatedAtUtc: DateTime.utc(2026, 8, 27),
      version: 1,
    );
    final selections = <bool>[];

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TaskListRow(
            task: task,
            columns: const [TaskSavedViewColumn.title],
            memberProfilesByUserId: const {},
            onOpen: () {},
            onSelectionChanged: selections.add,
          ),
        ),
      ),
    );

    expect(find.byType(TasksSelectionCheckbox), findsOneWidget);
    // Kolumna zaznaczenia oddaje kontrolce pole 28 px, więc glyph 16 px jest
    // od niego mniejszy i wiersz zachowuje gęstość tabeli.
    expect(tester.getSize(find.byType(TasksSelectionCheckbox)).width, 28);
    expect(find.bySemanticsLabel(RegExp('TASK-3')), findsOneWidget);

    await tester.tap(find.byType(TasksSelectionCheckbox));
    await tester.pumpAndSettle();

    // Zaznaczenie bez Shift pozostaje pojedynczym przełączeniem wiersza.
    expect(selections, [false]);
  });
}
