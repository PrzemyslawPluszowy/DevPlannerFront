import 'dart:async';

import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_folder_actions_menu.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements StorageRepository {}

final class _RouteObserver extends NavigatorObserver {
  final events = <String>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    events.add('push:${route.runtimeType}:${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    events.add('pop:${route.runtimeType}:${route.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    events.add('remove:${route.runtimeType}:${route.settings.name}');
  }
}

final class _FolderActionApp extends StatefulWidget {
  const _FolderActionApp({
    required this.repository,
    this.scale = 1,
    this.locale = const Locale('pl'),
    this.dark = false,
    this.routeObserver,
    super.key,
  });

  final StorageRepository repository;
  final double scale;
  final Locale locale;
  final bool dark;
  final _RouteObserver? routeObserver;

  @override
  State<_FolderActionApp> createState() => _FolderActionAppState();
}

final class _FolderActionAppState extends State<_FolderActionApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final StorageFolderMutationCubit _originalMutation =
      StorageFolderMutationCubit(repository: widget.repository);
  late final StorageFolderMutationCubit _replacementMutation =
      StorageFolderMutationCubit(repository: widget.repository);
  late final StorageBrowserCubit _originalBrowser = StorageBrowserCubit(
    repository: widget.repository,
  );
  late final StorageBrowserCubit _replacementBrowser = StorageBrowserCubit(
    repository: widget.repository,
  );
  bool _replaced = false;

  StorageFolderMutationCubit get _mutation =>
      _replaced ? _replacementMutation : _originalMutation;
  StorageBrowserCubit get _browser =>
      _replaced ? _replacementBrowser : _originalBrowser;

  void replaceOwners() => setState(() => _replaced = true);

