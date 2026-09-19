import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_type_visual.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/header/task_list_column_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/header/task_list_header_cell.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

part 'task_list_draggable_header.part.dart';

/// Stały nagłówek tabeli zadań z obsługą unifikowanych kolumn, zmiany szerokości,
/// interaktywnego sortowania oraz otwierania arkusza konfiguracji kolumn.
class TaskListTableHeader extends StatelessWidget {
  const TaskListTableHeader({
    super.key,
    this.columnReferences,
    this.columns = const [],
    this.customFields = const [],
    this.onCustomFieldChanged,
    this.allSelected = false,
    this.onToggleAll,
    this.selectionTooltip,
    this.height = 42,
    this.columnWidths = const {},
    this.columnWidthsById = const {},
    this.onColumnWidthDelta,
    this.onColumnWidthDeltaById,
    this.onColumnResizeStart,
    this.onColumnResizeUpdate,
    this.onColumnResizeEnd,
    this.activeSortField,
    this.sortDirection,
    this.onSortField,
    this.onOpenColumnSettings,
    this.onReorderColumns,
  });

  /// Uporządkowana lista unifikowanych referencji kolumn (systemowych i własnych).
  final List<TaskColumnReference>? columnReferences;

  /// Lista systemowych kolumn widoku (wariant alternatywny/rezerwowy).
  final List<TaskSavedViewColumn> columns;

  /// Definicje pól niestandardowych projektu do wyświetlenia w nagłówku.
  final List<TaskCustomFieldResponse> customFields;

  /// Callback informujący o zmianie kolejności kolumn (Drag and Drop).
  final void Function(int oldIndex, int newIndex)? onReorderColumns;

  /// Callback wywoływany przy zmianie wartości pola niestandardowego.
  final Future<bool> Function(TaskCustomFieldResponse field, Object? value)?
  onCustomFieldChanged;

  /// Czy wszystkie widoczne zadania są aktualnie zaznaczone.
  final bool allSelected;

  /// Callback przełączający stan zaznaczenia wszystkich wierszy.
  final ValueChanged<bool>? onToggleAll;

  /// Podpowiedź dostępności dla checkboxa nagłówka.
  final String? selectionTooltip;

  /// Wysokość paska nagłówka.
  final double height;

  /// Ręcznie dostosowane szerokości kolumn systemowych.
  final Map<TaskSavedViewColumn, double> columnWidths;

  /// Zunifikowana mapa szerokości kolumn według klucza tekstowego (`sys:` / `cf:`).
  final Map<String, double> columnWidthsById;

  /// Callback informujący o zmianie szerokości kolumny systemowej.
  final void Function(TaskSavedViewColumn column, double delta)?
  onColumnWidthDelta;

  /// Zunifikowany callback zmiany szerokości kolumny według klucza ID.
  final void Function(String columnId, double delta)? onColumnWidthDeltaById;

  /// Callback rozpoczęcia zmiany szerokości kolumny przeciąganiem.
  final void Function(String columnId)? onColumnResizeStart;

  /// Callback ciągłej aktualizacji zmiany szerokości kolumny (delta pikseli).
  final void Function(String columnId, double delta)? onColumnResizeUpdate;

  /// Callback zakończenia zmiany szerokości kolumny.
  final void Function(String columnId)? onColumnResizeEnd;

  /// Bieżące pole sortowania listy.
  final TaskSavedViewSortField? activeSortField;

  /// Bieżący kierunek sortowania listy.
  final TaskSavedViewSortDirection? sortDirection;

  /// Callback wywoływany przy kliknięciu w kolumnę wspierającą sortowanie.
  final ValueChanged<TaskSavedViewSortField>? onSortField;

  /// Callback otwierający arkusz dostosowywania kolumn.
  final VoidCallback? onOpenColumnSettings;

