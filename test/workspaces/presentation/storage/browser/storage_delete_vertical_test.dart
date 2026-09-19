import 'dart:typed_data';

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
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockStorageRepository extends Mock implements StorageRepository {}

final class _NoopDownloadTransport implements DownloadTransport {
  @override
  Future<Either<ApiError, Unit>> downloadUrl({
    required String downloadUrl,
    required String fileName,
    Map<String, String>? headers,
  }) async => right(unit);

  @override
  Future<Either<ApiError, Uint8List>> fetchBytes({
    required String downloadUrl,
    Map<String, String>? headers,
  }) async => right(Uint8List(0));

  @override
  Future<Either<ApiError, Unit>> saveBytes({
    required List<int> bytes,
    required String fileName,
  }) async => right(unit);
}

final class _DeletePageSupport {
  static const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
  static const folderId = 'folder-delete-1';
  static const fileId = 'file-delete-1';
  static final now = DateTime.utc(2026, 9, 18);

  static StorageFolderResponse folder() => StorageFolderResponse(
    id: folderId,
    name: 'Do usunięcia',
    folderType: StorageFolderType.workspace,
    workspaceId: workspaceId,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
    itemCount: 0,
    updatedAtUtc: now,
    accessLevel: StorageEffectiveAccessLevel.owner,
  );

