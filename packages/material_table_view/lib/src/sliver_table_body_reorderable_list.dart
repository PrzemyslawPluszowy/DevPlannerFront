import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// [SliverReorderableList] with workarounds for use in a table.
class SliverTableBodyReorderableList extends SliverReorderableList {
  // ignore: use_super_parameters
  const SliverTableBodyReorderableList({
    super.key,
    required IndexedWidgetBuilder itemBuilder,
    ChildIndexGetter? findChildIndexCallback,
    required int itemCount,
    required ReorderCallback onReorderItem,
    required this.useHigherScrollable,
    required this.addAutomaticKeepAlives,
    void Function(int)? onReorderStart,
    void Function(int)? onReorderEnd,
    double? itemExtent,
    ItemExtentBuilder? itemExtentBuilder,
    Widget? prototypeItem,
    ReorderItemProxyDecorator? proxyDecorator,
  }) : super(
          itemBuilder: itemBuilder,
          findChildIndexCallback: findChildIndexCallback,
          itemCount: itemCount,
          onReorderItem: onReorderItem,
          onReorderStart: onReorderStart,
          onReorderEnd: onReorderEnd,
          itemExtent: itemExtent,
          itemExtentBuilder: itemExtentBuilder,
          prototypeItem: prototypeItem,
          proxyDecorator: proxyDecorator,
        );

  /// Makes the widget use the second next [Scrollable] parent rather than
  /// the first one.
  final bool useHigherScrollable;

  final bool addAutomaticKeepAlives;

  @override
  SliverReorderableListState createState() =>
      _SliverTableReorderableListState();
}

class _SliverTableReorderableListState extends SliverReorderableListState {
  BuildContext? _buildContextOverride;

  @override
  BuildContext get context => _buildContextOverride ?? super.context;

  @override
  void didChangeDependencies() {
    if ((widget as SliverTableBodyReorderableList).useHigherScrollable) {
      // we make the parent state think it is higher on the hierarchy than
      // it actually is for a brief moment so it will grab
      // the correct scrollable
      _buildContextOverride = Scrollable.of(context).context;
    }

    super.didChangeDependencies();

    _buildContextOverride = null;
  }

  @override
  Widget build(BuildContext context) {
    final originalSliverList =
        super.build(context) as SliverMultiBoxAdaptorWidget;

    // so we basically gutting this thing open just to build it back up
    // with addRepaintBoundaries set to false

    final originalDelegate =
        originalSliverList.delegate as SliverChildBuilderDelegate;

    final SliverChildBuilderDelegate childrenDelegate =
        SliverChildBuilderDelegate(
      originalDelegate.builder,
      childCount: originalDelegate.childCount,
      findChildIndexCallback: widget.findChildIndexCallback,
      addRepaintBoundaries: false,
      addAutomaticKeepAlives:
          (widget as SliverTableBodyReorderableList).addAutomaticKeepAlives,
    );

    if (widget.itemExtent != null) {
      return SliverFixedExtentList(
        delegate: childrenDelegate,
        itemExtent: widget.itemExtent!,
      );
    }

    if (widget.itemExtentBuilder != null) {
      return SliverVariedExtentList(
        delegate: childrenDelegate,
        itemExtentBuilder: widget.itemExtentBuilder!,
      );
    }

    if (widget.prototypeItem != null) {
      return SliverPrototypeExtentList(
        delegate: childrenDelegate,
        prototypeItem: widget.prototypeItem!,
      );
    }

    return SliverList(delegate: childrenDelegate);
  }
}
