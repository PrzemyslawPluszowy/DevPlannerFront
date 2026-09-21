import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart'
    show KanbanBoardGroupingBar, TasksHeader;
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_route_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_list_command_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/tasks_board_route_fixture.dart';

/// Montuje realną trasę Tasks z hermetycznym grafem portów.
class _Harness extends StatelessWidget {
  const _Harness({required this.fixture, required this.initialView});

  final TasksBoardRouteFixture fixture;
  final String? initialView;

  @override
  Widget build(BuildContext context) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('pl'),
    home: Scaffold(
      body: TasksBoardRoutePage(
        composition: fixture.composition,
        projectSettings: fixture.settings.composition,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        authSession: AuthSessionController(
          initial: const AuthSessionSnapshot(
            status: AuthSessionStatus.signedIn,
            user: AuthUser(
              userId: 'user-1',
              login: 'tester',
              displayName: 'Tester',
            ),
          ),
        ),
        initialView: initialView,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  registerTasksBoardRouteFallbacks();

  testWidgets(
    'priorytet z wiersza poleceń Kanbanu jedzie do odczytu tablicy i daje się zdjąć',
    (tester) async {
      // Szerokość desktopowa: wiersz poleceń musi zmieścić kontrolki filtra,
      // żeby kliknięcia trafiały w widoczne klawisze.
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1440, 900);
      addTearDown(tester.view.reset);

      final fixture = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
      );
      await tester.pumpWidget(
        _Harness(fixture: fixture, initialView: 'kanban'),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('board_filter_priority')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('board_filter_assignee')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('board_filter_clear')), findsNothing);

      await tester.tap(find.byKey(const ValueKey('board_filter_priority')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Wysoki priorytet'));
      await tester.pumpAndSettle();

      verify(
        () => fixture.kanban.getBoard(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          filter: any(
            named: 'filter',
            that: predicate<KanbanBoardFilter>(
              (value) => value.priority == TaskPriority.high,
            ),
          ),
        ),
      ).called(1);
      expect(find.byKey(const ValueKey('board_filter_clear')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('board_filter_clear')));
      await tester.pumpAndSettle();

      // „Wyczyść wszystko” wraca do pełnego projektu nowym odczytem tablicy.
      verify(
        () => fixture.kanban.getBoard(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          filter: any(
            named: 'filter',
            that: predicate<KanbanBoardFilter>((value) => !value.isActive),
          ),
        ),
      ).called(2);
      expect(find.byKey(const ValueKey('board_filter_clear')), findsNothing);
    },
  );

  testWidgets('wiersz poleceń Listy nie jest montowany na widoku Kanbanu', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 900);
    addTearDown(tester.view.reset);

    final fixture = TasksBoardRouteFixture(
      boardResult: emptyKanbanBoardResult,
    );
    await tester.pumpWidget(_Harness(fixture: fixture, initialView: 'kanban'));
    await tester.pumpAndSettle();

    expect(find.byType(TaskListCommandBar), findsNothing);
    expect(find.byKey(const ValueKey('quick_filter_menu')), findsOneWidget);
  });

  testWidgets(
    'przełącznik grupowania stoi w wierszu poleceń, a nie nad tablicą',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1440, 900);
      addTearDown(tester.view.reset);

      final fixture = TasksBoardRouteFixture(
        boardResult: kanbanBoardResultWithColumns,
      );
      await tester.pumpWidget(
        _Harness(fixture: fixture, initialView: 'kanban'),
      );
      await tester.pumpAndSettle();

      final header = tester.getRect(find.byType(TasksHeader));
      final grouping = tester.getRect(find.byType(KanbanBoardGroupingBar));
      final priority = tester.getRect(
        find.byKey(const ValueKey('board_filter_priority')),
      );

      // Trzeci rząd nagłówka (osobna belka nad tablicą) był główną przyczyną
      // zbyt wysokiej góry ekranu, więc przełącznik musi siedzieć w tym samym
      // wierszu co filtry.
      expect(
        grouping.top,
        greaterThanOrEqualTo(header.top),
        reason: 'przełącznik grupowania jest częścią nagłówka',
      );
      expect(
        grouping.bottom,
        lessThanOrEqualTo(header.bottom + 0.5),
        reason: 'przełącznik nie wystaje poza nagłówek',
      );
      expect(
        (grouping.center.dy - priority.center.dy).abs(),
        lessThan(2),
        reason: 'ten sam wiersz poleceń co filtry tablicy',
      );
    },
  );

  testWidgets(
    'filtr statusu pojawia się w widoku osób i zawęża grupy po stronie Backendu',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1440, 900);
      addTearDown(tester.view.reset);

      final fixture = TasksBoardRouteFixture(
        boardResult: kanbanBoardResultWithColumns,
        assigneeBoardResult: assigneeKanbanBoardResult,
      );
      await tester.pumpWidget(
        _Harness(fixture: fixture, initialView: 'kanban'),
      );
      await tester.pumpAndSettle();

      // Widok statusów: kolumna sama jest statusem, więc ten filtr jest zbędny.
      expect(find.byKey(const ValueKey('board_filter_status')), findsNothing);

      await tester.tap(find.text('Według osoby przypisanej'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('board_filter_status')),
        findsOneWidget,
        reason: 'w widoku osób status jest filtrem kart',
      );

      await tester.tap(find.byKey(const ValueKey('board_filter_status')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Do zrobienia').last);
      await tester.pumpAndSettle();

      verify(
        () => fixture.kanban.getAssigneeBoard(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          filter: any(
            named: 'filter',
            that: predicate<KanbanBoardFilter>(
              (value) => value.status == ProjectTaskStatus.todo,
            ),
          ),
        ),
      ).called(greaterThanOrEqualTo(1));
      expect(
        find.byKey(const ValueKey('board_active_filter_status')),
        findsOneWidget,
        reason: 'pasek aktywnych filtrów pokazuje wymiar statusu',
      );
    },
  );

  testWidgets('pasek aktywnych filtrów pokazuje priorytet i daje się zdjąć', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 900);
    addTearDown(tester.view.reset);

    final fixture = TasksBoardRouteFixture(
      boardResult: kanbanBoardResultWithColumns,
    );
    await tester.pumpWidget(_Harness(fixture: fixture, initialView: 'kanban'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('board_active_filter_priority')),
      findsNothing,
    );

    await tester.tap(find.byKey(const ValueKey('board_filter_priority')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wysoki priorytet'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('board_active_filter_priority')),
      findsOneWidget,
      reason:
          'pasek musi pokazywać każdy wymiar filtra, nie tylko szybki filtr',
    );

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('board_active_filter_priority')),
        matching: find.byType(Icon),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('board_active_filter_priority')),
      findsNothing,
    );
    verify(
      () => fixture.kanban.getBoard(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        filter: any(
          named: 'filter',
          that: predicate<KanbanBoardFilter>((value) => !value.isActive),
        ),
      ),
    ).called(greaterThanOrEqualTo(1));
  });

  testWidgets(
    'widok osób nie pokazuje filtra wykonawcy, tylko widoczność kolumn',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1440, 900);
      addTearDown(tester.view.reset);

      final fixture = TasksBoardRouteFixture(
        boardResult: kanbanBoardResultWithColumns,
        assigneeBoardResult: assigneeKanbanBoardResult,
      );
      await tester.pumpWidget(
        _Harness(fixture: fixture, initialView: 'kanban'),
      );
      await tester.pumpAndSettle();

      // Widok statusów: filtr wykonawcy jest na miejscu.
      expect(
        find.byKey(const ValueKey('board_filter_assignee')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('board_assignee_columns_menu')),
        findsNothing,
      );

      // Przełączenie na osoby zamienia go na menu widoczności kolumn.
      await tester.tap(find.text('Według osoby przypisanej'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('board_filter_assignee')),
        findsNothing,
        reason: 'w widoku osób osoba jest kolumną, a nie filtrem kart',
      );
      expect(
        find.byKey(const ValueKey('board_assignee_columns_menu')),
        findsOneWidget,
      );
    },
  );
}
