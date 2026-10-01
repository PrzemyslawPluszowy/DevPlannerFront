import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_file_capabilities.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_file_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_preview_launcher.dart';
import 'package:flutter/material.dart';

export 'task_attachment_file_capabilities.dart';

/// Task attachment actions on the same context-menu surface as Tasks and Storage.
abstract final class TaskAttachmentFileActions {
  static List<TaskAttachmentFileAction> availableActions(
    StorageFileResponse file,
  ) => TaskAttachmentFileCapabilities.actions(file);

  static Future<void> show(
    BuildContext context,
    StorageFileResponse file,
  ) async {
    final actions = TaskAttachmentFileMenu.actions(context, file);
    if (actions.isEmpty || !context.mounted) return;
    await AppContextMenu.show(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      headerTitle: file.originalFileName,
      actions: actions,
    );
  }

  static Future<void> openPreview(
    BuildContext context,
    StorageFileResponse file,
  ) => TaskAttachmentPreviewLauncher.open(context, file);
}
