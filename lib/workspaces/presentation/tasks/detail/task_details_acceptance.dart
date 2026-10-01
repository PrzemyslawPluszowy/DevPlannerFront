import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class AcceptanceCriteriaSection extends StatefulWidget {
  const AcceptanceCriteriaSection({
    required this.criteria,
    required this.isSaving,
    super.key,
  });

  final List<TaskAcceptanceCriterionResponse> criteria;
  final bool isSaving;

  @override
  State<AcceptanceCriteriaSection> createState() =>
      AcceptanceCriteriaSectionState();
}

class AcceptanceCriteriaSectionState extends State<AcceptanceCriteriaSection> {
  TaskDetailDraftRegistration? _draft;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refreshDraft);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsAddAcceptanceCriterion,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Section(
    title: context.l10n.taskDetailsAcceptanceCriteria,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            for (final criterion in widget.criteria)
              Row(
                children: [
                  Checkbox(
                    value: criterion.isAccepted,
                    onChanged: widget.isSaving
                        ? null
                        : (_) => unawaited(
                            context
                                .read<TaskDetailsCubit>()
                                .toggleAcceptanceCriterion(criterion),
                          ),
                  ),
                  Expanded(
                    child: Text(
                      criterion.text,
                      style: context.text.bodyMedium?.copyWith(
                        decoration: criterion.isAccepted
                            ? TextDecoration.lineThrough
                            : null,
                        color: criterion.isAccepted
                            ? context.colors.onSurfaceVariant
                            : null,
                      ),
                    ),
                  ),
                  if (criterion.isAccepted)
                    Icon(
                      Symbols.verified_rounded,
                      size: 17,
                      color: context.colors.primary,
                    ),
                  IconButton(
                    tooltip: context.l10n.taskDetailsEditAcceptanceCriterion,
                    onPressed: widget.isSaving
                        ? null
                        : () => TaskDetailsTextEditor.editAcceptanceCriterion(
                            context,
                            criterion,
                          ),
                    icon: const Icon(Symbols.edit, size: 17),
                  ),
                  IconButton(
                    tooltip: context.l10n.taskDetailsDeleteAcceptanceCriterion,
                    onPressed: widget.isSaving
                        ? null
                        : () => unawaited(
                            context
                                .read<TaskDetailsCubit>()
                                .deleteAcceptanceCriterion(criterion),
                          ),
                    icon: const Icon(Symbols.close_rounded, size: 18),
                  ),
                ],
              ),
            if (widget.criteria.isNotEmpty) const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !widget.isSaving,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _add(),
                    decoration: InputDecoration(
                      hintText: context.l10n.taskDetailsAddAcceptanceCriterion,
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: context.l10n.taskDetailsAddAcceptanceCriterion,
                  onPressed: widget.isSaving ? null : _add,
                  icon: widget.isSaving
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Symbols.add_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _add() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final added = await context.read<TaskDetailsCubit>().addAcceptanceCriterion(
      text,
    );
    if (mounted && added) {
      _controller.clear();
      _draft?.clear();
    }
  }
}

/// Otwiera edycję krótkiego tekstu i przekazuje mutacje do Cubita szczegółu.
///
/// Klasa zarządza tylko interakcją UI. Własność danych i I/O pozostają w
/// `TaskDetailsCubit`.
final class TaskDetailsTextEditor {
  const TaskDetailsTextEditor._();

  static Future<void> editChecklistItem(
    BuildContext context,
    TaskChecklistItemResponse item,
  ) {
    final cubit = context.read<TaskDetailsCubit>();
    return _show(
      context,
      title: context.l10n.taskDetailsEditChecklistItem,
      initialValue: item.title,
      onSave: (value) => cubit.updateChecklistItem(item, title: value),
    );
  }

  static Future<void> editAcceptanceCriterion(
    BuildContext context,
    TaskAcceptanceCriterionResponse criterion,
  ) {
    final cubit = context.read<TaskDetailsCubit>();
    return _show(
      context,
      title: context.l10n.taskDetailsEditAcceptanceCriterion,
      initialValue: criterion.text,
      onSave: (value) => cubit.updateAcceptanceCriterion(
        criterion,
        text: value,
      ),
    );
  }

  static Future<void> _show(
    BuildContext context, {
    required String title,
    required String initialValue,
    required Future<bool> Function(String value) onSave,
  }) {
    return DevPlannerModalHost.showDialog<void>(
      context,
      builder: (_) => BlocProvider.value(
        value: context.read<TaskDetailsCubit>(),
        child: TaskDetailsTextEditDialog(
          title: title,
          initialValue: initialValue,
          onSave: onSave,
        ),
      ),
    );
  }
}

class TaskDetailsTextEditDialog extends StatefulWidget {
  const TaskDetailsTextEditDialog({
    required this.title,
    required this.initialValue,
    required this.onSave,
    super.key,
  });

  final String title;
  final String initialValue;
  final Future<bool> Function(String value) onSave;

  @override
  State<TaskDetailsTextEditDialog> createState() =>
      TaskDetailsTextEditDialogState();
}

class TaskDetailsTextEditDialogState extends State<TaskDetailsTextEditDialog> {
  TaskDetailDraftRegistration? _draft;
  late final TextEditingController _controller;
  final ValueNotifier<bool> _saving = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_refreshDraft);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: widget.title,
    );
  }

  void _refreshDraft() {
    if (_controller.text == widget.initialValue) {
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
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: _saving,
    builder: (context, saving, _) => WorkspaceCreationModalWrapper(
      title: widget.title,
      icon: Symbols.check_circle_outline_rounded,
      accentColor: context.colors.primary,
      isSubmitting: saving,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      maxWidth: 460,
      onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
        context,
        _draft,
      ),
      onSubmit: saving ? null : _save,
      body: BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state case TaskDetailsReady(mutationFailure: final error?)) ...[
              TaskDetailsModalError(error: error),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _controller,
              autofocus: true,
              maxLength: 500,
              minLines: 1,
              maxLines: 4,
              enabled: !saving,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p12,
                ),
              ),
              onSubmitted: saving ? null : (_) => _save(),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _save() async {
    final value = _controller.text.trim();
    if (_saving.value || value.isEmpty) return;
    _saving.value = true;
    final source = context.read<TaskDetailsCubit>();
    final saved = await widget.onSave(value);
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
