import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/user_hub/project_user_hub_modal.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_columns_viewport.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_route_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/bulk/task_list_bulk_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_list_command_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/project_tasks_list.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/tasks_board_route_fixture.dart';

final class _RouteHarness extends StatelessWidget {
  const _RouteHarness({required this.fixture, this.initialView = 'kanban'});

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

  group('TasksBoardRoutePage', () {
    testWidgets('mounts one Tasks module and the List for the canonical route', (
      tester,
    ) async {
      final fixture = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
      );
      await tester.pumpWidget(
        _RouteHarness(fixture: fixture, initialView: null),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TasksProjectViewHost), findsOneWidget);
      expect(find.byType(TasksBoardReadyView), findsOneWidget);
      expect(find.byType(ProjectTasksList), findsOneWidget);
      // Nagłówek nie zna routera: wyjście z projektu dostarcza trasa.
      expect(
        tester
            .widget<TasksHeader>(find.byType(TasksHeader))
            .onProjectExited,
        isNotNull,
      );
      // Lista oddaje swój wiersz poleceń nagłówkowi, więc kontrolki widoku są
      // w drugim wierszu chrome, a nie w przewijanej treści.
      expect(
        find.descendant(
          of: find.byType(TasksHeader),
          matching: find.byType(TaskListCommandBar),
        ),
        findsOneWidget,
      );
      // Bez zaznaczenia nie ma paska akcji masowych; nie ma też drugiego,
      // pływającego paska nad tabelą.
      expect(find.byType(TaskListBulkBar), findsNothing);
      verify(
        () => fixture.tasks.listProjectTaskGroups(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          query: any(named: 'query'),
        ),
      ).called(1);
    });

