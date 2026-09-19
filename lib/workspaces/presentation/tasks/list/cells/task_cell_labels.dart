import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Komórka etykiet zadania w tabeli.
///
/// Wyświetla zwięzłe chipy etykiet w pojedynczym wierszu z licznikiem (+1, +2)
/// oraz umożliwia interaktywny wybór etykiet w wyskakującym panelu.
class TaskCellLabels extends StatelessWidget {
  const TaskCellLabels({
    required this.task,
    super.key,
    this.onChanged,
  });

  /// Zadanie z przypisanymi etykietami.
  final ProjectTaskListItemResponse task;

  /// Callback wywoływany przy zmianie listy identyfikatorów etykiet.
  final Future<bool> Function(List<String> labelIds)? onChanged;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (cellContext) => SizedBox(
      width: TaskListGrid.labels,
      child: InkWell(
        mouseCursor: onChanged != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onTap: onChanged == null
            ? null
            : () {
                final box = cellContext.findRenderObject() as RenderBox?;
                final pos = box != null
                    ? box.localToGlobal(Offset(0, box.size.height + 2))
                    : Offset.zero;
                unawaited(
                  _showLabelsMenu(
                    cellContext,
                    task,
                    onChanged!,
                    position: pos,
                  ),
                );
              },
        child: Padding(
          padding: const .symmetric(horizontal: 10),
          child: Align(
            alignment: .centerLeft,
            child: task.labels.isEmpty
                ? TaskCellEmptyPlaceholder(
                    icon: Symbols.label_outline_rounded,
                    tooltip: onChanged != null ? 'Dodaj etykiety' : null,
                    isInteractive: onChanged != null,
                  )
                : Tooltip(
                    message: task.labels.map((l) => l.name).join(', '),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        Flexible(
                          child: _TaskLabelChip(label: task.labels.first),
                        ),
                        if (task.labels.length > 1) ...[
                          const SizedBox(width: 4),
                          _TaskCountBadge(count: task.labels.length - 1),
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      ),
    ),
  );

  static Future<void> _showLabelsMenu(
    BuildContext context,
    ProjectTaskListItemResponse task,
    Future<bool> Function(List<String> labelIds) onChanged, {
    required Offset position,
  }) async {
    final cubit = context.read<ProjectTasksListCubit>();
    final result = await context.read<TaskMetadataRepository>().listLabels(
      workspaceId: cubit.workspaceId,
      projectId: cubit.projectId,
    );
    if (!context.mounted) return;
    final labels = result.fold<List<TaskLabelResponse>>(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
        return const [];
      },
      (items) => items,
    );
    if (labels.isEmpty) return;
    final selectedIds = task.labels.map((label) => label.id).toSet();
    await AppContextMenu.showCustom(
      context,
      globalPosition: position,
      maxWidth: 260,
      contentBuilder: (_, dismiss) => _LabelsMenuPanel(
        labels: labels,
        selectedIds: selectedIds,
        onChanged: onChanged,
      ),
    );
  }
}

class _TaskLabelChip extends StatelessWidget {
  const _TaskLabelChip({required this.label});

  final TaskLabelResponse label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: _parseLabelColor(label.color).withValues(alpha: .14),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Padding(
      padding: const .symmetric(horizontal: 6, vertical: 3),
      child: Text(
        label.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.labelSmall?.copyWith(
          color: _parseLabelColor(label.color),
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );

  static Color _parseLabelColor(String color) {
    final normalized = color.replaceFirst('#', '');
    final value = int.tryParse(normalized, radix: 16);
    return value == null ? const Color(0xFF64748B) : Color(0xFF000000 | value);
  }
}

class _TaskCountBadge extends StatelessWidget {
  const _TaskCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Padding(
      padding: const .symmetric(horizontal: 6, vertical: 3),
      child: Text(
        '+$count',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.labelSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class _LabelsMenuPanel extends StatefulWidget {
  const _LabelsMenuPanel({
    required this.labels,
    required this.selectedIds,
    required this.onChanged,
  });

  final List<TaskLabelResponse> labels;
  final Set<String> selectedIds;
  final Future<bool> Function(List<String> labelIds) onChanged;

  @override
  State<_LabelsMenuPanel> createState() => _LabelsMenuPanelState();
}

class _LabelsMenuPanelState extends State<_LabelsMenuPanel> {
  late final ValueNotifier<_LabelsMenuUiState> _ui = ValueNotifier(
    _LabelsMenuUiState(selectedIds: {...widget.selectedIds}),
  );

  @override
  void dispose() {
    _ui.dispose();
    super.dispose();
  }

  Future<void> _toggle(String labelId) async {
    final current = _ui.value;
    if (current.isSaving) return;
    final previous = {...current.selectedIds};
    final next = {...current.selectedIds};
    if (next.contains(labelId)) {
      next.remove(labelId);
    } else {
      next.add(labelId);
    }
    _ui.value = current.copyWith(selectedIds: next, isSaving: true);
    try {
      final success = await widget.onChanged(next.toList(growable: false));
      if (!mounted) return;
      if (!success) {
        _ui.value = _ui.value.copyWith(selectedIds: previous);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nie udało się zapisać etykiet zadania.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _ui.value = _ui.value.copyWith(selectedIds: previous);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd zapisu etykiet: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        _ui.value = _ui.value.copyWith(isSaving: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<_LabelsMenuUiState>(
        valueListenable: _ui,
        builder: (context, ui, _) => _buildContent(context, ui),
      );

  Widget _buildContent(BuildContext context, _LabelsMenuUiState ui) {
    final filtered = widget.labels
        .where(
          (l) => l.name.toLowerCase().contains(ui.query.toLowerCase().trim()),
        )
        .toList();

    return SizedBox(
      width: 260,
      child: Padding(
        padding: const .all(Sizes.p8),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              autofocus: true,
              style: context.text.bodySmall,
              decoration: InputDecoration(
                isDense: true,
                hintText: context.l10n.tasksListLabelsSearchHint,
                prefixIcon: const Icon(Symbols.search_rounded, size: 16),
                prefixIconConstraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 28,
                ),
                contentPadding: const .symmetric(
                  horizontal: Sizes.p8,
                  vertical: Sizes.p6,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: context.colors.outlineVariant.withValues(alpha: .5),
                  ),
                  borderRadius: const BorderRadius.all(
                    .circular(Sizes.p6),
                  ),
                ),
              ),
              onChanged: (val) => _ui.value = _ui.value.copyWith(query: val),
            ),
            const SizedBox(height: Sizes.p6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const .all(Sizes.p12),
                      child: Center(
                        child: Text(
                          context.l10n.tasksListLabelsEmpty,
                          style: context.text.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final label = filtered[index];
                        final isSelected = ui.selectedIds.contains(label.id);
                        return InkWell(
                          onTap: ui.isSaving ? null : () => _toggle(label.id),
                          borderRadius: const BorderRadius.all(
                            .circular(Sizes.p4),
                          ),
                          child: Padding(
                            padding: const .symmetric(
                              vertical: Sizes.p4,
                              horizontal: Sizes.p6,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: isSelected,
                                    onChanged: ui.isSaving
                                        ? null
                                        : (_) => _toggle(label.id),
                                    visualDensity: .compact,
                                  ),
                                ),
                                const SizedBox(width: Sizes.p6),
                                Expanded(
                                  child: _TaskLabelChip(label: label),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _LabelsMenuUiState {
  const _LabelsMenuUiState({
    required this.selectedIds,
    this.query = '',
    this.isSaving = false,
  });

  final Set<String> selectedIds;
  final String query;
  final bool isSaving;

  _LabelsMenuUiState copyWith({
    Set<String>? selectedIds,
    String? query,
    bool? isSaving,
  }) => _LabelsMenuUiState(
    selectedIds: selectedIds ?? this.selectedIds,
    query: query ?? this.query,
    isSaving: isSaving ?? this.isSaving,
  );
}
