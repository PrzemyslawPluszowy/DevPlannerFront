import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
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
}
