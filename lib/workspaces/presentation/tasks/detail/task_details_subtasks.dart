part of 'task_details_page.dart';

class _SubtasksSection extends StatelessWidget {
  const _SubtasksSection({required this.subtasks, required this.isSaving});
  final List<ProjectTaskSubtaskSummaryResponse> subtasks;
  final bool isSaving;
  @override
  Widget build(BuildContext context) => _Section(
    title: context.l10n.taskDetailsSubtasks,
    action: IconButton(
      tooltip: context.l10n.taskDetailsAddSubtask,
      onPressed: isSaving
          ? null
          : () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: const _CreateSubtaskDialog(),
              ),
            ),
      icon: const Icon(Symbols.add_task_rounded, size: 20),
    ),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: subtasks.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(14),
              child: Text(context.l10n.taskDetailsNoSubtasks),
            )
          : Column(
              children: [
                for (final subtask in subtasks)
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    leading: const Icon(Symbols.subdirectory_arrow_right),
                    title: Text(subtask.title),
                    subtitle: Text(subtask.key),
                    onTap: () {
                      final cubit = context.read<TaskDetailsCubit>();
                      context.go(
                        '/workspaces/${cubit.workspaceId}/projects/${cubit.projectId}/tasks/${subtask.id}',
                      );
                    },
                  ),
              ],
            ),
    ),
  );
}

class _CreateSubtaskDialog extends StatefulWidget {
  const _CreateSubtaskDialog();
  @override
  State<_CreateSubtaskDialog> createState() => _CreateSubtaskDialogState();
}

class _CreateSubtaskDialogState extends State<_CreateSubtaskDialog> {
  final _controller = TextEditingController();
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  @override
  void dispose() {
    _controller.dispose();
    _saving.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return ValueListenableBuilder<bool>(
      valueListenable: _saving,
      builder: (context, isSaving, _) => WorkspaceCreationModalWrapper(
        title: l10n.taskDetailsAddSubtask,
        subtitle: l10n.taskDetailsTitleField,
        icon: Symbols.account_tree_rounded,
        accentColor: colors.primary,
        isSubmitting: isSaving,
        submitLabel: l10n.save,
        cancelLabel: l10n.cancel,
        maxWidth: 440,
        onSubmit: _save,
        body: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              maxLength: 300,
              enabled: !isSaving,
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
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (_saving.value || text.isEmpty) return;
    _saving.value = true;
    final saved = await context.read<TaskDetailsCubit>().createSubtask(text);
    if (mounted) {
      if (saved) {
        Navigator.of(context).pop();
      } else {
        _saving.value = false;
      }
    }
  }
}
