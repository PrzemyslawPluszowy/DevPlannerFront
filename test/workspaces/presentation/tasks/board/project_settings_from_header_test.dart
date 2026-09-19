import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_route_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_support/tasks_board_route_fixture.dart';

final class _HeaderHarness extends StatelessWidget {
  const _HeaderHarness({required this.fixture});

  final TasksBoardRouteFixture fixture;

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
              permissions: {'SuperAdmin'},
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  registerTasksBoardRouteFallbacks();

  testWidgets('project settings opened from the Tasks header resolve ports', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 900);
    addTearDown(tester.view.reset);

    final fixture = TasksBoardRouteFixture(boardResult: emptyKanbanBoardResult);
    await tester.pumpWidget(_HeaderHarness(fixture: fixture));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('header_more_menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Panel admina'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Ustawienia projektu'), findsOneWidget);
  });
}
