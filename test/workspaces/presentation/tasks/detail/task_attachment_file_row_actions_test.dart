import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachments_ready.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

final class _StorageRepository implements StorageRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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
  testWidgets('row opens the menu for each non-download-only capability', (
    tester,
  ) async {
    final storageRepository = _StorageRepository();
    final attachmentRepository = _AttachmentRepository();
    final downloadTransport = _DownloadTransport();
    final attachments = TaskAttachmentsCubit(
      repository: attachmentRepository,
      uploadTransport: _UploadTransport(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    final mutation = StorageFileMutationCubit(
      repository: storageRepository,
      downloadTransport: downloadTransport,
    );
    addTearDown(attachments.close);
    addTearDown(mutation.close);

    final cases = <(StorageFileResponse, String)>[
      (_file(canEdit: true), 'Rename file'),
      (_file(canConvertToPdf: true), 'Convert to PDF'),
      (_file(canShare: true), 'Share'),
      (_file(canRead: true), 'Add to favorites'),
      (_file(canDismissFromShared: true), 'Hide from Shared'),
      (_file(canDelete: true), 'Delete'),
      (_file(isDeleted: true, canRestore: true, canPreview: true), 'Restore'),
    ];

    for (final testCase in cases) {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<StorageRepository>.value(value: storageRepository),
            Provider<DownloadTransport>.value(value: downloadTransport),
          ],
          child: MaterialApp(
            locale: const Locale('en'),
            theme: MaterialTheme.crm().light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MultiBlocProvider(
              providers: [
                BlocProvider<TaskAttachmentsCubit>.value(value: attachments),
                BlocProvider<StorageFileMutationCubit>.value(value: mutation),
              ],
              child: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 620,
                    child: AttachmentsReady(
                      state: TaskAttachmentsReady(files: [testCase.$1]),
                      onPickFiles: null,
                      isDragging: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final moreOptions = find.byTooltip('More options');
      expect(moreOptions, findsOneWidget);
      final buttonBounds = tester.getRect(moreOptions);
      await tester.tap(moreOptions);
      await tester.pumpAndSettle();
      expect(find.text(testCase.$2), findsOneWidget);
      final actionBounds = tester.getRect(find.text(testCase.$2));
      expect(actionBounds.left, greaterThan(buttonBounds.left - 340));
      if (testCase.$1.isDeleted) {
        expect(find.byTooltip('File preview'), findsNothing);
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
    }
  });
}
