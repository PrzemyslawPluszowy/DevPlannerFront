import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef AppSimpleTableCellBuilder<T> =
    Widget Function(
      BuildContext context,
      T row,
    );
typedef AppSimpleTableIndexedCellBuilder<T> =
    Widget Function(
      BuildContext context,
      T row,
      int sourceIndex,
      int visibleIndex,
    );
typedef AppSimpleTableCellColorResolver<T> =
    Color? Function(
      BuildContext context,
      T row,
    );
typedef AppSimpleTableRowColorResolver<T> =
    Color? Function(
      BuildContext context,
      T row,
    );
typedef AppSimpleTableSortValueResolver<T> = Object? Function(T row);
typedef AppSimpleTableSearchMatcher<T> = bool Function(T row, String query);
typedef AppSimpleTableRowTap<T> =
    void Function(
      BuildContext context,
      T row,
      int sourceIndex,
    );
typedef AppSimpleTableRowSecondaryTap<T> =
    void Function(
      BuildContext context,
      T row,
      int sourceIndex,
      TapDownDetails details,
    );

/// Definicja kolumny dla [AppSimpleTable].
class AppSimpleTableColumn<T> {
  const AppSimpleTableColumn({
    required this.label,
    required this.width,
    required this.cellBuilder,
    this.indexedCellBuilder,
    this.numeric = false,
    this.sortable = true,
    this.sortValue,
    this.minResizeWidth,
    this.maxResizeWidth,
    this.cellBackgroundColor,
    this.cellAlignment,
    this.tooltip,
  });

  final String label;
  final double width;
  final AppSimpleTableIndexedCellBuilder<T>? indexedCellBuilder;
  final bool numeric;
  final bool sortable;
  final AppSimpleTableSortValueResolver<T>? sortValue;
  final AppSimpleTableCellBuilder<T> cellBuilder;
  final double? minResizeWidth;
  final double? maxResizeWidth;
  final AppSimpleTableCellColorResolver<T>? cellBackgroundColor;
  final AlignmentGeometry? cellAlignment;
  final String? tooltip;
}

/// Lekka tabela do typowych ekranow CRM.
class AppSimpleTable<T> extends StatefulWidget {
  const AppSimpleTable({
    required this.rows,
    required this.columns,
    super.key,
    this.title,
    this.subtitle,
    this.showSearch = false,
    this.searchHintText = 'Szukaj...',
    this.searchMatcher,
    this.searchController,
    this.onSearchChanged,
    this.onRowTap,
    this.onRowSecondaryTap,
    this.showColumnHeader = true,
    this.enableColumnResize = true,
    this.rowHeight = 44,
    this.headerHeight = 44,
    this.height = 360,
    this.searchFieldMaxWidth = 300,
    this.searchInlineLabel,
    this.minScrollableWidthRatio,
    this.headerBackgroundColor,
    this.stateId,
    this.persistState = false,
    this.footer,
    this.simpleExcelMode = false,
    this.tableController,
    this.rowKeyBuilder,
    this.highlightedRowKey,
    this.rowBackgroundColor,
    this.onVisibleRowsChanged,
    this.scrollbarAlwaysVisible = false,
  });

  final List<T> rows;
  final List<AppSimpleTableColumn<T>> columns;
  final String? title;
  final String? subtitle;
  final bool showSearch;
  final String searchHintText;
  final AppSimpleTableSearchMatcher<T>? searchMatcher;
  final AppSearchTextFieldController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final AppSimpleTableRowTap<T>? onRowTap;
  final AppSimpleTableRowSecondaryTap<T>? onRowSecondaryTap;
  final bool showColumnHeader;
  final bool enableColumnResize;
  final double rowHeight;
  final double headerHeight;
  final double? height;
  final double searchFieldMaxWidth;
  final String? searchInlineLabel;
  final double? minScrollableWidthRatio;
  final Color? headerBackgroundColor;
  final String? stateId;
  final bool persistState;
  final Widget? footer;
  final bool simpleExcelMode;
  final TableViewController? tableController;
  final Object? Function(T row)? rowKeyBuilder;
  final Object? highlightedRowKey;
  final AppSimpleTableRowColorResolver<T>? rowBackgroundColor;
  final ValueChanged<List<T>>? onVisibleRowsChanged;
  final bool scrollbarAlwaysVisible;

