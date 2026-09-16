part of 'task_details_page.dart';

class _ChecklistSection extends StatefulWidget {
  const _ChecklistSection({required this.task, required this.isSaving});

  final ProjectTaskResponse task;
  final bool isSaving;

  @override
  State<_ChecklistSection> createState() => _ChecklistSectionState();
}

class _ChecklistSectionState extends State<_ChecklistSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.task.checklistItems;
    final completed = items.where((item) => item.isCompleted).length;
    return _Section(
      title: context.l10n.taskDetailsChecklist,
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
              if (items.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          value: completed / items.length,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '$completed/${items.length}',
                      style: context.text.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                for (final item in items)
                  Row(
                    children: [
                      Checkbox(
                        value: item.isCompleted,
                        onChanged: widget.isSaving
                            ? null
                            : (_) => unawaited(
                                context
                                    .read<TaskDetailsCubit>()
                                    .toggleChecklistItem(item),
                              ),
                      ),
                      Expanded(
                        child: Text(
                          item.title,
                          style: context.text.bodyMedium?.copyWith(
                            decoration: item.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: item.isCompleted
                                ? context.colors.onSurfaceVariant
                                : null,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: context.l10n.taskDetailsEditChecklistItem,
                        onPressed: widget.isSaving
                            ? null
                            : () => _editChecklistItem(context, item),
                        icon: const Icon(Symbols.edit, size: 17),
                      ),
                      IconButton(
                        tooltip: context.l10n.taskDetailsDeleteChecklistItem,
                        onPressed: widget.isSaving
                            ? null
                            : () => unawaited(
                                context
                                    .read<TaskDetailsCubit>()
                                    .deleteChecklistItem(item),
                              ),
                        icon: const Icon(Symbols.close_rounded, size: 18),
                      ),
                    ],
                  ),
                const Divider(height: 20),
              ],
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !widget.isSaving,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _add(),
                      decoration: InputDecoration(
                        hintText: context.l10n.taskDetailsAddChecklistItem,
                        isDense: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: context.l10n.taskDetailsAddChecklistItem,
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
  }

  Future<void> _add() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    final added = await context.read<TaskDetailsCubit>().addChecklistItem(
      title,
    );
    if (mounted && added) _controller.clear();
  }
}
