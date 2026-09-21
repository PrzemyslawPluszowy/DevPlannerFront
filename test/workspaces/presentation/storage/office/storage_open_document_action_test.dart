import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
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
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_page.dart';
import 'package:flutter/gestures.dart';
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

void main() {
  late _MockStorageRepository repository;
  final now = DateTime.utc(2026, 9, 20);

  /// Dokument biurowy: tylko taki plik ma akcję otwarcia w edytorze.
  final document = StorageFileResponse(
    id: 'file-1',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'dokument.docx',
    extension: '.docx',
    mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
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
    canEditOnline: true,
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
    ).thenAnswer((_) async => const Right(<StorageFolderResponse>[]));
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
          Right(CursorPageResponse<StorageFileResponse>(items: [document])),
    );
    // Sesja edytora kończy się błędem: ten test nie uruchamia osadzonego
    // OnlyOffice, a mimo to sprawdza ścieżkę otwarcia i odświeżenia.
    when(
      () => repository.getOfficeSession('file-1'),
    ).thenAnswer(
      (_) async => const Left(
        ApiError(type: ApiErrorType.connection, message: 'Brak połączenia'),
      ),
    );
  });

  Future<void> pumpShell(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
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
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Otwórz uruchamia edytor dokumentu i odświeża listę po zamknięciu',
    (
      tester,
    ) async {
      await pumpShell(tester);

      await tester.tap(
        find.text('dokument.docx'),
        buttons: kSecondaryMouseButton,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Otwórz dokument'));
      await tester.pumpAndSettle();

      expect(find.byType(StorageOfficeEditorDialog), findsOneWidget);
      verify(() => repository.getOfficeSession('file-1')).called(1);

      // Odczyt zużywa dotychczasowe wywołania, więc kontrola po zamknięciu
      // pokazuje dokładnie jedno nowe żądanie odświeżenia.
      verify(
        () => repository.listFiles(
          scope: any(named: 'scope'),
          folderId: any(named: 'folderId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
          filter: any(named: 'filter'),
        ),
      ).called(1);

      await tester.tap(find.byTooltip('Zamknij').first);
      await tester.pumpAndSettle();

      expect(find.byType(StorageOfficeEditorDialog), findsNothing);
      // OnlyOffice zapisuje wersję po własnym callbacku, więc po sesji lista musi
      // pochodzić z serwera, a nie z pamięci sprzed edycji.
      verify(
        () => repository.listFiles(
          scope: any(named: 'scope'),
          folderId: any(named: 'folderId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
          filter: any(named: 'filter'),
        ),
      ).called(1);
    },
  );

  testWidgets('plik bez obsługi online nie pokazuje akcji otwarcia', (
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
      (_) async => Right(
        CursorPageResponse<StorageFileResponse>(
          items: [document.copyWith(canEditOnline: false)],
        ),
      ),
    );
    await pumpShell(tester);

    await tester.tap(
      find.text('dokument.docx'),
      buttons: kSecondaryMouseButton,
    );
    await tester.pumpAndSettle();

    expect(find.text('Otwórz dokument'), findsNothing);
  });
}
