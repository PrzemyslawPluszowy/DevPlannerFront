import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/application/dashboard_preferences_cubit.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_header_actions.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';


/// Uniwersalny wrapper dla widgetów pulpitu.
///
/// Obsługuje dwa tryby:
/// - standardową kartę z nagłówkiem,
/// - minimalistyczny overlay bez pełnej ramki.
class DashboardWidgetWrapper extends StatefulWidget {
  /// Tworzy uniwersalny wrapper widgetu pulpitu.
  const DashboardWidgetWrapper({
    required this.name,
    required this.icon,
    required this.frameStyle,
    required this.supportedSizes,
    required this.currentSize,
    required this.onRemove,
    required this.onResize,
    required this.child,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.onDragCancel,
    this.onBringToFront,
    this.onSendToBack,
    super.key,
  });

  /// Nazwa widgetu.
  final String name;

  /// Ikona widgetu.
  final IconData icon;

  /// Styl ramki widgetu.
  final DashboardWidgetFrameStyle frameStyle;

  /// Dostępne rozmiary widgetu.
  final List<DashboardWidgetSize> supportedSizes;

  /// Aktualny rozmiar widgetu.
  final DashboardWidgetSize currentSize;

  /// Akcja wywoływana przy żądaniu usunięcia widgetu.
  final VoidCallback onRemove;

  /// Akcja wywoływana przy żądaniu zmiany rozmiaru widgetu.
  final ValueChanged<DashboardWidgetSize> onResize;

  /// Zawartość widgetu.
  final Widget child;

  /// Callbacki przeciągania obsługiwane przez wrapper.
  final GestureDragStartCallback? onDragStart;
  final GestureDragUpdateCallback? onDragUpdate;
  final GestureDragEndCallback? onDragEnd;

  /// Callback anulowania przeciągania.
  final VoidCallback? onDragCancel;

  /// Akcja przesunięcia widgetu na wierzch (opcjonalna, z-index).
  final VoidCallback? onBringToFront;

  /// Akcja przesunięcia widgetu pod spód (opcjonalna, z-index).
  final VoidCallback? onSendToBack;

  @override
  State<DashboardWidgetWrapper> createState() => _DashboardWidgetWrapperState();
}

/// Stan wrappera widgetu pulpitu.
class _DashboardWidgetWrapperState extends State<DashboardWidgetWrapper> {
  /// Kontroler akcji nagłówka widgetu.
  late final DashboardWidgetHeaderActionController _headerActionController;

  @override
  void initState() {
    super.initState();
    _headerActionController = DashboardWidgetHeaderActionController();
  }

  @override
  void dispose() {
    _headerActionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardWidgetHeaderActionScope(
      controller: _headerActionController,
      child: switch (widget.frameStyle) {
        DashboardWidgetFrameStyle.standard => _StandardWidgetFrame(
          name: widget.name,
          icon: widget.icon,
          supportedSizes: widget.supportedSizes,
          currentSize: widget.currentSize,
          onRemove: widget.onRemove,
          onResize: widget.onResize,
          onDragStart: widget.onDragStart,
          onDragUpdate: widget.onDragUpdate,
          onDragEnd: widget.onDragEnd,
          onDragCancel: widget.onDragCancel,
          onBringToFront: widget.onBringToFront,
          onSendToBack: widget.onSendToBack,
          actionController: _headerActionController,
          child: widget.child,
        ),
        DashboardWidgetFrameStyle.minimal => _MinimalWidgetFrame(
          name: widget.name,
          icon: widget.icon,
          supportedSizes: widget.supportedSizes,
          currentSize: widget.currentSize,
          onRemove: widget.onRemove,
          onResize: widget.onResize,
          onDragStart: widget.onDragStart,
          onDragUpdate: widget.onDragUpdate,
          onDragEnd: widget.onDragEnd,
          onDragCancel: widget.onDragCancel,
          onBringToFront: widget.onBringToFront,
          onSendToBack: widget.onSendToBack,
          actionController: _headerActionController,
          child: widget.child,
        ),
      },
    );
  }
}

