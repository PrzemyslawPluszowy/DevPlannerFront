import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_modal_accessibility_boundary.dart';
import 'package:flutter/material.dart';

/// Overlayowy wariant szablonu modułu dla małych szerokości.
class AppCompactModuleLayout extends StatefulWidget {
  const AppCompactModuleLayout({
    required this.sidebarBuilder,
    required this.contentSurfaceBuilder,
    required this.outerPadding,
    required this.constraints,
    super.key,
  });

  final Widget Function(BuildContext, bool, double) sidebarBuilder;
  final WidgetBuilder contentSurfaceBuilder;
  final double outerPadding;
  final BoxConstraints constraints;

  @override
  State<AppCompactModuleLayout> createState() => _AppCompactModuleLayoutState();
}

class _AppCompactModuleLayoutState extends State<AppCompactModuleLayout> {
  bool _isSidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sidebarWidth = (widget.constraints.maxWidth - Sizes.p24).clamp(
      0.0,
      360.0,
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.contentSurfaceBuilder(context),
        PositionedDirectional(
          top: widget.outerPadding + Sizes.p8,
          start: widget.outerPadding + Sizes.p8,
          child: Material(
            elevation: 3,
            color: colors.surface,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: 'Otwórz menu',
              onPressed: () => setState(() => _isSidebarOpen = true),
              icon: const Icon(Icons.menu),
            ),
          ),
        ),
        if (_isSidebarOpen)
          Positioned.fill(
            child: Stack(
              children: [
                ModalBarrier(
                  onDismiss: () => setState(() => _isSidebarOpen = false),
                  color: Colors.black.withValues(alpha: .28),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: SafeArea(
                    child: AppModalAccessibilityBoundary(
                      onDismiss: () => setState(() => _isSidebarOpen = false),
                      child: Material(
                        elevation: 16,
                        color: colors.surface,
                        child: SizedBox(
                          width: sidebarWidth,
                          height: double.infinity,
                          child: Column(
                            children: [
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: IconButton(
                                  tooltip: 'Zamknij menu',
                                  onPressed: () =>
                                      setState(() => _isSidebarOpen = false),
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                              Expanded(
                                child: widget.sidebarBuilder(
                                  context,
                                  true,
                                  widget.outerPadding,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
