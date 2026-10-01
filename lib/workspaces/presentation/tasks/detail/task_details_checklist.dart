import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_acceptance.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class ChecklistSection extends StatefulWidget {
  const ChecklistSection({required this.task, required this.isSaving, super.key});

  final ProjectTaskResponse task;
  final bool isSaving;

  @override
  State<ChecklistSection> createState() => ChecklistSectionState();
}

class ChecklistSectionState extends State<ChecklistSection> {
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
      label: context.l10n.taskDetailsAddChecklistItem,
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
  Widget build(BuildContext context) {
    final items = widget.task.checklistItems;
    final completed = items.where((item) => item.isCompleted).length;
    return Section(
      title: context.l10n.taskDetailsChecklist,
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
                            : () => TaskDetailsTextEditor.editChecklistItem(
                                context,
                                item,
                              ),
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
    if (mounted && added) {
      _controller.clear();
      _draft?.clear();
    }
  }
}
