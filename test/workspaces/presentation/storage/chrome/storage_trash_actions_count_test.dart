import 'package:dartz/dartz.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/grid/storage_file_grid.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_browser_body.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/storage_shell_harness.dart';

class _Repository extends Mock implements StorageRepository {}

void main() {
  late _Repository repository;
  late List<StorageFileResponse> files;
  late List<StorageFolderResponse> folders;
  setUpAll(registerStorageFallbacks);
  setUp(() {
    repository = _Repository();
    files = [storageTestFile(), storageTestFile(id: 'file-2')];
    folders = [storageTestFolder()];
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right(folders));
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
      (_) async => right(CursorPageResponse<StorageFileResponse>(items: files)),
    );
  });

  Finder count(String value) => find.descendant(
    of: find.byKey(const ValueKey('storage-item-count')),
    matching: find.text(value),
  );

  testWidgets(
    'delete and folder creation refresh complete total without loading transition',
    (tester) async {
      when(() => repository.deleteFile(any())).thenAnswer((_) async {
        files = files.sublist(1);
        return right(unit);
      });
      await pumpStorageShell(tester, repository: repository);
      expect(count('3'), findsOneWidget);
      final context = tester.element(find.byType(StorageBrowserBody));
      await context.read<StorageFileMutationCubit>().deleteFile('file-1');
      await tester.pumpAndSettle();
      expect(count('2'), findsOneWidget);
      folders = [...folders, storageTestFolder(id: 'child')];
      await context.read<StorageBrowserCubit>().load(showLoading: false);
      await tester.pumpAndSettle();
      expect(count('3'), findsOneWidget);
    },
  );

  for (final grid in [false, true]) {
    testWidgets(
      'trash ${grid ? 'grid' : 'list'} hides live actions, restore ACL and total update',
      (tester) async {
        files = [
          storageTestFile().copyWith(isDeleted: true, canRestore: true),
          storageTestFile(id: 'file-2')
              .copyWith(isDeleted: true, canRestore: false),
        ];
        when(() => repository.restoreFile(any())).thenAnswer((_) async {
          final restored = files.first.copyWith(isDeleted: false);
          files = files.sublist(1);
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
        final l10n = AppLocalizations.of(context)!;
        expect(find.byTooltip(l10n.storageUploadFiles), findsNothing);
        expect(find.byKey(const ValueKey('share-file-file-1')), findsNothing);
        expect(
          find.byKey(const ValueKey('download-file-file-1')),
          findsNothing,
        );
        expect(find.byTooltip(l10n.storageAddFavoriteAction), findsNothing);
        expect(find.byKey(const ValueKey('restore-file-file-2')), findsNothing);
        expect(count('2'), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey('restore-file-file-1')));
        await tester.pumpAndSettle();
        expect(count('1'), findsOneWidget);
        verify(() => repository.restoreFile('file-1')).called(1);
      },
    );
  }

  for (final scope in [
    const StorageScope.favorites(),
    const StorageScope.recent(),
  ]) {
    testWidgets(
      'system scope $scope cannot create content in an ambiguous destination',
      (tester) async {
        await pumpStorageShell(tester, repository: repository, scope: scope);
        final context = tester.element(find.byType(StorageBrowserBody));
        expect(
          find.byTooltip(AppLocalizations.of(context)!.storageUploadFiles),
          findsNothing,
        );
        verifyNever(
          () => repository.listFolders(
            scope: any(named: 'scope'),
            parentFolderId: any(named: 'parentFolderId'),
          ),
        );
      },
    );
  }

  testWidgets('ordinary personal root still offers upload', (tester) async {
    await pumpStorageShell(tester, repository: repository);
    final context = tester.element(find.byType(StorageBrowserBody));
    expect(
      find.byTooltip(AppLocalizations.of(context)!.storageUploadFiles),
      findsOneWidget,
    );
  });

  for (final grid in [false, true]) {
    testWidgets(
      'explicit ${grid ? 'grid' : 'list'} checkboxes select files and folders independently',
      (tester) async {
        await pumpStorageShell(tester, repository: repository);
        final context = tester.element(find.byType(StorageBrowserBody));
        if (grid) {
          context.read<StorageBrowserCubit>().setViewMode(StorageViewMode.grid);
          await tester.pumpAndSettle();
        }
        final checkbox = find.byKey(const ValueKey('select-file-file-1'));
        final fileControl = find.descendant(
          of: checkbox,
          matching: find.byType(Checkbox),
        );
        expect(
          tester.widget<Checkbox>(fileControl).semanticLabel,
          'Zaznacz dokument.pdf',
        );
        Focus.of(
          tester.element(
            find
                .descendant(of: fileControl, matching: find.byType(CustomPaint))
                .last,
          ),
        ).requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expect(
          context.read<StorageSelectionCubit>().state.isFileSelected('file-1'),
          isTrue,
        );
        await tester.tap(find.byKey(const ValueKey('select-folder-folder-1')));
        await tester.pumpAndSettle();
        expect(
          context.read<StorageSelectionCubit>().state.isFolderSelected(
            'folder-1',
          ),
          isTrue,
        );
        await tester.tap(checkbox);
        await tester.pumpAndSettle();
        expect(
          context.read<StorageSelectionCubit>().state.isFileSelected('file-1'),
          isFalse,
        );
      },
    );
  }

  testWidgets(
    '120px checkbox center selects instead of opening underlying artwork',
    (tester) async {
      final selection = StorageSelectionCubit();
      addTearDown(selection.close);
      final opened = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 120,
                child: BlocProvider.value(
                  value: selection,
                  child: StorageFileGrid(
                    files: [storageTestFile().copyWith(canPreview: false)],
                    onOpenFileDetails: opened.add,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tapAt(
        tester.getCenter(find.byKey(const ValueKey('select-file-file-1'))),
        kind: PointerDeviceKind.mouse,
      );
      await tester.pumpAndSettle();
      expect(selection.state.isFileSelected('file-1'), isTrue);
      expect(opened, isEmpty);
      selection.clearSelection();
      await tester.pumpAndSettle();
      await tester.tap(find.text('dokument.pdf'));
      await tester.pumpAndSettle();
      expect(opened, ['file-1']);
      expect(tester.takeException(), isNull);
    },
  );

  for (final grid in [false, true]) {
    for (final hasDetails in [false, true]) {
      testWidgets(
        '${grid ? 'grid' : 'list'} no preview opens ${hasDetails ? 'details' : 'unavailable surface'}',
        (tester) async {
          files = [storageTestFile().copyWith(canPreview: false)];
          when(() => repository.getDownloadTicket('file-1')).thenAnswer(
            (_) async => right(
              StorageDownloadTicketResponse(
                fileId: 'file-1',
                originalFileName: 'dokument.pdf',
                mimeType: 'application/pdf',
                fileSizeBytes: 1024,
                downloadUrl: 'https://storage.invalid/file',
                expiresAtUtc: DateTime.utc(2026, 10, 5),
              ),
            ),
          );
          final opened = <String>[];
          await pumpStorageShell(
            tester,
            repository: repository,
            onOpenFileDetails: hasDetails ? opened.add : null,
          );
          final context = tester.element(find.byType(StorageBrowserBody));
          if (grid) {
            context.read<StorageBrowserCubit>().setViewMode(
              StorageViewMode.grid,
            );
            await tester.pumpAndSettle();
          }
          await tester.tap(find.text('dokument.pdf'));
          await tester.pumpAndSettle();
          if (hasDetails) {
            expect(opened, ['file-1']);
            expect(find.byType(StoragePreviewDialog), findsNothing);
          } else {
            expect(find.byType(StoragePreviewDialog), findsOneWidget);
            expect(
              find.text(
                AppLocalizations.of(context)!.storageUnsupportedDescription,
              ),
              findsOneWidget,
            );
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  test('deleted selection cannot offer active mutations even with broad stale permissions', () async {
    final selection = StorageSelectionCubit();
    addTearDown(selection.close);
    selection.toggleFile(
      storageTestFile().copyWith(isDeleted: true, canRestore: true),
    );
    expect(selection.state.canDelete, isFalse);
    expect(selection.state.canShare, isFalse);
    expect(selection.state.canFavorite, isFalse);
    expect(selection.state.canMove, isFalse);
    expect(selection.state.canDownloadZip, isFalse);
  });
}
