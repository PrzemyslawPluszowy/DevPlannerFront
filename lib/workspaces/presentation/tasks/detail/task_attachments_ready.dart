import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_file_actions.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_menu_button.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_presentation.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_attachments_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class AttachmentsReady extends StatelessWidget {
  const AttachmentsReady({
    required this.state,
    required this.onPickFiles,
    required this.isDragging,
    super.key,
  });
  final TaskAttachmentsReady state;
  final VoidCallback? onPickFiles;
  final bool isDragging;
  @override
  Widget build(BuildContext context) => Material(
    color: isDragging
        ? context.tasksTheme.rowSelected
        : context.tasksTheme.commandBarSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
      side: BorderSide(
        color: isDragging
            ? context.colors.primary
            : context.tasksTheme.canvasBorder,
        width: isDragging ? 2 : 1,
      ),
    ),
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AttachmentsMutationNotice(),
          if (state.isRefreshing)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          if (state.error != null) ...[
            Text(
              state.apiError == null
                  ? state.error!
                  : TaskAttachmentPresentation.errorMessage(
                      context,
                      state.apiError!,
                    ),
              style: TextStyle(color: context.colors.error),
            ),
            const SizedBox(height: 10),
          ],
          if (state.files.isEmpty && state.uploads.isEmpty)
            EmptyAttachments(onTap: onPickFiles, isDragging: isDragging),
          for (final file in state.files)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                file.isDeleted
                    ? Symbols.delete_outline_rounded
                    : Symbols.insert_drive_file,
              ),
              title: Text(
                file.isDeleted
                    ? '${file.originalFileName} · ${context.l10n.taskDetailsAttachmentsDeleted}'
                    : file.originalFileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                TaskAttachmentPresentation.fileSize(file.fileSizeBytes),
              ),
              trailing: Wrap(
                spacing: 2,
                children: [
                  if (!file.isDeleted && file.canPreview)
                    IconButton(
                      tooltip: context.l10n.storagePreviewTitle,
                      onPressed: () => unawaited(
                        TaskAttachmentFileActions.openPreview(context, file),
                      ),
                      icon: const Icon(Symbols.visibility_rounded, size: 18),
                    ),
                  if (TaskAttachmentFileCapabilities.hasAnyAction(file))
                    TaskAttachmentMenuButton(file: file),
                ],
              ),
              onTap: !file.isDeleted && file.canPreview
                  ? () => unawaited(
                      TaskAttachmentFileActions.openPreview(context, file),
                    )
                  : null,
            ),
          for (final upload in state.uploads)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                TaskAttachmentPresentation.uploadIcon(upload.status),
              ),
              title: Text(
                upload.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    upload.apiError == null
                        ? upload.error ??
                              TaskAttachmentPresentation.uploadLabel(
                                context,
                                upload.status,
                              )
                        : TaskAttachmentPresentation.errorMessage(
                            context,
                            upload.apiError!,
                          ),
                    style: upload.error == null
                        ? null
                        : TextStyle(color: context.colors.error),
                  ),
                  if (upload.status == TaskAttachmentUploadStatus.uploading)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: LinearProgressIndicator(
                        value: upload.totalBytes > 0
                            ? (upload.sentBytes / upload.totalBytes)
                                  .clamp(0, 1)
                                  .toDouble()
                            : null,
                      ),
                    ),
                  if (upload.apiError case final apiError?) ...[
                    if (apiError.apiCode case final code?)
                      Text('${context.l10n.taskDetailsErrorCode}: $code'),
                    if (apiError.traceId case final traceId?)
                      Text('${context.l10n.taskDetailsErrorTraceId}: $traceId'),
                  ],
                ],
              ),
              isThreeLine: upload.apiError != null,
              titleAlignment: ListTileTitleAlignment.center,
              trailing: _UploadRecoveryActions(
                upload: upload,
                canRetry: onPickFiles != null,
                isUploading: state.isUploading,
              ),
            ),
          if (state.isUploading) ...[
            const SizedBox(height: 10),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    ),
  );
}

class _UploadRecoveryActions extends StatelessWidget {
  const _UploadRecoveryActions({
    required this.upload,
    required this.canRetry,
    required this.isUploading,
  });

  final TaskAttachmentUploadProgress upload;
  final bool canRetry;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final isRecoverable =
        upload.status == TaskAttachmentUploadStatus.unknown ||
        upload.status == TaskAttachmentUploadStatus.failed;
    if (!isRecoverable) {
      return upload.apiError == null
          ? const SizedBox.shrink()
          : Icon(
              Symbols.error_outline_rounded,
              color: context.colors.error,
            );
    }
    return Wrap(
      spacing: 4,
      children: [
        IconButton(
          tooltip: context.l10n.taskDetailsAttachmentsCheckState,
          onPressed: isUploading
              ? null
              : () => unawaited(context.read<TaskAttachmentsCubit>().load()),
          icon: const Icon(Symbols.refresh_rounded, size: 18),
        ),
        if (canRetry)
          IconButton(
            tooltip: context.l10n.taskDetailsAttachmentsResend,
            onPressed: isUploading
                ? null
                : () => unawaited(
                    context.read<TaskAttachmentsCubit>().retryUpload(),
                  ),
            icon: const Icon(Symbols.upload_rounded, size: 18),
          ),
      ],
    );
  }
}
