import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/tasks_board_route_fixture.dart';
import '../../../../test_support/tasks_board_route_test_harness.dart';

AuthSessionController _signedInSession() => AuthSessionController(
  initial: const AuthSessionSnapshot(
    status: AuthSessionStatus.signedIn,
    user: AuthUser(userId: 'user-1', login: 'tester', displayName: 'Tester'),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  registerTasksBoardRouteFallbacks();

  group('TasksBoardRoutePage scope', () {
    testWidgets('replaces route Cubits when typed repository scope changes', (
      tester,
    ) async {
      final authSession = _signedInSession();
      final first = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
      );
      final replacement = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
      );

      await tester.pumpWidget(
        TasksBoardRouteTestHarness(fixture: first, authSession: authSession),
      );
      await tester.pumpAndSettle();
      verify(
        () => first.kanban.getBoard(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          filter: any(named: 'filter'),
        ),
      ).called(1);

      await tester.pumpWidget(
        TasksBoardRouteTestHarness(
          fixture: replacement,
          authSession: authSession,
        ),
      );
      await tester.pumpAndSettle();
      verify(
        () => replacement.kanban.getBoard(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          filter: any(named: 'filter'),
        ),
      ).called(1);
    });

    testWidgets('recreates route Cubits when the authenticated user changes', (
      tester,
    ) async {
      final authSession = _signedInSession();
      final fixture = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
      );
      await tester.pumpWidget(
        TasksBoardRouteTestHarness(fixture: fixture, authSession: authSession),
      );
      await tester.pumpAndSettle();

      authSession.setSignedIn(
        const AuthUser(
          userId: 'user-2',
          login: 'second-user',
          displayName: 'Second user',
        ),
      );
      await tester.pumpAndSettle();

      verify(
        () => fixture.kanban.getBoard(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          filter: any(named: 'filter'),
        ),
      ).called(2);
    });

    testWidgets('replaces recurrence Cubit when its repository changes', (
      tester,
    ) async {
      final authSession = _signedInSession();
      final first = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
      );
      final replacement = TasksBoardRouteFixture(
        boardResult: emptyKanbanBoardResult,
      );

      await tester.pumpWidget(
        TasksBoardRouteTestHarness(
          fixture: first,
          authSession: authSession,
          initialView: 'recurrence',
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        TasksBoardRouteTestHarness(
          fixture: replacement,
          authSession: authSession,
          initialView: 'recurrence',
        ),
      );
      await tester.pumpAndSettle();

      verify(
        () => replacement.recurrence.getProjectRecurrences(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).called(1);
    });
  });
}
