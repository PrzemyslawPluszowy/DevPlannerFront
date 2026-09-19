import 'dart:ui';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/widgets/components/task_column_pool_chip.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/header/task_list_column_helper.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wirtualizowana pula ukrytych kolumn z filtrowaniem po stronie interfejsu.
class TaskColumnsSheetColumnPool extends StatelessWidget {
  const TaskColumnsSheetColumnPool({
    required this.state,
    required this.customFields,
    required this.isProjectTab,
    required this.searchController,
    required this.scrollController,
    required this.query,
    required this.onQueryChanged,
    required this.onAdd,
    super.key,
  });

  final TaskListPreferencesReady state;
  final List<TaskCustomFieldResponse> customFields;
  final bool isProjectTab;
  final TextEditingController searchController;
  final ScrollController scrollController;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<TaskColumnReference> onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final hidden = _hiddenColumns(context);
    final systemHidden = hidden
        .where((column) => !column.isCustomField)
        .toList();
    final customHidden = hidden
        .where((column) => column.isCustomField)
        .toList();
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Dostępne do dodania (${hidden.length})',
              style: text.labelSmall?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 170,
              height: 30,
              child: TextField(
                controller: searchController,
                style: text.labelSmall,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Filtruj kolumny...',
                  hintStyle: text.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  prefixIcon: const Icon(Symbols.search_rounded, size: 15),
                  prefixIconConstraints: const BoxConstraints.tightFor(
                    width: 26,
                    height: 26,
                  ),
                  contentPadding: const .symmetric(horizontal: 6, vertical: 6),
                  border: OutlineInputBorder(
                    borderRadius: .circular(6),
                    borderSide: BorderSide(
                      color: colors.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                onChanged: (value) => onQueryChanged(value.trim()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  _ColumnPoolSection(
                    label: 'Kolumny standardowe',
                    columns: systemHidden,
                    customFields: customFields,
                    onAdd: onAdd,
                  ),
                  _ColumnPoolSection(
                    label: 'Pola własne projektu',
                    columns: customHidden,
                    customFields: customFields,
                    onAdd: onAdd,
                  ),
                  if (hidden.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const .symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            query.isEmpty
                                ? 'Wszystkie kolumny są już widoczne w tabeli.'
                                : 'Brak kolumn pasujących do filtra.',
                            style: text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<TaskColumnReference> _hiddenColumns(BuildContext context) {
    final visible = isProjectTab
        ? state.effectiveProjectDefaultColumns
        : state.effectiveVisibleColumns;
    final visibleIds = visible.map((column) => column.id.toLowerCase()).toSet();
    final all = <TaskColumnReference>[
      for (final column in TaskSavedViewColumn.values)
        TaskColumnReference.system(column),
      for (final field in customFields)
        TaskColumnReference.customField(field.id),
    ];
    return all.where((column) {
      if (visibleIds.contains(column.id.toLowerCase())) return false;
      if (query.isEmpty) return true;
      final label = TaskListColumnHelper.referenceLabel(
        context,
        column,
        customFields: customFields,
      );
      return label.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

class _ColumnPoolSection extends StatelessWidget {
  const _ColumnPoolSection({
    required this.label,
    required this.columns,
    required this.customFields,
    required this.onAdd,
  });

  final String label;
  final List<TaskColumnReference> columns;
  final List<TaskCustomFieldResponse> customFields;
  final ValueChanged<TaskColumnReference> onAdd;

  @override
  Widget build(BuildContext context) {
    if (columns.isEmpty) return const SliverToBoxAdapter();
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label,
              style: context.text.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 10.5,
              ),
            ),
          ),
        ),
        SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisExtent: 34,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemCount: columns.length,
          itemBuilder: (context, index) {
            final column = columns[index];
            return TaskColumnPoolChip(
              key: ValueKey(column.id),
              column: column,
              onAdd: () => onAdd(column),
              customFields: customFields,
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
      ],
    );
  }
}
