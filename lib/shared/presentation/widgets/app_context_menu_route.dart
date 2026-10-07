import 'package:devplanner/shared/presentation/widgets/app_context_menu_layout_policy.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu_models.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu_panel.dart';
import 'package:flutter/material.dart';

/// Trasa odpowiedzialna za prezentację menu ponad bieżącym ekranem.
class AppContextMenuRoute<T> extends PopupRoute<T> {
  AppContextMenuRoute({
    required this.position,
    required this.entries,
    required this.maxWidth,
    required this.maxHeight,
    required this.viewportMargin,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.contentBuilder,
    required this.callerTheme,
    required this.localizedBarrierLabel,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
  });

  /// Pozycja menu w układzie overlayu.
  final Offset position;

  /// Pozycje menu.
  final List<AppContextMenuEntry<T>> entries;

  /// Maksymalna szerokość powierzchni menu.
  final double? maxWidth;

  /// Maksymalna wysokość powierzchni menu.
  final double? maxHeight;

  /// Minimalny odstęp powierzchni menu od krawędzi widoku.
  final double viewportMargin;

  final String? headerTitle;
  final String? headerSubtitle;
  final AppContextMenuContentBuilder? contentBuilder;
  final ThemeData callerTheme;
  final String localizedBarrierLabel;
  late final CurvedAnimation _transitionAnimation;
  late final Animation<double> _scaleTransitionAnimation;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => localizedBarrierLabel;

  @override
  void install() {
    super.install();
    final transition = CurvedAnimation(
      parent: animation!,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _transitionAnimation = transition;
    _scaleTransitionAnimation = Tween<double>(begin: .985, end: 1).animate(
      transition,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Theme(
      // PopupRoute używa root navigatora. Przekazanie motywu wywołującego
      // zachowuje lokalny wariant ChatTheme i pozostałe lokalne style.
      data: callerTheme,
      child: CustomSingleChildLayout(
        delegate: _AppContextMenuPositionDelegate(
          position,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          viewportMargin: viewportMargin,
        ),
        child: AppContextMenuPanel<T>(
          entries: entries,
          headerTitle: headerTitle,
          headerSubtitle: headerSubtitle,
          contentBuilder: contentBuilder,
          onSelected: _select,
          onDismiss: _dismiss,
        ),
      ),
    );
  }

  void _dismiss() {
    if (isCurrent) navigator?.pop();
  }

  void _select(T value) {
    if (isCurrent) navigator?.pop(value);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = _transitionAnimation;
    final scaleAnimation = _scaleTransitionAnimation;
    assert(
      identical(curvedAnimation.parent, animation),
      'Menu route must use the animation installed with this route.',
    );
    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(
        alignment: .topLeft,
        scale: scaleAnimation,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    _transitionAnimation.dispose();
    super.dispose();
  }
}

/// Delegat utrzymujący menu wewnątrz widocznego obszaru ekranu.
class _AppContextMenuPositionDelegate extends SingleChildLayoutDelegate {
  const _AppContextMenuPositionDelegate(
    this.position, {
    required this.maxWidth,
    required this.viewportMargin,
    this.maxHeight,
  });

  /// Pozycja menu w układzie overlayu.
  final Offset position;

  /// Maksymalna szerokość i wysokość powierzchni menu.
  final double? maxWidth;
  final double? maxHeight;
  final double viewportMargin;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final dimensions = AppContextMenuLayoutPolicy.constraints(
      availableWidth: constraints.maxWidth,
      availableHeight: constraints.maxHeight,
      requestedMaxWidth: maxWidth ?? 300,
      requestedMaxHeight: maxHeight,
      viewportMargin: viewportMargin,
      preferredMinWidth: 220,
    );
    return BoxConstraints(
      minWidth: dimensions.minWidth,
      maxWidth: dimensions.maxWidth,
      maxHeight: dimensions.maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final margin = viewportMargin;
    final maxX = (size.width - childSize.width - margin).clamp(
      margin,
      double.infinity,
    );
    final maxY = (size.height - childSize.height - margin).clamp(
      margin,
      double.infinity,
    );
    return Offset(
      position.dx.clamp(margin, maxX),
      position.dy.clamp(margin, maxY),
    );
  }

  @override
  bool shouldRelayout(_AppContextMenuPositionDelegate oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.maxWidth != maxWidth ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.viewportMargin != viewportMargin;
  }
}
