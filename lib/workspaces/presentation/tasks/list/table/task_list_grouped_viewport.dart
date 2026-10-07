import 'package:flutter/material.dart';

/// Lazy vertical groups whose column header remains visible within its group.
/// The caller retains ownership of the scroll controller and row interaction.
class TaskListGroupedViewport<T> extends StatefulWidget {
  const TaskListGroupedViewport({
    required this.rows,
    required this.controller,
    required this.isGroupStart,
    required this.isColumnHeader,
    required this.rowBuilder,
    this.headerHeight = 42,
    this.trailing,
    super.key,
  });

  final List<T> rows;
  final ScrollController controller;
  final bool Function(T) isGroupStart;
  final bool Function(T) isColumnHeader;
  final Widget Function(BuildContext, T) rowBuilder;
  final double headerHeight;
  final Widget? trailing;

  @override
  State<TaskListGroupedViewport<T>> createState() =>
      _TaskListGroupedViewportState<T>();
}

class _TaskListGroupedViewportState<T>
    extends State<TaskListGroupedViewport<T>> {
  late List<_GroupRange> _groups;

  @override
  void initState() {
    super.initState();
    _indexGroups();
  }

  @override
  void didUpdateWidget(covariant TaskListGroupedViewport<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.rows, widget.rows) ||
        oldWidget.isGroupStart != widget.isGroupStart ||
        oldWidget.isColumnHeader != widget.isColumnHeader) {
      _indexGroups();
    }
  }

  void _indexGroups() {
    final groups = <_GroupRange>[];
    var start = 0;
    int? header;
    for (var index = 0; index < widget.rows.length; index++) {
      final row = widget.rows[index];
      if (index > start && widget.isGroupStart(row)) {
        groups.add(_GroupRange(start, index, header));
        start = index;
        header = null;
      }
      if (widget.isColumnHeader(row)) header = index;
    }
    if (start < widget.rows.length) {
      groups.add(_GroupRange(start, widget.rows.length, header));
    }
    _groups = groups;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.controller,
      slivers: [
        for (final group in _groups)
          SliverMainAxisGroup(
            slivers: [
              if (group.header case final header?) ...[
                if (header > group.start)
                  SliverList.builder(
                    itemCount: header - group.start,
                    itemBuilder: (context, index) => widget.rowBuilder(
                      context,
                      widget.rows[group.start + index],
                    ),
                  ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _ColumnHeaderDelegate(
                    height: widget.headerHeight,
                    child: widget.rowBuilder(context, widget.rows[header]),
                  ),
                ),
                SliverList.builder(
                  itemCount: group.end - header - 1,
                  itemBuilder: (context, index) => widget.rowBuilder(
                    context,
                    widget.rows[header + index + 1],
                  ),
                ),
              ] else
                SliverList.builder(
                  itemCount: group.end - group.start,
                  itemBuilder: (context, index) => widget.rowBuilder(
                    context,
                    widget.rows[group.start + index],
                  ),
                ),
            ],
          ),
        if (widget.trailing case final trailing?)
          SliverToBoxAdapter(child: trailing),
      ],
    );
  }
}

class _GroupRange {
  const _GroupRange(this.start, this.end, this.header);

  final int start;
  final int end;
  final int? header;
}

class _ColumnHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _ColumnHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => SizedBox.expand(child: child);

  @override
  bool shouldRebuild(covariant _ColumnHeaderDelegate oldDelegate) =>
      height != oldDelegate.height || child != oldDelegate.child;
}
