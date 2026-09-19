import 'package:dartz/dartz.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_scope_route_codec.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_page.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_sidebar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

class _MockDownloadTransport extends Mock implements DownloadTransport {}

class _MockUploadTransport extends Mock implements UploadTransport {}

void main() {
  late _MockStorageRepository repository;
  late _MockDownloadTransport downloadTransport;
  late _MockUploadTransport uploadTransport;

  final now = DateTime.utc(2026, 3, 30);

  final sampleFolder = StorageFolderResponse(
    id: 'folder-1',
    name: 'Projekty 2026',
    folderType: StorageFolderType.personal,
    itemCount: 2,
    updatedAtUtc: now,
    accessLevel: StorageEffectiveAccessLevel.owner,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
  );

  final sampleFile = StorageFileResponse(
    id: 'file-1',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'dokument.pdf',
    extension: 'pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 1024,
    version: 1,
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    createdAtUtc: now,
    updatedAtUtc: now,
    isDeleted: false,
    processingStatus: StorageProcessingStatus.ready,
    scanStatus: StorageScanStatus.clean,
    aiStatus: StorageAiStatus.completed,
    accessLevel: StorageEffectiveAccessLevel.owner,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
    canPreview: true,
    canDownload: true,
    canManageVersions: true,
  );

  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
  });

  setUp(() {
    repository = _MockStorageRepository();
    downloadTransport = _MockDownloadTransport();
    uploadTransport = _MockUploadTransport();

    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => Right([sampleFolder]));

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
      (_) async => Right(
        CursorPageResponse<StorageFileResponse>(
          items: [sampleFile],
        ),
      ),
    );
  });

  Widget buildHarness({Locale locale = const Locale('pl')}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: StorageShellPage(
          storageRepository: repository,
          downloadTransport: downloadTransport,
          uploadTransport: uploadTransport,
        ),
      ),
    );
  }

  testWidgets('StorageShellPage renderuje sidebar, toolbar i elementy listy', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildHarness());
    await tester.pumpAndSettle();

    // Weryfikacja obecności folderu i pliku
    expect(find.text('Projekty 2026'), findsOneWidget);
    expect(find.text('dokument.pdf'), findsOneWidget);

    // Weryfikacja obecności elementów sidebara
    expect(find.text('Moje pliki'), findsAtLeastNWidgets(1));
    expect(find.text('Udostępnione mi'), findsOneWidget);
    expect(find.text('Kosz'), findsOneWidget);
    expect(find.text('Nowy dokument'), findsOneWidget);
  });

  testWidgets(
    'globalny widok otwarty z workspace zachowuje powrót do workspace',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final router = GoRouter(
        initialLocation: '/workspaces/w-1/files',
        routes: [
          GoRoute(
            path: '/workspaces/:workspaceId/files',
            builder: (_, state) => StorageShellPage(
              initialScope: StorageScope.workspace(
                state.pathParameters['workspaceId']!,
              ),
              storageRepository: repository,
              downloadTransport: downloadTransport,
              uploadTransport: uploadTransport,
            ),
          ),
          GoRoute(
            path: '/me/files',
            builder: (_, state) => StorageShellPage(
              initialScope: StorageScopeRouteCodec.fromPersonalUri(state.uri),
              storageRepository: repository,
              downloadTransport: downloadTransport,
              uploadTransport: uploadTransport,
            ),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pl'),
        ),
      );
      await tester.pumpAndSettle();

      final workspaceCubit = tester
          .element(find.byType(StorageSidebar))
          .read<StorageBrowserCubit>();
      expect(workspaceCubit.currentScope, isA<StorageWorkspaceScope>());

      await tester.tap(find.text('Ostatnie'));
      await tester.pumpAndSettle();
      final globalUri = router.routerDelegate.currentConfiguration.uri;
      expect(globalUri.path, '/workspaces/w-1/files');
      expect(globalUri.queryParameters['view'], 'recent');
      expect(
        tester
            .element(find.byType(StorageSidebar))
            .read<StorageBrowserCubit>()
            .currentScope,
        isA<StorageRecentScope>(),
      );

      expect(await tester.binding.handlePopRoute(), isTrue);
      await tester.pumpAndSettle();
      expect(
        router.routerDelegate.currentConfiguration.uri.toString(),
        '/workspaces/w-1/files',
      );
    },
  );

  testWidgets('dialog nowego dokumentu mieści się w kompaktowym oknie', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildHarness());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nowy dokument').last);
    await tester.pumpAndSettle();

    expect(find.text('Nowy dokument'), findsOneWidget);
    expect(
      find.byType(DropdownButtonFormField<StorageDocumentFormat>),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('secondary-click na pliku otwiera menu kontekstowe desktop', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildHarness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('dokument.pdf'), buttons: kSecondaryMouseButton);
    await tester.pumpAndSettle();

    expect(find.text('Podgląd pliku'), findsOneWidget);
    expect(find.text('Udostępnij'), findsOneWidget);
    expect(find.text('Pobierz'), findsOneWidget);
  });

  testWidgets('secondary-click na folderze udostępnia akcję zmiany nazwy', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildHarness());
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('Projekty 2026'),
      buttons: kSecondaryMouseButton,
    );
    await tester.pumpAndSettle();

    expect(find.text('Zmień nazwę folderu'), findsOneWidget);
    expect(find.text('Usuń'), findsOneWidget);
  });

  testWidgets('lokalizuje korzeń breadcrumbs poza Cubitem', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildHarness(locale: const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('My files'), findsAtLeastNWidgets(1));
    expect(find.text('Moje pliki'), findsNothing);
  });

  testWidgets('Ctrl+A zaznacza widoczne elementy, a Escape czyści wybór', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildHarness());
    await tester.pumpAndSettle();
    final selection = tester
        .element(find.byType(StorageSidebar))
        .read<StorageSelectionCubit>();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    expect(selection.state.count, 2);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();

    expect(selection.state.hasSelection, isFalse);
  });

  testWidgets('Cmd+A zaznacza elementy na platformach z klawiszem Meta', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildHarness());
    await tester.pumpAndSettle();
    final selection = tester
        .element(find.byType(StorageSidebar))
        .read<StorageSelectionCubit>();
    Focus.of(tester.element(find.text('dokument.pdf'))).requestFocus();
    await tester.pump();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
    await tester.pump();

    expect(selection.state.count, 2);
  });

  testWidgets('Ctrl+A nie przejmuje zaznaczania w polu wyszukiwania', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildHarness());
    await tester.pumpAndSettle();
    final selection = tester
        .element(find.byType(StorageSidebar))
        .read<StorageSelectionCubit>();
    final searchField = find.byType(TextField);
    await tester.tap(searchField);
    await tester.enterText(searchField, 'raport');
    await tester.pump(const Duration(milliseconds: 400));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    expect(selection.state.hasSelection, isFalse);
  });

  testWidgets('renderuje explorer po zwężeniu okna bez błędów layoutu', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(720, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildHarness());
    await tester.pumpAndSettle();

    expect(find.text('dokument.pdf'), findsOneWidget);
    final compactError = tester.takeException();
    expect(
      compactError,
      isNull,
      reason: compactError is FlutterError ? compactError.toStringDeep() : null,
    );

    tester.view.physicalSize = const Size(1280, 900);
    await tester.pumpAndSettle();

    expect(find.text('dokument.pdf'), findsOneWidget);
    final resizedError = tester.takeException();
    expect(
      resizedError,
      isNull,
      reason: resizedError is FlutterError ? resizedError.toStringDeep() : null,
    );
  });
}
