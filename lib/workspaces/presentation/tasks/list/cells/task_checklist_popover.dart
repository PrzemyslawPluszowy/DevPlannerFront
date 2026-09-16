import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';

/// Interaktywny popover checklisty zakotwiczony w komórce wiersza tabeli.
class TaskChecklistPopover extends StatefulWidget {
  const TaskChecklistPopover({
    required this.task,
    required this.workspaceId,
    required this.projectId,
    super.key,
    this.onCountsChanged,
  });

  final ProjectTaskListItemResponse task;
  final String workspaceId;
  final String projectId;
  final void Function(int completedCount, int totalCount, int? newVersion)?
  onCountsChanged;

  @override
  State<TaskChecklistPopover> createState() => _TaskChecklistPopoverState();
}

class _TaskChecklistPopoverState extends State<TaskChecklistPopover> {
  late final TextEditingController _newItemController;
  late final FocusNode _newItemFocusNode;

  List<TaskChecklistItemResponse> _items = const [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  late int _taskVersion;

  @override
  void initState() {
    super.initState();
    _newItemController = TextEditingController();
    _newItemFocusNode = FocusNode();
    _taskVersion = widget.task.version;
    unawaited(_loadChecklist());
  }

  @override
  void dispose() {
    _newItemController.dispose();
    _newItemFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadChecklist({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    final taskRepo = context.read<TasksRepository>();
    final result = await taskRepo.getTask(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      taskId: widget.task.id,
    );

    if (!mounted) return;

    result.fold(
      (error) => setState(() {
        if (!silent) _isLoading = false;
        _errorMessage = error.message;
      }),
      (details) {
        setState(() {
          if (!silent) _isLoading = false;
          _items = details.task.checklistItems;
          _taskVersion = details.task.version;
        });
        _notifyCounts();
      },
    );
  }

  void _notifyCounts() {
    final completed = _items.where((i) => i.isCompleted).length;
    final total = _items.length;
    widget.onCountsChanged?.call(completed, total, _taskVersion);
  }

  Future<void> _toggleItem(TaskChecklistItemResponse item) async {
    final newCompleted = !item.isCompleted;
    final updatedList = _items.map((i) {
      if (i.id == item.id) {
        return i.copyWith(isCompleted: newCompleted);
      }
      return i;
    }).toList();

    setState(() => _items = updatedList);
    _notifyCounts();

    final checklistRepo = context.read<TaskChecklistRepository>();
    final result = await checklistRepo.updateItem(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      taskId: widget.task.id,
      itemId: item.id,
      payload: UpdateTaskChecklistItemPayload(
        title: item.title,
        position: item.position,
        isCompleted: newCompleted,
        expectedVersion: _taskVersion,
      ),
    );

    if (!mounted) return;

    result.fold(
      (_) => unawaited(_loadChecklist()),
      (mutation) {
        _taskVersion = mutation.taskVersion;
        _notifyCounts();
      },
    );
  }

  Future<void> _addItem() async {
    final title = _newItemController.text.trim();
    if (title.isEmpty || _isSubmitting || _isLoading) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final checklistRepo = context.read<TaskChecklistRepository>();
    final result = await checklistRepo.addItem(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      taskId: widget.task.id,
      payload: CreateTaskChecklistItemPayload(
        title: title,
        expectedVersion: _taskVersion,
      ),
    );

    if (!mounted) return;

    result.fold(
      (error) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = error.message;
        });
        unawaited(_loadChecklist(silent: true));
      },
      (mutation) {
        _newItemController.clear();
        setState(() {
          _isSubmitting = false;
          _items = [..._items, mutation.data];
          _taskVersion = mutation.taskVersion;
        });
        _notifyCounts();
        _newItemFocusNode.requestFocus();
      },
    );
  }

