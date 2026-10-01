import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/cubit/storage_versions_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/cubit/storage_versions_state.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_versions_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements StorageRepository {}

final class _Download extends Mock implements DownloadTransport {}

final class _App extends StatelessWidget {
  const _App({
    required this.repository,
    required this.transport,
    this.fileId = 'file-1',
  });

  final StorageRepository repository;
  final DownloadTransport transport;
  final String fileId;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: MaterialTheme.crm().light(),
    locale: const Locale('pl'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: StorageVersionsDialog(
        file: StorageFileResponse(
          id: fileId,
          module: StorageModule.workspaces,
          resourceType: StorageResourceType.document,
          originalFileName: 'report.pdf',
          extension: 'pdf',
          mimeType: 'application/pdf',
          fileSizeBytes: 10,
          version: 3,
          ownerUserId: 'owner',
          createdByUserId: 'owner',
          createdAtUtc: DateTime.utc(2026, 10),
          updatedAtUtc: DateTime.utc(2026, 10),
          isDeleted: false,
          processingStatus: StorageProcessingStatus.ready,
          scanStatus: StorageScanStatus.clean,
          aiStatus: StorageAiStatus.none,
          canRead: true,
        ),
        repository: repository,
        downloadTransport: transport,
      ),
    ),
  );
}

void main() {
  for (final replaceRepository in [true, false]) {
    testWidgets(
      'versions owner replaced for new source: repository=$replaceRepository',
      (tester) async {
        final original = _Repository();
        final replacement = replaceRepository ? _Repository() : original;
        final transport = _Download();
        final pending =
            Completer<Either<ApiError, List<StorageFileVersionResponse>>>();
        when(() => original.listFileVersions('file-1'))
            .thenAnswer((_) => pending.future);
        final currentId = replaceRepository ? 'file-1' : 'file-2';
        when(() => replacement.listFileVersions(currentId))
            .thenAnswer((_) async => right([]));
        // Ten sam ID przy wymianie repozytorium ma osobne stuby, nie nadpisuje starego.
        await tester.pumpWidget(
          _App(repository: original, transport: transport),
        );
        await tester.pump();
        final oldOwner = tester
            .element(
              find.byType(
                BlocBuilder<StorageVersionsCubit, StorageVersionsState>,
              ),
            )
            .read<StorageVersionsCubit>();
        await tester.pumpWidget(
          _App(
            repository: replacement,
            transport: transport,
            fileId: currentId,
          ),
        );
        await tester.pump();
        pending.complete(right([]));
        await tester.pumpAndSettle();
        expect(oldOwner.isClosed, true);
        final currentOwner = tester
            .element(
              find.byType(
                BlocBuilder<StorageVersionsCubit, StorageVersionsState>,
              ),
            )
            .read<StorageVersionsCubit>();
        expect(identical(oldOwner, currentOwner), false);
        expect(currentOwner.fileId, currentId);
        expect(identical(currentOwner.repository, replacement), true);
        verify(() => replacement.listFileVersions(currentId)).called(1);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('ordinary rebuild retains the current versions owner', (
    tester,
  ) async {
    final repository = _Repository();
    final transport = _Download();
    when(() => repository.listFileVersions('file-1')).thenAnswer(
      (_) async => right([]),
    );
    await tester.pumpWidget(_App(repository: repository, transport: transport));
    await tester.pumpAndSettle();
    final owner = tester
        .element(
          find.byType(
            BlocBuilder<StorageVersionsCubit, StorageVersionsState>,
          ),
        )
        .read<StorageVersionsCubit>();
    await tester.pumpWidget(_App(repository: repository, transport: transport));
    await tester.pumpAndSettle();
    final afterRebuild = tester
        .element(
          find.byType(
            BlocBuilder<StorageVersionsCubit, StorageVersionsState>,
          ),
        )
        .read<StorageVersionsCubit>();
    expect(identical(owner, afterRebuild), true);
    expect(owner.isClosed, false);
    verify(() => repository.listFileVersions('file-1')).called(1);
    expect(tester.takeException(), isNull);
  });
}
