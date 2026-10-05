import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_view_preference.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_active_filter_strip.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_file_artwork.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_grid_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/storage_shell_harness.dart';

class _Repository extends Mock implements StorageRepository {}

void _noop() {}

void main() {
  setUpAll(registerStorageFallbacks);

  for (final key in [LogicalKeyboardKey.enter, LogicalKeyboardKey.space]) {
    testWidgets('filter removal is enabled, named and works with $key', (
      tester,
    ) async {
      final repository = _Repository();
      when(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer((_) async => right([]));
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
      await pumpStorageShell(tester, repository: repository);
      final cubit = tester
          .element(find.byType(StorageActiveFilterStrip))
          .read<StorageBrowserCubit>();
      expect(find.text('Najnowsze'), findsOneWidget);
      cubit.setSort(const StorageSortCriteria(field: StorageSortField.size));
      await tester.pumpAndSettle();
      expect(find.text('Największe'), findsOneWidget);
      expect(find.text('Najnowsze'), findsNothing);
      await cubit.setFilter(
        const StorageBrowserFilter(
          extension: 'pdf',
          aiStatus: StorageAiStatus.completed,
        ),
      );
      await tester.pumpAndSettle();
      final remove = find.byKey(const ValueKey('storage-filter-remove-PDF'));
      expect(tester.widget<TextButton>(remove).onPressed, isNotNull);
      final semantics = tester.ensureSemantics();
      expect(find.bySemanticsLabel('Wyczyść: PDF'), findsOneWidget);
      // Actual Tab traversal, rather than invoking the callback directly.
      var reached = false;
      for (var index = 0; index < 45; index++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        final focusContext = FocusManager.instance.primaryFocus?.context;
        final button = focusContext
            ?.findAncestorWidgetOfExactType<TextButton>();
        if (button?.key == const ValueKey('storage-filter-remove-PDF')) {
          reached = true;
          break;
        }
      }
      expect(reached, isTrue);
      await tester.sendKeyEvent(key);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(cubit.currentFilter.extension, isNull);
      expect(cubit.currentFilter.aiStatus, StorageAiStatus.completed);
      expect(remove, findsNothing);
      // Active→active changes must refresh the remaining label as well.
      await cubit.setFilter(const StorageBrowserFilter(extension: 'docx'));
      await tester.pumpAndSettle();
      expect(find.text('DOCX'), findsOneWidget);
      expect(find.text('Gotowe'), findsNothing);
      semantics.dispose();
    });
  }

  testWidgets(
    'actual grid at 200 percent keeps long names and details action',
    (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final repository = _Repository();
      final file = storageTestFile(
        name: 'Bardzo długi końcowy dokument klienta.pdf',
      ).copyWith(isDeleted: true, canPreview: false);
      when(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer(
        (_) async => right([
          storageTestFolder(
            name: 'Bardzo długi folder końcowych dokumentów klienta',
          ),
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
      ).thenAnswer((_) async => right(CursorPageResponse(items: [file])));
      final opened = <String>[];
      await pumpStorageShell(
        tester,
        repository: repository,
        onOpenFileDetails: opened.add,
      );
      final cubit = tester
          .element(find.byType(StorageActiveFilterStrip))
          .read<StorageBrowserCubit>();
      // List and grid expose the action that will actually run.
      expect(
        tester
            .widget<StorageFileArtwork>(find.byType(StorageFileArtwork))
            .actionLabel,
        'Szczegóły pliku',
      );
      cubit.setViewMode(StorageViewMode.grid);
      await tester.pumpAndSettle();
      expect(find.byType(StorageGridName), findsNWidgets(2));
      expect(tester.takeException(), isNull);
      final artwork = find.byType(StorageFileArtwork);
      expect(
        tester.widget<StorageFileArtwork>(artwork).actionLabel,
        'Szczegóły pliku',
      );
      await tester.tap(artwork);
      await tester.pumpAndSettle();
      expect(opened, [file.id]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'long grid name stays two-line and full name is available on focus',
    (
      tester,
    ) async {
      const name = 'Dokument końcowy klienta z pełną bardzo długą nazwą.docx';
      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().dark(),
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 184,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StorageGridName(name: name),
                    TextButton(onPressed: _noop, child: Text('Next')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      final label = tester.widget<Text>(find.text(name));
      expect(label.maxLines, 2);
      expect(label.semanticsLabel, name);
      expect(find.byTooltip(name), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text(name), findsNWidgets(2));
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(find.text(name), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