  Future<void> _deleteItem(TaskChecklistItemResponse item) async {
    setState(() {
      _items = _items.where((i) => i.id != item.id).toList();
    });
    _notifyCounts();

    final checklistRepo = context.read<TaskChecklistRepository>();
    final result = await checklistRepo.deleteItem(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      taskId: widget.task.id,
      itemId: item.id,
      expectedVersion: _taskVersion,
    );

    if (!mounted) return;

    result.fold(
      (_) => unawaited(_loadChecklist()),
      (mutation) {
        _taskVersion = mutation.taskVersion;
        _notifyCounts();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _items.where((i) => i.isCompleted).length;
    final totalCount = _items.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return SizedBox(
      width: 340,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const .fromLTRB(16, 12, 12, 8),
            child: Row(
              children: [
                Icon(
                  Symbols.checklist_rounded,
                  size: 18,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.tasksListChecklistTitle,
                  style: context.text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                if (totalCount > 0)
                  Container(
                    padding: const .symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: progress == 1.0
                          ? const Color(0xFF10B981).withValues(alpha: .15)
                          : context.colors.surfaceContainerHighest,
                      borderRadius: const BorderRadius.all(.circular(10)),
                    ),
                    child: Text(
                      '$completedCount/$totalCount',
                      style: context.text.labelSmall?.copyWith(
                        color: progress == 1.0
                            ? const Color(0xFF10B981)
                            : context.colors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                const Spacer(),
                if (_isLoading)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          if (totalCount > 0)
            Padding(
              padding: const .symmetric(horizontal: 16, vertical: 2),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(.circular(2)),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: context.colors.surfaceContainerHighest,
                  color: progress == 1.0
                      ? const Color(0xFF10B981)
                      : context.colors.primary,
                ),
              ),
            ),
          const Divider(height: 8),
          if (_errorMessage != null)
            Padding(
              padding: const .symmetric(horizontal: 16, vertical: 4),
              child: Text(
                _errorMessage!,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: _isLoading && _items.isEmpty
                ? const SizedBox(
                    height: 80,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _items.isEmpty
                ? Padding(
                    padding: const .all(16),
                    child: Center(
                      child: Text(
                        context.l10n.tasksListChecklistEmpty,
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _items.length,
                    padding: const .symmetric(horizontal: 8, vertical: 2),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return _ChecklistItemTile(
                        item: item,
                        onToggle: () => _toggleItem(item),
                        onDelete: () => _deleteItem(item),
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const .fromLTRB(12, 6, 12, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newItemController,
                    focusNode: _newItemFocusNode,
                    style: context.text.bodySmall,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addItem(),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: context.l10n.tasksListChecklistNewItemHint,
                      hintStyle: context.text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant.withValues(
                          alpha: .6,
                        ),
                      ),
                      contentPadding: const .symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(.circular(6)),
                        borderSide: BorderSide(
                          color: context.colors.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Symbols.add_rounded, size: 18),
                  visualDensity: .compact,
                  onPressed: _isSubmitting ? null : _addItem,
                  tooltip: context.l10n.tasksListChecklistAddItem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItemTile extends StatefulWidget {
  const _ChecklistItemTile({
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  final TaskChecklistItemResponse item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  State<_ChecklistItemTile> createState() => _ChecklistItemTileState();
}

class _ChecklistItemTileState extends State<_ChecklistItemTile> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: InkWell(
        borderRadius: const BorderRadius.all(.circular(4)),
        onTap: widget.onToggle,
        child: Padding(
          padding: const .symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: item.isCompleted,
                  visualDensity: .compact,
                  onChanged: (_) => widget.onToggle(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    decoration: item.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: item.isCompleted
                        ? context.colors.onSurfaceVariant.withValues(alpha: .6)
                        : context.colors.onSurface,
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isHovered,
                builder: (context, isHovered, _) {
                  if (!isHovered) return const SizedBox(width: 24);
                  return IconButton(
                    icon: Icon(
                      Symbols.delete_rounded,
                      size: 14,
                      color: context.colors.error,
                    ),
                    visualDensity: .compact,
                    constraints: const BoxConstraints.tightFor(
                      width: 24,
                      height: 24,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: widget.onDelete,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
