import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

TasksBoardReady _readyState() => const TasksBoardReady(
  board: KanbanBoardResponse(
    projectId: 'p-1',
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
        totalTaskCount: 5,
        isWipLimitExceeded: false,
        tasks: [],
      ),
      KanbanColumnResponse(
        status: ProjectTaskStatus.inProgress,
        displayName: 'W toku',
        color: '#F59E0B',
        totalTaskCount: 3,
        isWipLimitExceeded: false,
        tasks: [],
      ),
    ],
  ),
  userPreference: UserKanbanPreferenceResponse(
    workspaceId: 'w-1',
    projectId: 'p-1',
    userId: 'user-1',
    version: 1,
    collapsedColumns: [],
    collapsedCustomStatusIds: [],
    quickFilter: KanbanQuickFilter.all,
  ),
  presence: [],
  connectionState: WorkspaceSignalRConnectionState.connected,
);

Widget _app({
  required ThemeData theme,
  required double width,
  required double textScale,
}) => MaterialApp(
  theme: theme,
  locale: const Locale('pl'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: MediaQuery(
    data: MediaQueryData(
      size: Size(width, 900),
      textScaler: TextScaler.linear(textScale),
    ),
    child: Scaffold(
      body: SizedBox(
        width: width,
        child: TasksHeader(
          state: _readyState(),
          workspaceId: 'w-1',
          projectId: 'p-1',
          view: TasksProjectView.board,
          onViewChanged: (_) {},
        ),
      ),
    ),
  ),
);

void main() {
  final themes = <String, ThemeData>{
    'light': MaterialTheme.crm().light(),
    'dark': MaterialTheme.crm().dark(),
  };
  const widths = [1024.0, 1440.0, 1920.0];
  const scales = [1.0, 1.25, 1.5];

  for (final entry in themes.entries) {
    for (final width in widths) {
      for (final scale in scales) {
        testWidgets(
          'nagłówek Tasks: ${entry.key}, $width px, ${scale}x bez overflow',
          (tester) async {
            tester.view.physicalSize = Size(width, 900);
            tester.view.devicePixelRatio = 1.0;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);

            await tester.pumpWidget(
              _app(theme: entry.value, width: width, textScale: scale),
            );
            await tester.pumpAndSettle();

            expect(tester.takeException(), isNull);
            expect(find.text('Tablica'), findsOneWidget);
            expect(find.text('8'), findsOneWidget);
          },
        );
      }
    }
  }

  testWidgets('tokeny Tasks są obecne także przy 150% skali tekstu', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late DevPlannerTasksTheme tokens;
    await tester.pumpWidget(
      _app(
        theme: MaterialTheme.crm().light(),
        width: 1440,
        textScale: 1.5,
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.text('Tablica'));
    tokens = context.tasksTheme;
    expect(tokens.metaText.fontSize, greaterThanOrEqualTo(11));
    expect(tokens.canvas, isNot(Colors.transparent));
  });
}