  @override
  State<AppSimpleTable<T>> createState() => _AppSimpleTableState<T>();
}

class _AppSimpleTableState<T> extends State<AppSimpleTable<T>> {
  static const _storagePrefix = 'app_simple_table_state_v1';
  final TableViewController _ownedTableController = TableViewController();
  final AppSearchTextFieldController _searchController =
      AppSearchTextFieldController();
  late List<double> columnWidths;
  String query = '';
  int? sortedColumnIndex;
  bool sortAscending = true;
  int? hoveredRowIndex;
  Timer? _persistTimer;

  TableViewController get _tableController =>
      widget.tableController ?? _ownedTableController;

  AppSearchTextFieldController get _effectiveSearchController =>
      widget.searchController ?? _searchController;

  @override
  void initState() {
    super.initState();
    columnWidths = widget.columns.map((c) => c.width).toList();
    unawaited(_restoreState());
  }

  @override
  void dispose() {
    _persistTimer?.cancel();
    if (widget.searchController == null) {
      _searchController.dispose();
    }
    _ownedTableController.dispose();
    super.dispose();
  }

  void _schedulePersist() {
    if (!_canPersist) return;
    _persistTimer?.cancel();
    _persistTimer = Timer(const Duration(milliseconds: 500), () {
      unawaited(_persistState());
    });
  }

  bool get _canPersist {
    final stateId = widget.stateId?.trim();
    return widget.persistState && stateId != null && stateId.isNotEmpty;
  }

  String get _storageKey => '$_storagePrefix:${widget.stateId}';

  Future<void> _restoreState() async {
    if (!_canPersist) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return;
      }

      final persistedSortedIndex = decoded['sortedColumnIndex'] as int?;
      final persistedSortAscending = decoded['sortAscending'] as bool?;
      final persistedQuery = decoded['query'] as String?;
      final persistedWidthsRaw = decoded['columnWidths'] as List<dynamic>?;

      final persistedWidths = persistedWidthsRaw
          ?.map((value) => (value as num?)?.toDouble())
          .whereType<double>()
          .toList(growable: false);

      if (!mounted) {
        return;
      }

