import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart'
    show KanbanBoardGroupingBar;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Przełącznik grupowania jako kontrolka wiersza poleceń.
///
/// Wiersz poleceń to poziomy scroll, więc szerokość jest nieograniczona:
/// kontrolka nie może zawierać `Spacer`/`Expanded` ani własnego scrolla, bo
/// kończy się to błędem layoutu („non-zero flex but incoming width constraints
/// are unbounded”).
void main() {
  TasksBoardReady state({required TasksBoardGrouping grouping}) =>
      TasksBoardReady(
        board: const KanbanBoardResponse(
          projectId: 'project-1',
          swimlaneMode: KanbanSwimlaneMode.none,
          settingsVersion: 1,
          hiddenColumns: [],
          visibleCardFields: [],
          defaultCardDensity: KanbanCardDensity.comfortable,
          columns: [
            KanbanColumnResponse(
              status: ProjectTaskStatus.todo,
              displayName: 'Do zrobienia',
              color: '#2563EB',
              totalTaskCount: 0,
              isWipLimitExceeded: false,
              tasks: [],
            ),
          ],
        ),
        grouping: grouping,
        presence: const [],
        connectionState: WorkspaceSignalRConnectionState.connected,
      );

  Future<void> pumpInsideCommandRow(
    WidgetTester tester, {
    required TasksBoardReady boardState,
    bool loading = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: MaterialTheme.crm().light(),
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 900,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KanbanBoardGroupingBar(
                    state: loading
                        ? boardState.copyWith(isAssigneeBoardLoading: true)
                        : boardState,
                  ),
                  const SizedBox(width: 8),
                  const Text('filtr priorytetu'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // `pumpAndSettle` nie zadziała ze wskaźnikiem wczytywania: jego animacja
    // nigdy się nie kończy, więc ramka musi wystarczyć.
    await tester.pump();
    await tester.pump();
  }

  testWidgets('kontrolka grupowania mieści się w rzędzie o nieograniczonej '
      'szerokości', (tester) async {
    await pumpInsideCommandRow(
      tester,
      boardState: state(grouping: TasksBoardGrouping.status),
    );

    expect(
      tester.takeException(),
      isNull,
      reason: 'Spacer albo Expanded w poziomym scrollu łamie layout',
    );
    expect(find.text('Status'), findsOneWidget);
    expect(find.text('Według osoby przypisanej'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(KanbanBoardGroupingBar),
        matching: find.byType(SingleChildScrollView),
      ),
      findsNothing,
      reason: 'przełącznik nie dokłada własnego scrolla do wiersza poleceń',
    );
  });

  testWidgets('wskaźnik wczytywania tablicy osób nie łamie kontrolki', (
    tester,
  ) async {
    await pumpInsideCommandRow(
      tester,
      boardState: state(grouping: TasksBoardGrouping.assignee),
      loading: true,
    );

    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byType(KanbanBoardGroupingBar),
        matching: find.byType(CircularProgressIndicator),
      ),
      findsOneWidget,
    );
    // Kontrolka nadal pokazuje wybór grupowania, więc jej szerokość pozostaje
    // ograniczona także w trakcie przełączania.
    expect(find.text('Według osoby przypisanej'), findsOneWidget);
  });
}
