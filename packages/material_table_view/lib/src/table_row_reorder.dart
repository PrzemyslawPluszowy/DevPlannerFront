import 'package:flutter/widgets.dart';

/// Holds properties to enable row reordering in a table.
class TableRowReorder {
  /// See [SliverReorderableList.findChildIndexCallback].
  final ChildIndexGetter? findChildIndexCallback;

  /// See [SliverReorderableList.onReorderItem].
  final ReorderCallback onReorderItem;

  /// See [SliverReorderableList.onReorderStart].
  final void Function(int)? onReorderStart;

  /// See [SliverReorderableList.onReorderEnd].
  final void Function(int)? onReorderEnd;

  /// See [SliverReorderableList.proxyDecorator].
  final ReorderItemProxyDecorator? proxyDecorator;

  /// See [SliverReorderableList.autoScrollerVelocityScalar].
  final double? autoScrollerVelocityScalar;

  TableRowReorder({
    @Deprecated(
      'Use onReorderItem instead. '
      'This feature was deprecated after v3.41.0-0.0.pre.',
    )
    ReorderCallback? onReorder,
    ReorderCallback? onReorderItem,
    this.onReorderStart,
    this.onReorderEnd,
    this.findChildIndexCallback,
    this.proxyDecorator,
    this.autoScrollerVelocityScalar,
  })  : assert(
          (onReorderItem != null && onReorder == null) ||
              (onReorderItem == null && onReorder != null),
          'Provide exactly one reorder callback.',
        ),
        onReorderItem = onReorderItem ?? onReorder!;
}