  void replaceTopRoute() {
    _navigatorKey.currentState!.pushReplacement<void, void>(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Replacement route')),
      ),
    );
  }

  Future<void> changeScope() => _browser.setScope(const StorageScope.shared());

  @override
  void dispose() {
    unawaited(_originalMutation.close());
    unawaited(_replacementMutation.close());
    unawaited(_originalBrowser.close());
    unawaited(_replacementBrowser.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: _mutation),
      BlocProvider.value(value: _browser),
    ],
    child: MaterialApp(
      navigatorKey: _navigatorKey,
      navigatorObservers: [?widget.routeObserver],
      theme: widget.dark
          ? MaterialTheme.crm().dark()
          : MaterialTheme.crm().light(),
      locale: widget.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(widget.scale),
        ),
        child: child!,
      ),
      home: Builder(
        builder: (actionContext) => Scaffold(
          body: Column(
            children: [
              TextButton(
                key: const ValueKey('replace_folder_action_owners'),
                onPressed: () => setState(() => _replaced = true),
                child: const Text('Replace owners'),
              ),
              TextButton(
                key: const ValueKey('change_folder_action_scope'),
                onPressed: () => _browser.setScope(const StorageScope.shared()),
                child: const Text('Change scope'),
              ),
              TextButton(
                key: const ValueKey('open_folder_rename_dialog'),
                onPressed: () => StorageFolderActionsMenu.showRename(
                  actionContext,
                  _folder,
                ),
                child: const Text('Rename folder'),
              ),
              StorageFolderActionsMenu(
                folder: _folder,
                capabilities: StorageShellCapabilities.desktop,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  static final _folder = StorageFolderResponse(
    id: 'folder-1',
    name: 'Dokumenty',
    folderType: StorageFolderType.personal,
    itemCount: 0,
    updatedAtUtc: DateTime.utc(2026, 10),
    accessLevel: StorageEffectiveAccessLevel.owner,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
  );
}

final class _FolderDialogErrorScenario {
  static Future<void> run(
    WidgetTester tester, {
    required Locale locale,
    required bool dark,
  }) async {
    tester.view.physicalSize = const Size(420, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = _Repository();
    final routeObserver = _RouteObserver();
    final message = locale.languageCode == 'pl'
        ? 'Ta nazwa folderu jest już używana.'
        : 'This folder name is already in use.';
    final fields = {
      for (var index = 0; index < 30; index++)
        'field_$index': ['Validation details for field $index.'],
    };
    final error = ApiError(
      type: ApiErrorType.conflict,
      message: List.filled(12, message).join('\n'),
      statusCode: 409,
      apiCode: 'storage.folder_conflict',
      contractCode: 'storage.folder_name_conflict',
      backendCode: 72,
      fields: fields,
      traceId: 'folder-409-trace',
    );
    when(
      () => repository.updateFolder(
        folderId: 'folder-1',
        name: 'Nowa nazwa',
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => Left(error));
    await tester.pumpWidget(
      _FolderActionApp(
        repository: repository,
        scale: 2,
        locale: locale,
        dark: dark,
        routeObserver: routeObserver,
      ),
    );
    await tester.tap(find.byKey(const ValueKey('open_folder_rename_dialog')));
    await tester.pumpAndSettle();
    final l10n = await AppLocalizations.delegate.load(locale);
    await tester.enterText(
      find.byKey(const ValueKey('storage_folder_rename_name')),
      'Nowa nazwa',
    );
    await tester.pump();
    final save = find.byKey(const ValueKey('storage_folder_rename_save'));
    await tester.ensureVisible(save);
    expect(save.hitTestable(), findsOneWidget);
    expect(tester.widget<FilledButton>(save).onPressed, isNotNull);
    await tester.tap(save);
    await tester.pumpAndSettle();

    verify(
      () => repository.updateFolder(
        folderId: 'folder-1',
        name: 'Nowa nazwa',
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).called(1);

    expect(find.textContaining(message), findsOneWidget);
    expect(find.textContaining('folder-409-trace'), findsOneWidget);
    expect(find.textContaining('storage.folder_name_conflict'), findsOneWidget);
    expect(find.textContaining('72'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(
      tester
          .widget<TextField>(
            find.byKey(const ValueKey('storage_folder_rename_name')),
          )
          .controller!
          .text,
      'Nowa nazwa',
    );
    expect(save.hitTestable(), findsOneWidget);
    expect(find.text(l10n.cancel).hitTestable(), findsOneWidget);
    expect(
      routeObserver.events.where(
        (event) => event.startsWith('push:RawDialogRoute'),
      ),
      hasLength(1),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }
}

void main() {
  setUpAll(() => registerFallbackValue(const StorageScope.personal()));

  testWidgets(
    'pokazuje błąd wymaganej nazwy i nie zapisuje pustego folderu',
    (tester) async {
      tester.view.physicalSize = const Size(420, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repository = _Repository();
      await tester.pumpWidget(
        _FolderActionApp(repository: repository, scale: 2),
      );
      await tester.tap(find.byKey(const ValueKey('open_folder_rename_dialog')));
      await tester.pumpAndSettle();
      final nameField = find.byKey(
        const ValueKey('storage_folder_rename_name'),
      );
      await tester.enterText(nameField, '   ');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('pl'));
      expect(find.text(l10n.workspacesNameRequiredError), findsOneWidget);
      final save = find.byKey(const ValueKey('storage_folder_rename_save'));
      expect(tester.widget<FilledButton>(save).onPressed, isNull);
      verifyNever(
        () => repository.updateFolder(
          folderId: any(named: 'folderId'),
          name: any(named: 'name'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
    variant: TargetPlatformVariant.only(TargetPlatform.linux),
  );

  for (final config in [
    (const Locale('pl'), false),
    (const Locale('en'), true),
  ]) {
    testWidgets(
      'zachowuje szkic i pełny błąd 200% dla ${config.$1.languageCode}/dark=${config.$2}',
      (tester) => _FolderDialogErrorScenario.run(
        tester,
        locale: config.$1,
        dark: config.$2,
      ),
      variant: TargetPlatformVariant.only(TargetPlatform.linux),
    );
  }

  testWidgets(
    'zamyka i ponownie otwiera dialog bez blokowania akcji',
    (tester) async {
      final repository = _Repository();
      final routeObserver = _RouteObserver();
      when(
        () => repository.updateFolder(
          folderId: 'folder-1',
          name: 'Nowa nazwa',
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer(
        (_) async =>
            Right(_FolderActionAppState._folder.copyWith(name: 'Nowa nazwa')),
      );
      await tester.pumpWidget(
        _FolderActionApp(repository: repository, routeObserver: routeObserver),
      );

      await tester.tap(find.byKey(const ValueKey('open_folder_rename_dialog')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Anuluj'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);

      await tester.tap(find.byKey(const ValueKey('open_folder_rename_dialog')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('storage_folder_rename_name')),
        'Nowa nazwa',
      );
      await tester.pump();
      final save = find.byKey(const ValueKey('storage_folder_rename_save'));
      expect(save.hitTestable(), findsOneWidget);
      await tester.tap(save);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      verify(
        () => repository.updateFolder(
          folderId: 'folder-1',
          name: 'Nowa nazwa',
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).called(1);
      expect(
        routeObserver.events.where(
          (event) => event.startsWith('push:RawDialogRoute'),
        ),
        hasLength(2),
      );
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.linux),
  );

  testWidgets(
    'spóźniony sukces rename nie zamyka nowej trasy',
    (tester) async {
      final repository = _Repository();
      final appKey = GlobalKey<_FolderActionAppState>();
      final response = Completer<Either<ApiError, StorageFolderResponse>>();
      when(
        () => repository.updateFolder(
          folderId: 'folder-1',
          name: 'Nowa nazwa',
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer((_) => response.future);
      await tester.pumpWidget(
        _FolderActionApp(key: appKey, repository: repository),
      );
      await tester.tap(find.byKey(const ValueKey('open_folder_rename_dialog')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('storage_folder_rename_name')),
        'Nowa nazwa',
      );
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey('storage_folder_rename_save')),
      );
      await tester.pump();
      verify(
        () => repository.updateFolder(
          folderId: 'folder-1',
          name: 'Nowa nazwa',
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).called(1);

      appKey.currentState!.replaceTopRoute();
      await tester.pump();
      response.complete(
        Right(_FolderActionAppState._folder.copyWith(name: 'Nowa nazwa')),
      );
      await tester.pump();
      expect(find.text('Replacement route'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpAndSettle();
      expect(find.text('Replacement route'), findsOneWidget);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.linux),
  );

  for (final changeScope in [false, true]) {
    testWidgets(
      'nie zapisuje szkicu po zmianie właściciela lub zakresu: scope=$changeScope',
      (tester) async {
        final repository = _Repository();
        final appKey = GlobalKey<_FolderActionAppState>();
        when(
          () => repository.listFolders(
            scope: any(named: 'scope'),
            parentFolderId: any(named: 'parentFolderId'),
          ),
        ).thenAnswer(
          (_) async => const Right<ApiError, List<StorageFolderResponse>>([]),
        );
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
          (_) async =>
              const Right<ApiError, CursorPageResponse<StorageFileResponse>>(
                CursorPageResponse(items: <StorageFileResponse>[]),
              ),
        );

        await tester.pumpWidget(
          _FolderActionApp(key: appKey, repository: repository),
        );
        await tester.tap(
          find.byKey(const ValueKey('open_folder_rename_dialog')),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('storage_folder_rename_name')),
          'Nowa nazwa',
        );
        await tester.pump();

        if (changeScope) {
          await appKey.currentState!.changeScope();
        } else {
          appKey.currentState!.replaceOwners();
        }
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const ValueKey('storage_folder_rename_save')),
        );
        await tester.pumpAndSettle();

        verifyNever(
          () => repository.updateFolder(
            folderId: any(named: 'folderId'),
            name: any(named: 'name'),
            parentFolderId: any(named: 'parentFolderId'),
          ),
        );
        expect(find.byType(AlertDialog), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
