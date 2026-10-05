import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_open_intent.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dialog_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class SubtasksSection extends StatelessWidget {
  const SubtasksSection({
    required this.subtasks,
    required this.isSaving,
    super.key,
  });
  final List<ProjectTaskSubtaskSummaryResponse> subtasks;
  final bool isSaving;

  void _openSubtask(BuildContext context, String taskId) {
    final source = context.read<TaskDetailsCubit>();
    final navigation = DevPlannerNavigation.of(context);
    unawaited(
      navigation.goToTask(
        workspaceId: source.workspaceId,
        projectId: source.projectId,
        taskId: taskId,
        currentLocation: Uri.parse(navigation.currentPath),
        source: TaskDetailOpenSource.subtask,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Section(
    title: context.l10n.taskDetailsSubtasks,
    action: IconButton(
      tooltip: context.l10n.taskDetailsAddSubtask,
      onPressed: isSaving
          ? null
          : () => DevPlannerModalHost.showDialog<void>(
              context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: const CreateSubtaskDialog(),
              ),
            ),
      icon: const Icon(Symbols.add_task_rounded, size: 20),
    ),
    child: Material(
      color: context.colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
        side: BorderSide(color: context.colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: subtasks.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(12),
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
                    subtitle: Text(
                      '${subtask.key} · '
                      '${subtask.customStatusName ?? TaskDetailsLabeler.status(context, subtask.status)}',
                    ),
                    onTap: () => _openSubtask(context, subtask.id),
                  ),
              ],
            ),
    ),
  );
}

class CreateSubtaskDialog extends StatefulWidget {
  const CreateSubtaskDialog({super.key});
  @override
  State<CreateSubtaskDialog> createState() => CreateSubtaskDialogState();
}

class CreateSubtaskDialogState extends State<CreateSubtaskDialog> {
  TaskDetailDraftRegistration? _draft;
  final _controller = TextEditingController();
  final ValueNotifier<bool> _saving = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refreshDraft);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsAddSubtask,
    );
  }

  void _refreshDraft() {
    if (_controller.text.trim().isEmpty) {
      _draft?.clear();
    } else {
      _draft?.markDirty();
    }
  }

  @override
  void dispose() {
    _draft?.dispose();
    _controller.removeListener(_refreshDraft);
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
        onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
          context,
          _draft,
        ),
        onSubmit: _save,
        body: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TaskDetailsDialogMutationError(),
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
    final source = context.read<TaskDetailsCubit>();
    final saved = await source.createSubtask(text);
    if (!mounted) return;
    if (source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      _saving.value = false;
      return;
    }
    if (saved) {
      _draft?.clear();
      Navigator.of(context).pop();
    } else {
      _saving.value = false;
    }
  }
}
