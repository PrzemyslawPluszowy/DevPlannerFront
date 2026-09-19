import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
  });

  final now = DateTime.utc(2026, 9, 17);
  final folder = StorageFolderResponse(
    id: 'folder-1',
    name: 'Dokumenty',
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
    canRead: true,
    canPreview: true,
  );

  Widget harness(_MockStorageRepository repository) {
    return MaterialApp(
      locale: const Locale('pl'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(useMaterial3: true),
      home: StorageReadOnlyBrowserPage(repository: repository),
    );
  }

  void stubListing(_MockStorageRepository repository) {
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right([folder]));
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
      (_) async => right(CursorPageResponse(items: [file])),
    );
  }

  testWidgets('renderuje foldery i pliki z lokalnego repozytorium', (
    tester,
  ) async {
    final repository = _MockStorageRepository();
    stubListing(repository);

    await tester.pumpWidget(harness(repository));
    await tester.pumpAndSettle();

    expect(find.text('Dokumenty'), findsOneWidget);
    expect(find.text('raport.pdf'), findsOneWidget);
    expect(find.text('Moje pliki'), findsOneWidget);
  });

  testWidgets('pokazuje typed 403 i nie udaje pustej listy', (tester) async {
    final repository = _MockStorageRepository();
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer(
      (_) async => left(
        const ApiError(
          type: ApiErrorType.forbidden,
          statusCode: 403,
          message: 'Brak dostępu.',
        ),
      ),
    );

    await tester.pumpWidget(harness(repository));
    await tester.pumpAndSettle();

    expect(find.text('Brak uprawnień'), findsOneWidget);
    expect(find.text('Brak folderów i plików'), findsNothing);
    verifyNever(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    );
  });

  testWidgets('preview zachowuje błąd repozytorium', (tester) async {
    final repository = _MockStorageRepository();
    stubListing(repository);
    when(() => repository.getDownloadTicket(file.id)).thenAnswer(
      (_) async => left(
        const ApiError(
          type: ApiErrorType.forbidden,
          statusCode: 403,
          message: 'Plik nie jest dostępny.',
        ),
      ),
    );

    await tester.pumpWidget(harness(repository));
    await tester.pumpAndSettle();
    await tester.tap(find.text('raport.pdf'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Plik nie jest dostępny.'), findsOneWidget);
  });
}
