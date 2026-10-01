import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Presentation-only labels and icons for task attachment states.
final class TaskAttachmentPresentation {
  const TaskAttachmentPresentation._();

  static IconData uploadIcon(TaskAttachmentUploadStatus status) =>
      switch (status) {
        TaskAttachmentUploadStatus.queued => Symbols.schedule_rounded,
        TaskAttachmentUploadStatus.uploading => Symbols.upload_rounded,
        TaskAttachmentUploadStatus.uploaded =>
          Symbols.check_circle_outline_rounded,
        TaskAttachmentUploadStatus.completing => Symbols.pending_actions,
        TaskAttachmentUploadStatus.processing => Symbols.sync_rounded,
        TaskAttachmentUploadStatus.ready => Symbols.verified_rounded,
        TaskAttachmentUploadStatus.unknown => Symbols.help_outline_rounded,
        TaskAttachmentUploadStatus.failed => Symbols.error_outline_rounded,
      };

  static String uploadLabel(
    BuildContext context,
    TaskAttachmentUploadStatus status,
  ) => switch (status) {
    TaskAttachmentUploadStatus.queued =>
      context.l10n.taskDetailsAttachmentsQueued,
    TaskAttachmentUploadStatus.uploading =>
      context.l10n.taskDetailsAttachmentsUploading,
    TaskAttachmentUploadStatus.uploaded =>
      context.l10n.taskDetailsAttachmentsUploaded,
    TaskAttachmentUploadStatus.completing =>
      context.l10n.taskDetailsAttachmentsCompleting,
    TaskAttachmentUploadStatus.processing =>
      context.l10n.taskDetailsAttachmentsProcessing,
    TaskAttachmentUploadStatus.ready =>
      context.l10n.taskDetailsAttachmentsReady,
    TaskAttachmentUploadStatus.unknown =>
      context.l10n.taskDetailsAttachmentsUnknown,
    TaskAttachmentUploadStatus.failed =>
      context.l10n.taskDetailsAttachmentsFailed,
  };

  static String fileSize(int bytes) => bytes < 1024
      ? '$bytes B'
      : bytes < 1024 * 1024
      ? '${(bytes / 1024).toStringAsFixed(1)} KB'
      : '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';

  static String errorMessage(BuildContext context, ApiError error) =>
      switch (error.apiCode) {
        'task_upload_canceled' => context.l10n.taskUploadCanceled,
        'task_upload_invalid_input' => context.l10n.taskUploadInvalidInput,
        _ => error.message,
      };
}