  static StorageFileResponse file({bool deleted = false}) =>
      StorageFileResponse(
        id: fileId,
        module: StorageModule.workspaces,
        resourceType: StorageResourceType.document,
        originalFileName: 'Do usunięcia.pdf',
        extension: 'pdf',
        mimeType: 'application/pdf',
        fileSizeBytes: 1024,
        version: 1,
        ownerUserId: 'user-1',
        createdByUserId: 'user-1',
        createdAtUtc: now,
        updatedAtUtc: now,
        isDeleted: deleted,
        processingStatus: StorageProcessingStatus.ready,
        scanStatus: StorageScanStatus.clean,
        aiStatus: StorageAiStatus.none,
        canRead: true,
        canDelete: true,
        canRestore: deleted,
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
        CursorPageResponse(items: [file()]),
      ),
    );
  }

  static Future<void> pumpPage(
    WidgetTester tester,
    StorageRepository repository, {
    bool allowDeletion = true,
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
          allowDeletion: allowDeletion,
          downloadTransport: allowDeletion ? _NoopDownloadTransport() : null,
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

  testWidgets('folder delete wymaga potwierdzenia i odświeża dokładnie raz', (
    tester,
  ) async {
    final repository = _MockStorageRepository();
    var folderCalls = 0;
    _DeletePageSupport.stubListing(repository);
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async {
      folderCalls++;
      return right([_DeletePageSupport.folder()]);
    });
    when(
      () => repository.deleteFolder(_DeletePageSupport.folderId),
    ).thenAnswer((_) async => right(unit));

    await _DeletePageSupport.pumpPage(tester, repository);
    final initialFolderCalls = folderCalls;
    await tester.tap(
      find.byKey(const ValueKey('delete-folder-folder-delete-1')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Potwierdź usunięcie'), findsOneWidget);
    verifyNever(
      () => repository.deleteFolder(_DeletePageSupport.folderId),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Usuń').last);
    await tester.pumpAndSettle();

    verify(
      () => repository.deleteFolder(_DeletePageSupport.folderId),
    ).called(1);
    expect(folderCalls, initialFolderCalls + 1);
    expect(find.text('Element został przeniesiony do kosza.'), findsOneWidget);
  });

  testWidgets('anulowanie potwierdzenia nie wysyła żądania ani nie odświeża', (
    tester,
  ) async {
    final repository = _MockStorageRepository();
    var folderCalls = 0;
    _DeletePageSupport.stubListing(repository);
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async {
      folderCalls++;
      return right([_DeletePageSupport.folder()]);
    });

    await _DeletePageSupport.pumpPage(tester, repository);
    final initialFolderCalls = folderCalls;
    await tester.tap(
      find.byKey(const ValueKey('delete-folder-folder-delete-1')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Anuluj').last);
    await tester.pumpAndSettle();

    verifyNever(
      () => repository.deleteFolder(_DeletePageSupport.folderId),
    );
    expect(folderCalls, initialFolderCalls);
    expect(find.text('Potwierdź usunięcie'), findsNothing);
  });

  testWidgets('file delete używa ACL i odświeża dokładnie raz', (tester) async {
    final repository = _MockStorageRepository();
    var fileCalls = 0;
    _DeletePageSupport.stubListing(repository);
    when(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer((_) async {
      fileCalls++;
      return right(CursorPageResponse(items: [_DeletePageSupport.file()]));
    });
    when(
      () => repository.deleteFile(_DeletePageSupport.fileId),
    ).thenAnswer((_) async => right(unit));

    await _DeletePageSupport.pumpPage(tester, repository);
    final initialFileCalls = fileCalls;
    await tester.tap(
      find.byKey(const ValueKey('delete-file-file-delete-1')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Usuń').last);
    await tester.pumpAndSettle();

    verify(() => repository.deleteFile(_DeletePageSupport.fileId)).called(1);
    expect(fileCalls, initialFileCalls + 1);
    expect(find.text('Element został przeniesiony do kosza.'), findsOneWidget);
  });

  testWidgets('BFF/read-only composition nie pokazuje akcji delete', (
    tester,
  ) async {
    final repository = _MockStorageRepository();
    _DeletePageSupport.stubListing(repository);

    await _DeletePageSupport.pumpPage(
      tester,
      repository,
      allowDeletion: false,
    );

    expect(
      find.byKey(const ValueKey('delete-folder-folder-delete-1')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('delete-file-file-delete-1')),
      findsNothing,
    );
  });

  testWidgets('restore pliku wymaga potwierdzenia i odświeża dokładnie raz', (
    tester,
  ) async {
    final repository = _MockStorageRepository();
    var fileCalls = 0;
    _DeletePageSupport.stubListing(repository);
    when(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer((_) async {
      fileCalls++;
      return right(
        CursorPageResponse(items: [_DeletePageSupport.file(deleted: true)]),
      );
    });
    when(
      () => repository.restoreFile(_DeletePageSupport.fileId),
    ).thenAnswer((_) async => right(_DeletePageSupport.file()));

    await _DeletePageSupport.pumpPage(tester, repository);
    final initialFileCalls = fileCalls;
    await tester.tap(find.byKey(const ValueKey('restore-file-file-delete-1')));
    await tester.pumpAndSettle();

    expect(find.text('Przywrócić plik?'), findsOneWidget);
    verifyNever(() => repository.restoreFile(_DeletePageSupport.fileId));
    await tester.tap(find.widgetWithText(FilledButton, 'Przywróć').last);
    await tester.pumpAndSettle();

    verify(() => repository.restoreFile(_DeletePageSupport.fileId)).called(1);
    expect(fileCalls, initialFileCalls + 1);
    expect(find.text('Plik został przywrócony.'), findsOneWidget);
  });

  testWidgets('read-only composition nie pokazuje restore', (tester) async {
    final repository = _MockStorageRepository();
    _DeletePageSupport.stubListing(repository);
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
        CursorPageResponse(items: [_DeletePageSupport.file(deleted: true)]),
      ),
    );
    await _DeletePageSupport.pumpPage(tester, repository, allowDeletion: false);
    expect(
      find.byKey(const ValueKey('restore-file-file-delete-1')),
      findsNothing,
    );
  });

  for (final failureCase in const [
    (403, 'Brak uprawnień'),
    (404, 'Folder już nie istnieje.'),
    (409, 'Folder o tej nazwie już istnieje.'),
    (422, 'Wprowadź prawidłową nazwę folderu.'),
  ]) {
    testWidgets(
      'mapuje błąd delete folder ${failureCase.$1} bez fałszywego sukcesu',
      (tester) async {
        final repository = _MockStorageRepository();
        var folderCalls = 0;
        _DeletePageSupport.stubListing(repository);
        when(
          () => repository.listFolders(
            scope: any(named: 'scope'),
            parentFolderId: any(named: 'parentFolderId'),
          ),
        ).thenAnswer((_) async {
          folderCalls++;
          return right([_DeletePageSupport.folder()]);
        });
        when(
          () => repository.deleteFolder(_DeletePageSupport.folderId),
        ).thenAnswer(
          (_) async => left(
            ApiError(
              type: ApiErrorType.server,
              message: 'backend detail',
              statusCode: failureCase.$1,
            ),
          ),
        );

        await _DeletePageSupport.pumpPage(tester, repository);
        final initialFolderCalls = folderCalls;
        await tester.tap(
          find.byKey(const ValueKey('delete-folder-folder-delete-1')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Usuń').last);
        await tester.pumpAndSettle();

        expect(find.text(failureCase.$2), findsOneWidget);
        expect(
          find.text('Element został przeniesiony do kosza.'),
          findsNothing,
        );
        expect(folderCalls, initialFolderCalls);
      },
    );
  }
}
