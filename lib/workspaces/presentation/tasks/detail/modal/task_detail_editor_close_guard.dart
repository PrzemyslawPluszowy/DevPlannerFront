import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_discard_confirmation.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_registry.dart';
import 'package:flutter/material.dart';

/// Confirms dismissal of the specific editor whose draft registration is dirty.
abstract final class TaskDetailEditorCloseGuard {
  static Future<bool> canClose(
    BuildContext context,
    TaskDetailDraftRegistration? registration,
  ) async {
    if (registration == null || !registration.isDirty) return true;
    final confirmed = await DevPlannerModalHost.showDialog<bool>(
      context,
      barrierDismissible: false,
      builder: (_) => const TaskDetailDraftDiscardConfirmation(),
    );
    if (!context.mounted || confirmed != true) return false;
    registration.clear();
    return true;
  }
}
