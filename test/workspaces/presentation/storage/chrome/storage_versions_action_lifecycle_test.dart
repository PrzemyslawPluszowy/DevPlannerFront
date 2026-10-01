import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_versions_action.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_versions_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements StorageRepository {}

final class _Download extends Mock implements DownloadTransport {}

typedef _Sources = ({
  StorageBrowserCubit browser,
  StorageRepository repository,
  DownloadTransport transport,
});

final class _App extends StatelessWidget {
  const _App({required this.sources, required this.file});
  final ValueNotifier<_Sources> sources;
  final StorageFileResponse file;
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: MaterialTheme.crm().light(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: ValueListenableBuilder<_Sources>(
      valueListenable: sources,
      builder: (context, source, _) =>
          RepositoryProvider<StorageRepository>.value(
            value: source.repository,
            child: RepositoryProvider<DownloadTransport>.value(
              value: source.transport,
              child: BlocProvider<StorageBrowserCubit>.value(
                value: source.browser,
                child: _Launcher(file: file),
              ),
            ),
          ),
    ),
  );
}

final class _Launcher extends StatelessWidget {
  const _Launcher({required this.file});
  final StorageFileResponse file;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => StorageVersionsAction.show(
        context,
        file,
        StorageShellCapabilities.readOnly,
      ),
      child: const Text('Open'),
    ),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
  });
  for (final mode in [
    'current',
    'scope',
    'browser',
    'repository',
    'transport',
    'cancel',
  ]) {
    testWidgets('versions return only refreshes current sources: $mode', (
      tester,
    ) async {
      final repository = _Repository();
      final replacementRepository = _Repository();
      final transport = _Download();
      final replacementTransport = _Download();
      final browser = StorageBrowserCubit(repository: repository);
      final replacementBrowser = StorageBrowserCubit(repository: repository);
      addTearDown(browser.close);
      addTearDown(replacementBrowser.close);
      when(() => repository.listFileVersions('file-1'))
          .thenAnswer((_) async => right([]));
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
      ).thenAnswer(
        (_) async => left(
          const ApiError(type: ApiErrorType.unknown, message: 'fixture'),
        ),
      );
      final sources = ValueNotifier<_Sources>((
        browser: browser,
        repository: repository,
        transport: transport,
      ));
      addTearDown(sources.dispose);
      final now = DateTime.utc(2026, 10);
      final file = StorageFileResponse(
        id: 'file-1',
        module: StorageModule.workspaces,
        resourceType: StorageResourceType.document,
        originalFileName: 'report.pdf',
        extension: 'pdf',
        mimeType: 'application/pdf',
        fileSizeBytes: 10,
        version: 1,
        ownerUserId: 'owner',
        createdByUserId: 'owner',
        createdAtUtc: now,
        updatedAtUtc: now,
        isDeleted: false,
        processingStatus: StorageProcessingStatus.ready,
        scanStatus: StorageScanStatus.clean,
        aiStatus: StorageAiStatus.none,
        canRead: true,
      );
      await tester.pumpWidget(_App(sources: sources, file: file));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      if (mode == 'scope') {
        await browser.setScope(const StorageScope.shared());
      }
      if (mode == 'browser') {
        sources.value = (
          browser: replacementBrowser,
          repository: repository,
          transport: transport,
        );
      }
      if (mode == 'repository') {
        sources.value = (
          browser: browser,
          repository: replacementRepository,
          transport: transport,
        );
      }
      if (mode == 'transport') {
        sources.value = (
          browser: browser,
          repository: repository,
          transport: replacementTransport,
        );
      }
      await tester.pump();
      clearInteractions(repository);
      Navigator.of(tester.element(find.byType(StorageVersionsDialog)))
          .pop(mode != 'cancel');
      await tester.pumpAndSettle();
      Future<Either<ApiError, List<StorageFolderResponse>>> read() =>
          repository.listFolders(
            scope: any(named: 'scope'),
            parentFolderId: any(named: 'parentFolderId'),
          );
      if (mode == 'current') {
        verify(read).called(1);
      } else {
        verifyNever(read);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