/// Standardowa, szklista rama widgetu pulpitu z nagłówkiem.
class _StandardWidgetFrame extends StatelessWidget {
  /// Tworzy standardową ramę widgetu.
  const _StandardWidgetFrame({
    required this.name,
    required this.icon,
    required this.supportedSizes,
    required this.currentSize,
    required this.onRemove,
    required this.onResize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDragCancel,
    required this.onBringToFront,
    required this.onSendToBack,
    required this.actionController,
    required this.child,
  });

  /// Nazwa widgetu.
  final String name;

  /// Ikona widgetu.
  final IconData icon;

  /// Dostępne rozmiary widgetu.
  final List<DashboardWidgetSize> supportedSizes;

  /// Aktualny rozmiar widgetu.
  final DashboardWidgetSize currentSize;

  /// Akcja usunięcia widgetu.
  final VoidCallback onRemove;

  /// Akcja zmiany rozmiaru widgetu.
  final ValueChanged<DashboardWidgetSize> onResize;

  /// Callback rozpoczęcia przeciągania.
  final GestureDragStartCallback? onDragStart;

  /// Callback aktualizacji przeciągania.
  final GestureDragUpdateCallback? onDragUpdate;

  /// Callback zakończenia przeciągania.
  final GestureDragEndCallback? onDragEnd;

  /// Callback anulowania przeciągania.
  final VoidCallback? onDragCancel;

  /// Akcja przesunięcia widgetu na wierzch (opcjonalna, z-index).
  final VoidCallback? onBringToFront;

  /// Akcja przesunięcia widgetu pod spód (opcjonalna, z-index).
  final VoidCallback? onSendToBack;

  /// Kontroler akcji nagłówka.
  final DashboardWidgetHeaderActionController actionController;

  /// Zawartość widgetu.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? Colors.black.withValues(alpha: .35)
        : Colors.white.withValues(alpha: .45);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: .12)
        : Colors.white.withValues(alpha: .4);
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: .3)
        : Colors.black.withValues(alpha: .08);

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // Umożliwia otwarcie menu kontekstowego prawym przyciskiem myszy na całej powierzchni widgetu.
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTapUp: (details) => _openWidgetContextMenu(
          context: context,
          renderContext: context,
          globalPosition: details.globalPosition,
          name: name,
          icon: icon,
          supportedSizes: supportedSizes,
          currentSize: currentSize,
          onRemove: onRemove,
          onResize: onResize,
          onRefresh: actionController.refreshAction,
          customActions: actionController.contextMenuActions(context),
          onBringToFront: onBringToFront,
          onSendToBack: onSendToBack,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _WidgetHeader(
                    name: name,
                    icon: icon,
                    supportedSizes: supportedSizes,
                    currentSize: currentSize,
                    onRemove: onRemove,
                    onResize: onResize,
                    onDragStart: onDragStart,
                    onDragUpdate: onDragUpdate,
                    onDragEnd: onDragEnd,
                    onDragCancel: onDragCancel,
                    onBringToFront: onBringToFront,
                    onSendToBack: onSendToBack,
                    actionController: actionController,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Minimalistyczna rama widgetu pulpitu bez widocznej karty i nagłówka.
class _MinimalWidgetFrame extends StatelessWidget {
  /// Tworzy minimalistyczną ramę widgetu.
  const _MinimalWidgetFrame({
    required this.name,
    required this.icon,
    required this.supportedSizes,
    required this.currentSize,
    required this.onRemove,
    required this.onResize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDragCancel,
    required this.onBringToFront,
    required this.onSendToBack,
    required this.actionController,
    required this.child,
  });

  /// Nazwa widgetu.
  final String name;

  /// Ikona widgetu.
  final IconData icon;

  /// Dostępne rozmiary widgetu.
  final List<DashboardWidgetSize> supportedSizes;

  /// Aktualny rozmiar widgetu.
  final DashboardWidgetSize currentSize;

  /// Akcja usunięcia widgetu.
  final VoidCallback onRemove;

  /// Akcja zmiany rozmiaru widgetu.
  final ValueChanged<DashboardWidgetSize> onResize;

  /// Callback rozpoczęcia przeciągania.
  final GestureDragStartCallback? onDragStart;

  /// Callback aktualizacji przeciągania.
  final GestureDragUpdateCallback? onDragUpdate;

  /// Callback zakończenia przeciągania.
  final GestureDragEndCallback? onDragEnd;

  /// Callback anulowania przeciągania.
  final VoidCallback? onDragCancel;

  /// Akcja przesunięcia widgetu na wierzch (opcjonalna, z-index).
  final VoidCallback? onBringToFront;

  /// Akcja przesunięcia widgetu pod spód (opcjonalna, z-index).
  final VoidCallback? onSendToBack;

  /// Kontroler akcji nagłówka.
  final DashboardWidgetHeaderActionController actionController;

  /// Zawartość widgetu.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _WidgetInteractionSurface(
      name: name,
      icon: icon,
      supportedSizes: supportedSizes,
      currentSize: currentSize,
      onRemove: onRemove,
      onResize: onResize,
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
      onDragEnd: onDragEnd,
      onDragCancel: onDragCancel,
      onBringToFront: onBringToFront,
      onSendToBack: onSendToBack,
      actionController: actionController,
      cursor: SystemMouseCursors.grab,
      child: SizedBox.expand(child: child),
    );
  }
}

