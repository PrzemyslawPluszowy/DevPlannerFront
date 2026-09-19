import 'dart:ui';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/header/task_list_column_helper.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Horyzontalny pasek podglądu nagłówka tabeli w konfiguratorze kolumn.
///
/// Umożliwia przeciąganie kolumn w poziomie (reorder D&D) w celu ustalenia
/// ich dokładnej kolejności w tabeli, a także szybkie usuwanie kolumn (odłożenie do puli).
class TaskColumnHeaderPreviewStrip extends StatefulWidget {
  const TaskColumnHeaderPreviewStrip({
    required this.columns,
    required this.state,
    required this.cubit,
    required this.customFields,
    this.onReorder,
    this.onRemove,
    super.key,
  });

  final List<TaskColumnReference> columns;
  final TaskListPreferencesReady state;
  final TaskListPreferencesCubit cubit;
  final List<TaskCustomFieldResponse> customFields;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final void Function(TaskColumnReference column)? onRemove;

  @override
  State<TaskColumnHeaderPreviewStrip> createState() =>
      _TaskColumnHeaderPreviewStripState();
}

class _TaskColumnHeaderPreviewStripState
    extends State<TaskColumnHeaderPreviewStrip> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 70,
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: .circular(10),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        child: Scrollbar(
          controller: _scrollController,
          thickness: 4,
          radius: const Radius.circular(2),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: ReorderableListView.builder(
              scrollController: _scrollController,
              scrollDirection: Axis.horizontal,
              buildDefaultDragHandles: false,
              onReorderItem: widget.onReorder ?? widget.cubit.reorderColumns,
              itemCount: widget.columns.length,
              proxyDecorator: (child, index, animation) => Material(
                elevation: 6,
                color: Colors.transparent,
                shadowColor: colors.shadow.withValues(alpha: 0.3),
                borderRadius: .circular(6),
                child: child,
              ),
              itemBuilder: (context, index) {
                final col = widget.columns[index];
                final label = TaskListColumnHelper.referenceLabel(
                  context,
                  col,
                  customFields: widget.customFields,
                );
                final icon = TaskListColumnHelper.referenceIcon(
                  col,
                  customFields: widget.customFields,
                );
                final isRequired = widget.state.isColumnRequired(col.id);

                return Container(
                  key: ValueKey('preview-col-${col.id}'),
                  margin: const .only(right: 6),
                  padding: const .symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: .circular(6),
                    border: Border.all(
                      color: colors.outlineVariant.withValues(alpha: 0.6),
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.04),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      ReorderableDragStartListener(
                        index: index,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.grab,
                          child: Padding(
                            padding: const .only(right: 4),
                            child: Icon(
                              Symbols.drag_indicator_rounded,
                              size: 15,
                              color: colors.onSurfaceVariant.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        icon,
                        size: 14,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 5),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.labelSmall?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (isRequired)
                        Tooltip(
                          message: 'Kolumna wymagana',
                          child: Icon(
                            Symbols.lock_rounded,
                            size: 12,
                            color: colors.onSurfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        )
                      else
                        InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          borderRadius: .circular(4),
                          onTap: () {
                            if (widget.onRemove != null) {
                              widget.onRemove!(col);
                            } else {
                              widget.cubit.toggleColumn(col);
                            }
                          },
                          child: Padding(
                            padding: const .all(2),
                            child: Icon(
                              Symbols.close_rounded,
                              size: 13,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
