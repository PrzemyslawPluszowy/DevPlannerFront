import 'dart:async';

import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_file_mutation_listener.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/storage_shell_harness.dart';

final class _Repository extends Mock implements StorageRepository {}

final class _Downloads extends Fake implements DownloadTransport {}

void main() {
  setUpAll(registerStorageFallbacks);
  for (final failed in [false, true]) {
    testWidgets('stary wynik $failed nie zmienia nowego zakresu Files', (
      tester,
    ) async {
      final repository = _Repository();
      final result = Completer<Either<ApiError, Unit>>();
      when(() => repository.deleteFile('file-1')).thenAnswer(
        (_) => result.future,
      );
      var refreshes = 0;
      when(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer((_) async {
        refreshes++;
        return right([]);
      });
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
      final mutation = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: _Downloads(),
      );
      final firstBrowser = StorageBrowserCubit(repository: repository);
      final nextBrowser = StorageBrowserCubit(
        repository: repository,
        initialScope: const StorageScope.workspace('next-workspace'),
      );
      final firstSelection = StorageSelectionCubit()
        ..selectAll(files: [storageTestFile()], folders: const []);
      final nextSelection = StorageSelectionCubit()
        ..selectAll(
          files: [storageTestFile(id: 'file-2', name: 'nowy-plik.pdf')],
          folders: const [],
        );
      addTearDown(mutation.close);
      addTearDown(firstBrowser.close);
      addTearDown(nextBrowser.close);
      addTearDown(firstSelection.close);
      addTearDown(nextSelection.close);
      final errors = <StorageMutationError>[];
      final owners = ValueNotifier(false);
      addTearDown(owners.dispose);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ValueListenableBuilder(
            valueListenable: owners,
            builder: (context, replaced, _) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: mutation),
                BlocProvider.value(
                  value: replaced ? nextBrowser : firstBrowser,
                ),
                BlocProvider.value(
                  value: replaced ? nextSelection : firstSelection,
                ),
              ],
              child: StorageFileMutationListener(
                onError: errors.add,
                child: const Scaffold(body: Text('Files')),
              ),
            ),
          ),
        ),
      );
      final operation = mutation.deleteFile('file-1');
      await tester.pump();
      owners.value = true;
      await tester.pump();
      result.complete(
        failed
            ? left(
                const ApiError(
                  type: ApiErrorType.badResponse,
                  message: 'Błąd starego pliku.',
                  apiCode: 'storage.stale_failure',
                  statusCode: 409,
                ),
              )
            : right(unit),
      );
      await operation;
      await tester.pumpAndSettle();
      expect(errors, isEmpty);
      expect(refreshes, 0);
      expect(nextSelection.state.selectedFileIds, {'file-2'});
      expect(tester.takeException(), isNull);
    });
  }
  for (final change in ['scope', 'operation', 'current']) {
    testWidgets('retry powiązania respektuje $change', (tester) async {
      final repository = _Repository();
      const conflict = ApiError(
        type: ApiErrorType.badResponse,
        message: 'Konflikt powiązania.',
        apiCode: 'storage.placement_conflict',
        statusCode: 409,
      );
      var placementCalls = 0;
      when(
        () => repository.createFilePlacement(
          fileId: 'file-1',
          folderId: 'target-folder',
        ),
      ).thenAnswer((_) async {
        placementCalls++;
        return left(conflict);
      });
      when(() => repository.deleteFile('file-1')).thenAnswer(
        (_) async => left(
          const ApiError(
            type: ApiErrorType.badResponse,
            message: 'Inna operacja.',
            apiCode: 'storage.delete_failed',
            statusCode: 409,
          ),
        ),
      );
      final mutation = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: _Downloads(),
      );
      final selection = StorageSelectionCubit()
        ..selectAll(files: [storageTestFile()], folders: const []);
      final firstBrowser = StorageBrowserCubit(repository: repository);
      final nextBrowser = StorageBrowserCubit(
        repository: repository,
        initialScope: const StorageScope.workspace('next-workspace'),
      );
      addTearDown(mutation.close);
      addTearDown(selection.close);
      addTearDown(firstBrowser.close);
      addTearDown(nextBrowser.close);
      final owners = ValueNotifier(false);
      addTearDown(owners.dispose);
      final errors = <StorageMutationError>[];
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ValueListenableBuilder(
            valueListenable: owners,
            builder: (context, replaced, _) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: mutation),
                BlocProvider.value(value: selection),
                BlocProvider.value(
                  value: replaced ? nextBrowser : firstBrowser,
                ),
              ],
              child: StorageFileMutationListener(
                onError: errors.add,
                child: const Scaffold(body: Text('Files')),
              ),
            ),
          ),
        ),
      );
      await mutation.moveFileToFolder(
        fileId: 'file-1',
        targetFolderId: 'target-folder',
      );
      await tester.pumpAndSettle();
      final retry = errors.single.onRetry;
      expect(retry, isNotNull);
      if (change == 'scope') {
        owners.value = true;
      } else if (change == 'operation') {
        await mutation.deleteFile('file-1');
      }
      await tester.pumpAndSettle();
      retry!();
      await tester.pumpAndSettle();
      expect(placementCalls, change == 'current' ? 2 : 1);
      expect(tester.takeException(), isNull);
    });
  }
}
