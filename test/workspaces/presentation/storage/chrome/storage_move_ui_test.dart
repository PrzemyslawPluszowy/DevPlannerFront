import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_drag_and_drop.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_folder_picker_dialog.dart';
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

void main() {
  late _MockStorageRepository repository;
  final now = DateTime.utc(2026, 9, 20);

  final folder = StorageFolderResponse(
    id: 'folder-1',
    name: 'Umowy',
    folderType: StorageFolderType.personal,
    itemCount: 0,
    updatedAtUtc: now,
    accessLevel: StorageEffectiveAccessLevel.owner,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
  );

  final nestedFolder = StorageFolderResponse(
    id: 'folder-2',
    name: 'Podfolder',
    folderType: StorageFolderType.personal,
    itemCount: 0,
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

  StorageFilePlacementResponse placement({int version = 5}) =>
      StorageFilePlacementResponse(
        id: 'placement-1',
        fileId: file.id,
        folderId: folder.id,
        createdAtUtc: now,
        version: version,
      );

  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
    registerFallbackValue(
      const MoveStorageFilePlacementPayload(
        targetFolderId: 'fallback',
        expectedVersion: 1,
      ),
    );
  });

  setUp(() {
    repository = _MockStorageRepository();
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer(
      (invocation) async => Right([
        if (invocation.namedArguments[#parentFolderId] == folder.id)
          nestedFolder
        else
          folder,
      ]),
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
          Right(CursorPageResponse<StorageFileResponse>(items: [file])),
    );
    when(() => repository.getFolder(folder.id)).thenAnswer(
      (_) async => Right(folder),
    );
    when(() => repository.getFolder(nestedFolder.id)).thenAnswer(
      (_) async => Right(nestedFolder),
    );
    when(
      () => repository.listFolderPlacements(any()),
    ).thenAnswer((_) async => Right([placement()]));
    when(
      () => repository.moveFilePlacement(
        placementId: any(named: 'placementId'),
        targetFolderId: any(named: 'targetFolderId'),
        expectedVersion: any(named: 'expectedVersion'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async => Right(placement()));
    when(
      () => repository.createFilePlacement(
        fileId: any(named: 'fileId'),
        folderId: any(named: 'folderId'),
      ),
    ).thenAnswer((_) async => Right(placement()));
  });

  Widget harness(StorageShellCapabilities capabilities) => MaterialApp(
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
        capabilities: capabilities,
        filePicker: _FakeFilePicker(),
        onOpenFileDetails: (_) {},
      ),
    ),
  );

  Future<void> pumpShell(
    WidgetTester tester, {
    StorageShellCapabilities capabilities = StorageShellCapabilities.desktop,
  }) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(harness(capabilities));
    await tester.pumpAndSettle();
  }

  testWidgets('picker folderu przenosi plik do wybranego folderu', (
    tester,
  ) async {
    await pumpShell(tester);

    // Wewnątrz folderu plik jest placementem, więc przeniesienie idzie
    // istniejącą referencją, a nie tworzeniem nowej.
    await tester.tap(find.text('Umowy'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('move-file-file-1')));
    await tester.pumpAndSettle();

    expect(find.byType(StorageFolderPickerDialog), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(StorageFolderPickerDialog),
        matching: find.text('Podfolder'),
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey('storage_picker_folder-folder-2')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('storage_picker_confirm')));
    await tester.pumpAndSettle();

    final captured = verify(
      () => repository.moveFilePlacement(
        placementId: captureAny(named: 'placementId'),
        targetFolderId: captureAny(named: 'targetFolderId'),
        expectedVersion: captureAny(named: 'expectedVersion'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).captured;
    expect(captured[0], 'placement-1');
    expect(captured[1], 'folder-2');
    // Wersja pochodzi z odczytanego placementu, nie z UI.
    expect(captured[2], 5);
  });

  testWidgets(
    'upuszczenie pliku na folder używa tego samego przypadku użycia',
    (
      tester,
    ) async {
      await pumpShell(tester);

      await tester.tap(find.text('Umowy'));
      await tester.pumpAndSettle();

      final source = find.byType(StorageFileDragSource);
      final target = find.byType(StorageFolderDropTarget);
      expect(source, findsOneWidget);
      expect(target, findsOneWidget);

      final gesture = await tester.startGesture(tester.getCenter(source));
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.moveTo(tester.getCenter(target));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      verify(
        () => repository.moveFilePlacement(
          placementId: 'placement-1',
          targetFolderId: 'folder-2',
          expectedVersion: 5,
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'upuszczenie pliku zakresu tworzy referencję, bo plik nie ma jeszcze placementu',
    (tester) async {
      await pumpShell(tester);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(StorageFileDragSource)),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.moveTo(
        tester.getCenter(find.byType(StorageFolderDropTarget)),
      );
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      verify(
        () => repository.createFilePlacement(
          fileId: 'file-1',
          folderId: 'folder-1',
        ),
      ).called(1);
      verifyNever(
        () => repository.moveFilePlacement(
          placementId: any(named: 'placementId'),
          targetFolderId: any(named: 'targetFolderId'),
          expectedVersion: any(named: 'expectedVersion'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      );
    },
  );

  testWidgets(
    'kompozycja read-only nie pokazuje przenoszenia ani nie pozwala upuścić pliku',
    (
      tester,
    ) async {
      await pumpShell(tester, capabilities: StorageShellCapabilities.readOnly);

      expect(find.byKey(const ValueKey('move-file-file-1')), findsNothing);
      // Bez uprawnień nie ma ani źródła przeciągania, ani celu upuszczenia, więc
      // gest nie może wywołać niedozwolonej akcji.
      expect(find.byType(Draggable<String>), findsNothing);
      expect(find.byType(DragTarget<String>), findsNothing);
      verifyNever(
        () => repository.moveFilePlacement(
          placementId: any(named: 'placementId'),
          targetFolderId: any(named: 'targetFolderId'),
          expectedVersion: any(named: 'expectedVersion'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      );
    },
  );
}
