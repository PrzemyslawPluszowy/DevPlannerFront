import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_bulk_restore_commands.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_browser_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_support/storage_shell_harness.dart';

class _Repository extends Mock implements StorageRepository {}

void main() {
  setUpAll(registerStorageFallbacks);

  for (final grid in [false, true]) {
    testWidgets(
      'trash folder ${grid ? "grid" : "list"} retains rename and root fields after conflict and updates total on restore',
      (tester) async {
        final repository = _Repository();
        var folders = [
          storageTestFolder(name: 'Archived').copyWith(
            isDeleted: true,
            canRestore: true,
            canRead: false,
            canEdit: false,
            canDelete: false,
            canShare: false,
          ),
        ];
        when(repository.listTrashFolders)
            .thenAnswer((_) async => right(folders));
        when(
          () => repository.listFiles(
            scope: any(named: 'scope'),
            folderId: any(named: 'folderId'),
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
            query: any(named: 'query'),
            filter: any(named: 'filter'),
          ),
        ).thenAnswer((_) async => right(const CursorPageResponse(items: [])));
        var attempts = 0;
        final calls = <(String?, bool)>[];
        when(
          () => repository.restoreFolder(
            folderId: 'folder-1',
            name: any(named: 'name'),
            parentFolderId: any(named: 'parentFolderId'),
            restoreToRoot: any(named: 'restoreToRoot'),
          ),
        ).thenAnswer((invocation) async {
          calls.add((
            invocation.namedArguments[#name] as String?,
            invocation.namedArguments[#restoreToRoot]! as bool,
          ));
          if (attempts++ == 0) {
            return left(
              const ApiError(
                type: ApiErrorType.conflict,
                message: 'backend',
                apiCode: 'storage.folder_name_conflict',
                statusCode: 409,
              ),
            );
          }
          final restored = folders.single.copyWith(
            isDeleted: false,
            canRestore: false,
          );
          folders = [];
          return right(restored);
        });
        await pumpStorageShell(
          tester,
          repository: repository,
          scope: const StorageScope.trash(),
        );
        final context = tester.element(find.byType(StorageBrowserBody));
        if (grid) {
          context.read<StorageBrowserCubit>().setViewMode(StorageViewMode.grid);
          await tester.pumpAndSettle();
        }
        await tester.tap(find.byKey(const ValueKey('folder-open-folder-1')));
        await tester.pumpAndSettle();
        expect(
          context.read<StorageBrowserCubit>().currentScope,
          const StorageScope.trash(),
        );
        await tester.tap(find.byKey(const ValueKey('folder-restore-folder-1')));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Renamed');
        await tester.tap(find.byType(CheckboxListTile));
        await tester.tap(
          find.byKey(const ValueKey('storage_folder_restore_save')),
        );
        await tester.pumpAndSettle();
        expect(find.text('Renamed'), findsOneWidget);
        expect(
          tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
          isTrue,
        );
        expect(
          find.text(
            'Folder o tej nazwie już istnieje. Wprowadź inną nazwę lub wybierz katalog główny.',
          ),
          findsOneWidget,
        );
        await tester.tap(
          find.byKey(const ValueKey('storage_folder_restore_save')),
        );
        await tester.pumpAndSettle();
        expect(calls, [('Renamed', true), ('Renamed', true)]);
        expect(
          find.byKey(const ValueKey('folder-restore-folder-1')),
          findsNothing,
        );
        expect(
          context.read<StorageBrowserCubit>().state,
          isA<StorageBrowserEmpty>(),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  test('trash folders stay visible with files and search; cannot enter deleted folder', () async {
    final repository = _Repository();
    final folder = storageTestFolder(name: 'Archived folder')
        .copyWith(isDeleted: true, canRestore: true, canRead: false);
    when(repository.listTrashFolders).thenAnswer((_) async => right([folder]));
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
        CursorPageResponse(
          items: [storageTestFile().copyWith(isDeleted: true)],
        ),
      ),
    );
    final browser = StorageBrowserCubit(
      repository: repository,
      initialScope: const StorageScope.trash(),
    );
    addTearDown(browser.close);
    await browser.load();
    expect((browser.state as StorageBrowserReady).folders, [folder]);
    await browser.openFolder(folder);
    expect(browser.currentScope, const StorageScope.trash());
    await browser.search('Archived');
    expect((browser.state as StorageBrowserReady).folders, [folder]);
    verifyNever(() => repository.getFolder(any()));
  });

  test(
    'mixed trash selection only offers restore with complete current ACL',
    () async {
      final selection = StorageSelectionCubit();
      addTearDown(selection.close);
      final folder = storageTestFolder().copyWith(
        isDeleted: true,
        canRestore: true,
        canDelete: false,
        canShare: false,
      );
      final file = storageTestFile().copyWith(
        isDeleted: true,
        canRestore: true,
        canDelete: false,
      );
      selection.selectAll(files: [file], folders: [folder]);
      expect(selection.state.canRestore, isTrue);
      expect(
        selection.state.canDelete ||
            selection.state.canMove ||
            selection.state.canDownloadZip ||
            selection.state.canShare ||
            selection.state.canFavorite,
        isFalse,
      );
      selection.retain(
        allFiles: [file],
        allFolders: [folder.copyWith(canRestore: false)],
      );
      expect(selection.state.canRestore, isFalse);
    },
  );

  test('mixed restore keeps per-item conflicts and does not label skipped items failed', () async {
    final repository = _Repository();
    const conflict = ApiError(
      type: ApiErrorType.conflict,
      message: 'conflict',
      statusCode: 409,
      apiCode: 'storage.folder_name_conflict',
    );
    when(() => repository.restoreFolder(folderId: 'bad'))
        .thenAnswer((_) async => left(conflict));
    when(() => repository.restoreFolder(folderId: 'good'))
        .thenAnswer((_) async => right(storageTestFolder()));
    when(() => repository.restoreFile('file'))
        .thenAnswer((_) async => right(storageTestFile()));
    final result = await StorageBulkRestoreCommands(repository).execute(
      fileIds: ['file'],
      folderIds: ['bad', 'good'],
      isCurrent: () => true,
    );
    final partial = result! as StorageFileMutationPartialSuccess;
    expect(partial.succeededIds, ['good', 'file']);
    expect(partial.failedIds, ['bad']);
    expect(partial.apiErrorsById['bad'], conflict);
    expect(partial.notAttemptedIds, isEmpty);
    expect(partial.messageCode, StorageFileMutationMessage.partialRestore);
  });

  test('restore stops after throttling and after owner invalidation', () async {
    final repository = _Repository();
    const error = ApiError(
      type: ApiErrorType.server,
      message: '',
      statusCode: 429,
    );
    when(() => repository.restoreFolder(folderId: 'first'))
        .thenAnswer((_) async => left(error));
    final result = await StorageBulkRestoreCommands(
      repository,
    ).execute(fileIds: ['file'], folderIds: ['first'], isCurrent: () => true);
    expect((result! as StorageFileMutationFailure).notAttemptedIds, ['file']);
    verifyNever(() => repository.restoreFile(any()));
    var current = true;
    when(() => repository.restoreFolder(folderId: 'first'))
        .thenAnswer((_) async {
          current = false;
          return right(storageTestFolder());
        });
    expect(
      await StorageBulkRestoreCommands(repository).execute(
        fileIds: ['file'],
        folderIds: ['first'],
        isCurrent: () => current,
      ),
      isNull,
    );
    verifyNever(() => repository.restoreFile(any()));
  });

  test(
    'single restore preserves error metadata and cannot emit after close',
    () async {
      final repository = _Repository();
      const conflict = ApiError(
        type: ApiErrorType.conflict,
        message: 'conflict',
        statusCode: 409,
        traceId: 'trace',
        apiCode: 'storage.folder_parent_deleted',
      );
      when(
        () => repository.restoreFolder(
          folderId: 'folder',
          name: 'Name',
          restoreToRoot: true,
        ),
      ).thenAnswer((_) async => left(conflict));
      final cubit = StorageFolderMutationCubit(repository: repository);
      await cubit.restoreFolder(
        folderId: 'folder',
        name: ' Name ',
        restoreToRoot: true,
      );
      expect((cubit.state as StorageFolderMutationFailure).error, conflict);
      final pending = Completer<Either<ApiError, StorageFolderResponse>>();
      when(() => repository.restoreFolder(folderId: 'folder'))
          .thenAnswer((_) => pending.future);
      final operation = cubit.restoreFolder(folderId: 'folder');
      await cubit.close();
      pending.complete(right(storageTestFolder()));
      await operation;
      expect(cubit.state, isA<StorageFolderMutationLoading>());
    },
  );
}
