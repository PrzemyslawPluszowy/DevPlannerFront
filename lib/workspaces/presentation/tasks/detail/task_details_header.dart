part of 'task_details_page.dart';

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.details, required this.isSaving});

  final ProjectTaskDetailsResponse details;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final task = details.task;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primaryContainer.withValues(alpha: .55),
            context.colors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(color: context.colors.outlineVariant),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 14, 22),
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
                IconButton(
                  tooltip: details.isPinnedByMe
                      ? context.l10n.taskDetailsUnpin
                      : context.l10n.taskDetailsPin,
                  onPressed: isSaving
                      ? null
                      : () => context.read<TaskDetailsCubit>().togglePinned(),
                  icon: Icon(
                    details.isPinnedByMe
                        ? Symbols.push_pin_rounded
                        : Symbols.push_pin,
                  ),
                ),
                IconButton(
                  tooltip: details.isWatchedByMe
                      ? context.l10n.taskDetailsStopWatching
                      : context.l10n.taskDetailsWatch,
                  onPressed: isSaving
                      ? null
                      : () => context.read<TaskDetailsCubit>().toggleWatching(),
                  icon: Icon(
                    details.isWatchedByMe
                        ? Symbols.notifications_active
                        : Symbols.notifications_none_rounded,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.edit,
                  onPressed: isSaving
                      ? null
                      : () => showDialog<void>(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: context.read<TaskDetailsCubit>(),
                            child: _EditBasicsDialog(details: details),
                          ),
                        ),
                  icon: isSaving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Symbols.edit),
                ),
                IconButton(
                  tooltip: context.l10n.taskDetailsHistory,
                  onPressed: () =>
                      unawaited(TaskHistoryDialogLauncher.show(context)),
                  icon: const Icon(Symbols.history_rounded),
                ),
                IconButton(
                  tooltip: context.l10n.taskDetailsCreateTemplate,
                  onPressed: isSaving
                      ? null
                      : () => unawaited(
                          TaskTemplateDialogLauncher.show(
                            context,
                            initialName: task.title,
                          ),
                        ),
                  icon: const Icon(Symbols.bookmark_add),
                ),
                IconButton(
                  tooltip: task.archivedAtUtc == null
                      ? context.l10n.taskDetailsArchive
                      : context.l10n.taskDetailsRestore,
                  onPressed: isSaving
                      ? null
                      : () => TaskArchiveConfirmation.show(
                          context,
                          task.archivedAtUtc == null,
                        ),
                  icon: Icon(
                    task.archivedAtUtc == null
                        ? Symbols.archive
                        : Symbols.unarchive,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.taskDetailsClose,
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Symbols.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              task.title,
              style: context.text.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Pill(
                  icon: Symbols.radio_button_checked_rounded,
                  label: TaskDetailsLabeler.status(context, task.status),
                ),
                _Pill(
                  icon: Symbols.flag,
                  label: TaskDetailsLabeler.priority(context, task.priority),
                ),
                if (task.archivedAtUtc != null)
                  _Pill(
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

class _EditBasicsDialog extends StatefulWidget {
  const _EditBasicsDialog({required this.details});

  final ProjectTaskDetailsResponse details;

  @override
  State<_EditBasicsDialog> createState() => _EditBasicsDialogState();
}

class _EditBasicsDialogState extends State<_EditBasicsDialog> {
  late final TextEditingController _titleController;
  late final ValueNotifier<ProjectTaskStatus> _status;
  late final ValueNotifier<TaskPriority> _priority;
  final ValueNotifier<bool> _saving = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    final task = widget.details.task;
    _titleController = TextEditingController(text: task.title);
    _status = ValueNotifier(task.status);
    _priority = ValueNotifier(task.priority);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _status.dispose();
    _priority.dispose();
    _saving.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workflow = widget.details.workflow;
    final allowedTargets = <ProjectTaskStatus>{
      widget.details.task.status,
      for (final transition in workflow.transitions)
        if (transition.fromStatus == widget.details.task.status)
          transition.toStatus,
    };
    final configuredStatuses = workflow.statuses
        .where((item) => allowedTargets.contains(item.status))
        .map((item) => item.status)
        .toSet()
        .toList(growable: false);
    final statuses = workflow.statuses.isEmpty
        ? ProjectTaskStatus.values
        : configuredStatuses;
    final l10n = context.l10n;
    final colors = context.colors;

    return AnimatedBuilder(
      animation: Listenable.merge([_status, _priority, _saving]),
      builder: (context, _) => WorkspaceCreationModalWrapper(
        title: l10n.taskDetailsEditBasics,
        icon: Symbols.edit_note_rounded,
        accentColor: colors.primary,
        isSubmitting: _saving.value,
        submitLabel: l10n.save,
        cancelLabel: l10n.cancel,
        maxWidth: 460,
        onSubmit: _save,
        body: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.taskDetailsTitleField,
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h8,
            TextField(
              controller: _titleController,
              autofocus: true,
              maxLength: 300,
              decoration: InputDecoration(
                hintText: l10n.taskDetailsTitleField,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p12,
                ),
              ),
              onSubmitted: (_) => _save(),
            ),
            Gaps.h12,
            Text(
              l10n.taskDetailsStatusField,
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h8,
            DropdownButtonFormField<ProjectTaskStatus>(
              initialValue: _status.value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p8,
                ),
              ),
              items: [
                for (final status in statuses)
                  DropdownMenuItem(
                    value: status,
                    child: Text(TaskDetailsLabeler.status(context, status)),
                  ),
              ],
              onChanged: _saving.value
                  ? null
                  : (value) {
                      if (value != null) _status.value = value;
                    },
            ),
            Gaps.h12,
            Text(
              l10n.taskDetailsPriorityField,
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h8,
            DropdownButtonFormField<TaskPriority>(
              initialValue: _priority.value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p8,
                ),
              ),
              items: [
                for (final priority in TaskPriority.values)
                  DropdownMenuItem(
                    value: priority,
                    child: Text(TaskDetailsLabeler.priority(context, priority)),
                  ),
              ],
              onChanged: _saving.value
                  ? null
                  : (value) {
                      if (value != null) _priority.value = value;
                    },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) return;
    _saving.value = true;
    final saved = await context.read<TaskDetailsCubit>().updateBasics(
      title: _titleController.text,
      status: _status.value,
      priority: _priority.value,
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      _saving.value = false;
    }
  }
}
