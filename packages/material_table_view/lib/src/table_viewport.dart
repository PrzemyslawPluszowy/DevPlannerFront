import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// This is a highly sophisticated widget used as a [Viewport] for the table.
///
/// The only difference from a regular [Viewport] is that it doesn't serve as a
/// [RepaintBoundary] and thus doesn't mess up custom compositing.
class TableViewport extends Viewport {
  // ignore: use_super_parameters
  TableViewport({
    Key? key,
    AxisDirection axisDirection = AxisDirection.down,
    AxisDirection? crossAxisDirection,
    double anchor = 0.0,
    required ViewportOffset offset,
    Key? center,
    @Deprecated(
      'Use scrollCacheExtent instead. '
      'This feature was deprecated after v3.41.0-0.0.pre.',
    )
    double? cacheExtent,
    @Deprecated(
      'Use scrollCacheExtent instead. '
      'This feature was deprecated after v3.41.0-0.0.pre.',
    )
    CacheExtentStyle cacheExtentStyle = CacheExtentStyle.pixel,
    ScrollCacheExtent? scrollCacheExtent,
    Clip clipBehavior = Clip.hardEdge,
    List<Widget> slivers = const <Widget>[],
  }) : super(
          key: key,
          axisDirection: axisDirection,
          crossAxisDirection: crossAxisDirection,
          anchor: anchor,
          offset: offset,
          center: center,
          scrollCacheExtent: scrollCacheExtent ??
              _resolveScrollCacheExtent(
                cacheExtent: cacheExtent,
                cacheExtentStyle: cacheExtentStyle,
              ),
          clipBehavior: clipBehavior,
          slivers: slivers,
        );

  static ScrollCacheExtent? _resolveScrollCacheExtent({
    required double? cacheExtent,
    required CacheExtentStyle cacheExtentStyle,
  }) {
    if (cacheExtent == null) {
      return null;
    }

    if (cacheExtentStyle == CacheExtentStyle.viewport) {
      return ScrollCacheExtent.viewport(cacheExtent);
    }

    return ScrollCacheExtent.pixels(cacheExtent);
  }

  @override
  RenderViewport createRenderObject(BuildContext context) =>
      _RenderTableViewport(
        axisDirection: axisDirection,
        crossAxisDirection: crossAxisDirection ??
            Viewport.getDefaultCrossAxisDirection(context, axisDirection),
        anchor: anchor,
        offset: offset,
        scrollCacheExtent: scrollCacheExtent,
        clipBehavior: clipBehavior,
      );
}

class _RenderTableViewport extends RenderViewport {
  _RenderTableViewport({
    super.axisDirection,
    required super.crossAxisDirection,
    required super.offset,
    super.anchor = 0.0,
    super.scrollCacheExtent,
    super.clipBehavior,
  });

  // All that crap is just for this.
  @override
  bool get isRepaintBoundary => false;
}

/// This is a highly sophisticated widget used as a [ShrinkWrappingViewport]
/// for the table.
///
/// The only difference from a regular [ShrinkWrappingViewport] is that
/// it doesn't serve as a [RepaintBoundary] and
/// thus doesn't mess up custom compositing.
class TableShrinkWrappingViewport extends ShrinkWrappingViewport {
  const TableShrinkWrappingViewport({
    super.key,
    super.axisDirection,
    super.crossAxisDirection,
    required super.offset,
    super.clipBehavior,
    super.slivers,
  });

  @override
  RenderShrinkWrappingViewport createRenderObject(BuildContext context) =>
      _RenderTableShrinkWrappingViewport(
        axisDirection: axisDirection,
        crossAxisDirection: crossAxisDirection ??
            Viewport.getDefaultCrossAxisDirection(context, axisDirection),
        offset: offset,
        clipBehavior: clipBehavior,
      );
}

class _RenderTableShrinkWrappingViewport extends RenderShrinkWrappingViewport {
  _RenderTableShrinkWrappingViewport({
    super.axisDirection,
    required super.crossAxisDirection,
    required super.offset,
    super.clipBehavior,
  });

  // All that crap is just for this.
  @override
  bool get isRepaintBoundary => false;
}
