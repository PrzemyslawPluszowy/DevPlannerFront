import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_columns_viewport.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart'
    show KanbanAssigneeColumn, KanbanAssigneeColumnsViewport, KanbanColumnSurface;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Poziomy pasek przewijania tablicy dostaje własne pasmo na dole.
///
/// Kolumny mają pełną wysokość, więc bez zarezerwowanego pasma uchwyt paska
/// zasłaniałby ich dolną krawędź — wiersz „Dodaj zadanie” włącznie. Ten sam
/// kontrakt obowiązuje w widoku statusów i w widoku osób.
void main() {
  const viewportHeight = 600.0;

  KanbanColumnResponse statusColumn() => const KanbanColumnResponse(
    status: ProjectTaskStatus.todo,
    displayName: 'Do zrobienia',
    color: '#2563EB',
    totalTaskCount: 0,
    isWipLimitExceeded: false,
    tasks: [],
  );

  AssigneeKanbanGroupResponse group() => const AssigneeKanbanGroupResponse(
    assigneeUserId: 'user-1',
    displayName: 'Marta',
    isCurrentUser: true,
    totalTaskCount: 0,
    tasks: [],
  );

  TasksBoardReady state({AssigneeKanbanBoardResponse? assigneeBoard}) =>
      TasksBoardReady(
        board: KanbanBoardResponse(
          projectId: 'project-1',
          swimlaneMode: KanbanSwimlaneMode.none,
          settingsVersion: 1,
          hiddenColumns: const [],
          visibleCardFields: const [],
          defaultCardDensity: KanbanCardDensity.comfortable,
          columns: [statusColumn()],
        ),
        assigneeBoard: assigneeBoard,
        presence: const [],
        connectionState: WorkspaceSignalRConnectionState.connected,
      );

  /// Odstęp między dolną krawędzią kolumny a dolną krawędzią tablicy.
  ///
  /// Pasek przewijania zajmuje całą szerokość i wysokość tablicy, więc jego
  /// prostokąt jest zarazem prostokątem viewportu, w którym mieści się uchwyt.
  double columnGapToViewportBottom(
    WidgetTester tester, {
    required Type column,
  }) {
    final viewport = tester.getRect(find.byType(Scrollbar).first);
    final columnBottom = tester.getRect(find.byType(column).first).bottom;
    return viewport.bottom - columnBottom;
  }

  testWidgets('widok statusów rezerwuje pasmo na pasek przewijania', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pl'),
        home: BlocProvider<TasksBoardCubit>.value(
          value: _cubit(),
          child: Scaffold(
            body: SizedBox(
              width: 900,
              height: viewportHeight,
              child: KanbanColumnsViewportProbe(state: state()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      columnGapToViewportBottom(tester, column: KanbanColumnSurface),
      greaterThanOrEqualTo(KanbanCardTokens.boardScrollbarThickness),
      reason: 'uchwyt paska nie może wchodzić na krawędź kolumny',
    );
    final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar).first);
    expect(
      scrollbar.thickness,
      KanbanCardTokens.boardScrollbarThickness,
      reason: 'obie tablice mają ten sam pasek',
    );
  });

  testWidgets('widok osób rezerwuje pasmo na pasek przewijania', (
    tester,
  ) async {
    final board = AssigneeKanbanBoardResponse(
      projectId: 'project-1',
      grouping: KanbanSwimlaneMode.assignee,
      settingsVersion: 1,
      visibleCardFields: const [],
      defaultCardDensity: KanbanCardDensity.comfortable,
      groups: [group()],
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pl'),
        home: BlocProvider<TasksBoardCubit>.value(
          value: _cubit(),
          child: Scaffold(
            body: SizedBox(
              width: 900,
              height: viewportHeight,
              child: KanbanAssigneeColumnsViewport(
                workspaceId: 'workspace-1',
                projectId: 'project-1',
                state: state(assigneeBoard: board),
                board: board,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      columnGapToViewportBottom(tester, column: KanbanAssigneeColumn),
      greaterThanOrEqualTo(KanbanCardTokens.boardScrollbarThickness),
      reason: 'uchwyt paska nie może wchodzić na krawędź kolumny osoby',
    );
    final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar).first);
    expect(scrollbar.thickness, KanbanCardTokens.boardScrollbarThickness);
    expect(
      scrollbar.trackVisibility,
      isTrue,
      reason: 'widok osób ma ten sam pasek co widok statusów',
    );
  });
}

/// Widok statusów w tej samej obudowie co produkcyjna tablica.
///
/// Test mierzy pasmo pod paskiem, więc potrzebuje dokładnie tego viewportu,
/// którego używa aplikacja — bez nagłówka i przełączników.
class KanbanColumnsViewportProbe extends StatelessWidget {
  const KanbanColumnsViewportProbe({required this.state, super.key});

  final TasksBoardReady state;

  @override
  Widget build(BuildContext context) => KanbanColumnsViewport(
    workspaceId: 'workspace-1',
    projectId: 'project-1',
    state: state,
  );
}

TasksBoardCubit _cubit() => TasksBoardCubit(
  _UnusedRepository(),
  _UnusedRealtime(),
  _UnusedTasksRepository(),
  workspaceId: 'workspace-1',
  projectId: 'project-1',
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
