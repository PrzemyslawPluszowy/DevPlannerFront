import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dialog_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class EditBasicsDialog extends StatefulWidget {
  const EditBasicsDialog({required this.details, super.key});

  final ProjectTaskDetailsResponse details;

  @override
  State<EditBasicsDialog> createState() => EditBasicsDialogState();
}

class EditBasicsDialogState extends State<EditBasicsDialog> {
  TaskDetailDraftRegistration? _draft;
  late final TextEditingController _titleController;
  late final ValueNotifier<ProjectTaskStatus> _status;
  late final ValueNotifier<TaskPriority> _priority;
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  late final Listenable _formChanges;

  @override
  void initState() {
    super.initState();
    final task = widget.details.task;
    _titleController = TextEditingController(text: task.title);
    _status = ValueNotifier(task.status);
    _priority = ValueNotifier(task.priority);
    _titleController.addListener(_refreshDraft);
    _formChanges = Listenable.merge([
      _titleController,
      _status,
      _priority,
      _saving,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsEditBasics,
    );
  }

  void _refreshDraft() {
    final task = widget.details.task;
    final isDirty =
        _titleController.text != task.title ||
        _status.value != task.status ||
        _priority.value != task.priority;
    if (isDirty) {
      _draft?.markDirty();
    } else {
      _draft?.clear();
    }
  }

  @override
  void dispose() {
    _draft?.dispose();
    _titleController.removeListener(_refreshDraft);
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
      if (workflow.transitions.isEmpty) ...ProjectTaskStatus.values,
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
    final tasks = context.tasksTheme;

    return AnimatedBuilder(
      animation: _formChanges,
      builder: (context, _) => WorkspaceCreationModalWrapper(
        title: l10n.taskDetailsEditBasics,
        icon: Symbols.edit_note_rounded,
        accentColor: tasks.selectionAccent,
        isSubmitting: _saving.value,
        submitLabel: l10n.save,
        cancelLabel: l10n.cancel,
        maxWidth: 460,
        onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
          context,
          _draft,
        ),
        onSubmit: _save,
        body: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TaskDetailsDialogMutationError(hideConflict: true),
            TaskDetailsBasicsConflictNotice(
              draftTitle: _titleController.text,
              draftStatus: _status.value,
              draftPriority: _priority.value,
            ),
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
              maxLength: 240,
              enabled: !_saving.value,
              decoration: InputDecoration(
                hintText: l10n.taskDetailsTitleField,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(tasks.controlRadius),
                ),
                contentPadding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p12,
                ),
              ),
              onSubmitted: (_) => _save(),
            ),
            Gaps.h12,
            TaskDetailsSelectField<ProjectTaskStatus>(
              label: l10n.taskDetailsStatusField,
              value: _status.value,
              options: [
                for (final status in statuses)
                  TaskDetailsSelectOption(
                    value: status,
                    label: TaskDetailsLabeler.status(context, status),
                  ),
              ],
              enabled: !_saving.value,
              onChanged: (value) {
                _status.value = value;
                _refreshDraft();
              },
            ),
            Gaps.h12,
            TaskDetailsSelectField<TaskPriority>(
              label: l10n.taskDetailsPriorityField,
              value: _priority.value,
              options: [
                for (final priority in TaskPriority.values)
                  TaskDetailsSelectOption(
                    value: priority,
                    label: TaskDetailsLabeler.priority(context, priority),
                  ),
              ],
              enabled: !_saving.value,
              onChanged: (value) {
                _priority.value = value;
                _refreshDraft();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_saving.value) return;
    final title = _titleController.text.trim();
    if (title.isEmpty || title.length > 240) return;
    _saving.value = true;
    final cubit = context.read<TaskDetailsCubit>();
    try {
      final saved = await cubit.updateBasics(
        title: title,
        status: _status.value,
        priority: _priority.value,
      );
      if (!mounted) return;
      if (cubit.isClosed ||
          !identical(cubit, context.read<TaskDetailsCubit>())) {
        return;
      }
      if (saved) {
        _draft?.clear();
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) _saving.value = false;
    }
  }
}

class TaskDetailsBasicsConflictNotice extends StatelessWidget {
  const TaskDetailsBasicsConflictNotice({
    required this.draftTitle,
    required this.draftStatus,
    required this.draftPriority,
    super.key,
  });

  final String draftTitle;
  final ProjectTaskStatus draftStatus;
  final TaskPriority draftPriority;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) {
          if (state
              case TaskDetailsReady(
                mutationFailure: final error?,
                conflictBase: final base?,
              )
              when error.type == ApiErrorType.conflict) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: TaskDetailsModalError(
                error: error,
                conflictFields: [
                  TaskDetailsModalConflictField(
                    label: context.l10n.taskDetailsTitleField,
                    baseline: base.task.title,
                    current: state.details.task.title,
                    draft: draftTitle,
                  ),
                  TaskDetailsModalConflictField(
                    label: context.l10n.taskDetailsStatusField,
                    baseline: TaskDetailsLabeler.status(
                      context,
                      base.task.status,
                    ),
                    current: TaskDetailsLabeler.status(
                      context,
                      state.details.task.status,
                    ),
                    draft: TaskDetailsLabeler.status(context, draftStatus),
                  ),
                  TaskDetailsModalConflictField(
                    label: context.l10n.taskDetailsPriorityField,
                    baseline: TaskDetailsLabeler.priority(
                      context,
                      base.task.priority,
                    ),
                    current: TaskDetailsLabeler.priority(
                      context,
                      state.details.task.priority,
                    ),
                    draft: TaskDetailsLabeler.priority(context, draftPriority),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      );
}
