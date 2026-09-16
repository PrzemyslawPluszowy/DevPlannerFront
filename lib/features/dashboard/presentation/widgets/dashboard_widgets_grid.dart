import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/features/dashboard/application/dashboard_preferences_cubit.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_widget_preference.dart';
import 'package:ready_next/features/dashboard/domain/services/dashboard_desktop_layout_engine.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_desktop_item_wrapper.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_wrapper.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widgets_catalog.dart';

/// Panel rozmieszczający widgety na pulpicie na bazie siatki.
class DashboardWidgetsGrid extends StatefulWidget {
  /// Tworzy panel siatki widgetów pulpitu.
  const DashboardWidgetsGrid({
    required this.widgets,
    required this.previewController,
    super.key,
  });

  /// Lista preferencji widgetów do wyświetlenia na pulpicie.
  final List<DashboardWidgetPreference> widgets;

  /// Współdzielony kontroler podglądu układu pulpitu.
  final ValueNotifier<DashboardDesktopLayoutResult?> previewController;

  @override
  State<DashboardWidgetsGrid> createState() => _DashboardWidgetsGridState();
}

class _DashboardWidgetsGridState extends State<DashboardWidgetsGrid> {
  String? _draggingWidgetId;
  Offset? _draggingPointerOffset;
  Map<String, Offset> _previewOffsetsByWidgetId = const {};
  Offset? _previewDropOffset;

  Offset _clampPointerOffset(
    Offset rawOffset,
    double width,
    double height,
    Size desktopSize,
  ) {
    final maxX = (desktopSize.width - width).clamp(0.0, double.infinity);
    final maxY = (desktopSize.height - height).clamp(0.0, double.infinity);

    return Offset(
      rawOffset.dx.clamp(0.0, maxX),
      rawOffset.dy.clamp(0.0, maxY),
    );
  }

