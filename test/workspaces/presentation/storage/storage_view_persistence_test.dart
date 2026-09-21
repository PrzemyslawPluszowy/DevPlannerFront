import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/preferences/shared_preferences_storage_view_store.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_view_preference.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/grid/storage_file_grid.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/list/storage_file_rows.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

class _FakeFilePicker extends Fake implements FilePickerPort {
  @override
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
  }) async => const [];
}

void main() {
  late _MockStorageRepository repository;
  final now = DateTime.utc(2026, 9, 20);

  final file = StorageFileResponse(
    id: 'file-1',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'raport.pdf',
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
      (_) async =>
          right(CursorPageResponse<StorageFileResponse>(items: [file])),
    );
  });

  Widget harness(SharedPreferencesStorageViewStore store) => MaterialApp(
    theme: MaterialTheme.crm().light(),
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: StorageShellPage(
        storageRepository: repository,
        capabilities: StorageShellCapabilities.desktop,
        filePicker: _FakeFilePicker(),
        viewPreferenceStore: store,
      ),
    ),
  );

  Future<SharedPreferencesStorageViewStore> restartStore() async {
    final store = SharedPreferencesStorageViewStore(
      currentUserId: () => 'user-1',
    );
    await store.load();
    return store;
  }

  testWidgets('zapisany widok i gęstość wracają po restarcie klienta', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues(<String, Object>{
      'devplanner.files-view.user-1.personal': jsonEncode(
        const StorageViewPreference(
          viewMode: StorageViewMode.grid,
          density: StorageDensity.compact,
        ).toJson(),
      ),
    });

    await tester.pumpWidget(harness(await restartStore()));
    await tester.pumpAndSettle();

    // Siatka z zapisu, nie domyślna lista.
    expect(find.byType(StorageFileGrid), findsOneWidget);
    expect(find.byType(StorageFileRows), findsNothing);
  });

  testWidgets('zmiana widoku jest zapisywana i wraca po restarcie', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(harness(await restartStore()));
    await tester.pumpAndSettle();
    expect(find.byType(StorageFileRows), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('storage_view_mode_grid')));
    await tester.pumpAndSettle();
    expect(find.byType(StorageFileGrid), findsOneWidget);

    // Nowy start aplikacji: wybór użytkownika obowiązuje bez ponownego klikania.
    await tester.pumpWidget(harness(await restartStore()));
    await tester.pumpAndSettle();

    expect(find.byType(StorageFileGrid), findsOneWidget);
  });

  testWidgets('zakres bez zapisu nie dziedziczy widoku innego zakresu', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues(<String, Object>{
      'devplanner.files-view.user-1.personal': jsonEncode(
        const StorageViewPreference(viewMode: StorageViewMode.grid).toJson(),
      ),
    });

    await tester.pumpWidget(harness(await restartStore()));
    await tester.pumpAndSettle();
    expect(find.byType(StorageFileGrid), findsOneWidget);

    await tester.tap(find.text('Kosz'));
    await tester.pumpAndSettle();

    // Kosz nie ma własnego zapisu, więc obowiązuje domyślna lista.
    expect(find.byType(StorageFileRows), findsOneWidget);
    expect(find.byType(StorageFileGrid), findsNothing);
  });
}
