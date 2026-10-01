import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_rename_file_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_sharing_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_versions_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_registry.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_detail_editor_close_guard.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_description_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_file_capabilities.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_file_mutations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract final class TaskAttachmentFileMenu {
  static List<AppContextMenuAction> actions(
    BuildContext context,
    StorageFileResponse file,
  ) {
    final l10n = context.l10n;
    final repository = context.read<StorageRepository>();
    final mutation = context.read<StorageFileMutationCubit>();
    final attachments = context.read<TaskAttachmentsCubit>();
    final download = context.read<DownloadTransport>();
    final available = TaskAttachmentFileCapabilities.actions(file);
    return [
      if (available.contains(TaskAttachmentFileAction.preview))
        AppContextMenuAction(
          label: l10n.storagePreviewTitle,
          icon: AppIcons.documentText,
          onTap: (menuContext) =>
              TaskAttachmentFileMutations.preview(menuContext, file),
        ),
      if (available.contains(TaskAttachmentFileAction.rename))
        AppContextMenuAction(
          label: l10n.storageRenameFileDialogTitle,
          icon: Icons.drive_file_rename_outline,
          onTap: (menuContext) => _rename(menuContext, file, attachments),
        ),
      if (available.contains(TaskAttachmentFileAction.description))
        AppContextMenuAction(
          label: l10n.taskAttachmentDescriptionTitle,
          icon: Icons.description_outlined,
          onTap: (menuContext) =>
              TaskAttachmentDescriptionDialog.show(menuContext, file),
        ),
      if (available.contains(TaskAttachmentFileAction.office))
        AppContextMenuAction(
          label: l10n.storageOpenOfficeAction,
          icon: AppIcons.documentText,
          onTap: (menuContext) =>
              TaskAttachmentFileMutations.openOffice(menuContext, file),
        ),
      if (available.contains(TaskAttachmentFileAction.convertToPdf))
        AppContextMenuAction(
          label: l10n.storageConvertToPdfAction,
          icon: Icons.picture_as_pdf_outlined,
          onTap: (menuContext) => TaskAttachmentFileMutations.convertToPdf(
            menuContext,
            file,
            repository,
            attachments,
          ),
        ),
      if (available.contains(TaskAttachmentFileAction.share))
        AppContextMenuAction(
          label: l10n.storageShareAction,
          icon: AppIcons.share,
          onTap: (menuContext) async {
            await StorageSharingDialog.show(
              menuContext,
              file: file,
              repository: repository,
              userDirectory: menuContext.read<StorageUserDirectoryPort?>(),
            );
            if (menuContext.mounted) await attachments.load();
          },
        ),
      if (available.contains(TaskAttachmentFileAction.favorite))
        AppContextMenuAction(
          label: file.isFavorite
              ? l10n.storageRemoveFavoriteAction
              : l10n.storageAddFavoriteAction,
          icon: AppIcons.star,
          onTap: (_) => TaskAttachmentFileMutations.mutate(
            context,
            mutation,
            attachments,
            () => mutation.toggleFavorite(file),
          ),
        ),
      if (available.contains(TaskAttachmentFileAction.dismiss))
        AppContextMenuAction(
          label: l10n.storageDismissFromSharedAction,
          icon: Icons.visibility_off_outlined,
          onTap: (menuContext) => TaskAttachmentFileMutations.confirmAndMutate(
            menuContext,
            file,
            attachments,
            mutation,
            title: l10n.storageDismissFromSharedTitle,
            message: l10n.storageDismissFromSharedConfirm,
            confirmLabel: l10n.storageDismissFromSharedAction,
            action: () => mutation.dismissSharedFile(file.id),
          ),
        ),
      if (available.contains(TaskAttachmentFileAction.download))
        AppContextMenuAction(
          label: l10n.storageDownloadAction,
          icon: AppIcons.download,
          onTap: (_) => mutation.downloadFile(file),
        ),
      if (available.contains(TaskAttachmentFileAction.versions))
        AppContextMenuAction(
          label: l10n.storageVersionsTitle,
          icon: Icons.history_rounded,
          onTap: (menuContext) async {
            final restored = await StorageVersionsDialog.show(
              menuContext,
              file: file,
              repository: repository,
              downloadTransport: download,
              canPreview: file.canPreview,
              canDownload: file.canDownload,
              canRestore: file.canRestore,
              canDeleteVersions: file.canManageVersions,
            );
            if (restored == true && menuContext.mounted) {
              await attachments.load();
            }
          },
        ),
      if (available.contains(TaskAttachmentFileAction.restore))
        AppContextMenuAction(
          label: l10n.storageRestoreSelected,
          icon: AppIcons.refresh,
          onTap: (menuContext) => TaskAttachmentFileMutations.confirmAndMutate(
            menuContext,
            file,
            attachments,
            mutation,
            title: l10n.storageRestoreConfirmTitle,
            message: l10n.storageRestoreConfirmMessage,
            confirmLabel: l10n.storageRestoreSelected,
            action: () => mutation.restoreFile(file.id),
          ),
        ),
      if (available.contains(TaskAttachmentFileAction.delete))
        AppContextMenuAction(
          label: l10n.storageDeleteAction,
          icon: AppIcons.delete,
          isDestructive: true,
          onTap: (menuContext) => TaskAttachmentFileMutations.confirmAndMutate(
            menuContext,
            file,
            attachments,
            mutation,
            title: l10n.storageDeleteConfirmTitle,
            message: l10n.storageDeleteConfirmMessage,
            confirmLabel: l10n.storageDeleteAction,
            action: () => mutation.deleteFile(file.id),
          ),
        ),
    ];
  }

  static Future<void> _rename(
    BuildContext context,
    StorageFileResponse file,
    TaskAttachmentsCubit attachments,
  ) async {
    final registration = TaskDetailDraftScope.maybeOf(
      context,
    )?.registerDraft(label: 'attachment name');
    try {
      final renamed = await StorageRenameFileDialog.show(
        context,
        file,
        onDirty: registration?.markDirty,
        onCloseAttempt: () =>
            TaskDetailEditorCloseGuard.canClose(context, registration),
      );
      if (renamed) {
        registration?.clear();
        if (context.mounted) await attachments.load();
      }
    } finally {
      registration?.dispose();
    }
  }
}
