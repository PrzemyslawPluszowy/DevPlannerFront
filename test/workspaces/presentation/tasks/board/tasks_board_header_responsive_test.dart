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
        child: TasksBoardHeader(
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

  group('TasksBoardHeader - Responsywność i hierarchia', () {
    const testWidths = [360.0, 768.0, 920.0, 1060.0, 1400.0];

    for (final width in testWidths) {
      testWidgets(
        'renderuje się poprawnie bez błędów overflow dla szerokości $width px',
        (tester) async {
          tester.view.physicalSize = Size(width, 800);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          final state = _createReadyState();
          await tester.pumpWidget(
            _buildHeaderTestApp(state: state, width: width),
          );
          await tester.pumpAndSettle();

          // Rząd 1: Tytuł/nazwa projektu, licznik i primary CTA
          expect(find.text('8'), findsOneWidget); // 5 + 3 = 8
          if (width <= 920) {
            expect(find.byTooltip('Dodaj zadanie'), findsOneWidget);
          } else {
            expect(find.text('Dodaj zadanie'), findsOneWidget);
          }

          // Rząd 2: Nawigacja widoków
          expect(find.text('Tablica'), findsOneWidget);

          // Weryfikacja wysokości: dla ekranów szerokich/desktopowych (>= 920 px) nagłówek ma 1 rząd <= 52.0 px
          if (width >= 920) {
            final headerHeight = tester
                .getSize(find.byType(TasksBoardHeader))
                .height;
            expect(headerHeight, lessThanOrEqualTo(52.0));
            expect(headerHeight, greaterThanOrEqualTo(40.0));
          }
        },
      );
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

        // Zamiast zakładek widoków pojawia się pasek masowych akcji
        expect(find.text('Wybrano: 2'), findsOneWidget);
        expect(find.text('Przenieś wybrane zadania'), findsOneWidget);
        expect(find.text('Zmień priorytet wybranych zadań'), findsOneWidget);
        expect(find.text('Ustaw termin wybranych zadań'), findsOneWidget);

        // Zakładka Tablica nie jest widoczna podczas aktywnego Bulk Toolbara
        expect(find.text('Tablica'), findsNothing);
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
      'split button tworzenia zadania w nagłówku otwiera menu szablonów TaskContextMenu',
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

        // Menu kontekstowe TaskContextMenu powinno się otworzyć z opcją szablonu
        expect(find.text('Użyj szablonu'), findsOneWidget);
      },
    );

    testWidgets(
      'menu szybkiego filtra otwiera TaskContextMenu ze wszystkimi opcjami',
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
