import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_chrome_pill.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Repozytorium Storage wystarczające do złożenia chrome'u i ciała.
class _MockStorageRepository extends Mock implements StorageRepository {}

/// Picker bez systemowego dialogu: test nie wybiera plików z dysku, ale
/// kompozycja musi go mieć, inaczej akcja wysyłania słusznie nie istnieje.
class _FakeFilePicker extends Fake implements FilePickerPort {
  @override
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
  }) async => const [];
}

/// Widoki, w których chrome Plików musi działać bez wyjątków i bez
/// znikającego wyszukiwania.
const _viewports = <({String name, double width, double height})>[
  (name: 'telefon', width: 360, height: 720),
  (name: 'mały tablet', width: 560, height: 760),
  (name: 'tablet', width: 760, height: 900),
  (name: 'laptop', width: 1024, height: 900),
  (name: 'desktop', width: 1440, height: 900),
  (name: 'szeroki desktop', width: 1920, height: 1080),
];

void main() {
  late _MockStorageRepository repository;

  final now = DateTime.utc(2026, 9, 20);

  final sampleFolder = StorageFolderResponse(
    id: 'folder-1',
    name: 'Projekty',
    folderType: StorageFolderType.personal,
    itemCount: 1,
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
    originalFileName: 'raport.pdf',
    extension: 'pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 2048,
    version: 1,
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    createdAtUtc: now,
    updatedAtUtc: now,
    isDeleted: false,
    processingStatus: StorageProcessingStatus.ready,
    scanStatus: StorageScanStatus.clean,
    aiStatus: StorageAiStatus.none,
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
      (_) async =>
          Right(CursorPageResponse<StorageFileResponse>(items: [sampleFile])),
    );
  });

  Widget harness({
    ThemeData? theme,
    double textScale = 1.0,
    StorageShellCapabilities capabilities = StorageShellCapabilities.readOnly,
  }) => MaterialApp(
    theme: theme ?? MaterialTheme.crm().light(),
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: Scaffold(
        body: StorageShellPage(
          storageRepository: repository,
          capabilities: capabilities,
          filePicker: _FakeFilePicker(),
        ),
      ),
    ),
  );

  Future<void> pumpAt(
    WidgetTester tester, {
    required double width,
    required double height,
    ThemeData? theme,
    double textScale = 1.0,
    StorageShellCapabilities capabilities = StorageShellCapabilities.readOnly,
  }) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      harness(
        theme: theme,
        textScale: textScale,
        capabilities: capabilities,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('chrome Plików w widokach', () {
    for (final viewport in _viewports) {
      testWidgets('${viewport.name} bez wyjątków i bez utraty wyszukiwania', (
        tester,
      ) async {
        await pumpAt(tester, width: viewport.width, height: viewport.height);

        expect(find.byType(StorageShellPage), findsOneWidget);
        // Wyszukiwanie jest dostępne w każdym widoku: w drugim wierszu albo
        // we własnym wierszu, ale nigdy zniknięte.
        expect(
          find.byKey(const ValueKey('storage_search_field')),
          findsOneWidget,
        );
        expect(find.byKey(const ValueKey('storage_sort_menu')), findsOneWidget);
        expect(
          find.byKey(const ValueKey('storage_view_mode_list')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('chrome Plików: skala tekstu i motyw', () {
    final themes = <String, ThemeData>{
      'light': MaterialTheme.crm().light(),
      'dark': MaterialTheme.crm().dark(),
    };
    const scales = [1.0, 1.25, 1.5];
    const widths = [1024.0, 1440.0, 1920.0];

    for (final entry in themes.entries) {
      for (final scale in scales) {
        for (final width in widths) {
          testWidgets(
            '${entry.key}, ${width.toInt()} px, ${scale}x bez overflow',
            (tester) async {
              await pumpAt(
                tester,
                width: width,
                height: 900,
                theme: entry.value,
                textScale: scale,
              );

              final error = tester.takeException();
              expect(
                error,
                isNull,
                reason: error is FlutterError ? error.toStringDeep() : null,
              );
            },
          );
        }
      }
    }
  });

  testWidgets('chrome trzyma dwa wiersze o wysokości z tokenów modułu', (
    tester,
  ) async {
    await pumpAt(
      tester,
      width: 1440,
      height: 900,
      capabilities: StorageShellCapabilities.desktop,
    );

    // Wiersz kontekstu i wiersz poleceń muszą mieścić się w tokenach wspólnej
    // gęstości modułów danych, inaczej chrome rozjeżdża się z Tasks/Kanban.
    final tokens = DevPlannerTasksTheme.of(
      Theme.of(tester.element(find.byType(StorageShellPage))).textTheme,
      Theme.of(tester.element(find.byType(StorageShellPage))).colorScheme,
    );
    expect(tokens.contextRowHeight, inInclusiveRange(44, 48));
    expect(tokens.commandRowHeight, inInclusiveRange(36, 40));

    final contextRow = tester.getSize(
      find.byKey(const ValueKey('storage_create_menu')),
    );
    expect(contextRow.height, lessThanOrEqualTo(tokens.contextRowHeight));
    expect(
      tester
          .getSize(find.byKey(const ValueKey('storage_upload_action')))
          .height,
      lessThanOrEqualTo(tokens.contextRowHeight),
    );
  });

  testWidgets('na wąskim ekranie akcje tworzące zwijają się do jednego menu', (
    tester,
  ) async {
    await pumpAt(
      tester,
      width: 700,
      height: 900,
      capabilities: StorageShellCapabilities.desktop,
    );

    // CTA wysyłania zostaje, ale tworzenie i akcje drugorzędne są w jednym
    // menu, żeby nie wypychały wyszukiwania ani przełącznika widoku.
    expect(find.byKey(const ValueKey('storage_upload_action')), findsOneWidget);
    expect(find.byKey(const ValueKey('storage_create_menu')), findsNothing);
    expect(find.byKey(const ValueKey('storage_more_menu')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('storage_search_field')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('wpisanie frazy trafia do wyszukiwania po debounce', (
    tester,
  ) async {
    await pumpAt(tester, width: 1440, height: 900);

    await tester.enterText(
      find.byKey(const ValueKey('storage_search_field')),
      'raport',
    );
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    verify(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: 'raport',
        filter: any(named: 'filter'),
      ),
    ).called(1);
  });

  testWidgets("fokus klawiatury dochodzi do kontrolek chrome'u", (
    tester,
  ) async {
    await pumpAt(
      tester,
      width: 1440,
      height: 900,
      capabilities: StorageShellCapabilities.desktop,
    );

    // Użytkownik klawiatury musi móc wejść w pasek poleceń, a nie tylko
    // w ciało eksploratora.
    var reachedChrome = false;
    for (var step = 0; step < 16 && !reachedChrome; step++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final focused = FocusManager.instance.primaryFocus?.context;
      reachedChrome =
          focused != null &&
          focused.findAncestorWidgetOfExactType<StorageChromePill>() != null;
    }
    expect(reachedChrome, isTrue);

    // Każda kontrolka ikonowa ma nazwę dostępną dla czytnika ekranu.
    expect(find.byTooltip('Prześlij pliki'), findsOneWidget);
    expect(find.byTooltip('Widok listy'), findsOneWidget);
    expect(find.byTooltip('Widok siatki'), findsOneWidget);
  });

  group('filtry', () {
    testWidgets('filtr typu zawęża zapytanie i schodzi z paska filtrów', (
      tester,
    ) async {
      await pumpAt(tester, width: 1440, height: 900);
      expect(
        find.byKey(const ValueKey('storage_active_filter_strip')),
        findsNothing,
      );

      await tester.tap(find.byKey(const ValueKey('storage_filter_menu')));
      await tester.pumpAndSettle();

      // Opcje typu pochodzą z listy, więc panel nie proponuje formatów,
      // których w katalogu nie ma.
      expect(find.text('PDF'), findsOneWidget);
      await tester.tap(find.text('PDF'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('storage_filter_apply')));
      await tester.pumpAndSettle();

      final captured = verify(
        () => repository.listFiles(
          scope: any(named: 'scope'),
          folderId: any(named: 'folderId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
          filter: captureAny(named: 'filter'),
        ),
      ).captured;
      final lastFilter = captured.last as StorageBrowserFilter;
      expect(lastFilter.extension, 'pdf');

      // Aktywny filtr jest widoczny i ma jedno wyjście do zdjęcia warunku.
      expect(
        find.byKey(const ValueKey('storage_active_filter_strip')),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const ValueKey('storage_active_filter_clear')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('storage_active_filter_strip')),
        findsNothing,
      );
      final cleared = verify(
        () => repository.listFiles(
          scope: any(named: 'scope'),
          folderId: any(named: 'folderId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
          filter: captureAny(named: 'filter'),
        ),
      ).captured;
      expect(
        (cleared.last as StorageBrowserFilter).hasActiveFilters,
        isFalse,
      );
    });
  });

  group('trwały banner błędu', () {
    testWidgets('brak bannera, gdy zakres wczytuje się poprawnie', (
      tester,
    ) async {
      await pumpAt(tester, width: 1440, height: 900);
      expect(find.text('Ponów'), findsNothing);
      expect(find.text('Odśwież'), findsNothing);
    });

    testWidgets('pokazuje komunikat, kod i traceId oraz ponawia', (
      tester,
    ) async {
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
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.badResponse,
            message: 'Nie udało się pobrać plików.',
            statusCode: 409,
            apiCode: 'storage.version_conflict',
            traceId: 'trace-7f3',
          ),
        ),
      );

      await pumpAt(tester, width: 1440, height: 900);

      expect(find.text('Nie udało się pobrać plików.'), findsOneWidget);
      expect(
        find.textContaining('storage.version_conflict'),
        findsOneWidget,
      );
      expect(find.textContaining('trace-7f3'), findsOneWidget);
      expect(find.text('Ponów'), findsOneWidget);
      expect(find.text('Odśwież'), findsOneWidget);

      await tester.tap(find.text('Ponów'));
      await tester.pumpAndSettle();

      verify(
        () => repository.listFiles(
          scope: any(named: 'scope'),
          folderId: any(named: 'folderId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
          filter: any(named: 'filter'),
        ),
      ).called(2);
    });
  });
}
