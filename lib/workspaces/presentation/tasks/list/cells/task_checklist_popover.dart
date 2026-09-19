import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_checklist_item_tile.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_checklist_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

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
  late final ValueNotifier<TaskChecklistUiState> _ui;

  @override
  void initState() {
    super.initState();
    _newItemController = TextEditingController();
    _newItemFocusNode = FocusNode();
    _ui = ValueNotifier(TaskChecklistUiState(version: widget.task.version));
    unawaited(_loadChecklist());
  }

  @override
  void dispose() {
    _newItemController.dispose();
    _newItemFocusNode.dispose();
    _ui.dispose();
    super.dispose();
  }

  Future<void> _loadChecklist({bool silent = false}) async {
    if (!silent) {
      _ui.value = _ui.value.copyWith(isLoading: true, clearError: true);
    }

    final taskRepo = context.read<TasksRepository>();
    final result = await taskRepo.getTask(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      taskId: widget.task.id,
    );

    if (!mounted) return;

    result.fold(
      (error) => _ui.value = _ui.value.copyWith(
        isLoading: silent ? null : false,
        errorMessage: error.message,
      ),
      (details) {
        _ui.value = _ui.value.copyWith(
          isLoading: silent ? null : false,
          items: details.task.checklistItems,
          version: details.task.version,
        );
        _notifyCounts();
      },
    );
  }

  void _notifyCounts() {
    final state = _ui.value;
    final completed = state.items.where((i) => i.isCompleted).length;
    widget.onCountsChanged?.call(completed, state.items.length, state.version);
  }

  Future<void> _toggleItem(TaskChecklistItemResponse item) async {
    final newCompleted = !item.isCompleted;
    final state = _ui.value;
    final updatedList = state.items.map((i) {
      if (i.id == item.id) {
        return i.copyWith(isCompleted: newCompleted);
      }
      return i;
    }).toList();

    _ui.value = state.copyWith(items: updatedList);
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
        expectedVersion: state.version,
      ),
    );

    if (!mounted) return;

    result.fold(
      (_) => unawaited(_loadChecklist()),
      (mutation) {
        _ui.value = _ui.value.copyWith(version: mutation.taskVersion);
        _notifyCounts();
      },
    );
  }

  Future<void> _addItem() async {
    final title = _newItemController.text.trim();
    final state = _ui.value;
    if (title.isEmpty || state.isSubmitting || state.isLoading) return;

    _ui.value = state.copyWith(isSubmitting: true, clearError: true);

    final checklistRepo = context.read<TaskChecklistRepository>();
    final result = await checklistRepo.addItem(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      taskId: widget.task.id,
      payload: CreateTaskChecklistItemPayload(
        title: title,
        expectedVersion: state.version,
      ),
    );

    if (!mounted) return;

    result.fold(
      (error) {
        _ui.value = _ui.value.copyWith(
          isSubmitting: false,
          errorMessage: error.message,
        );
        unawaited(_loadChecklist(silent: true));
      },
      (mutation) {
        _newItemController.clear();
        _ui.value = _ui.value.copyWith(
          isSubmitting: false,
          items: [..._ui.value.items, mutation.data],
          version: mutation.taskVersion,
        );
        _notifyCounts();
        _newItemFocusNode.requestFocus();
      },
    );
  }

  Future<void> _deleteItem(TaskChecklistItemResponse item) async {
    final state = _ui.value;
    _ui.value = state.copyWith(
      items: state.items.where((i) => i.id != item.id).toList(),
    );
    _notifyCounts();

    final checklistRepo = context.read<TaskChecklistRepository>();
    final result = await checklistRepo.deleteItem(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      taskId: widget.task.id,
      itemId: item.id,
      expectedVersion: state.version,
    );

    if (!mounted) return;

    result.fold(
      (_) => unawaited(_loadChecklist()),
      (mutation) {
        _ui.value = _ui.value.copyWith(version: mutation.taskVersion);
        _notifyCounts();
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<TaskChecklistUiState>(
        valueListenable: _ui,
        builder: (context, state, _) => _buildContent(context, state),
      );

  Widget _buildContent(BuildContext context, TaskChecklistUiState state) {
    final completedCount = state.items.where((i) => i.isCompleted).length;
    final totalCount = state.items.length;
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
                if (state.isLoading)
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
          if (state.errorMessage != null)
            Padding(
              padding: const .symmetric(horizontal: 16, vertical: 4),
              child: Text(
                state.errorMessage!,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: state.isLoading && state.items.isEmpty
                ? const SizedBox(
                    height: 80,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : state.items.isEmpty
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
                    itemCount: state.items.length,
                    padding: const .symmetric(horizontal: 8, vertical: 2),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return TaskChecklistItemTile(
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
                  icon: state.isSubmitting
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Symbols.add_rounded, size: 18),
                  visualDensity: .compact,
                  onPressed: state.isSubmitting ? null : _addItem,
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
