import 'package:flutter/material.dart';

import 'table_column.dart';
import 'table_view.dart';
import 'table_view_controller.dart';
import 'table_view_style.dart';

typedef SearchableTableCellBuilder<T> = Widget Function(
    BuildContext context, T row);
typedef SearchableTableSearchMatcher<T> = bool Function(T row, String query);
typedef SearchableTableRowHoverChanged<T> = void Function(
    T row, bool isHovered);
typedef SearchableTableRowTap<T> = void Function(
    BuildContext context, T row, int sourceIndex);
typedef SearchableTableRowRightTap<T> = void Function(
    BuildContext context, T row, int sourceIndex, Offset globalPosition);

@immutable
class SearchableTableColumn<T> {
  const SearchableTableColumn({
    required this.label,
    required this.cellBuilder,
    required this.width,
    this.numeric = false,
    this.minResizeWidth,
    this.maxResizeWidth,
  });

  final String label;
  final SearchableTableCellBuilder<T> cellBuilder;
  final bool numeric;
  final double width;
  final double? minResizeWidth;
  final double? maxResizeWidth;
}

/// Wrapper nad [TableView] z gotowa wyszukiwarka i callbackiem hover.
class SearchableTableView<T> extends StatefulWidget {
  const SearchableTableView({
    super.key,
    required this.columns,
    required this.rows,
    this.style,
    this.controller,
    this.rowHeight = 44,
    this.headerHeight = 44,
    this.physics,
    this.physicsHorizontal,
    this.minScrollableWidth,
    this.minScrollableWidthRatio,
    this.shrinkWrapHorizontal = false,
    this.shrinkWrapVertical = false,
    this.searchHintText = 'Szukaj...',
    this.searchMatcher,
    this.onSearchChanged,
    this.onRowHoverChanged,
    this.onRowTap,
    this.onRowRightTap,
    this.headerBackgroundColor,
    this.cellHorizontalPadding = 12,
    this.cellVerticalPadding = 8,
    this.searchFieldMaxWidth,
    this.searchFieldDense = true,
  });

  final List<SearchableTableColumn<T>> columns;
  final List<T> rows;
  final TableViewStyle? style;
  final TableViewController? controller;
  final double rowHeight;
  final double headerHeight;
  final ScrollPhysics? physics;
  final ScrollPhysics? physicsHorizontal;
  final double? minScrollableWidth;
  final double? minScrollableWidthRatio;
  final bool shrinkWrapHorizontal;
  final bool shrinkWrapVertical;
  final String searchHintText;
  final SearchableTableSearchMatcher<T>? searchMatcher;
  final ValueChanged<String>? onSearchChanged;
  final SearchableTableRowHoverChanged<T>? onRowHoverChanged;
  final SearchableTableRowTap<T>? onRowTap;
  final SearchableTableRowRightTap<T>? onRowRightTap;
  final Color? headerBackgroundColor;
  final double cellHorizontalPadding;
  final double cellVerticalPadding;
  final double? searchFieldMaxWidth;
  final bool searchFieldDense;

  @override
  State<SearchableTableView<T>> createState() => _SearchableTableViewState<T>();
}

