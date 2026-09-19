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

final class _MockStorageRepository extends Mock implements StorageRepository {}

final class _FolderPageTestSupport {
  static const workspaceId = '550e8400-e29b-41d4-a716-446655440000';

  static void stubListing(_MockStorageRepository repository) {
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
  }

  static StorageFolderResponse createdFolder() => StorageFolderResponse(
    id: 'folder-new',
    name: 'Dokumenty',
    folderType: StorageFolderType.workspace,
    workspaceId: workspaceId,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
    itemCount: 0,
    updatedAtUtc: DateTime.utc(2026, 9, 18),
    accessLevel: StorageEffectiveAccessLevel.owner,
  );

  static Future<void> pumpPage(
    WidgetTester tester,
    StorageRepository repository,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: StorageReadOnlyBrowserPage(
          repository: repository,
          initialScope: const StorageScope.workspace(workspaceId),
          allowFolderCreation: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
  });

  testWidgets('tworzy folder i odświeża listę dopiero po sukcesie', (
    tester,
  ) async {
    final repository = _MockStorageRepository();
    var folderCalls = 0;
    _FolderPageTestSupport.stubListing(repository);
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async {
      folderCalls++;
      return right(const <StorageFolderResponse>[]);
    });
    when(
      () => repository.createFolder(
        scope: const StorageScope.workspace(_FolderPageTestSupport.workspaceId),
        name: 'Dokumenty',
      ),
    ).thenAnswer((_) async => right(_FolderPageTestSupport.createdFolder()));

    await _FolderPageTestSupport.pumpPage(tester, repository);
    final initialFolderCalls = folderCalls;

    await tester.tap(find.widgetWithText(FilledButton, 'Utwórz').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Dokumenty');
    await tester.tap(find.widgetWithText(FilledButton, 'Utwórz').last);
    await tester.pumpAndSettle();

    verify(
      () => repository.createFolder(
        scope: const StorageScope.workspace(_FolderPageTestSupport.workspaceId),
        name: 'Dokumenty',
      ),
    ).called(1);
    expect(folderCalls, initialFolderCalls + 1);
    expect(find.text('Folder został utworzony.'), findsOneWidget);
  });

  for (final failureCase in const [
    (403, 'Brak uprawnień'),
    (409, 'Folder o tej nazwie już istnieje.'),
    (422, 'Wprowadź prawidłową nazwę folderu.'),
  ]) {
    testWidgets(
      'mapuje błąd tworzenia folderu ${failureCase.$1} bez sukcesu',
      (tester) async {
        final repository = _MockStorageRepository();
        _FolderPageTestSupport.stubListing(repository);
        when(
          () => repository.createFolder(
            scope: const StorageScope.workspace(
              _FolderPageTestSupport.workspaceId,
            ),
            name: 'Dokumenty',
          ),
        ).thenAnswer(
          (_) async => Left(
            ApiError(
              type: ApiErrorType.server,
              message: 'backend detail',
              statusCode: failureCase.$1,
            ),
          ),
        );

        await _FolderPageTestSupport.pumpPage(tester, repository);
        await tester.tap(find.widgetWithText(FilledButton, 'Utwórz').first);
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Dokumenty');
        await tester.tap(find.widgetWithText(FilledButton, 'Utwórz').last);
        await tester.pumpAndSettle();

        expect(find.text(failureCase.$2), findsOneWidget);
      },
    );
  }
}
