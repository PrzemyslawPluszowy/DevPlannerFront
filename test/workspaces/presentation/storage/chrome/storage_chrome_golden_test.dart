import 'package:dartz/dartz.dart';
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
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

class _FakeFilePicker extends Fake implements FilePickerPort {
  @override
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
  }) async => const [];
}

/// Klucz granicy renderowania, którą porównujemy z plikiem golden.
const ValueKey<String> _boundaryKey = ValueKey(
  'golden_storage_chrome_boundary',
);

void main() {
  late _MockStorageRepository repository;
  final now = DateTime.utc(2026, 9, 20);

  final folder = StorageFolderResponse(
    id: 'folder-1',
    name: 'Umowy',
    folderType: StorageFolderType.personal,
    itemCount: 3,
    updatedAtUtc: now,
    accessLevel: StorageEffectiveAccessLevel.owner,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
  );

  final file = StorageFileResponse(
    id: 'file-1',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'raport-roczny.pdf',
    extension: 'pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 20480,
    version: 3,
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
    ).thenAnswer((_) async => Right([folder]));
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
          Right(CursorPageResponse<StorageFileResponse>(items: [file])),
    );
  });

  Widget harness({
    required double width,
    required ThemeData theme,
  }) => MaterialApp(
    theme: theme,
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: Size(width, 900)),
      child: RepaintBoundary(
        key: _boundaryKey,
        child: Scaffold(
          body: StorageShellPage(
            storageRepository: repository,
            capabilities: StorageShellCapabilities.desktop,
            filePicker: _FakeFilePicker(),
          ),
        ),
      ),
    ),
  );

  Future<void> pumpGolden(
    WidgetTester tester, {
    required double width,
    required ThemeData theme,
  }) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(harness(width: width, theme: theme));
    await tester.pumpAndSettle();
  }

  for (final theme in <String, ThemeData>{
    'light': MaterialTheme.crm().light(),
    'dark': MaterialTheme.crm().dark(),
  }.entries) {
    testWidgets('chrome Plików 1280 px, desktop ${theme.key}', (tester) async {
      await pumpGolden(tester, width: 1280, theme: theme.value);
      await expectLater(
        find.byKey(_boundaryKey),
        matchesGoldenFile('goldens/storage_chrome_1280_${theme.key}.png'),
      );
    });
  }

  testWidgets('chrome Plików 700 px: akcje zwinięte do jednego menu', (
    tester,
  ) async {
    await pumpGolden(
      tester,
      width: 700,
      theme: MaterialTheme.crm().light(),
    );
    await expectLater(
      find.byKey(_boundaryKey),
      matchesGoldenFile('goldens/storage_chrome_700_light.png'),
    );
  });
}
