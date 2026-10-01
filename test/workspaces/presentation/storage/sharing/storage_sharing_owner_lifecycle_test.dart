import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/standalone/storage_desktop_sharing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements StorageRepository {}

final class _App extends StatelessWidget {
  const _App({
    required this.repository,
    this.fileId = 'file-1',
    this.textScaler = TextScaler.noScaling,
  });

  final StorageRepository repository;
  final String fileId;
  final TextScaler textScaler;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: MaterialTheme.crm().light(),
    locale: const Locale('pl'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(
      body: StorageDesktopSharingDialog(
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
      ),
    ),
  );
}

void main() {
  for (final replaceRepository in [true, false]) {
    testWidgets(
      'sharing owner replaced for new source: repository=$replaceRepository',
      (tester) async {
        final original = _Repository();
        final replacement = replaceRepository ? _Repository() : original;
        final pending =
            Completer<Either<ApiError, List<StorageFileShareResponse>>>();
        when(() => original.listFileShares('file-1'))
            .thenAnswer((_) => pending.future);
        final currentId = replaceRepository ? 'file-1' : 'file-2';
        when(() => replacement.listFileShares(currentId))
            .thenAnswer((_) async => right([]));
        // Ten sam ID przy wymianie repozytorium ma osobne stuby, nie nadpisuje starego.
        await tester.pumpWidget(
          _App(repository: original),
        );
        await tester.pump();
        final oldOwner = tester
            .element(
              find
                  .byType(
                    BlocBuilder<StorageSharingCubit, StorageSharingState>,
                  )
                  .first,
            )
            .read<StorageSharingCubit>();
        await tester.pumpWidget(
          _App(
            repository: replacement,
            fileId: currentId,
          ),
        );
        await tester.pump();
        pending.complete(right([]));
        await tester.pumpAndSettle();
        expect(oldOwner.isClosed, true);
        final currentOwner = tester
            .element(
              find
                  .byType(
                    BlocBuilder<StorageSharingCubit, StorageSharingState>,
                  )
                  .first,
            )
            .read<StorageSharingCubit>();
        expect(identical(oldOwner, currentOwner), false);
        expect(currentOwner.fileId, currentId);
        expect(identical(currentOwner.repository, replacement), true);
        verify(() => replacement.listFileShares(currentId)).called(1);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('ordinary rebuild retains the current sharing owner', (
    tester,
  ) async {
    final repository = _Repository();
    when(() => repository.listFileShares('file-1')).thenAnswer(
      (_) async => right([]),
    );
    await tester.pumpWidget(_App(repository: repository));
    await tester.pumpAndSettle();
    final owner = tester
        .element(
          find
              .byType(
                BlocBuilder<StorageSharingCubit, StorageSharingState>,
              )
              .first,
        )
        .read<StorageSharingCubit>();
    await tester.pumpWidget(_App(repository: repository));
    await tester.pumpAndSettle();
    final afterRebuild = tester
        .element(
          find
              .byType(
                BlocBuilder<StorageSharingCubit, StorageSharingState>,
              )
              .first,
        )
        .read<StorageSharingCubit>();
    expect(identical(owner, afterRebuild), true);
    expect(owner.isClosed, false);
    verify(() => repository.listFileShares('file-1')).called(1);
    expect(tester.takeException(), isNull);
  });
  testWidgets('long sharing failure keeps close and content at 200%', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = _Repository();
    when(() => repository.listFileShares('file-1')).thenAnswer(
      (_) async => left(
        ApiError(
          type: ApiErrorType.server,
          message: List.filled(20, 'Request failed').join(' '),
          fields: {
            for (var i = 0; i < 30; i++)
              'field-$i': ['Validation failed repeatedly'],
          },
          statusCode: 503,
          traceId: 'long-error-trace',
        ),
      ),
    );
    await tester.pumpWidget(
      _App(repository: repository, textScaler: const TextScaler.linear(2)),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('Zamknij').hitTestable(), findsOneWidget);
    expect(find.byType(StorageDesktopSharingDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
