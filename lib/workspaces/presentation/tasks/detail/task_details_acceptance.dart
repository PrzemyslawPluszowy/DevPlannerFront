part of 'task_details_page.dart';

class _AcceptanceCriteriaSection extends StatefulWidget {
  const _AcceptanceCriteriaSection({
    required this.criteria,
    required this.isSaving,
  });

  final List<TaskAcceptanceCriterionResponse> criteria;
  final bool isSaving;

  @override
  State<_AcceptanceCriteriaSection> createState() =>
      _AcceptanceCriteriaSectionState();
}

class _AcceptanceCriteriaSectionState
    extends State<_AcceptanceCriteriaSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _Section(
    title: context.l10n.taskDetailsAcceptanceCriteria,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
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
    if (mounted && added) _controller.clear();
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
  ) async {
    final value = await _show(
      context,
      title: context.l10n.taskDetailsEditChecklistItem,
      initialValue: item.title,
    );
    if (value == null || !context.mounted) return;
    await context.read<TaskDetailsCubit>().updateChecklistItem(
      item,
      title: value,
    );
  }

  static Future<void> editAcceptanceCriterion(
    BuildContext context,
    TaskAcceptanceCriterionResponse criterion,
  ) async {
    final value = await _show(
      context,
      title: context.l10n.taskDetailsEditAcceptanceCriterion,
      initialValue: criterion.text,
    );
    if (value == null || !context.mounted) return;
    await context.read<TaskDetailsCubit>().updateAcceptanceCriterion(
      criterion,
      text: value,
    );
  }

  static Future<String?> _show(
    BuildContext context, {
    required String title,
    required String initialValue,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => WorkspaceCreationModalWrapper(
        title: title,
        icon: Symbols.check_circle_outline_rounded,
        accentColor: dialogContext.colors.primary,
        submitLabel: dialogContext.l10n.save,
        cancelLabel: dialogContext.l10n.cancel,
        maxWidth: 460,
        onSubmit: () {
          final normalized = controller.text.trim();
          if (normalized.isNotEmpty) {
            Navigator.of(dialogContext).pop(normalized);
          }
        },
        body: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              maxLength: 500,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p12,
                ),
              ),
              onSubmitted: (value) {
                final normalized = value.trim();
                if (normalized.isNotEmpty) {
                  Navigator.of(dialogContext).pop(normalized);
                }
              },
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    return result;
  }
}

/// Tłumaczy typ relacji zadania tylko dla widoku zależności.
final class TaskDependencyTypeLabeler {
  const TaskDependencyTypeLabeler._();

  static String label(BuildContext context, TaskDependencyType type) =>
      switch (type) {
        TaskDependencyType.blocks => context.l10n.taskDependencyBlocks,
        TaskDependencyType.relatedTo => context.l10n.taskDependencyRelated,
        TaskDependencyType.duplicate => context.l10n.taskDependencyDuplicate,
      };
}