      setState(() {
        if (persistedSortedIndex != null &&
            persistedSortedIndex >= 0 &&
            persistedSortedIndex < widget.columns.length) {
          sortedColumnIndex = persistedSortedIndex;
        }

        if (persistedSortAscending != null) {
          sortAscending = persistedSortAscending;
        }

        if (persistedQuery != null) {
          query = persistedQuery;
          _effectiveSearchController.setQuery(persistedQuery);
          widget.onSearchChanged?.call(persistedQuery);
        }

        if (persistedWidths != null &&
            persistedWidths.length == widget.columns.length) {
          columnWidths = [
            for (var i = 0; i < persistedWidths.length; i++)
              persistedWidths[i].clamp(
                widget.columns[i].minResizeWidth ?? 40.0,
                widget.columns[i].maxResizeWidth ?? 800.0,
              ),
          ];
        }
      });
    } catch (_) {
      // Ignore corrupted persisted state.
    }
  }

  @override
  void didUpdateWidget(covariant AppSimpleTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.columns.length != oldWidget.columns.length) {
      columnWidths = widget.columns.map((c) => c.width).toList();
    }
    if (sortedColumnIndex != null &&
        sortedColumnIndex! >= widget.columns.length) {
      sortedColumnIndex = null;
    }
  }

  Future<void> _persistState() async {
    if (!_canPersist) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final payload = <String, Object?>{
      'sortedColumnIndex': sortedColumnIndex,
      'sortAscending': sortAscending,
      'query': query,
      'columnWidths': columnWidths,
    };
    await prefs.setString(_storageKey, jsonEncode(payload));
  }

  void _toggleSort(int index) {
    if (!widget.columns[index].sortable) return;

    setState(() {
      if (sortedColumnIndex == index) {
        sortAscending = !sortAscending;
      } else {
        sortedColumnIndex = index;
        sortAscending = true;
      }
    });
    _schedulePersist();
  }

  void _resizeColumn(int index, double delta) {
    if (!widget.enableColumnResize) return;

    setState(() {
      final newWidth = columnWidths[index] + delta;
      final column = widget.columns[index];
      final min = column.minResizeWidth ?? 40.0;
      final max = column.maxResizeWidth ?? 800.0;
      columnWidths[index] = newWidth.clamp(min, max);
    });
    _schedulePersist();
  }

  List<int> _getVisibleIndexes() {
    final indexes = List.generate(widget.rows.length, (i) => i);

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      indexes.removeWhere((i) {
        final row = widget.rows[i];
        if (widget.searchMatcher != null) {
          return !widget.searchMatcher!(row, query);
        }
        // Fallback: proste przeszukiwanie pol tekstowych.
        return !row.toString().toLowerCase().contains(lowerQuery);
      });
    }

    if (sortedColumnIndex != null) {
      final column = widget.columns[sortedColumnIndex!];
      indexes.sort((a, b) {
        final rowA = widget.rows[a];
        final rowB = widget.rows[b];
        final valA = column.sortValue?.call(rowA) ?? rowA.toString();
        final valB = column.sortValue?.call(rowB) ?? rowB.toString();

        if (valA is Comparable && valB is Comparable) {
          return sortAscending ? valA.compareTo(valB) : valB.compareTo(valA);
        }
        return 0;
      });
    }

    return indexes;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final visibleIndexes = _getVisibleIndexes();
    final visibleRows = visibleIndexes
        .map((index) => widget.rows[index])
        .toList(growable: false);
    final hasHeader = widget.title != null || widget.subtitle != null;
    final gridColor = colors.outlineVariant.withValues(
      alpha: widget.simpleExcelMode ? .6 : .28,
    );
    final cellVerticalPadding = widget.simpleExcelMode ? Sizes.p4 : Sizes.p8;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      widget.onVisibleRowsChanged?.call(visibleRows);
    });

    final decoration = BoxDecoration(
      color: colors.surfaceContainerLowest,
      borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
      border: Border.all(color: colors.outlineVariant),
    );
    final minimumTableHeight =
        (widget.showColumnHeader ? widget.headerHeight : 0) + Sizes.p24;

    Widget tableContainer(Widget child) {
      return Container(
        decoration: decoration,
        clipBehavior: .antiAlias,
        child: child,
      );
    }

    Widget constrainedFallback() {
      return tableContainer(
        Center(
          child: Text(
            'Za mało miejsca na wyświetlenie tabeli.',
            textAlign: .center,
            style: context.text.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final tableView = TableView.builder(
      controller: _tableController,
      style: widget.scrollbarAlwaysVisible
          ? const TableViewStyle(
              scrollbars: TableViewScrollbarsStyle.symmetric(
                TableViewScrollbarStyle(
                  enabled: TableViewScrollbarEnabled.always,
                  thumbVisibility: WidgetStatePropertyAll(true),
                  trackVisibility: WidgetStatePropertyAll(true),
                ),
              ),
            )
          : null,
      columns: [
        for (var i = 0; i < widget.columns.length; i++)
          if (widget.columns[i] case final column)
            TableColumn(
              width: columnWidths[i],
              minResizeWidth: column.minResizeWidth,
              maxResizeWidth: column.maxResizeWidth,
            ),
      ],
      rowCount: visibleIndexes.length,
      rowHeight: widget.rowHeight,
      headerBuilder: widget.showColumnHeader
          ? (context, contentBuilder) {
              final bg =
                  widget.headerBackgroundColor ?? colors.surfaceContainerLow;
              return Material(
                color: bg,
                child: contentBuilder(
                  context,
                  (context, columnIndex) {
                    final column = widget.columns[columnIndex];
                    final isLastColumn =
                        columnIndex == widget.columns.length - 1;
                    final isSorted = sortedColumnIndex == columnIndex;
                    final sortIcon = !column.sortable
                        ? null
                        : isSorted
                        ? sortAscending
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded
                        : Icons.unfold_more_rounded;

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          right: isLastColumn
                              ? BorderSide.none
                              : BorderSide(color: gridColor),
                          bottom: BorderSide(color: gridColor),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _toggleSort(columnIndex),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Sizes.p8,
                                vertical: cellVerticalPadding,
                              ),
                              child: Row(
                                mainAxisAlignment: column.numeric
                                    ? .end
                                    : .start,
                                children: [
                                  Flexible(
                                    child: column.tooltip != null
                                        ? AppTooltip(
                                            message: column.tooltip!,
                                            child: Text(
                                              column.label,
                                              maxLines: 1,
                                              overflow: .ellipsis,
                                              style: context.text.labelLarge
                                                  ?.copyWith(
                                                    fontWeight: .w700,
                                                  ),
                                              textAlign: column.numeric
                                                  ? TextAlign.right
                                                  : TextAlign.left,
                                            ),
                                          )
                                        : Text(
                                            column.label,
                                            maxLines: 1,
                                            overflow: .ellipsis,
                                            style: context.text.labelLarge
                                                ?.copyWith(
                                                  fontWeight: .w700,
                                                ),
                                            textAlign: column.numeric
                                                ? TextAlign.right
                                                : TextAlign.left,
                                          ),
                                  ),
                                  if (sortIcon case final icon?) ...[
                                    Gaps.w4,
                                    Icon(
                                      icon,
                                      size: Sizes.p16,
                                      color: isSorted
                                          ? colors.primary
                                          : colors.onSurfaceVariant,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (widget.enableColumnResize)
                              Positioned(
                                top: 0,
                                right: 0,
                                bottom: 0,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.resizeColumn,
                                  child: GestureDetector(
                                    behavior: .opaque,
                                    onHorizontalDragUpdate: (details) {
                                      _resizeColumn(
                                        columnIndex,
                                        details.delta.dx,
                                      );
                                    },
                                    child: Container(
                                      width: Sizes.p8,
                                      alignment: .center,
                                      child: Container(
                                        width: 2,
                                        height: Sizes.p16,
                                        decoration: BoxDecoration(
                                          color: colors.outlineVariant,
                                          borderRadius: const BorderRadius.all(
                                            .circular(1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          : null,
      headerHeight: widget.showColumnHeader ? widget.headerHeight : 0,
      minScrollableWidthRatio: widget.minScrollableWidthRatio ?? .45,
      rowBuilder: (context, rowIndex, contentBuilder) {
        final sourceIndex = visibleIndexes[rowIndex];
        final row = widget.rows[sourceIndex];
        final odd = rowIndex.isOdd;
        final rowKey = widget.rowKeyBuilder?.call(row);
        final isHighlighted =
            rowKey != null && rowKey == widget.highlightedRowKey;
        final baseRowBackground = widget.rowBackgroundColor?.call(context, row);
        final rowBackground = isHighlighted
            ? colors.primaryContainer.withValues(
                alpha: widget.simpleExcelMode ? .72 : .48,
              )
            : hoveredRowIndex == rowIndex
            ? colors.primary.withValues(
                alpha: widget.simpleExcelMode ? .08 : .05,
              )
            : baseRowBackground ??
                  switch ((widget.simpleExcelMode, odd)) {
                    (true, true) => colors.surfaceContainerHigh.withValues(
                      alpha: .32,
                    ),
                    (true, false) => colors.surfaceContainerLowest,
                    (false, true) => colors.surfaceContainerLow.withValues(
                      alpha: .42,
                    ),
                    (false, false) => colors.surfaceContainerLowest,
                  };
        final highlightColor = widget.simpleExcelMode
            ? colors.primary.withValues(alpha: isHighlighted ? .14 : .08)
            : colors.primary.withValues(alpha: isHighlighted ? .1 : .05);

        final finalRowKey = rowKey ?? row;

        return Material(
          key: ValueKey(finalRowKey),
          color: rowBackground,
          child: MouseRegion(
            onEnter: (_) {
              if (hoveredRowIndex != rowIndex) {
                setState(() => hoveredRowIndex = rowIndex);
              }
            },
            onExit: (_) {
              if (hoveredRowIndex == rowIndex) {
                setState(() => hoveredRowIndex = null);
              }
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onSecondaryTapDown: widget.onRowSecondaryTap == null
                  ? null
                  : (details) => widget.onRowSecondaryTap!(
                      context,
                      row,
                      sourceIndex,
                      details,
                    ),
              child: InkWell(
                onTap: widget.onRowTap == null
                    ? null
                    : () => widget.onRowTap!(context, row, sourceIndex),
                hoverColor: Colors.transparent,
                highlightColor: highlightColor,
                child: contentBuilder(
                  context,
                  (context, columnIndex) {
                    final column = widget.columns[columnIndex];
                    final isLastColumn =
                        columnIndex == widget.columns.length - 1;
                    final cellBg = column.cellBackgroundColor?.call(
                      context,
                      row,
                    );
                    final cell = DecoratedBox(
                      decoration: BoxDecoration(
                        color: cellBg,
                        border: Border(
                          right: isLastColumn
                              ? BorderSide.none
                              : BorderSide(color: gridColor),
                          bottom: BorderSide(color: gridColor),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.p8,
                          vertical: cellVerticalPadding,
                        ),
                        child: Align(
                          alignment:
                              column.cellAlignment ??
                              (column.numeric ? .centerRight : .centerLeft),
                          child:
                              column.indexedCellBuilder?.call(
                                context,
                                row,
                                sourceIndex,
                                rowIndex,
                              ) ??
                              column.cellBuilder(context, row),
                        ),
                      ),
                    );
                    return cell;
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    return Column(
      crossAxisAlignment: .start,
      children: [
        if (hasHeader || widget.showSearch)
          Padding(
            padding: const .only(bottom: Sizes.p12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final shouldStack =
                    widget.showSearch &&
                    constraints.maxWidth <
                        (hasHeader
                            ? widget.searchFieldMaxWidth + 320
                            : widget.searchFieldMaxWidth);

                final header = hasHeader
                    ? Column(
                        crossAxisAlignment: .start,
                        children: [
                          if (widget.title case final title?)
                            Text(
                              title,
                              style: context.text.titleSmall?.copyWith(
                                fontWeight: .w700,
                              ),
                            ),
                          if (widget.subtitle case final subtitle?) ...[
                            Gaps.h4,
                            Text(
                              subtitle,
                              style: context.text.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      )
                    : null;

                final searchField = widget.showSearch
                    ? AppSearchTextField(
                        controller: _effectiveSearchController,
                        inlineLabel: widget.searchInlineLabel,
                        hintText: widget.searchHintText,
                        width: shouldStack
                            ? constraints.maxWidth
                            : widget.searchFieldMaxWidth,
                        onChanged: (value) {
                          setState(() => query = value);
                          widget.onSearchChanged?.call(value);
                          _schedulePersist();
                        },
                      )
                    : null;

                if (shouldStack) {
                  final children = <Widget>[];

                  if (header != null) {
                    children.add(header);
                  }

                  if (header != null && searchField != null) {
                    children.add(Gaps.h12);
                  }

                  if (searchField != null) {
                    children.add(searchField);
                  }

                  return Column(
                    crossAxisAlignment: .start,
                    children: children,
                  );
                }

                final rowChildren = <Widget>[];

                if (header != null) {
                  rowChildren.add(Expanded(child: header));
                }

                if (searchField != null) {
                  rowChildren.add(searchField);
                }

                return Row(
                  crossAxisAlignment: .start,
                  children: rowChildren,
                );
              },
            ),
          ),
        if (widget.height != null)
          SizedBox(
            height: math.max(widget.height!, minimumTableHeight),
            child: tableContainer(tableView),
          )
        else
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxHeight < minimumTableHeight) {
                  return constrainedFallback();
                }

                return tableContainer(tableView);
              },
            ),
          ),
        if (widget.footer != null) widget.footer!,
      ],
    );
  }
}