    testWidgets('canonical route does not mount the unopened Kanban board', (
      tester,
    ) async {
      final fixture = TasksBoardRouteFixture(
        boardResult: kanbanBoardResultWithColumns,
      );
      await tester.pumpWidget(
        _RouteHarness(fixture: fixture, initialView: null),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KanbanColumnsViewport), findsNothing);
    });

    testWidgets('legacy kanban query keeps mounting the board', (tester) async {
      final fixture = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
      );
      await tester.pumpWidget(_RouteHarness(fixture: fixture));
      await tester.pumpAndSettle();

      expect(find.byType(TasksBoardReadyView), findsOneWidget);
      expect(find.byType(ProjectTasksList), findsNothing);
      verify(
        () => fixture.kanban.getBoard(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          filter: any(named: 'filter'),
        ),
      ).called(1);
    });

    testWidgets('every Tasks view is served by the same module', (tester) async {
      for (final view in const [
        'board',
        'list',
        'timeline',
        'workload',
        'recurrence',
      ]) {
        final fixture = TasksBoardRouteFixture(
          boardResult: emptyKanbanBoardResult,
        );
        await tester.pumpWidget(
          _RouteHarness(fixture: fixture, initialView: view),
        );
        await tester.pumpAndSettle();

        expect(
          find.byType(TasksProjectViewHost),
          findsOneWidget,
          reason: 'view=$view',
        );
        expect(
          find.byType(TasksBoardReadyView),
          findsOneWidget,
          reason: 'view=$view',
        );
        // Ten sam chrome Listy i Kanbanu: jeden nagłówek z wierszem kontekstu,
        // zakładkami, CTA i paskiem poleceń.
        expect(
          find.byType(TasksHeader),
          findsOneWidget,
          reason: 'view=$view',
        );
        expect(find.byType(TabBar), findsOneWidget, reason: 'view=$view');
        expect(
          find.byKey(const ValueKey('saved_views_menu')),
          findsOneWidget,
          reason: 'view=$view',
        );
        // Akcje zależne od widoku należą do wspólnego paska poleceń.
        final isBoardView = view == 'board' || view == 'kanban';
        expect(
          find.byKey(const ValueKey('quick_filter_menu')),
          isBoardView ? findsOneWidget : findsNothing,
          reason: 'view=$view',
        );
      }
    });

    testWidgets('header user hub reads the project port from the route scope', (
      tester,
    ) async {
      // Szerokość okna desktopowego: ten test dowodzi kontraktu portów trasy,
      // nie responsywności modala użytkownika w wąskim oknie.
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1440, 900);
      addTearDown(tester.view.reset);

      final fixture = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
      );
      await tester.pumpWidget(
        _RouteHarness(fixture: fixture, initialView: null),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ProjectMemberFacepile));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ProjectUserHubModal), findsOneWidget);
      verify(
        () => fixture.projects.getProject(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).called(1);
    });

    testWidgets('unknown query falls back to the canonical List', (
      tester,
    ) async {
      final fixture = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
      );
      await tester.pumpWidget(
        _RouteHarness(fixture: fixture, initialView: 'nieznany'),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProjectTasksList), findsOneWidget);
    });

    testWidgets('renders loading boundary before the board response', (
      tester,
    ) async {
      final completer = Completer<Either<ApiError, KanbanBoardResponse>>();
      final fixture = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
        pendingBoard: completer.future,
      );
      await tester.pumpWidget(_RouteHarness(fixture: fixture));

      expect(find.byType(TasksBoardRoutePage), findsOneWidget);
      expect(find.byType(Container), findsWidgets);

      completer.complete(emptyKanbanBoardResult);
      await tester.pumpAndSettle();
    });

    testWidgets('passes workspace and project ids and renders empty board', (
      tester,
    ) async {
      final fixture = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
      );
      await tester.pumpWidget(_RouteHarness(fixture: fixture));
      await tester.pumpAndSettle();

      expect(
        find.text('Projekt nie ma skonfigurowanych kolumn'),
        findsOneWidget,
      );
      verify(
        () => fixture.kanban.getBoard(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          filter: any(named: 'filter'),
        ),
      ).called(1);
    });

    testWidgets('renders a forbidden boundary without a network request', (
      tester,
    ) async {
      final fixture = TasksBoardRouteFixture(
        boardResult: const Left<ApiError, KanbanBoardResponse>(
          ApiError(
            type: ApiErrorType.forbidden,
            statusCode: 403,
            message: 'Board access denied',
          ),
        ),
      );
      await tester.pumpWidget(_RouteHarness(fixture: fixture));
      await tester.pumpAndSettle();

      expect(find.text('Nie masz dostępu do tej tablicy'), findsOneWidget);
      expect(find.text('Board access denied'), findsOneWidget);
      verifyNever(
        () => fixture.kanban.getSystemColumn(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          status: ProjectTaskStatus.todo,
        ),
      );
    });

    testWidgets('cała zakładka Tasks odstaje 2 px od lewej krawędzi', (
      tester,
    ) async {
      final fixture = TasksBoardRouteFixture(
        boardResult: kanbanBoardResultWithColumns,
      );
      await tester.pumpWidget(
        _RouteHarness(fixture: fixture, initialView: null),
      );
      await tester.pumpAndSettle();

      // Nagłówek jest pierwszym elementem zakładki, a tabela Listy pierwszym
      // elementem jej treści — oba muszą zaczynać się na tym samym wcięciu.
      expect(tester.getTopLeft(find.byType(TasksHeader)).dx, Sizes.p2);
      expect(tester.getTopLeft(find.byType(TaskListTable)).dx, Sizes.p2);
    });

    testWidgets('wcięcie zakładki obowiązuje również kolumny Kanbanu', (
      tester,
    ) async {
      final fixture = TasksBoardRouteFixture(
        boardResult: kanbanBoardResultWithColumns,
      );
      // Domyślny widok harnessu to tablica, więc kolumny są zamontowane.
      await tester.pumpWidget(_RouteHarness(fixture: fixture));
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.byType(KanbanColumnWidget).first).dx,
        Sizes.p2 + KanbanCardTokens.boardGutter,
      );
    });
  });
}
