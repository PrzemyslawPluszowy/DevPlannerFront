import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_basics_editor.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_custom_status_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_history.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_templates.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_parent_navigation_link.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_priority_header_control.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({
    required this.details,
    required this.isSaving,
    required this.canEdit,
    required this.canToggleArchive,
    this.onClose,
    super.key,
  });

  final ProjectTaskDetailsResponse details;
  final bool isSaving;
  final bool canEdit;
  final bool canToggleArchive;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final task = details.task;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.tasksTheme.commandBarSurface,
        border: Border(bottom: BorderSide(color: context.tasksTheme.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  task.key,
                  style: context.text.labelLarge?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TaskDetailsHeaderAction(
                  tooltip: details.isPinnedByMe
                      ? context.l10n.taskDetailsUnpin
                      : context.l10n.taskDetailsPin,
                  icon: Icon(
                    details.isPinnedByMe ? Symbols.star_rounded : Symbols.star,
                    fill: details.isPinnedByMe ? 1 : 0,
                  ),
                  onPressed: isSaving
                      ? null
                      : () => context.read<TaskDetailsCubit>().togglePinned(),
                ),
                TaskDetailsHeaderAction(
                  tooltip: details.isWatchedByMe
                      ? context.l10n.taskDetailsStopWatching
                      : context.l10n.taskDetailsWatch,
                  icon: Icon(
                    details.isWatchedByMe
                        ? Symbols.notifications_active
                        : Symbols.notifications_none_rounded,
                  ),
                  onPressed: isSaving
                      ? null
                      : () => context.read<TaskDetailsCubit>().toggleWatching(),
                ),
                TaskDetailsHeaderAction(
                  tooltip: context.l10n.edit,
                  icon: isSaving
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Symbols.edit),
                  onPressed: isSaving || !canEdit
                      ? null
                      : () => DevPlannerModalHost.showDialog<void>(
                          context,
                          builder: (_) => BlocProvider.value(
                            value: context.read<TaskDetailsCubit>(),
                            child: EditBasicsDialog(details: details),
                          ),
                        ),
                ),
                TaskDetailsHeaderAction(
                  tooltip: context.l10n.taskDetailsHistory,
                  icon: const Icon(Symbols.history_rounded),
                  onPressed: () =>
                      unawaited(TaskHistoryDialogLauncher.show(context)),
                ),
                TaskDetailsHeaderAction(
                  tooltip: context.l10n.taskDetailsCreateTemplate,
                  icon: const Icon(Symbols.bookmark_add),
                  onPressed: isSaving || !canEdit
                      ? null
                      : () => unawaited(
                          TaskTemplateDialogLauncher.show(
                            context,
                            initialName: task.title,
                          ),
                        ),
                ),
                TaskDetailsHeaderAction(
                  tooltip: task.archivedAtUtc == null
                      ? context.l10n.taskDetailsArchive
                      : context.l10n.taskDetailsRestore,
                  icon: Icon(
                    task.archivedAtUtc == null
                        ? Symbols.archive
                        : Symbols.unarchive,
                  ),
                  onPressed: isSaving || !canToggleArchive
                      ? null
                      : () => TaskArchiveConfirmation.show(
                          context,
                          task.archivedAtUtc == null,
                        ),
                ),
                TaskDetailsHeaderAction(
                  tooltip: context.l10n.taskDetailsClose,
                  icon: const Icon(Symbols.close_rounded),
                  onPressed: onClose ?? () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
            if (task.parentTaskId case final parentId?)
              TaskParentNavigationLink(
                workspaceId: task.workspaceId,
                projectId: task.projectId,
                parentTaskId: parentId,
                enabled: !isSaving,
              ),
            const SizedBox(height: 4),
            Text(
              task.title,
              style: context.text.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                TaskCustomStatusHeaderControl(
                  details: details,
                  fallbackLabel: TaskDetailsLabeler.status(
                    context,
                    task.status,
                  ),
                  enabled: canEdit && !isSaving,
                ),
                TaskPriorityHeaderControl(
                  priority: task.priority,
                  enabled: canEdit && !isSaving,
                ),
                if (task.archivedAtUtc != null)
                  Pill(
                    icon: Symbols.archive,
                    label: context.l10n.taskDetailsArchived,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class TaskDetailsHeaderAction extends StatelessWidget {
  const TaskDetailsHeaderAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: tooltip,
    child: IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      padding: const EdgeInsets.all(8),
      icon: icon,
    ),
  );
}

/// Potwierdza archiwizację, a mutację deleguje do lokalnego Cubita szczegółów.
final class TaskArchiveConfirmation {
  const TaskArchiveConfirmation._();

  static Future<void> show(BuildContext context, bool archive) async {
    final confirmed =
        !archive ||
        await AppConfirmDialog.show(
          context,
          title: context.l10n.taskDetailsArchiveConfirmTitle,
          message: context.l10n.taskDetailsArchiveConfirmMessage,
          confirmLabel: context.l10n.taskDetailsArchive,
          cancelLabel: context.l10n.cancel,
          tone: AppConfirmDialogTone.warning,
        );
    if (!confirmed) return;
    if (!context.mounted) return;
    await context.read<TaskDetailsCubit>().toggleArchive();
  }
}
