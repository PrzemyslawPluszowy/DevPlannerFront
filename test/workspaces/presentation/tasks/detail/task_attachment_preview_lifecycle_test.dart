import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_file_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

final class _StorageRepository extends Mock implements StorageRepository {}

final class _AttachmentRepository implements TaskAttachmentRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _UploadTransport implements TaskAttachmentUploadTransport {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _DownloadTransport implements DownloadTransport {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

StorageFileResponse _file({
  bool canEdit = false,
  bool canPreview = false,
  bool canConvertToPdf = false,
  bool canShare = false,
  bool canRead = false,
  bool canDismissFromShared = false,
  bool canDelete = false,
  bool canRestore = false,
  bool isDeleted = false,
}) => StorageFileResponse(
  id: 'file-1',
  module: StorageModule.workspaces,
  resourceType: StorageResourceType.task,
  originalFileName: 'brief.txt',
  extension: 'txt',
  mimeType: 'text/plain',
  fileSizeBytes: 10,
  version: 1,
  ownerUserId: 'user-1',
  createdByUserId: 'user-1',
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  isDeleted: isDeleted,
  processingStatus: StorageProcessingStatus.ready,
  scanStatus: StorageScanStatus.clean,
  aiStatus: StorageAiStatus.none,
  canPreview: canPreview,
  canEdit: canEdit,
  canConvertToPdf: canConvertToPdf,
  canShare: canShare,
  canRead: canRead,
  canDismissFromShared: canDismissFromShared,
  canDelete: canDelete,
  canRestore: canRestore,
);

void main() {
  for (final replaceRepository in <bool?>[true, false, null]) {
    testWidgets(
      switch (replaceRepository) {
        true => 'late preview ignores replaced storage repository',
        false => 'late preview ignores closed task attachment session',
        null => 'current preview opens with visible ticket failure',
      },
      (tester) async {
        final first = _StorageRepository();
        final next = _StorageRepository();
        final activeRepository = ValueNotifier<StorageRepository>(first);
        addTearDown(activeRepository.dispose);
        final ticket =
            Completer<Either<ApiError, StorageDownloadTicketResponse>>();
        when(() => first.getDownloadTicket('file-1'))
            .thenAnswer((_) => ticket.future);
        final attachments = TaskAttachmentsCubit(
          repository: _AttachmentRepository(),
          uploadTransport: _UploadTransport(),
          workspaceId: 'ws',
          projectId: 'project',
          taskId: 'task',
        );
        addTearDown(() async {
          if (!attachments.isClosed) await attachments.close();
        });
        await tester.pumpWidget(
          MaterialApp(
            theme: MaterialTheme.crm().light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ValueListenableBuilder<StorageRepository>(
              valueListenable: activeRepository,
              builder: (context, value, _) => MultiProvider(
                providers: [
                  Provider<StorageRepository>.value(value: value),
                  Provider<DownloadTransport>.value(
                    value: _DownloadTransport(),
                  ),
                  BlocProvider<TaskAttachmentsCubit>.value(value: attachments),
                ],
                child: const _PreviewButton(),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Preview'));
        await tester.pump();
        verify(() => first.getDownloadTicket('file-1')).called(1);
        if (replaceRepository == true) {
          activeRepository.value = next;
        } else if (replaceRepository == false) {
          await attachments.close();
        }
        await tester.pump();
        ticket.complete(
          const Left(
            ApiError(
              type: ApiErrorType.notFound,
              message: 'expired ticket',
              apiCode: 'preview.expired',
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (replaceRepository == null) {
          expect(find.byType(StoragePreviewDialog), findsOneWidget);
          expect(find.textContaining('expired ticket'), findsOneWidget);
          final dialogContext = tester.element(
            find.byType(StoragePreviewDialog),
          );
          final preview = dialogContext.read<StoragePreviewCubit>();
          final mutation = dialogContext.read<StorageFileMutationCubit>();
          Navigator.of(tester.element(find.byType(StoragePreviewDialog))).pop();
          await tester.pumpAndSettle();
          expect(preview.isClosed, isTrue);
          expect(mutation.isClosed, isTrue);
        } else {
          expect(find.byType(StoragePreviewDialog), findsNothing);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }
}

final class _PreviewButton extends StatelessWidget {
  const _PreviewButton();
  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => unawaited(
        TaskAttachmentFileActions.openPreview(context, _file(canPreview: true)),
      ),
      child: const Text('Preview'),
    ),
  );
}
