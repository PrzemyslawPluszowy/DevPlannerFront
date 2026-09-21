import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
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
    version: 2,
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

  /// Ten sam konflikt wersji, który publikuje kontrakt przenoszenia.
  const conflict = ApiError(
    type: ApiErrorType.badResponse,
    message: 'Placement został zmieniony przez innego użytkownika.',
    statusCode: 409,
    apiCode: 'storage.placement_conflict',
    traceId: 'trace-42',
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
    when(() => repository.getFolder('folder-1')).thenAnswer(
      (_) async => Right(folder),
    );
    when(
      () => repository.listFolderPlacements(any()),
    ).thenAnswer(
      (_) async => Right([
        StorageFilePlacementResponse(
          id: 'placement-1',
          fileId: file.id,
          folderId: 'folder-1',
          createdAtUtc: now,
          version: 7,
        ),
      ]),
    );
    when(
      () => repository.deleteFile(any()),
    ).thenAnswer((_) async => const Left(conflict));
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

  testWidgets('nieudane usunięcie pokazuje trwały banner z kodem i traceId', (
    tester,
  ) async {
    await pumpShell(tester);

    await tester.tap(find.text('raport.pdf'), buttons: kSecondaryMouseButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usuń').last);
    await tester.pumpAndSettle();

    // SnackBar znikał razem z kodem i identyfikatorem żądania.
    expect(
      find.text('Placement został zmieniony przez innego użytkownika.'),
      findsOneWidget,
    );
    expect(find.textContaining('storage.placement_conflict'), findsOneWidget);
    expect(find.textContaining('trace-42'), findsOneWidget);

    // Usunięcia nie da się bezpiecznie powtórzyć bez odtworzenia intencji,
    // więc banner oferuje odświeżenie, a nie obiecuje „Ponów”.
    expect(find.text('Ponów'), findsNothing);
    expect(find.text('Odśwież'), findsOneWidget);

    await tester.tap(find.text('Odśwież'));
    await tester.pumpAndSettle();

    expect(
      find.text('Placement został zmieniony przez innego użytkownika.'),
      findsNothing,
    );
  });

  testWidgets('odwołana sesja w trakcie mutacji nie udaje sukcesu', (
    tester,
  ) async {
    // 401 po odwołaniu sesji: lista i operacja muszą zostać odrzucone, a nie
    // pokazane jako powodzenie z cache.
    when(() => repository.deleteFile(any())).thenAnswer(
      (_) async => const Left(
        ApiError(
          type: ApiErrorType.unauthorized,
          message: 'Sesja wygasła. Zaloguj się ponownie.',
          statusCode: 401,
          apiCode: 'auth.session_revoked',
          traceId: 'trace-401',
        ),
      ),
    );
    await pumpShell(tester);

    await tester.tap(find.text('raport.pdf'), buttons: kSecondaryMouseButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usuń').last);
    await tester.pumpAndSettle();

    expect(find.text('Sesja wygasła. Zaloguj się ponownie.'), findsOneWidget);
    expect(find.textContaining('auth.session_revoked'), findsOneWidget);
    expect(find.textContaining('trace-401'), findsOneWidget);
    // Plik nadal jest na liście: nieudana operacja nie może zniknąć lokalnie.
    expect(find.text('raport.pdf'), findsOneWidget);
  });

  testWidgets('konflikt przeniesienia daje ponowienie tą samą intencją', (
    tester,
  ) async {
    when(
      () => repository.moveFilePlacement(
        placementId: any(named: 'placementId'),
        targetFolderId: any(named: 'targetFolderId'),
        expectedVersion: any(named: 'expectedVersion'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async => const Left(conflict));
    await pumpShell(tester);

    // Wewnątrz folderu plik jest placementem, więc przeniesienie idzie
    // istniejącą referencją z jej wersją.
    await tester.tap(find.text('Umowy'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('move-file-file-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Podfolder').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('storage_picker_confirm')));
    await tester.pumpAndSettle();

    expect(find.text('Ponów'), findsOneWidget);

    await tester.tap(find.text('Ponów'));
    await tester.pumpAndSettle();

    // Ponowienie używa zachowanej intencji i klucza idempotencji.
    final keys = verify(
      () => repository.moveFilePlacement(
        placementId: any(named: 'placementId'),
        targetFolderId: any(named: 'targetFolderId'),
        expectedVersion: any(named: 'expectedVersion'),
        idempotencyKey: captureAny(named: 'idempotencyKey'),
      ),
    ).captured;
    expect(keys, hasLength(2));
    expect(keys[0], keys[1]);
  });
}