class _SearchableTableViewState<T> extends State<SearchableTableView<T>> {
  final searchController = TextEditingController();
  final focusNode = FocusNode();
  late List<int> filteredIndexes = _buildFilteredIndexes('');
  int? hoveredSourceIndex;

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchableTableView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rows.length != widget.rows.length ||
        oldWidget.rows != widget.rows) {
      filteredIndexes = _buildFilteredIndexes(searchController.text);
    }
  }

  List<int> _buildFilteredIndexes(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return List<int>.generate(widget.rows.length, (index) => index);
    }

    final matcher = widget.searchMatcher ?? _defaultMatcher;
    final result = <int>[];
    for (var i = 0; i < widget.rows.length; i++) {
      if (matcher(widget.rows[i], normalized)) {
        result.add(i);
      }
    }
    return result;
  }

  bool _defaultMatcher(T row, String query) {
    return row.toString().toLowerCase().contains(query);
  }

  void _onSearchTextChanged(String value) {
    setState(() => filteredIndexes = _buildFilteredIndexes(value));
    widget.onSearchChanged?.call(value);
  }

  void _setHoveredRow(T row, int sourceIndex, bool hovered) {
    if (!hovered) {
      if (hoveredSourceIndex == sourceIndex) {
        setState(() => hoveredSourceIndex = null);
      }
      widget.onRowHoverChanged?.call(row, false);
      return;
    }

    if (hoveredSourceIndex != sourceIndex) {
      setState(() => hoveredSourceIndex = sourceIndex);
    }
    widget.onRowHoverChanged?.call(row, true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final searchField = TextField(
      controller: searchController,
      focusNode: focusNode,
      onChanged: _onSearchTextChanged,
      decoration: InputDecoration(
        isDense: widget.searchFieldDense,
        hintText: widget.searchHintText,
        prefixIcon: const Icon(Icons.search_rounded, size: 18),
        filled: true,
        fillColor: colors.surfaceContainerLowest,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: colors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
      ),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: widget.searchFieldMaxWidth == null
              ? searchField
              : Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: widget.searchFieldMaxWidth,
                    child: searchField,
                  ),
                ),
        ),
        Expanded(
          child: TableView.builder(
            style: widget.style,
            controller: widget.controller,
            columns: [
              for (final column in widget.columns)
                TableColumn(
                  width: column.width,
                  minResizeWidth: column.minResizeWidth,
                  maxResizeWidth: column.maxResizeWidth,
                ),
            ],
            rowCount: filteredIndexes.length,
            rowHeight: widget.rowHeight,
            headerHeight: widget.headerHeight,
            physics: widget.physics,
            physicsHorizontal: widget.physicsHorizontal,
            minScrollableWidth: widget.minScrollableWidth,
            minScrollableWidthRatio: widget.minScrollableWidthRatio,
            shrinkWrapHorizontal: widget.shrinkWrapHorizontal,
            shrinkWrapVertical: widget.shrinkWrapVertical,
            headerBuilder: (context, contentBuilder) {
              final bg = widget.headerBackgroundColor ??
                  Theme.of(context).colorScheme.surfaceContainerLow;
              return Material(
                color: bg,
                child: contentBuilder(
                  context,
                  (context, columnIndex) {
                    final column = widget.columns[columnIndex];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.cellHorizontalPadding,
                        vertical: widget.cellVerticalPadding,
                      ),
                      child: Text(
                        column.label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign:
                            column.numeric ? TextAlign.right : TextAlign.left,
                      ),
                    );
                  },
                ),
              );
            },
            rowBuilder: (context, rowIndex, contentBuilder) {
              final sourceIndex = filteredIndexes[rowIndex];
              final row = widget.rows[sourceIndex];
              final hovered = hoveredSourceIndex == sourceIndex;
              final odd = rowIndex.isOdd;
              final backgroundColor = hovered
                  ? colors.primaryContainer.withValues(alpha: .32)
                  : odd
                      ? colors.surfaceContainerLow.withValues(alpha: .45)
                      : colors.surfaceContainerLowest;

              return MouseRegion(
                onEnter: (_) => _setHoveredRow(row, sourceIndex, true),
                onExit: (_) => _setHoveredRow(row, sourceIndex, false),
                child: Material(
                  color: backgroundColor,
                  child: InkWell(
                    onTap: widget.onRowTap == null
                        ? null
                        : () => widget.onRowTap!(context, row, sourceIndex),
                    onSecondaryTapDown: widget.onRowRightTap == null
                        ? null
                        : (details) => widget.onRowRightTap!(
                              context,
                              row,
                              sourceIndex,
                              details.globalPosition,
                            ),
                    child: contentBuilder(
                      context,
                      (context, columnIndex) {
                        final column = widget.columns[columnIndex];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.cellHorizontalPadding,
                            vertical: widget.cellVerticalPadding,
                          ),
                          child: Align(
                            alignment: column.numeric
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: column.cellBuilder(context, row),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