  static TaskSavedViewSortField? _sortFieldForColumn(
    TaskSavedViewColumn column,
  ) => switch (column) {
    TaskSavedViewColumn.title => TaskSavedViewSortField.title,
    TaskSavedViewColumn.priority => TaskSavedViewSortField.priority,
    TaskSavedViewColumn.dueAtUtc => TaskSavedViewSortField.dueAtUtc,
    TaskSavedViewColumn.updatedAtUtc => TaskSavedViewSortField.updatedAtUtc,
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: TaskListGrid.selection,
            child: Row(
              mainAxisAlignment: .center,
              children: [
                SizedBox(
                  width: 28,
                  child: selectionTooltip == null
                      ? _buildSelectionCheckbox()
                      : Tooltip(
                          message: selectionTooltip,
                          child: _buildSelectionCheckbox(),
                        ),
                ),
                // Odstęp odpowiadający szerokości chevronu hierarchii w wierszu danych.
                const SizedBox(width: 18),
              ],
            ),
          ),
          if (columnReferences != null)
            for (var i = 0; i < columnReferences!.length; i++)
              _buildReferenceHeaderCell(
                context,
                columnReferences![i],
                index: i,
                totalCount: columnReferences!.length,
              )
          else ...[
            for (var i = 0; i < columns.length; i++)
              _buildSystemHeaderCell(
                context,
                columns[i],
                index: i,
                totalCount: columns.length,
              ),
            for (final field in customFields)
              _buildCustomFieldHeaderCell(context, field),
          ],
          if (onOpenColumnSettings != null)
            SizedBox(
              width: 36,
              child: Tooltip(
                message: l10n.tasksListColumnsTitle,
                child: IconButton(
                  icon: const Icon(Symbols.tune_rounded, size: 16),
                  onPressed: onOpenColumnSettings,
                  padding: EdgeInsets.zero,
                  visualDensity: .compact,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReferenceHeaderCell(
    BuildContext context,
    TaskColumnReference ref, {
    int? index,
    int? totalCount,
  }) {
    final id = ref.id;
    final width =
        columnWidthsById[id] ??
        (switch (ref) {
          SystemColumnReference(:final column) =>
            columnWidths[column] ?? TaskListGrid.width(column),
          CustomFieldColumnReference() => TaskListGrid.customField,
        });

    final label = TaskListColumnHelper.referenceLabel(
      context,
      ref,
      customFields: customFields,
    );
    final icon = TaskListColumnHelper.referenceIcon(
      ref,
      customFields: customFields,
    );

    final sortField = switch (ref) {
      SystemColumnReference(:final column) => _sortFieldForColumn(column),
      CustomFieldColumnReference() => null,
    };

    final canReorder =
        onReorderColumns != null &&
        index != null &&
        totalCount != null &&
        totalCount > 1;

    Widget buildCell(
      BuildContext context, [
      Widget Function(Widget child)? dragHandleBuilder,
    ]) {
      return TaskListHeaderCell(
        width: width,
        label: label,
        icon: icon,
        canReorder: canReorder,
        reorderHandleBuilder: dragHandleBuilder,
        sortDirection: activeSortField == sortField ? sortDirection : null,
        onTapSort: sortField != null && onSortField != null
            ? () => onSortField!(sortField)
            : null,
        onResizeStart: () => onColumnResizeStart?.call(id),
        onResizeUpdate: (delta) => onColumnResizeUpdate?.call(id, delta),
        onResizeEnd: () => onColumnResizeEnd?.call(id),
        onResizeDelta: onColumnResizeUpdate != null
            ? null
            : (delta) {
                onColumnWidthDeltaById?.call(id, delta);
                if (ref is SystemColumnReference) {
                  onColumnWidthDelta?.call(ref.column, delta);
                }
              },
      );
    }

    if (!canReorder) return buildCell(context);

    return _DraggableHeaderCellWrapper(
      index: index,
      width: width,
      height: height,
      label: label,
      icon: icon,
      onReorder: onReorderColumns,
      builder: buildCell,
    );
  }

  Widget _buildSystemHeaderCell(
    BuildContext context,
    TaskSavedViewColumn column, {
    int? index,
    int? totalCount,
  }) {
    final sortField = _sortFieldForColumn(column);
    final id = 'sys:${column.name}';
    final width =
        columnWidthsById[id] ??
        columnWidths[column] ??
        TaskListGrid.width(column);
    final label = TaskListColumnHelper.label(context, column);
    final icon = TaskListColumnHelper.icon(column);

    final canReorder =
        onReorderColumns != null &&
        index != null &&
        totalCount != null &&
        totalCount > 1;

    Widget buildCell(
      BuildContext context, [
      Widget Function(Widget child)? dragHandleBuilder,
    ]) {
      return TaskListHeaderCell(
        width: width,
        label: label,
        icon: icon,
        canReorder: canReorder,
        reorderHandleBuilder: dragHandleBuilder,
        sortDirection: activeSortField == sortField ? sortDirection : null,
        onTapSort: sortField != null && onSortField != null
            ? () => onSortField!(sortField)
            : null,
        onResizeStart: () => onColumnResizeStart?.call(id),
        onResizeUpdate: (delta) => onColumnResizeUpdate?.call(id, delta),
        onResizeEnd: () => onColumnResizeEnd?.call(id),
        onResizeDelta: onColumnResizeUpdate != null
            ? null
            : (delta) {
                onColumnWidthDeltaById?.call(id, delta);
                onColumnWidthDelta?.call(column, delta);
              },
      );
    }

    if (!canReorder) return buildCell(context);

    return _DraggableHeaderCellWrapper(
      index: index,
      width: width,
      height: height,
      label: label,
      icon: icon,
      onReorder: onReorderColumns,
      builder: buildCell,
    );
  }

  Widget _buildCustomFieldHeaderCell(
    BuildContext context,
    TaskCustomFieldResponse field,
  ) {
    final id = 'cf:${field.id}';
    final width = columnWidthsById[id] ?? TaskListGrid.customField;

    return TaskListHeaderCell(
      width: width,
      label: field.name,
      icon: CustomFieldTypeVisualCatalog.forType(field.type).icon,
      iconColor: CustomFieldTypeVisualCatalog.forType(field.type).color,
      onResizeStart: () => onColumnResizeStart?.call(id),
      onResizeUpdate: (delta) => onColumnResizeUpdate?.call(id, delta),
      onResizeEnd: () => onColumnResizeEnd?.call(id),
      onResizeDelta:
          onColumnResizeUpdate != null || onColumnWidthDeltaById == null
          ? null
          : (delta) => onColumnWidthDeltaById!(id, delta),
    );
  }

  Widget _buildSelectionCheckbox() => Checkbox(
    value: allSelected,
    semanticLabel: selectionTooltip,
    onChanged: onToggleAll == null
        ? null
        : (value) => onToggleAll!(value ?? false),
    visualDensity: .compact,
  );
}
