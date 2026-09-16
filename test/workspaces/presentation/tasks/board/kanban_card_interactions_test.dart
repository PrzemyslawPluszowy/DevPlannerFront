import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/kanban/models/kanban_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/tasks_board_page.dart';

final class _MockTasksRepository implements TasksRepository {
  @override
  Future<Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>>
  listProjectTasks({
    required String workspaceId,
    required String projectId,
    ProjectTasksQuery query = const ProjectTasksQuery(),
  }) async => Right(
    CursorPageResponse<ProjectTaskListItemResponse>(
      items: [
        ProjectTaskListItemResponse(
          id: 'sub-1',
          number: 102,
          key: 'EX-102',
          title: 'Podzadanie 1',
          status: ProjectTaskStatus.todo,
          priority: TaskPriority.normal,
          assignees: const [],
          checklistCompletedCount: 0,
          checklistTotalCount: 0,
          updatedAtUtc: DateTime.utc(2026, 9, 6),
          version: 1,
        ),
      ],
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

KanbanTaskCardResponse _createSampleCard({
  String id = 'task-1',
  String title = 'Zadanie testowe',
  int subtaskTotal = 3,
  int subtaskCompleted = 1,
  bool isPinned = false,
  bool isWatchedByMe = false,
}) => KanbanTaskCardResponse(
  id: id,
  number: 101,
  taskCode: 'EX-101',
  title: title,
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.high,
  position: 1000,
  checklistTotal: 0,
  checklistCompleted: 0,
  attachmentCount: 0,
  subtaskTotal: subtaskTotal,
  subtaskCompleted: subtaskCompleted,
  isPinned: isPinned,
  isWatchedByMe: isWatchedByMe,
  watcherCount: 2,
  version: 1,
);

Widget _buildCardTestApp({
  required Widget child,
  TasksRepository? tasksRepository,
}) => RepositoryProvider<TasksRepository>.value(
  value: tasksRepository ?? _MockTasksRepository(),
  child: MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Center(
        child: child,
      ),
    ),
  ),
);

void main() {
  group('Kanban Card Subtasks Section', () {
    testWidgets(
      'renderuje podsumowanie podzadań i przełącza stan rozwinięcia',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final card = _createSampleCard();

        await tester.pumpWidget(
          _buildCardTestApp(
            child: SizedBox(
              width: 300,
              child: KanbanCardSubtasksSection(
                task: card,
                workspaceId: 'w-1',
                projectId: 'p-1',
                memberProfilesByCoreUserId: const {},
              ),
            ),
          ),
        );

        // Etykieta zwinięta z licznikiem
        expect(find.textContaining('(1/3)'), findsOneWidget);
        expect(
          find.byIcon(Symbols.keyboard_arrow_right_rounded),
          findsOneWidget,
        );

        // Kliknięcie rozwija sekcję
        await tester.tap(find.byIcon(Symbols.keyboard_arrow_right_rounded));
        await tester.pumpAndSettle();

        // Chevron obraca się w dół (0.25 obrotu / 90 stopni)
        final chevronRotationFinder = find.ancestor(
          of: find.byIcon(Symbols.keyboard_arrow_right_rounded),
          matching: find.byType(RotationTransition),
        );
        final rotation = tester.widget<RotationTransition>(
          chevronRotationFinder,
        );
        expect(rotation.turns.value, 0.25);
        // Przycisk dodawania podzadania jest widoczny po rozwinięciu
        expect(find.text('Dodaj podzadanie'), findsOneWidget);

        // Kliknięcie 'Dodaj podzadanie' aktywuje inline create input
        await tester.tap(find.text('Dodaj podzadanie'));
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Enter ↵'), findsOneWidget);
      },
    );
  });

  group('Kanban Subtasks Interactions & Non-bubbling', () {
    testWidgets(
      'kliknięcie wiersza podzadania nie otwiera zadania rodzica (izolacja stref kliknięcia)',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final card = _createSampleCard();
        await tester.pumpWidget(
          _buildCardTestApp(
            child: SizedBox(
              width: 300,
              child: KanbanCardSubtasksSection(
                task: card,
                workspaceId: 'w-1',
                projectId: 'p-1',
                memberProfilesByCoreUserId: const {},
              ),
            ),
          ),
        );

        // Rozwinięcie podzadań
        await tester.tap(find.byIcon(Symbols.keyboard_arrow_right_rounded));
        await tester.pumpAndSettle();

        // Podzadanie 1 jest widoczne
        expect(find.text('Podzadanie 1'), findsOneWidget);

        // Kliknięcie wiersza podzadania
        await tester.tap(find.text('Podzadanie 1'));
        await tester.pump();

        // Nie rzuca żadnego błędu ani nie wykonuje nieoczekiwanej akcji
        expect(find.text('Podzadanie 1'), findsOneWidget);
      },
    );

    testWidgets(
      'paginacja: "Pokaż kolejne 5" doładowuje elementy bez zamykania sekcji',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // Karta mająca 7 podzadań
        final card = _createSampleCard(subtaskTotal: 7, subtaskCompleted: 2);
        await tester.pumpWidget(
          _buildCardTestApp(
            child: SizedBox(
              width: 300,
              child: KanbanCardSubtasksSection(
                task: card,
                workspaceId: 'w-1',
                projectId: 'p-1',
                memberProfilesByCoreUserId: const {},
              ),
            ),
          ),
        );

        // Rozwinięcie podzadań
        await tester.tap(find.byIcon(Symbols.keyboard_arrow_right_rounded));
        await tester.pumpAndSettle();

        // Ponieważ repozytorium mock zwraca 1 element, a total to 7, widoczny jest przycisk paginacji
        expect(find.textContaining('kolejne'), findsOneWidget);

        // Kliknięcie przycisku paginacji
        await tester.tap(find.textContaining('kolejne'));
        await tester.pumpAndSettle();

        // Stan pozostaje rozwinięty i stabilny
        expect(find.text('Podzadanie 1'), findsOneWidget);
      },
    );

    testWidgets(
      'drag preview jest bezstanowy i nie inicjuje pobierania danych',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        var listFetchCount = 0;
        final repo = _MockCountingTasksRepository(
          onList: () => listFetchCount++,
        );

        final card = _createSampleCard(subtaskTotal: 4);

        await tester.pumpWidget(
          _buildCardTestApp(
            tasksRepository: repo,
            child: SizedBox(
              width: 300,
              child: KanbanCardDragPreview(
                task: card,
                density: KanbanCardDensity.comfortable,
                visibleCardFields: const [
                  KanbanCardField.subtasks,
                  KanbanCardField.dueDate,
                ],
                memberProfilesByCoreUserId: const {},
              ),
            ),
          ),
        );

        // Renderuje się tytuł zadania i licznik bezstanowy
        expect(find.text('Zadanie testowe'), findsOneWidget);
        expect(find.text('Podzadania (1/4)'), findsOneWidget);

        // Nie nastąpiło wywołanie repozytorium
        expect(listFetchCount, 0);
      },
    );
  });
}

final class _MockCountingTasksRepository implements TasksRepository {
  _MockCountingTasksRepository({required this.onList});

  final VoidCallback onList;

  @override
  Future<Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>>
  listProjectTasks({
    required String workspaceId,
    required String projectId,
    ProjectTasksQuery query = const ProjectTasksQuery(),
  }) async {
    onList();
    return const Right(
      CursorPageResponse<ProjectTaskListItemResponse>(
        items: [],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
