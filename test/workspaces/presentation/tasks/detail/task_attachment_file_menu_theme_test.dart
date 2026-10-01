import 'dart:async';

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
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_file_actions.dart';
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

StorageFileResponse _previewableFile() => StorageFileResponse(
  id: 'file-1',
  module: StorageModule.workspaces,
  resourceType: StorageResourceType.task,
  originalFileName: 'brief.pdf',
  extension: 'pdf',
  mimeType: 'application/pdf',
  fileSizeBytes: 10,
  version: 1,
  ownerUserId: 'user-1',
  createdByUserId: 'user-1',
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  isDeleted: false,
  processingStatus: StorageProcessingStatus.ready,
  scanStatus: StorageScanStatus.clean,
  aiStatus: StorageAiStatus.none,
  canPreview: true,
);

void main() {
  testWidgets('task file menu keeps Tasks surface tokens in light and dark', (
    tester,
  ) async {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final theme = brightness == Brightness.light
          ? MaterialTheme.crm().light()
          : MaterialTheme.crm().dark();
      final expectedSurface = theme.extension<DevPlannerMenuTheme>()!.surface;
      final repository = _StorageRepository();
      final mutation = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: _DownloadTransport(),
      );
      final attachments = TaskAttachmentsCubit(
        repository: _AttachmentRepository(),
        uploadTransport: _UploadTransport(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );

      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey<Brightness>(brightness),
          locale: const Locale('en'),
          theme: MaterialTheme.crm().light(),
          darkTheme: MaterialTheme.crm().dark(),
          themeMode: brightness == Brightness.light
              ? ThemeMode.light
              : ThemeMode.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiProvider(
            providers: [
              Provider<StorageRepository>.value(value: repository),
              Provider<DownloadTransport>.value(
                value: _DownloadTransport(),
              ),
              BlocProvider<StorageFileMutationCubit>.value(value: mutation),
              BlocProvider<TaskAttachmentsCubit>.value(value: attachments),
            ],
            child: Scaffold(
              body: Builder(
                builder: (context) => FilledButton(
                  onPressed: () => unawaited(
                    TaskAttachmentFileActions.show(
                      context,
                      _previewableFile(),
                    ),
                  ),
                  child: const Text('Open file actions'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open file actions'));
      await tester.pumpAndSettle();
      expect(find.text('File preview'), findsOneWidget);
      expect(
        tester
            .widgetList<DecoratedBox>(find.byType(DecoratedBox))
            .any(
              (box) =>
                  box.decoration is BoxDecoration &&
                  (box.decoration as BoxDecoration).color == expectedSurface,
            ),
        isTrue,
      );
      expect(
        Theme.of(tester.element(find.text('File preview'))).brightness,
        brightness,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
      await mutation.close();
      await attachments.close();
    }
  });
}
