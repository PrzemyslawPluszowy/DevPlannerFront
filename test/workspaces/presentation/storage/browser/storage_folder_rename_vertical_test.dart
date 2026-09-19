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

final class _RenamePageSupport {
  static const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
  static const folderId = 'folder-1';

  static StorageFolderResponse folder({String name = 'Stare'}) =>
      StorageFolderResponse(
        id: folderId,
        name: name,
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

  static void stubListing(_MockStorageRepository repository) {
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right([folder()]));
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

  static Future<void> pumpPage(
    WidgetTester tester,
    StorageRepository repository, {
    bool allowFolderRename = true,
  }) async {
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
          allowFolderRename: allowFolderRename,
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

  testWidgets('zmienia nazwę folderu i odświeża listę dokładnie raz', (
    tester,
  ) async {
    final repository = _MockStorageRepository();
    var folderCalls = 0;
    _RenamePageSupport.stubListing(repository);
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async {
      folderCalls++;
      return right([_RenamePageSupport.folder()]);
    });
    when(
      () => repository.updateFolder(
        folderId: _RenamePageSupport.folderId,
        name: 'Nowa nazwa',
      ),
    ).thenAnswer(
      (_) async => right(_RenamePageSupport.folder(name: 'Nowa nazwa')),
    );

    await _RenamePageSupport.pumpPage(tester, repository);
    final initialFolderCalls = folderCalls;
    await tester.tap(find.byTooltip('Zmień nazwę folderu'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Nowa nazwa');
    await tester.tap(find.widgetWithText(FilledButton, 'Zmień nazwę'));
    await tester.pumpAndSettle();

    verify(
      () => repository.updateFolder(
        folderId: _RenamePageSupport.folderId,
        name: 'Nowa nazwa',
      ),
    ).called(1);
    expect(folderCalls, initialFolderCalls + 1);
    expect(find.text('Nazwa folderu została zmieniona.'), findsOneWidget);
  });

  testWidgets('read-only composition nie pokazuje zmiany nazwy', (
    tester,
  ) async {
    final repository = _MockStorageRepository();
    _RenamePageSupport.stubListing(repository);

    await _RenamePageSupport.pumpPage(
      tester,
      repository,
      allowFolderRename: false,
    );

    expect(find.byTooltip('Zmień nazwę folderu'), findsNothing);
  });

  for (final failureCase in const [
    (403, 'Brak uprawnień'),
    (404, 'Folder już nie istnieje.'),
    (409, 'Folder o tej nazwie już istnieje.'),
    (422, 'Wprowadź prawidłową nazwę folderu.'),
  ]) {
    testWidgets(
      'mapuje błąd zmiany nazwy folderu ${failureCase.$1}',
      (tester) async {
        final repository = _MockStorageRepository();
        _RenamePageSupport.stubListing(repository);
        when(
          () => repository.updateFolder(
            folderId: _RenamePageSupport.folderId,
            name: 'Nowa nazwa',
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

        await _RenamePageSupport.pumpPage(tester, repository);
        await tester.tap(find.byTooltip('Zmień nazwę folderu'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Nowa nazwa');
        await tester.tap(find.widgetWithText(FilledButton, 'Zmień nazwę'));
        await tester.pumpAndSettle();

        expect(find.text(failureCase.$2), findsOneWidget);
      },
    );
  }
}