  Offset _offsetForWidget(
    DashboardWidgetPreference widget,
    Size desktopSize,
  ) {
    final preferences = context.read<DashboardPreferencesCubit>().state;
    if (!preferences.snapToGrid &&
        widget.exactDx != null &&
        widget.exactDy != null) {
      return Offset(widget.exactDx!, widget.exactDy!);
    }
    return DashboardDesktopGeometry.cellOffset(
      widget.gridColumn,
      widget.gridRow,
      desktopSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapToGrid = context.select<DashboardPreferencesCubit, bool>(
      (cubit) => cubit.state.snapToGrid,
    );

    return ValueListenableBuilder<DashboardDesktopLayoutResult?>(
      valueListenable: widget.previewController,
      builder: (context, previewLayout, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final desktopSize = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            );

            final sortedWidgets = [...widget.widgets]..sort((a, b) {
              if (a.id == _draggingWidgetId) return 1;
              if (b.id == _draggingWidgetId) return -1;
              return 0;
            });

            return Stack(
              clipBehavior: Clip.none,
              children: [
                if (snapToGrid &&
                    _draggingWidgetId != null &&
                    _previewDropOffset != null)
                  _buildDropIndicator(desktopSize),
                for (final pref in sortedWidgets)
                  _buildWidgetPositioned(
                    context: context,
                    pref: pref,
                    desktopSize: desktopSize,
                    previewLayout: previewLayout,
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildWidgetPositioned({
    required BuildContext context,
    required DashboardWidgetPreference pref,
    required Size desktopSize,
    required DashboardDesktopLayoutResult? previewLayout,
  }) {
    final permissions = context.select<AuthCubit, Set<String>>(
      (cubit) => switch (cubit.state) {
        AuthAuthenticated(:final user) => user?.permissions ?? const {},
        _ => const {},
      },
    );
    final definition = DashboardWidgetsCatalog.getById(
      pref.widgetTypeId,
      permissions,
    );
    if (definition == null) {
      return const SizedBox.shrink();
    }

    final width = DashboardDesktopGeometry.widgetWidthPx(
      pref.width,
      desktopSize,
    );
    final height = DashboardDesktopGeometry.widgetHeightPx(
      pref.height,
      desktopSize,
    );
    final isDraggingThis = pref.id == _draggingWidgetId;
    final draggingOffset = isDraggingThis
        ? _draggingPointerOffset ?? _offsetForWidget(pref, desktopSize)
        : null;
    final previewWidget = previewLayout?.widgets.where(
      (item) => item.id == pref.id,
    );
    final previewOffset =
        _previewOffsetsByWidgetId[pref.id] ??
        (previewWidget != null && previewWidget.isNotEmpty
            ? _offsetForWidget(previewWidget.first, desktopSize)
            : null);

    return DashboardDesktopItemWrapper(
      key: ValueKey('pos_${pref.id}'),
      position:
          draggingOffset ??
          previewOffset ??
          _offsetForWidget(pref, desktopSize),
      width: width,
      height: height,
      isDragging: isDraggingThis,
      child: _buildWrapper(
        context: context,
        pref: pref,
        definition: definition,
        desktopSize: desktopSize,
      ),
    );
  }

  Widget _buildDropIndicator(Size desktopSize) {
    final widgetId = _draggingWidgetId;
    if (widgetId == null || _previewDropOffset == null) {
      return const SizedBox.shrink();
    }

    DashboardWidgetPreference? pref;
    for (final item in widget.widgets) {
      if (item.id == widgetId) {
        pref = item;
        break;
      }
    }
    if (pref == null) {
      return const SizedBox.shrink();
    }

    final width = DashboardDesktopGeometry.widgetWidthPx(
      pref.width,
      desktopSize,
    );
    final height = DashboardDesktopGeometry.widgetHeightPx(
      pref.height,
      desktopSize,
    );

    return DashboardDesktopItemWrapper(
      key: const ValueKey('widget_drop_indicator'),
      position: _previewDropOffset!,
      width: width,
      height: height,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            borderRadius: const BorderRadius.all(.circular(20)),
            border: Border.all(
              color: Colors.white.withValues(alpha: .42),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: .08),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 44,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .55),
                borderRadius: const BorderRadius.all(.circular(999)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWrapper({
    required BuildContext context,
    required DashboardWidgetPreference pref,
    required DashboardWidgetDefinition definition,
    required Size desktopSize,
  }) {
    return DashboardWidgetWrapper(
      key: ValueKey('wrapper_${pref.id}'),
      name: definition.name(context),
      icon: definition.icon,
      frameStyle: definition.frameStyle,
      supportedSizes: definition.supportedSizes,
      currentSize: DashboardWidgetSize(pref.width, pref.height),
      onRemove: () =>
          context.read<DashboardPreferencesCubit>().removeWidget(pref.id),
      onResize: (newSize) =>
          context.read<DashboardPreferencesCubit>().updateWidgetSize(
            pref.id,
            newSize.width,
            newSize.height,
            desktopSize: desktopSize,
          ),
      onBringToFront: () =>
          context.read<DashboardPreferencesCubit>().bringWidgetToFront(pref.id),
      onSendToBack: () =>
          context.read<DashboardPreferencesCubit>().sendWidgetToBack(pref.id),
      onDragStart: (details) {
        final currentOffset = _offsetForWidget(pref, desktopSize);
        setState(() {
          _draggingWidgetId = pref.id;
          _draggingPointerOffset = currentOffset;
          _previewDropOffset = currentOffset;
          _previewOffsetsByWidgetId = const {};
        });
      },
      onDragUpdate: (details) {
        final pointerOffset = _draggingPointerOffset;
        if (pointerOffset == null) {
          return;
        }

        final width = DashboardDesktopGeometry.widgetWidthPx(
          pref.width,
          desktopSize,
        );
        final height = DashboardDesktopGeometry.widgetHeightPx(
          pref.height,
          desktopSize,
        );
        final nextPointerOffset = _clampPointerOffset(
          pointerOffset + details.delta,
          width,
          height,
          desktopSize,
        );
        final targetCell = DashboardDesktopGeometry.offsetToCell(
          nextPointerOffset,
          spanWidth: pref.width,
          spanHeight: pref.height,
          desktopSize: desktopSize,
        );
        final previewLayout = DashboardDesktopLayoutEngine.moveWidget(
          preferences: context.read<DashboardPreferencesCubit>().state,
          widgetId: pref.id,
          gridColumn: targetCell.col,
          gridRow: targetCell.row,
          desktopSize: desktopSize,
        );

        Offset? nextDropOffset;
        for (final item in previewLayout.widgets) {
          if (item.id == pref.id) {
            nextDropOffset = _offsetForWidget(item, desktopSize);
            break;
          }
        }

        setState(() {
          _draggingPointerOffset = nextPointerOffset;
          _previewDropOffset =
              nextDropOffset ?? _offsetForWidget(pref, desktopSize);
          _previewOffsetsByWidgetId = {
            for (final item in previewLayout.widgets)
              if (item.id != pref.id)
                item.id: _offsetForWidget(item, desktopSize),
          };
        });
        widget.previewController.value = previewLayout;
      },
      onDragEnd: (details) async {
        final widgetId = _draggingWidgetId;
        final finalPointerOffset = _draggingPointerOffset;

        if (widgetId != null && finalPointerOffset != null) {
          final targetCell = DashboardDesktopGeometry.offsetToCell(
            finalPointerOffset,
            spanWidth: pref.width,
            spanHeight: pref.height,
            desktopSize: desktopSize,
          );
          final preferences = context.read<DashboardPreferencesCubit>().state;
          final finalLayout = DashboardDesktopLayoutEngine.moveWidget(
            preferences: preferences,
            widgetId: widgetId,
            gridColumn: targetCell.col,
            gridRow: targetCell.row,
            exactDx: preferences.snapToGrid ? null : finalPointerOffset.dx,
            exactDy: preferences.snapToGrid ? null : finalPointerOffset.dy,
            desktopSize: desktopSize,
          );
          DashboardWidgetPreference? droppedWidget;
          for (final item in finalLayout.widgets) {
            if (item.id == widgetId) {
              droppedWidget = item;
              break;
            }
          }
          widget.previewController.value = finalLayout;

          setState(() {
            _draggingWidgetId = null;
            _draggingPointerOffset = null;
            _previewDropOffset = null;
            _previewOffsetsByWidgetId = const {};
          });

          await context.read<DashboardPreferencesCubit>().updateWidgetPosition(
            widgetId,
            droppedWidget?.gridColumn ?? targetCell.col,
            droppedWidget?.gridRow ?? targetCell.row,
            exactDx: preferences.snapToGrid ? null : finalPointerOffset.dx,
            exactDy: preferences.snapToGrid ? null : finalPointerOffset.dy,
            desktopSize: desktopSize,
          );
          if (context.mounted) {
            widget.previewController.value = null;
          }
          return;
        }

        setState(() {
          _draggingWidgetId = null;
          _draggingPointerOffset = null;
          _previewDropOffset = null;
          _previewOffsetsByWidgetId = const {};
        });
        widget.previewController.value = null;
      },
      onDragCancel: () {
        setState(() {
          _draggingWidgetId = null;
          _draggingPointerOffset = null;
          _previewDropOffset = null;
          _previewOffsetsByWidgetId = const {};
        });
        widget.previewController.value = null;
      },
      child: DashboardWidgetSettingsScope(
        id: pref.id,
        settings: pref.settings,
        child: definition.build(
          context,
          DashboardWidgetSize(pref.width, pref.height),
        ),
      ),
    );
  }
}
