import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_registry.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_modal_navigation_host.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_modal_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const _taskId = '550e8400-e29b-41d4-a716-446655440002';

void main() {
  testWidgets('inactive task host tolerates a non-router board harness', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TaskDetailModalNavigationHost(
          workspaceId: 'ws-1',
          projectId: 'project-1',
          taskId: null,
          detailsComposition: null,
          child: Text('Board content'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Board content'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'task modal close restores opener focus across URL back and forward',
    (
      tester,
    ) async {
      final openerFocus = FocusNode(debugLabel: 'task-board-opener');
      addTearDown(openerFocus.dispose);
      late final GoRouter router;
      router = GoRouter(
        initialLocation:
            '/workspaces/ws-1/projects/project-1/tasks?view=kanban',
        routes: [
          GoRoute(
            path: '/workspaces/:workspaceId/projects/:projectId/tasks',
            builder: (context, state) => TaskDetailModalNavigationHost(
              workspaceId: state.pathParameters['workspaceId']!,
              projectId: state.pathParameters['projectId']!,
              taskId: state.uri.queryParameters['task'],
              detailsComposition: null,
              child: TextButton(
                focusNode: openerFocus,
                onPressed: () {
                  openerFocus.requestFocus();
                  router.go(
                    '/workspaces/ws-1/projects/project-1/tasks'
                    '?view=kanban&task=$_taskId',
                  );
                },
                child: const Text('Board task opener'),
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();
      final openerElement = tester.element(find.text('Board task opener'));
      await tester.tap(find.text('Board task opener'));
      await tester.pumpAndSettle();
      expect(find.byType(TaskDetailModalUnavailableContent), findsOneWidget);
      expect(openerFocus.hasFocus, isFalse);

      // A platform/browser Back request uses the same guarded close path.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.queryParameters['task'],
        isNull,
      );
      expect(openerFocus.hasFocus, isTrue);
      expect(find.byType(TaskDetailModalUnavailableContent), findsNothing);

      // Browser back removes the query while retaining the background element.
      router.go(
        '/workspaces/ws-1/projects/project-1/tasks?view=kanban&task=$_taskId',
      );
      await tester.pumpAndSettle();
      router.go('/workspaces/ws-1/projects/project-1/tasks?view=kanban');
      await tester.pumpAndSettle();
      expect(
        tester.element(find.text('Board task opener')),
        same(openerElement),
      );
      expect(find.byType(TaskDetailModalUnavailableContent), findsNothing);

      // Browser forward restores the modal over the same focused surface.
      router.go(
        '/workspaces/ws-1/projects/project-1/tasks?view=kanban&task=$_taskId',
      );
      await tester.pumpAndSettle();
      expect(
        tester.element(find.text('Board task opener')),
        same(openerElement),
      );
      expect(find.byType(TaskDetailModalUnavailableContent), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(
        router.routeInformationProvider.value.uri.queryParameters['task'],
        isNull,
      );
      expect(openerFocus.hasFocus, isTrue);
    },
  );

  testWidgets('same task id in a new project replaces the old modal route', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation:
          '/workspaces/ws-1/projects/project-1/tasks?task=$_taskId',
      routes: [
        GoRoute(
          path: '/workspaces/:workspaceId/projects/:projectId/tasks',
          builder: (context, state) => TaskDetailModalNavigationHost(
            workspaceId: state.pathParameters['workspaceId']!,
            projectId: state.pathParameters['projectId']!,
            taskId: state.uri.queryParameters['task'],
            detailsComposition: null,
            child: Text(
              '${state.pathParameters['workspaceId']}/'
              '${state.pathParameters['projectId']}',
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pl'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Transport workspace niedostępny'), findsOneWidget);

    router.go(
      '/workspaces/ws-2/projects/project-2/tasks?task=$_taskId',
    );
    await tester.pumpAndSettle();

    expect(find.text('ws-2/project-2'), findsOneWidget);
    expect(find.text('Transport workspace niedostępny'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.pathSegments[1], 'ws-2');

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.queryParameters['task'],
      isNull,
    );
  });

  testWidgets('dirty draft guards barrier, back and task scope changes', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation:
          '/workspaces/ws-1/projects/project-1/tasks?view=kanban&task=$_taskId',
      routes: [
        GoRoute(
          path: '/workspaces/:workspaceId/projects/:projectId/tasks',
          builder: (context, state) => TaskDetailModalNavigationHost(
            workspaceId: state.pathParameters['workspaceId']!,
            projectId: state.pathParameters['projectId']!,
            taskId: state.uri.queryParameters['task'],
            detailsComposition: null,
            child: Text(
              '${state.pathParameters['workspaceId']}/'
              '${state.pathParameters['projectId']}',
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pl'),
      ),
    );
    await tester.pumpAndSettle();
    final detailsContext = tester.element(
      find.text('Transport workspace niedostępny'),
    );
    final registry = TaskDetailDraftScope.maybeOf(detailsContext)!;
    final draft = registry.registerDraft(label: 'title');
    draft.markDirty();
    final l10n = AppLocalizations.of(detailsContext)!;

    await tester.tapAt(const Offset(1, 1));
    await tester.pumpAndSettle();
    expect(find.text(l10n.taskDetailsUnsavedChangesTitle), findsOneWidget);
    await tester.tap(find.text(l10n.taskDetailsUnsavedStay));
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.queryParameters['task'],
      _taskId,
    );

    router.go('/workspaces/ws-1/projects/project-1/tasks?view=kanban');
    await tester.pumpAndSettle();
    expect(find.text(l10n.taskDetailsUnsavedChangesTitle), findsOneWidget);
    await tester.tap(find.text(l10n.taskDetailsUnsavedStay));
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.queryParameters['task'],
      _taskId,
    );

    router.go(
      '/workspaces/ws-2/projects/project-2/tasks?view=list&task=$_taskId',
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.taskDetailsUnsavedChangesTitle), findsOneWidget);
    await tester.tap(find.text(l10n.taskDetailsUnsavedDiscard));
    await tester.pumpAndSettle();
    expect(find.text('ws-2/project-2'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.queryParameters['task'],
      _taskId,
    );

    draft.dispose();
  });

  testWidgets('logout removes task modal and draft scope without a prompt', (
    tester,
  ) async {
    final session = AuthSessionController()
      ..setSignedIn(
        const AuthUser(
          userId: 'user-a',
          login: 'user-a',
          displayName: 'User A',
        ),
      );
    final router = GoRouter(
      initialLocation:
          '/workspaces/ws-1/projects/project-1/tasks?task=$_taskId',
      routes: [
        GoRoute(
          path: '/workspaces/:workspaceId/projects/:projectId/tasks',
          builder: (context, state) => TaskDetailModalNavigationHost(
            workspaceId: state.pathParameters['workspaceId']!,
            projectId: state.pathParameters['projectId']!,
            taskId: state.uri.queryParameters['task'],
            detailsComposition: null,
            child: const Text('Signed-in board'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    addTearDown(session.dispose);

    await tester.pumpWidget(
      ListenableProvider<AuthSessionPort?>.value(
        value: session,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final modalContext = tester.element(
      find.byType(TaskDetailModalUnavailableContent),
    );
    final registry = TaskDetailDraftScope.maybeOf(modalContext)!;
    final l10n = AppLocalizations.of(modalContext)!;
    final dirtyDraft = registry.registerDraft(label: 'offline-chat-draft');
    dirtyDraft.markDirty();

    session.setSignedOut();
    await tester.pumpAndSettle();

    expect(find.text('Signed-in board'), findsOneWidget);
    expect(find.byType(TaskDetailModalUnavailableContent), findsNothing);
    expect(find.text(l10n.taskDetailsUnsavedChangesTitle), findsNothing);
    expect(dirtyDraft.isDirty, isFalse);
    expect(
      router.routeInformationProvider.value.uri.queryParameters['task'],
      _taskId,
      reason: 'signed-out shell cannot restore modal content from the task URL',
    );
  });
}
