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

TasksBoardReady _createReadyState({
  Set<String> selectedTaskIds = const {},
  KanbanQuickFilter quickFilter = KanbanQuickFilter.all,
}) => TasksBoardReady(
  board: const KanbanBoardResponse(
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
    collapsedColumns: const [],
    collapsedCustomStatusIds: const [],
    quickFilter: quickFilter,
  ),
  selectedTaskIds: selectedTaskIds,
  presence: const [],
  connectionState: WorkspaceSignalRConnectionState.connected,
);

Widget _buildHeaderTestApp({
  required TasksBoardReady state,
  required double width,
  double textScale = 1.0,
  TasksProjectView view = TasksProjectView.board,
  ValueChanged<TasksProjectView>? onViewChanged,
}) => MaterialApp(
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
      size: Size(width, 800),
      textScaler: TextScaler.linear(textScale),
    ),
    child: Scaffold(
      body: SizedBox(
        width: width,
        child: TasksHeader(
          state: state,
          workspaceId: 'w-1',
          projectId: 'p-1',
          view: view,
          onViewChanged: onViewChanged ?? (_) {},
        ),
      ),
    ),
  ),
);

void main() {
  setUp(() {
    FlutterError.onError = null;
  });

  group('TasksHeader - Responsywność i hierarchia', () {
    // Zakres desktopowy z planu (§3.2) plus wąskie okna dla odporności układu.
    const testWidths = [360.0, 768.0, 1024.0, 1440.0, 1920.0];

    for (final view in [TasksProjectView.board, TasksProjectView.list]) {
      for (final width in testWidths) {
        testWidgets(
          '${view.name}: $width px renderuje dwa wiersze bez overflow',
          (tester) async {
            tester.view.physicalSize = Size(width, 900);
            tester.view.devicePixelRatio = 1.0;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);

            final state = _createReadyState();
            await tester.pumpWidget(
              _buildHeaderTestApp(state: state, width: width, view: view),
            );
            await tester.pumpAndSettle();

            expect(tester.takeException(), isNull);

            // Wiersz kontekstu: nazwa/licznik, zakładki i główne CTA.
            expect(find.text('8'), findsOneWidget);
            expect(find.byType(TabBar), findsOneWidget);
            if (width <= 920) {
              expect(find.byTooltip('Dodaj zadanie'), findsOneWidget);
            } else {
              expect(find.text('Dodaj zadanie'), findsOneWidget);
            }

            // Wiersz poleceń: zapisane widoki; szybki filtr tylko dla Kanbanu.
            expect(
              find.byKey(const ValueKey('saved_views_menu')),
              findsOneWidget,
            );
            expect(
              find.byKey(const ValueKey('quick_filter_menu')),
              view == TasksProjectView.board ? findsOneWidget : findsNothing,
            );

            // Geometria obu wierszy mieści się w kontrakcie gęstości.
            final tokens = DevPlannerTasksTheme.of(
              Theme.of(
                tester.element(find.byType(TasksHeader)),
              ).textTheme,
              Theme.of(tester.element(find.byType(TasksHeader))).colorScheme,
            );
            final headerHeight = tester
                .getSize(find.byType(TasksHeader))
                .height;
            expect(
              headerHeight,
              greaterThanOrEqualTo(tokens.contextRowHeight),
            );
            if (width >= 1024) {
              expect(
                headerHeight,
                lessThanOrEqualTo(
                  tokens.contextRowHeight + tokens.commandRowHeight + 16,
                ),
                reason: 'Dwa wiersze nagłówka nie mogą rosnąć ponad kontrakt.',
              );
            }
          },
        );
      }
    }

    testWidgets(
      'renderuje się poprawnie przy powiększonym tekście textScale=2.0 bez overflow',
      (tester) async {
        tester.view.physicalSize = const Size(1060, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final state = _createReadyState();
        await tester.pumpWidget(
          _buildHeaderTestApp(state: state, width: 1060, textScale: 2.0),
        );
        await tester.pumpAndSettle();

        expect(find.text('8'), findsOneWidget);
        expect(find.text('Tablica'), findsOneWidget);
      },
    );

    testWidgets(
      'po zaznaczeniu zadań Rząd 2 zamienia się w kontekstowy Bulk Toolbar',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // Stan z dwoma zaznaczonymi zadaniami
        final stateWithSelection = _createReadyState(
          selectedTaskIds: {'task-1', 'task-2'},
        );

        await tester.pumpWidget(
          _buildHeaderTestApp(state: stateWithSelection, width: 1200),
        );
        await tester.pumpAndSettle();

        // Drugi wiersz staje się kontekstowym paskiem masowych akcji.
        expect(find.text('Wybrano: 2'), findsOneWidget);
        expect(find.text('Przenieś wybrane zadania'), findsOneWidget);
        expect(find.text('Zmień priorytet wybranych zadań'), findsOneWidget);
        expect(find.text('Ustaw termin wybranych zadań'), findsOneWidget);

        // Zakładki widoków zostają w pierwszym wierszu, a pasek poleceń widoku
        // ustępuje miejsca akcjom masowym, więc nie ma dwóch pasków naraz.
        expect(find.text('Tablica'), findsOneWidget);
        expect(find.byKey(const ValueKey('saved_views_menu')), findsNothing);
      },
    );

    testWidgets(
      'wyświetla chip aktywnego filtra gdy quickFilter != all',
      (tester) async {
        tester.view.physicalSize = const Size(1300, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final stateWithFilter = _createReadyState(
          quickFilter: KanbanQuickFilter.mine,
        );

        await tester.pumpWidget(
          _buildHeaderTestApp(state: stateWithFilter, width: 1300),
        );
        await tester.pumpAndSettle();

        expect(find.text('Aktywny filtr:'), findsOneWidget);
        expect(find.text('Moje zadania'), findsNWidgets(2));
        expect(find.text('Wyczyść'), findsOneWidget);
      },
    );

    testWidgets(
      'split button tworzenia zadania w nagłówku otwiera wspólne menu szablonów',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final state = _createReadyState();
        await tester.pumpWidget(_buildHeaderTestApp(state: state, width: 1200));
        await tester.pumpAndSettle();

        final templateTooltipFinder = find.byTooltip('Użyj szablonu');
        expect(templateTooltipFinder, findsOneWidget);

        await tester.tap(templateTooltipFinder);
        await tester.pumpAndSettle();

        // Wspólne menu kontekstowe powinno się otworzyć z opcją szablonu
        expect(find.text('Użyj szablonu'), findsOneWidget);
      },
    );

    testWidgets(
      'menu szybkiego filtra otwiera wspólne menu ze wszystkimi opcjami',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final state = _createReadyState();
        await tester.pumpWidget(_buildHeaderTestApp(state: state, width: 1200));
        await tester.pumpAndSettle();

        final filterButtonFinder = find.byTooltip('Szybki filtr tablicy');
        expect(filterButtonFinder, findsOneWidget);

        await tester.tap(filterButtonFinder);
        await tester.pumpAndSettle();

        // Opcje w menu
        expect(find.text('Moje zadania'), findsOneWidget);
        expect(find.text('Nieprzypisane'), findsOneWidget);
        expect(find.text('Zablokowane'), findsOneWidget);
        expect(find.text('Termin w ciągu 7 dni'), findsOneWidget);
      },
    );

    testWidgets(
      'renderuje ProjectMemberFacepile oraz menu Więcej w nagłówku',
      (tester) async {
        tester.view.physicalSize = const Size(1400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final state = _createReadyState();
        await tester.pumpWidget(_buildHeaderTestApp(state: state, width: 1400));
        await tester.pumpAndSettle();

        expect(find.byType(ProjectMemberFacepile), findsOneWidget);

        final moreMenuFinder = find.byKey(const ValueKey('header_more_menu'));
        expect(moreMenuFinder, findsOneWidget);

        await tester.tap(moreMenuFinder);
        await tester.pumpAndSettle();

        // Opcja statusu połączenia SignalR w menu Więcej
        expect(find.text('Zmiany są synchronizowane na żywo'), findsOneWidget);
      },
    );
  });
}
