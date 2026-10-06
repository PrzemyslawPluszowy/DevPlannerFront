import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_browser_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/storage_shell_harness.dart';

class _Repository extends Mock implements StorageRepository {}

void main() {
  setUpAll(registerStorageFallbacks);
  late _Repository repository;
  late StorageFolderResponse folder;
  late List<StorageFileResponse> files;
  setUp(() {
    repository = _Repository();
    folder = storageTestFolder().copyWith(
      isDeleted: true,
      canRestore: true,
      canRead: false,
      canDelete: false,
    );
    files = [
      storageTestFile().copyWith(
        isDeleted: true,
        canRestore: true,
        canDelete: false,
      ),
    ];
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
    ).thenAnswer((_) async => right(CursorPageResponse(items: files)));
  });

  testWidgets(
    'mixed restore retains conflicted folder selection and updates total',
    (tester) async {
      when(() => repository.restoreFolder(folderId: folder.id)).thenAnswer(
        (_) async => left(
          const ApiError(
            type: ApiErrorType.conflict,
            message: 'Name conflict',
            apiCode: 'storage.folder_name_conflict',
            statusCode: 409,
          ),
        ),
      );
      when(() => repository.restoreFile('file-1')).thenAnswer((_) async {
        final restored = files.single.copyWith(isDeleted: false);
        files = [];
        return right(restored);
      });
      await pumpStorageShell(
        tester,
        repository: repository,
        scope: const StorageScope.trash(),
      );
      final context = tester.element(find.byType(StorageBrowserBody));
      final selection = context.read<StorageSelectionCubit>();
      selection.selectAll(files: files, folders: [folder]);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('storage_bulk_restore')));
      await tester.pumpAndSettle();
      expect(selection.state.selectedFolderIds, {folder.id});
      expect(selection.state.selectedFileIds, isEmpty);
      final ready =
          context.read<StorageBrowserCubit>().state as StorageBrowserReady;
      expect(ready.files, isEmpty);
      expect(ready.folders.length, 1);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('storage-item-count')),
          matching: find.text('1'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'late restore does not refresh or clear selection in newer scope',
    (tester) async {
      files = [];
      var personalReads = 0;
      when(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer((_) async {
        personalReads++;
        return right([storageTestFolder()]);
      });
      final pending = Completer<Either<ApiError, StorageFolderResponse>>();
      when(() => repository.restoreFolder(folderId: folder.id))
          .thenAnswer((_) => pending.future);
      await pumpStorageShell(
        tester,
        repository: repository,
        scope: const StorageScope.trash(),
      );
      final context = tester.element(find.byType(StorageBrowserBody));
      final operation = context
          .read<StorageFolderMutationCubit>()
          .restoreFolder(folderId: folder.id);
      await tester.pump();
      final browser = context.read<StorageBrowserCubit>();
      await browser.setScope(const StorageScope.personal());
      await tester.pumpAndSettle();
      final selection = context.read<StorageSelectionCubit>();
      selection.toggleFolder(storageTestFolder());
      pending.complete(right(storageTestFolder()));
      await operation;
      await tester.pumpAndSettle();
      expect(personalReads, 1);
      expect(selection.state.selectedFolderIds, {folder.id});
    },
  );
}
