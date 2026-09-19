import 'package:dartz/dartz.dart';
import 'package:devplanner/app/devplanner_app.dart';
import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/bootstrap/host_launch_context.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
  });

  testWidgets('root workspaces route renders data from its typed gateway', (
    tester,
  ) async {
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );

    await tester.pumpWidget(
      DevPlannerApp(
        launchContext: const HostLaunchContext(
          initialRoute: '/workspaces',
          userId: null,
          userDisplayName: null,
        ),
        auth: auth,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('The workspace transport is not configured yet.'),
      findsOneWidget,
    );
  });

  test('unimplemented feature paths are not reachable root routes', () {
    expect(DevPlannerRouteCatalog.isStandalonePath('/workspaces'), isTrue);
    expect(DevPlannerRouteCatalog.isStandalonePath('/me'), isTrue);
    expect(DevPlannerRouteCatalog.isStandalonePath('/chat'), isFalse);
    expect(DevPlannerRouteCatalog.isStandalonePath('/notifications'), isFalse);
    expect(DevPlannerRouteCatalog.isStandalonePath('/storage'), isFalse);
  });

  test('safe initial location preserves the selected Tasks view', () {
    const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
    const projectId = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';

    expect(
      DevPlannerRouteCatalog.safeInitialLocation(
        DevPlannerRouteCatalog.projectKanban(workspaceId, projectId),
      ),
      DevPlannerRouteCatalog.projectKanban(workspaceId, projectId),
    );
  });

  testWidgets('legacy Kanban deep link redirects to the canonical Tasks URL', (
    tester,
  ) async {
    const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
    const projectId = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    final router = DevPlannerRouter(
      initialLocation: '/workspaces/$workspaceId/projects/$projectId/kanban',
      auth: auth,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      router.config.routerDelegate.currentConfiguration.uri.toString(),
      DevPlannerRouteCatalog.projectKanban(workspaceId, projectId),
    );
  });

  testWidgets('project deep link redirects to its real Tasks list', (
    tester,
  ) async {
    const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
    const projectId = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    final router = DevPlannerRouter(
      initialLocation: DevPlannerRouteCatalog.project(workspaceId, projectId),
      auth: auth,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      router.config.routerDelegate.currentConfiguration.uri.toString(),
      DevPlannerRouteCatalog.projectTasks(workspaceId, projectId),
    );
  });

  testWidgets('my Tasks route composes the verified personal task port', (
    tester,
  ) async {
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    final router = DevPlannerRouter(
      initialLocation: DevPlannerRouteCatalog.myTasks,
      auth: auth,
      taskViewRepository: _FakeTaskViewRepository(),
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Moje zadania'), findsOneWidget);
    expect(
      find.text('Nie masz obecnie zadań wymagających działania.'),
      findsOneWidget,
    );
  });

  testWidgets('workspace gateway route can render a real workspace card', (
    tester,
  ) async {
    // Compact shell (<960 px) renderuje sidebar ikonowy, więc marka i karta
    // workspace'u są widoczne równocześnie dopiero na szerokości desktopowej.
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    const gateway = _FakeWorkspacesGateway([
      WorkspaceSummary(
        id: 'workspace-1',
        name: 'DevPlanner',
        description: 'Workspace testowy',
        isPinned: true,
        isHidden: false,
        isOwner: true,
      ),
    ]);

    final router = DevPlannerRouter(
      initialLocation: '/workspaces',
      auth: auth,
      workspacesGateway: gateway,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    // Marka shella jest dziś logo z etykietą semantyczną, a nie tekstem, więc
    // nazwę „DevPlanner” niesie już tylko karta workspace'u.
    expect(
      find.byKey(const ValueKey('devplanner-sidebar-brand-logo')),
      findsOneWidget,
    );
    expect(find.text('DevPlanner'), findsOneWidget);
    expect(find.text('Workspace testowy'), findsOneWidget);
  });

  testWidgets('workspace card opens its real project catalog', (tester) async {
    const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
    const projectId = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    final router = DevPlannerRouter(
      initialLocation: '/workspaces',
      auth: auth,
      workspacesGateway: const _FakeWorkspacesGateway([
        WorkspaceSummary(
          id: workspaceId,
          name: 'DevPlanner',
          isPinned: true,
          isHidden: false,
          isOwner: true,
        ),
      ]),
      projectsGateway: const _ProjectItemsGateway([
        ProjectListItem(
          id: projectId,
          workspaceId: workspaceId,
          name: 'Planer',
        ),
      ]),
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('workspace-card-$workspaceId')));
    await tester.pumpAndSettle();

    expect(
      router.config.routerDelegate.currentConfiguration.uri.toString(),
      DevPlannerRouteCatalog.workspace(workspaceId),
    );
    expect(find.text('Projekty'), findsOneWidget);
    final project = find.text('Planer');
    expect(project, findsOneWidget);

    await tester.tap(project);
    await tester.pumpAndSettle();

    expect(
      router.config.routerDelegate.currentConfiguration.uri.toString(),
      DevPlannerRouteCatalog.projectTasks(workspaceId, projectId),
    );
  });

  testWidgets('workspace files route renders the real read-only browser', (
    tester,
  ) async {
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    final repository = _MockStorageRepository();
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right(const <StorageFolderResponse>[]));
    when(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer(
      (_) async => right(
        const CursorPageResponse<StorageFileResponse>(items: []),
      ),
    );
    const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
    final router = DevPlannerRouter(
      initialLocation: '/workspaces/$workspaceId/files',
      auth: auth,
      storageRepository: repository,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Moje pliki'), findsOneWidget);
    verify(
      () => repository.listFolders(
        scope: const StorageScope.workspace(workspaceId),
      ),
    ).called(1);
  });

  testWidgets('project Files route uses the real project-scoped browser', (
    tester,
  ) async {
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    final repository = _MockStorageRepository();
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right(const <StorageFolderResponse>[]));
    when(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer(
      (_) async => right(
        const CursorPageResponse<StorageFileResponse>(items: []),
      ),
    );
    const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
    const projectId = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
    final router = DevPlannerRouter(
      initialLocation: DevPlannerRouteCatalog.projectFiles(
        workspaceId,
        projectId,
      ),
      auth: auth,
      storageRepository: repository,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    verify(
      () => repository.listFolders(
        scope: const StorageScope.project(
          workspaceId: workspaceId,
          projectId: projectId,
        ),
      ),
    ).called(1);
  });

  testWidgets('personal Files route uses the real personal Storage scope', (
    tester,
  ) async {
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    final repository = _MockStorageRepository();
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right(const <StorageFolderResponse>[]));
    when(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer(
      (_) async => right(
        const CursorPageResponse<StorageFileResponse>(items: []),
      ),
    );
    final router = DevPlannerRouter(
      initialLocation: DevPlannerRouteCatalog.myFiles,
      auth: auth,
      storageRepository: repository,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    verify(
      () => repository.listFolders(scope: const StorageScope.personal()),
    ).called(1);
  });

  testWidgets('desktop Files route composes the real upload action', (
    tester,
  ) async {
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
      clientKind: AuthClientKind.desktopPkce,
    );
    final repository = _MockStorageRepository();
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right(const <StorageFolderResponse>[]));
    when(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer(
      (_) async => right(
        const CursorPageResponse<StorageFileResponse>(items: []),
      ),
    );
    const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
    final transport = DevPlannerHttpTransport(
      baseUrl: 'https://localhost:5173',
      isWeb: false,
      tokenProvider: () async => 'test-token',
    );
    final router = DevPlannerRouter(
      initialLocation: '/workspaces/$workspaceId/files',
      auth: auth,
      httpTransport: transport,
      storageRepository: repository,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prześlij pliki'), findsOneWidget);
    expect(find.text('Utwórz'), findsOneWidget);
  });

  testWidgets('Web BFF Files route fails closed for upload composition', (
    tester,
  ) async {
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    final repository = _MockStorageRepository();
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right(const <StorageFolderResponse>[]));
    when(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer(
      (_) async => right(
        const CursorPageResponse<StorageFileResponse>(items: []),
      ),
    );
    const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
    final transport = DevPlannerHttpTransport(
      baseUrl: 'https://localhost:5173',
      isWeb: true,
    );
    final router = DevPlannerRouter(
      initialLocation: '/workspaces/$workspaceId/files',
      auth: auth,
      httpTransport: transport,
      storageRepository: repository,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prześlij pliki'), findsNothing);
    expect(find.text('Utwórz'), findsNothing);
  });

  testWidgets('invalid workspace id is a typed unavailable route state', (
    tester,
  ) async {
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    final router = DevPlannerRouter(
      initialLocation: '/workspaces/not-a-uuid/files',
      auth: auth,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Adres workspace jest nieprawidłowy.'), findsOneWidget);
    expect(find.text('Pliki niedostępne'), findsOneWidget);
  });

  testWidgets('workspace Files node navigates to the protected route', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1024, 768));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
    );
    final repository = _MockStorageRepository();
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right(const <StorageFolderResponse>[]));
    when(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer(
      (_) async => right(
        const CursorPageResponse<StorageFileResponse>(items: []),
      ),
    );
    const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
    final router = DevPlannerRouter(
      initialLocation: '/workspaces',
      auth: auth,
      workspacesGateway: const _FakeWorkspacesGateway([
        WorkspaceSummary(
          id: workspaceId,
          name: 'DevPlanner',
          isPinned: true,
          isHidden: false,
          isOwner: true,
        ),
      ]),
      projectsGateway: const _FakeProjectsGateway(),
      storageRepository: repository,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    final personalFilesNode = find.byKey(
      const ValueKey('navigation-node-personal-files'),
    );
    expect(personalFilesNode, findsOneWidget);
    await tester.tap(personalFilesNode);
    await tester.pumpAndSettle();

    expect(
      router.config.routerDelegate.currentConfiguration.uri.toString(),
      DevPlannerRouteCatalog.myFiles,
    );

    await tester.tap(
      find.descendant(
        of: find.byKey(
          const ValueKey(
            'navigation-node-workspace:550e8400-e29b-41d4-a716-446655440000',
          ),
        ),
        matching: find.byIcon(Icons.chevron_right),
      ),
    );
    await tester.pumpAndSettle();

    final filesNode = find.byKey(
      const ValueKey(
        'navigation-node-workspace:550e8400-e29b-41d4-a716-446655440000:files',
      ),
    );
    expect(filesNode, findsOneWidget);
    await tester.tap(filesNode);
    await tester.pumpAndSettle();

    expect(find.text('Moje pliki'), findsOneWidget);
  });

  testWidgets(
    'desktop composition exposes a real Kanban route from the project menu',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final auth = AuthComposition.unavailable();
      auth.session.setSignedIn(
        const AuthUser(
          userId: 'user-1',
          login: 'user',
          displayName: 'User',
          permissions: {'workspace.read'},
        ),
        clientKind: AuthClientKind.desktopPkce,
      );
      const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
      const projectId = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
      final transport = DevPlannerHttpTransport(
        baseUrl: 'https://localhost:5173',
        isWeb: false,
        tokenProvider: () async => 'test-token',
      );
      final router = DevPlannerRouter(
        initialLocation: '/workspaces',
        auth: auth,
        httpTransport: transport,
        workspacesGateway: const _FakeWorkspacesGateway([
          WorkspaceSummary(
            id: workspaceId,
            name: 'DevPlanner',
            isPinned: true,
            isHidden: false,
            isOwner: true,
          ),
        ]),
        projectsGateway: const _ProjectItemsGateway([
          ProjectListItem(
            id: projectId,
            workspaceId: workspaceId,
            name: 'Board project',
          ),
        ]),
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MaterialApp.router(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router.config,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byKey(
            const ValueKey(
              'navigation-node-workspace:550e8400-e29b-41d4-a716-446655440000',
            ),
          ),
          matching: find.byIcon(Icons.chevron_right),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byKey(
            const ValueKey(
              'navigation-node-workspace:550e8400-e29b-41d4-a716-446655440000:projects',
            ),
          ),
          matching: find.byIcon(Icons.chevron_right),
        ),
      );
      await tester.pumpAndSettle();

      final projectNode = find.byKey(
        const ValueKey(
          'navigation-node-workspace:550e8400-e29b-41d4-a716-446655440000:project:6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        ),
      );
      expect(projectNode, findsOneWidget);
      await tester.tap(
        find.descendant(
          of: projectNode,
          matching: find.byIcon(Icons.chevron_right),
        ),
      );
      await tester.pumpAndSettle();
      final tasksNode = find.byKey(
        const ValueKey(
          'navigation-node-workspace:550e8400-e29b-41d4-a716-446655440000:project:6ba7b810-9dad-11d1-80b4-00c04fd430c8:tasks',
        ),
      );
      expect(tasksNode, findsOneWidget);
      await tester.tap(
        find.descendant(
          of: tasksNode,
          matching: find.byIcon(Icons.chevron_right),
        ),
      );
      await tester.pumpAndSettle();
      final taskListNode = find.byKey(
        const ValueKey(
          'navigation-node-workspace:550e8400-e29b-41d4-a716-446655440000:project:6ba7b810-9dad-11d1-80b4-00c04fd430c8:tasks:list',
        ),
      );
      final kanbanNode = find.byKey(
        const ValueKey(
          'navigation-node-workspace:550e8400-e29b-41d4-a716-446655440000:project:6ba7b810-9dad-11d1-80b4-00c04fd430c8:tasks:kanban',
        ),
      );
      expect(taskListNode, findsOneWidget);
      expect(kanbanNode, findsOneWidget);
      final filesNode = find.byKey(
        const ValueKey(
          'navigation-node-workspace:550e8400-e29b-41d4-a716-446655440000:project:6ba7b810-9dad-11d1-80b4-00c04fd430c8:files',
        ),
      );
      expect(filesNode, findsOneWidget);
      await tester.tap(taskListNode);
      expect(
        router.config.routerDelegate.currentConfiguration.uri.toString(),
        DevPlannerRouteCatalog.projectTasks(workspaceId, projectId),
      );
      await tester.tap(kanbanNode);

      expect(
        router.config.routerDelegate.currentConfiguration.uri.toString(),
        DevPlannerRouteCatalog.projectKanban(workspaceId, projectId),
      );
      await tester.tap(filesNode);

      expect(
        router.config.routerDelegate.currentConfiguration.uri.toString(),
        DevPlannerRouteCatalog.projectFiles(workspaceId, projectId),
      );
    },
  );
}

final class _FakeWorkspacesGateway implements WorkspacesGateway {
  const _FakeWorkspacesGateway(this.items);

  final List<WorkspaceSummary> items;

  @override
  Future<List<WorkspaceSummary>> listWorkspaces() async => items;
}

final class _FakeTaskViewRepository implements TaskViewRepository {
  @override
  Future<Either<ApiError, CursorPageResponse<MyTaskListItemResponse>>>
  listMyTasks({MyTasksQuery query = const MyTasksQuery()}) async =>
      const Right(CursorPageResponse<MyTaskListItemResponse>(items: []));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _MockStorageRepository extends Mock implements StorageRepository {}

final class _FakeProjectsGateway implements ProjectsGateway {
  const _FakeProjectsGateway();

  @override
  Future<List<ProjectListItem>> listProjects(
    String workspaceId, {
    bool includeHidden = false,
  }) async => const [];
}

final class _ProjectItemsGateway implements ProjectsGateway {
  const _ProjectItemsGateway(this.items);

  final List<ProjectListItem> items;

  @override
  Future<List<ProjectListItem>> listProjects(
    String workspaceId, {
    bool includeHidden = false,
  }) async => items;
}