class _WidgetHeader extends StatelessWidget {
  const _WidgetHeader({
    required this.name,
    required this.icon,
    required this.supportedSizes,
    required this.currentSize,
    required this.onRemove,
    required this.onResize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDragCancel,
    this.onBringToFront,
    this.onSendToBack,
    required this.actionController,
  });

  final String name;
  final IconData icon;
  final List<DashboardWidgetSize> supportedSizes;
  final DashboardWidgetSize currentSize;
  final VoidCallback onRemove;
  final ValueChanged<DashboardWidgetSize> onResize;
  final GestureDragStartCallback? onDragStart;
  final GestureDragUpdateCallback? onDragUpdate;
  final GestureDragEndCallback? onDragEnd;
  final VoidCallback? onDragCancel;
  final VoidCallback? onBringToFront;
  final VoidCallback? onSendToBack;
  final DashboardWidgetHeaderActionController actionController;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return AnimatedBuilder(
      animation: actionController,
      builder: (context, child) {
        return Container(
          height: 68,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: .08),
                width: .5,
              ),
            ),
          ),
          child: Padding(
            padding: const .symmetric(horizontal: Sizes.p12),
            child: Row(
              children: [
                Expanded(
                  child: _WidgetInteractionSurface(
                    name: name,
                    icon: icon,
                    supportedSizes: supportedSizes,
                    currentSize: currentSize,
                    onRemove: onRemove,
                    onResize: onResize,
                    onDragStart: onDragStart,
                    onDragUpdate: onDragUpdate,
                    onDragEnd: onDragEnd,
                    onDragCancel: onDragCancel,
                    onBringToFront: onBringToFront,
                    onSendToBack: onSendToBack,
                    actionController: actionController,
                    contextMenuOffsetBuilder: (renderBox) {
                      final offset = renderBox.localToGlobal(Offset.zero);
                      return Offset(
                        offset.dx + renderBox.size.width - 40,
                        offset.dy + 40,
                      );
                    },
                    cursor: SystemMouseCursors.grab,
                    child: Row(
                      children: [
                        Container(
                          padding: const .symmetric(
                            horizontal: Sizes.p8,
                            vertical: Sizes.p8,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.onSurface.withValues(
                              alpha: .06,
                            ),
                            borderRadius: const BorderRadius.all(
                              .circular(Sizes.p12),
                            ),
                          ),
                          child: Icon(
                            Icons.drag_indicator_rounded,
                            size: 18,
                            color: context.colors.onSurface.withValues(
                              alpha: .58,
                            ),
                          ),
                        ),
                        Gaps.w8,
                        Icon(
                          icon,
                          size: 20,
                          color: context.colors.onSurface.withValues(alpha: .8),
                        ),
                        Gaps.w8,
                        Expanded(
                          child: AppText(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: .w700,
                              color: context.colors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gaps.w8,
                SizedBox(
                  width: 88,
                  child: Align(
                    alignment: .centerRight,
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        if (actionController.hasRefreshAction) ...[
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, size: 20),
                            tooltip: intl.dashboardWidgetRefreshTooltip,
                            onPressed: actionController.refreshAction,
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(40, 40),
                            ),
                          ),
                          Gaps.w4,
                        ],
                        IconButton(
                          icon: const Icon(Icons.more_horiz_rounded, size: 20),
                          onPressed: () => _openWidgetContextMenu(
                            context: context,
                            renderContext: context,
                            name: name,
                            icon: icon,
                            supportedSizes: supportedSizes,
                            currentSize: currentSize,
                            onRemove: onRemove,
                            onResize: onResize,
                            onRefresh: actionController.refreshAction,
                            customActions: actionController.contextMenuActions(
                              context,
                            ),
                            onBringToFront: onBringToFront,
                            onSendToBack: onSendToBack,
                          ),
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(40, 40),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Powierzchnia interakcji widgetu obsługująca drag i prawy klik.
class _WidgetInteractionSurface extends StatefulWidget {
  /// Tworzy powierzchnię interakcji widgetu.
  const _WidgetInteractionSurface({
    required this.name,
    required this.icon,
    required this.supportedSizes,
    required this.currentSize,
    required this.onRemove,
    required this.onResize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDragCancel,
    this.onBringToFront,
    this.onSendToBack,
    required this.actionController,
    required this.child,
    this.cursor = SystemMouseCursors.move,
    this.contextMenuOffsetBuilder,
  });

  /// Nazwa widgetu.
  final String name;

  /// Ikona widgetu.
  final IconData icon;

  /// Dostępne rozmiary widgetu.
  final List<DashboardWidgetSize> supportedSizes;

  /// Aktualny rozmiar widgetu.
  final DashboardWidgetSize currentSize;

  /// Akcja usunięcia widgetu.
  final VoidCallback onRemove;

  /// Akcja zmiany rozmiaru widgetu.
  final ValueChanged<DashboardWidgetSize> onResize;

  /// Callback rozpoczęcia przeciągania.
  final GestureDragStartCallback? onDragStart;

  /// Callback aktualizacji przeciągania.
  final GestureDragUpdateCallback? onDragUpdate;

  /// Callback zakończenia przeciągania.
  final GestureDragEndCallback? onDragEnd;

  /// Callback anulowania przeciągania.
  final VoidCallback? onDragCancel;

  /// Akcja przesunięcia widgetu na wierzch (opcjonalna, z-index).
  final VoidCallback? onBringToFront;

  /// Akcja przesunięcia widgetu pod spód (opcjonalna, z-index).
  final VoidCallback? onSendToBack;

  /// Kontroler akcji nagłówka.
  final DashboardWidgetHeaderActionController actionController;

  /// Renderowana zawartość.
  final Widget child;

  /// Kursor używany nad powierzchnią.
  final MouseCursor cursor;

  /// Opcjonalny sposób wyznaczenia pozycji menu kontekstowego.
  final Offset Function(RenderBox renderBox)? contextMenuOffsetBuilder;

  @override
  State<_WidgetInteractionSurface> createState() =>
      _WidgetInteractionSurfaceState();
}

/// Stan powierzchni interakcji widgetu.
class _WidgetInteractionSurfaceState extends State<_WidgetInteractionSurface> {
  int? _activePointer;
  bool _dragStarted = false;

  bool get _dragEnabled =>
      widget.onDragStart != null ||
      widget.onDragUpdate != null ||
      widget.onDragEnd != null ||
      widget.onDragCancel != null;

  void _handlePointerDown(PointerDownEvent event) {
    if (!_dragEnabled) {
      return;
    }
    if (event.buttons == kSecondaryMouseButton) {
      return;
    }
    _activePointer = event.pointer;
    _dragStarted = false;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!_dragEnabled) {
      return;
    }
    if (_activePointer != event.pointer) {
      return;
    }

    if (!_dragStarted) {
      _dragStarted = true;
      widget.onDragStart?.call(
        DragStartDetails(
          globalPosition: event.position,
          localPosition: event.localPosition,
        ),
      );
    }

    widget.onDragUpdate?.call(
      DragUpdateDetails(
        globalPosition: event.position,
        localPosition: event.localPosition,
        delta: event.delta,
      ),
    );
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (!_dragEnabled) {
      return;
    }
    if (_activePointer != event.pointer) {
      return;
    }

    if (_dragStarted) {
      widget.onDragEnd?.call(DragEndDetails());
    }

    _activePointer = null;
    _dragStarted = false;
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (!_dragEnabled) {
      return;
    }
    if (_activePointer != event.pointer) {
      return;
    }

    if (_dragStarted) {
      widget.onDragCancel?.call();
    }

    _activePointer = null;
    _dragStarted = false;
  }

  Future<void> _openContextMenuAt(Offset? globalPosition) async {
    if (!mounted) {
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    final resolvedGlobalPosition =
        globalPosition ?? widget.contextMenuOffsetBuilder?.call(renderBox);
    if (resolvedGlobalPosition == null) {
      return;
    }

    await _openWidgetContextMenu(
      context: context,
      renderContext: context,
      globalPosition: resolvedGlobalPosition,
      name: widget.name,
      icon: widget.icon,
      supportedSizes: widget.supportedSizes,
      currentSize: widget.currentSize,
      onRemove: widget.onRemove,
      onResize: widget.onResize,
      onRefresh: widget.actionController.refreshAction,
      customActions: widget.actionController.contextMenuActions(context),
      onBringToFront: widget.onBringToFront,
      onSendToBack: widget.onSendToBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onSecondaryTapUp: (details) =>
            _openContextMenuAt(details.globalPosition),
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: _handlePointerDown,
          onPointerMove: _handlePointerMove,
          onPointerUp: _handlePointerUp,
          onPointerCancel: _handlePointerCancel,
          child: SizedBox.expand(child: widget.child),
        ),
      ),
    );
  }
}

Future<void> _openWidgetContextMenu({
  required BuildContext context,
  required BuildContext renderContext,
  Offset? globalPosition,
  required String name,
  required IconData icon,
  required List<DashboardWidgetSize> supportedSizes,
  required DashboardWidgetSize currentSize,
  required VoidCallback onRemove,
  required ValueChanged<DashboardWidgetSize> onResize,
  required VoidCallback? onRefresh,
  required List<AppContextMenuAction> customActions,
  VoidCallback? onBringToFront,
  VoidCallback? onSendToBack,
}) async {
  final intl = context.l10n;
  final renderBox = renderContext.findRenderObject() as RenderBox?;
  if (renderBox == null) {
    return;
  }

  final menuPosition =
      globalPosition ??
      renderBox.localToGlobal(
        Offset(
          renderBox.size.width - 40,
          40,
        ),
      );

  final isZIndexEnabled = !context
      .read<DashboardPreferencesCubit>()
      .state
      .snapToGrid;

  await AppContextMenu.show(
    context,
    globalPosition: menuPosition,
    style: AppContextMenuStyle.glass,
    headerTitle: supportedSizes.length > 1
        ? intl.dashboardWidgetResizeTitle
        : null,
    actions: [
      if (onRefresh != null)
        AppContextMenuAction(
          label: intl.dashboardWidgetRefreshTooltip,
          icon: Icons.refresh_rounded,
          onTap: (_) => onRefresh(),
        ),
      ...customActions,
      if (supportedSizes.length > 1)
        for (final size in supportedSizes)
          AppContextMenuAction(
            label: intl.dashboardWidgetResizeLabel(size.label),
            icon: Icons.aspect_ratio_rounded,
            selected: currentSize == size,
            separatorBefore:
                (onRefresh != null || customActions.isNotEmpty) &&
                size == supportedSizes.first,
            onTap: (_) {
              if (size != currentSize) {
                onResize(size);
              }
            },
          ),
      if (onBringToFront != null)
        AppContextMenuAction(
          label: intl.dashboardWidgetBringToFront,
          icon: Icons.flip_to_front_rounded,
          enabled: isZIndexEnabled,
          separatorBefore:
              supportedSizes.length > 1 ||
              onRefresh != null ||
              customActions.isNotEmpty,
          onTap: (_) {
            if (isZIndexEnabled) onBringToFront();
          },
        ),
      if (onSendToBack != null)
        AppContextMenuAction(
          label: intl.dashboardWidgetSendToBack,
          icon: Icons.flip_to_back_rounded,
          enabled: isZIndexEnabled,
          onTap: (_) {
            if (isZIndexEnabled) onSendToBack();
          },
        ),
      AppContextMenuAction(
        label: intl.dashboardWidgetRemoveAction,
        icon: Icons.delete_outline_rounded,
        isDestructive: true,
        separatorBefore:
            supportedSizes.length > 1 ||
            onRefresh != null ||
            customActions.isNotEmpty ||
            onBringToFront != null ||
            onSendToBack != null,
        onTap: (_) => onRemove(),
      ),
    ],
  );
}
