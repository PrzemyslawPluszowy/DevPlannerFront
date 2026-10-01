import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart'
    show KanbanColumnSurface, KanbanColumnWidget, TaskBoardColorParser;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wiersz „Dodaj zadanie” i powierzchnia kolumny Kanban.
///
/// Oba widoki grupowania mają identyczną powierzchnię kolumny (gradient akcentu,
/// ramka podświetlana w hover) i identycznie przypięty wiersz dodawania, więc
/// regresja w jednym z nich jest widoczna od razu.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final theme = MaterialTheme.crm().light();
  final accent = Color(TaskBoardColorParser.parse('#2563EB').toARGB32());

  KanbanColumnResponse column({required List<KanbanTaskCardResponse> tasks}) =>
      KanbanColumnResponse(
        status: ProjectTaskStatus.todo,
        displayName: 'Do zrobienia',
        color: '#2563EB',
        totalTaskCount: tasks.length,
        isWipLimitExceeded: false,
        tasks: tasks,
      );

  KanbanTaskCardResponse task() => const KanbanTaskCardResponse(
    id: 'task-1',
    number: 7,
    taskCode: 'TASK-7',
    title: 'Karta w kolumnie',
    status: ProjectTaskStatus.todo,
    priority: TaskPriority.normal,
    position: 1_000,
    checklistTotal: 0,
    checklistCompleted: 0,
    attachmentCount: 0,
    version: 1,
  );

  BoxDecoration surfaceDecoration(WidgetTester tester) {
    final decorated = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(KanbanColumnSurface),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .firstWhere((decoration) => decoration.gradient != null);
    return decorated;
  }

  Future<void> pumpColumn(
    WidgetTester tester, {
    required List<KanbanTaskCardResponse> tasks,
    KanbanCardDensity density = KanbanCardDensity.comfortable,
    TasksRepository? tasksRepository,
  }) async {
    await tester.pumpWidget(
      RepositoryProvider<TasksRepository>.value(
        value: tasksRepository ?? _UnusedTasksRepository(),
        child: MaterialApp(
          theme: theme,
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<TasksBoardCubit>.value(
            value: _cubit(),
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  height: 600,
                  child: KanbanColumnWidget(
                    workspaceId: 'w',
                    projectId: 'p',
                    column: column(tasks: tasks),
                    visibleCardFields: tasksRepository == null
                        ? const []
                        : const [KanbanCardField.subtasks],
                    density: density,
                    selectedTaskIds: const {},
                    pendingTaskIds: const {},
                    memberProfilesByUserId: const {},
                    isCollapsed: false,
                    onToggleCollapsed: () {},
                    isLoadingMore: false,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'przeniesienie pierwszej karty nie przenosi licznika podzadań na następną',
    (tester) async {
      final repo = _SubtasksRepository();
      final first = task().copyWith(id: 'first', subtaskTotal: 1);
      final second = task().copyWith(
        id: 'second',
        title: 'Drugie zadanie',
        subtaskTotal: 0,
      );
      await pumpColumn(tester, tasks: [first, second], tasksRepository: repo);
      expect(find.text('(0/1)'), findsOneWidget);
      await pumpColumn(tester, tasks: [second], tasksRepository: repo);
      expect(find.text('(0/1)'), findsNothing);
      expect(find.byKey(const ValueKey('subtasks_add_button')), findsOneWidget);
      expect(repo.parentIds, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'kolejność kart zachowuje rozwinięte podzadania właściwego rodzica',
    (tester) async {
      final repo = _SubtasksRepository();
      final first = task().copyWith(id: 'first', subtaskTotal: 0);
      final second = task().copyWith(
        id: 'second',
        title: 'Drugie zadanie',
        subtaskTotal: 2,
      );
      await pumpColumn(tester, tasks: [first, second], tasksRepository: repo);
      await tester.tap(find.byKey(const ValueKey('subtasks_toggle_button')));
      await tester.pumpAndSettle();
      expect(repo.parentIds, ['second']);
      expect(find.text('Dziecko second'), findsOneWidget);
      await pumpColumn(tester, tasks: [second, first], tasksRepository: repo);
      expect(find.text('Dziecko second'), findsOneWidget);
      expect(repo.parentIds, [
        'second',
      ], reason: 'zmiana kolejności nie tworzy nowej sesji podzadań');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'kolumna statusu trzyma wiersz dodawania na dole, poza listą kart',
    (tester) async {
      await pumpColumn(tester, tasks: [task()]);
      final columnBottom = tester
          .getBottomLeft(find.byType(KanbanColumnSurface))
          .dy;
      final rowBottom = tester.getBottomLeft(find.text('Dodaj zadanie')).dy;

      expect(find.text('Dodaj zadanie'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('Dodaj zadanie'),
          matching: find.byType(ListView),
        ),
        findsNothing,
        reason:
            'wiersz jest przypięty do kolumny, więc nie przewija się z kartami',
      );
      expect(
        rowBottom,
        closeTo(columnBottom, 24),
        reason: 'wiersz dodawania siedzi na samym dole kolumny',
      );
    },
  );

  testWidgets('pusta kolumna statusu też ma wiersz dodawania', (tester) async {
    await pumpColumn(tester, tasks: const []);

    expect(find.text('Dodaj zadanie'), findsOneWidget);
  });

  testWidgets('gęstość tablicy zmienia szerokość kolumny', (tester) async {
    await pumpColumn(
      tester,
      tasks: const [],
      density: KanbanCardDensity.compact,
    );
    expect(
      tester.getSize(find.byType(KanbanColumnSurface)).width,
      KanbanCardTokens.columnWidthCompact,
    );

    await pumpColumn(
      tester,
      tasks: const [],
      density: KanbanCardDensity.detailed,
    );
    expect(
      tester.getSize(find.byType(KanbanColumnSurface)).width,
      KanbanCardTokens.columnWidthDetailed,
    );

    // Gęstość musi realnie mieścić więcej kolumn na ekranie, a nie tylko
    // zmieniać padding karty o 2 px.
    expect(
      KanbanCardTokens.columnWidthCompact,
      lessThan(KanbanCardTokens.columnWidthStandard),
    );
    expect(
      KanbanCardTokens.columnWidthStandard,
      lessThan(KanbanCardTokens.columnWidthDetailed),
    );
  });

  testWidgets('kolor wiersza dodawania bierze się z akcentu motywu', (
    tester,
  ) async {
    await pumpColumn(tester, tasks: const []);
    final text = tester.widget<Text>(find.text('Dodaj zadanie'));

    expect(
      text.style?.color,
      theme.colorScheme.primary.withValues(alpha: .95),
      reason: 'wiersz jest akcją kolumny, a nie szarym metadanym',
    );
  });

  testWidgets('hover kolumny podświetla ramkę, a nie gradient', (tester) async {
    await pumpColumn(tester, tasks: const []);
    final restGradient = surfaceDecoration(tester).gradient! as LinearGradient;
    final restBorder = surfaceDecoration(tester).border!.top;
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    await gesture.moveTo(tester.getCenter(find.byType(KanbanColumnSurface)));
    await tester.pumpAndSettle();

    final hoveredGradient =
        surfaceDecoration(tester).gradient! as LinearGradient;
    final hoveredBorder = surfaceDecoration(tester).border!.top;

    expect(
      hoveredBorder.color,
      theme.colorScheme.primary,
      reason: 'hover świeci ramką kolumny',
    );
    expect(hoveredBorder.width, 1.5);
    expect(
      hoveredBorder.color,
      isNot(restBorder.color),
      reason: 'ramka w spoczynku nie jest niebieska',
    );
    expect(
      hoveredGradient.colors,
      restGradient.colors,
      reason: 'hover nie może przemalować gradientu kolumny',
    );
    expect(accent, isNotNull);
  });
}

TasksBoardCubit _cubit() => TasksBoardCubit(
  _UnusedRepository(),
  _UnusedRealtime(),
  _UnusedTasksRepository(),
  workspaceId: 'w',
  projectId: 'p',
);

final class _UnusedRepository implements KanbanRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('test nie używa repozytorium');
}

final class _UnusedTasksRepository implements TasksRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('test nie używa repozytorium');
}

final class _UnusedRealtime implements TaskProjectRealtime {
  @override
  Stream<TaskProjectRealtimeUpdate> get updates =>
      const Stream<TaskProjectRealtimeUpdate>.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('test nie używa realtime');
}

final class _SubtasksRepository implements TasksRepository {
  final List<String?> parentIds = [];
  @override
  Future<Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>>
  listProjectTasks({
    required String workspaceId,
    required String projectId,
    ProjectTasksQuery query = const ProjectTasksQuery(),
  }) async {
    parentIds.add(query.parentTaskId);
    return Right(
      CursorPageResponse(
        items: [
          ProjectTaskListItemResponse(
            id: 'child-${query.parentTaskId}',
            number: 102,
            key: 'TASK-102',
            title: 'Dziecko ${query.parentTaskId}',
            status: ProjectTaskStatus.todo,
            priority: TaskPriority.normal,
            assignees: const [],
            checklistCompletedCount: 0,
            checklistTotalCount: 0,
            updatedAtUtc: DateTime.utc(2026, 10),
            version: 1,
          ),
        ],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('unexpected repository call');
}
