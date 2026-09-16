import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/application/dashboard_preferences_cubit.dart';
import 'package:ready_next/features/dashboard/application/dashboard_shortcuts_cubit.dart';
import 'package:ready_next/features/dashboard/application/dashboard_shortcuts_state.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_ids.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_preference.dart';
import 'package:ready_next/features/dashboard/domain/services/dashboard_desktop_layout_engine.dart';
import 'package:ready_next/features/dashboard/presentation/shortcuts/dashboard_shortcuts_catalog.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_desktop_item_wrapper.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_tooltip.dart';

final double _desktopShortcutWidth = DashboardDesktopGeometry.shortcutWidth;
final double _desktopShortcutHeight = DashboardDesktopGeometry.shortcutHeight;

/// Wizualna ikona skrótu o podwyższonej estetyce z gradientem i cieniem.
class DashboardShortcutIcon extends StatelessWidget {
  /// Tworzy ikonę skrótu.
  const DashboardShortcutIcon({
    required this.shortcutId,
    required this.icon,
    this.size = 60,
    this.iconSize = 32,
    super.key,
  });

  /// Identyfikator skrótu do dopasowania gradientu.
  final String shortcutId;

  /// Ikona do wyświetlenia.
  final IconData icon;

  /// Całkowity rozmiar kontenera.
  final double size;

  /// Rozmiar ikony wewnątrz kontenera.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final Gradient gradient = switch (shortcutId) {
      DashboardShortcutIds.inventory => const LinearGradient(
        begin: .topLeft,
        end: .bottomRight,
        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      ),
      DashboardShortcutIds.bhp => const LinearGradient(
        begin: .topLeft,
        end: .bottomRight,
        colors: [Color(0xFF10B981), Color(0xFF047857)],
      ),
      DashboardShortcutIds.settings || _ => const LinearGradient(
        begin: .topLeft,
        end: .bottomRight,
        colors: [Color(0xFF6B7280), Color(0xFF374151)],
      ),
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .24),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: .15),
            offset: const Offset(0, -1.5),
            blurStyle: BlurStyle.outer,
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: .25),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Ikony skrótów wyświetlane bezpośrednio na powierzchni dashboardu.
class DashboardShortcutsPanel extends StatelessWidget {
  /// Tworzy powierzchnię ikon dashboardu.
  const DashboardShortcutsPanel({
    required this.items,
    required this.onShortcutPressed,
    required this.onShortcutRenamePressed,
    required this.onShortcutRemovePressed,
    required this.previewController,
    super.key,
  });

  /// Lista skrótów do wyświetlenia na ekranie.
  final List<DashboardShortcutItemViewModel> items;

  /// Akcja otwarcia konkretnego skrótu.
  final ValueChanged<DashboardShortcutItemViewModel> onShortcutPressed;

  /// Akcja zmiany nazwy konkretnego skrótu.
  final ValueChanged<DashboardShortcutItemViewModel> onShortcutRenamePressed;

  /// Akcja usunięcia konkretnego skrótu z pulpitu.
  final ValueChanged<DashboardShortcutItemViewModel> onShortcutRemovePressed;

  /// Współdzielony kontroler podglądu układu pulpitu.
  final ValueNotifier<DashboardDesktopLayoutResult?> previewController;

  @override
  Widget build(BuildContext context) {
    return _DashboardDesktopShortcuts(
      items: items,
      previewController: previewController,
      onShortcutPressed: onShortcutPressed,
      onShortcutRenamePressed: onShortcutRenamePressed,
      onShortcutRemovePressed: onShortcutRemovePressed,
    );
  }
}

/// Rozmieszcza skróty pulpitu na sztywnej siatce.
class _DashboardDesktopShortcuts extends StatefulWidget {
  /// Tworzy powierzchnię pulpitu ze skrótami.
  const _DashboardDesktopShortcuts({
    required this.items,
    required this.previewController,
    required this.onShortcutPressed,
    required this.onShortcutRenamePressed,
    required this.onShortcutRemovePressed,
  });

  /// Widoczne skróty dashboardu.
  final List<DashboardShortcutItemViewModel> items;

  /// Współdzielony kontroler podglądu układu pulpitu.
  final ValueNotifier<DashboardDesktopLayoutResult?> previewController;

  /// Akcja otwarcia konkretnego skrótu.
  final ValueChanged<DashboardShortcutItemViewModel> onShortcutPressed;

  /// Akcja zmiany nazwy konkretnego skrótu.
  final ValueChanged<DashboardShortcutItemViewModel> onShortcutRenamePressed;

  /// Akcja usunięcia konkretnego skrótu z pulpitu.
  final ValueChanged<DashboardShortcutItemViewModel> onShortcutRemovePressed;

  @override
  State<_DashboardDesktopShortcuts> createState() =>
      _DashboardDesktopShortcutsState();
}

/// Stan powierzchni skrótów obsługujący podgląd przeciągania.
class _DashboardDesktopShortcutsState
    extends State<_DashboardDesktopShortcuts> {
  static const Duration _reflowDuration = Duration(milliseconds: 220);
  static const Curve _reflowCurve = Curves.easeOutCubic;

  String? _draggingShortcutId;
  Offset? _draggingPointerOffset;
  Map<String, Offset> _previewOffsetsByShortcutId = const {};
  Offset? _previewDropOffset;

  Offset _offsetForShortcut(
    DashboardShortcutPreference shortcut,
    Size desktopSize,
  ) {
    final preferences = context.read<DashboardPreferencesCubit>().state;
    if (!preferences.snapToGrid &&
        shortcut.exactDx != null &&
        shortcut.exactDy != null) {
      return Offset(shortcut.exactDx!, shortcut.exactDy!);
    }
    return DashboardDesktopGeometry.cellOffset(
      shortcut.gridColumn,
      shortcut.gridRow,
      desktopSize,
    );
  }

  Offset _offsetForItem(
    DashboardShortcutItemViewModel item,
    Size desktopSize,
  ) {
    final preferences = context.read<DashboardPreferencesCubit>().state;
    if (!preferences.snapToGrid &&
        item.exactDx != null &&
        item.exactDy != null) {
      return Offset(item.exactDx!, item.exactDy!);
    }
    return DashboardDesktopGeometry.cellOffset(
      item.gridColumn,
      item.gridRow,
      desktopSize,
    );
  }

  Offset _clampPointerOffset(Offset rawOffset, Size desktopSize) {
    final maxX = (desktopSize.width - _desktopShortcutWidth).clamp(
      0.0,
      double.infinity,
    );
    final maxY = (desktopSize.height - _desktopShortcutHeight).clamp(
      0.0,
      double.infinity,
    );

    return Offset(
      rawOffset.dx.clamp(0.0, maxX),
      rawOffset.dy.clamp(0.0, maxY),
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

            return DragTarget<String>(
              onAcceptWithDetails: (details) async {
                final renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox == null) {
                  return;
                }

                final localOffset = renderBox.globalToLocal(details.offset);
                final centeredOffset = Offset(
                  localOffset.dx - (_desktopShortcutWidth / 2),
                  localOffset.dy - (_desktopShortcutHeight / 2),
                );
                final clampedOffset = _clampPointerOffset(
                  centeredOffset,
                  desktopSize,
                );
                final targetCell = DashboardDesktopGeometry.offsetToCell(
                  clampedOffset,
                  spanWidth: DashboardDesktopGeometry.shortcutSpanWidth,
                  spanHeight: DashboardDesktopGeometry.shortcutSpanHeight,
                  desktopSize: desktopSize,
                );

                await context.read<DashboardShortcutsCubit>().showShortcut(
                  details.data,
                  desktopSize: desktopSize,
                  gridColumn: targetCell.col,
                  gridRow: targetCell.row,
                );
              },
              builder: (context, candidateData, rejectedData) {
                final sortedItems = [...widget.items]
                  ..sort((a, b) {
                    if (a.shortcutId == _draggingShortcutId) return 1;
                    if (b.shortcutId == _draggingShortcutId) return -1;
                    return 0;
                  });

                return Stack(
                  children: [
                    if (snapToGrid &&
                        _draggingShortcutId != null &&
                        _previewDropOffset != null)
                      _buildDropIndicator(),
                    for (final item in sortedItems)
                      _DraggableDesktopShortcut(
                        key: ValueKey(item.shortcutId),
                        item: item,
                        desktopSize: desktopSize,
                        position: _effectiveOffsetFor(
                          item,
                          previewLayout,
                          desktopSize,
                        ),
                        isDragging: item.shortcutId == _draggingShortcutId,
                        animationDuration: _reflowDuration,
                        animationCurve: _reflowCurve,
                        onPressed: () => widget.onShortcutPressed(item),
                        onRenamePressed: () =>
                            widget.onShortcutRenamePressed(item),
                        onRemovePressed: () =>
                            widget.onShortcutRemovePressed(item),
                        onDragStart: () {
                          final currentOffset = _offsetForItem(
                            item,
                            desktopSize,
                          );
                          setState(() {
                            _draggingShortcutId = item.shortcutId;
                            _draggingPointerOffset = currentOffset;
                            _previewOffsetsByShortcutId = const {};
                            _previewDropOffset = currentOffset;
                          });
                        },
                        onDragUpdate: (delta) {
                          final draggingPointerOffset = _draggingPointerOffset;
                          if (draggingPointerOffset == null) {
                            return;
                          }

                          final nextPointerOffset = _clampPointerOffset(
                            draggingPointerOffset + delta,
                            desktopSize,
                          );
                          final targetCell =
                              DashboardDesktopGeometry.offsetToCell(
                                nextPointerOffset,
                                spanWidth:
                                    DashboardDesktopGeometry.shortcutSpanWidth,
                                spanHeight:
                                    DashboardDesktopGeometry.shortcutSpanHeight,
                                desktopSize: desktopSize,
                              );
                          final previewLayout =
                              DashboardDesktopLayoutEngine.moveShortcut(
                                preferences: _buildPreviewPreferences(context),
                                shortcutId: item.shortcutId,
                                gridColumn: targetCell.col,
                                gridRow: targetCell.row,
                                desktopSize: desktopSize,
                              );
                          Offset? nextDropOffset;
                          for (final shortcut in previewLayout.shortcuts) {
                            if (shortcut.shortcutId == item.shortcutId) {
                              nextDropOffset = _offsetForShortcut(
                                shortcut,
                                desktopSize,
                              );
                              break;
                            }
                          }

                          setState(() {
                            _draggingPointerOffset = nextPointerOffset;
                            _previewOffsetsByShortcutId = {
                              for (final shortcut in previewLayout.shortcuts)
                                if (shortcut.isVisible &&
                                    shortcut.shortcutId != item.shortcutId)
                                  shortcut.shortcutId: _offsetForShortcut(
                                    shortcut,
                                    desktopSize,
                                  ),
                            };
                            _previewDropOffset =
                                nextDropOffset ??
                                _offsetForItem(item, desktopSize);
                          });
                          widget.previewController.value = previewLayout;
                        },
                        onDragEnd: () async {
                          final finalPointerOffset = _draggingPointerOffset;
                          if (finalPointerOffset == null) {
                            setState(() {
                              _draggingShortcutId = null;
                              _draggingPointerOffset = null;
                              _previewOffsetsByShortcutId = const {};
                              _previewDropOffset = null;
                            });
                            widget.previewController.value = null;
                            return;
                          }

                          final targetCell =
                              DashboardDesktopGeometry.offsetToCell(
                                finalPointerOffset,
                                spanWidth:
                                    DashboardDesktopGeometry.shortcutSpanWidth,
                                spanHeight:
                                    DashboardDesktopGeometry.shortcutSpanHeight,
                                desktopSize: desktopSize,
                              );
                          final preferences = context
                              .read<DashboardPreferencesCubit>()
                              .state;
                          final finalLayout =
                              DashboardDesktopLayoutEngine.moveShortcut(
                                preferences: _buildPreviewPreferences(context),
                                shortcutId: item.shortcutId,
                                gridColumn: targetCell.col,
                                gridRow: targetCell.row,
                                exactDx: preferences.snapToGrid
                                    ? null
                                    : finalPointerOffset.dx,
                                exactDy: preferences.snapToGrid
                                    ? null
                                    : finalPointerOffset.dy,
                                desktopSize: desktopSize,
                              );
                          DashboardShortcutPreference? droppedShortcut;
                          for (final shortcut in finalLayout.shortcuts) {
                            if (shortcut.shortcutId == item.shortcutId) {
                              droppedShortcut = shortcut;
                              break;
                            }
                          }
                          widget.previewController.value = finalLayout;
                          setState(() {
                            _draggingShortcutId = null;
                            _draggingPointerOffset = null;
                            _previewOffsetsByShortcutId = const {};
                            _previewDropOffset = null;
                          });

                          final savedPreferences = await context
                              .read<DashboardShortcutsCubit>()
                              .setShortcutDesktopPosition(
                                item.shortcutId,
                                gridColumn:
                                    droppedShortcut?.gridColumn ??
                                    targetCell.col,
                                gridRow:
                                    droppedShortcut?.gridRow ?? targetCell.row,
                                exactDx: preferences.snapToGrid
                                    ? null
                                    : finalPointerOffset.dx,
                                exactDy: preferences.snapToGrid
                                    ? null
                                    : finalPointerOffset.dy,
                                desktopSize: desktopSize,
                              );
                          if (!context.mounted) {
                            return;
                          }
                          if (savedPreferences == null) {
                            widget.previewController.value = null;
                            return;
                          }
                          context
                              .read<DashboardPreferencesCubit>()
                              .applySavedPreferences(savedPreferences);
                          widget.previewController.value = null;
                        },
                        onDragCancel: () {
                          setState(() {
                            _draggingShortcutId = null;
                            _draggingPointerOffset = null;
                            _previewOffsetsByShortcutId = const {};
                            _previewDropOffset = null;
                          });
                          widget.previewController.value = null;
                        },
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDropIndicator() {
    return DashboardDesktopItemWrapper(
      key: const ValueKey('shortcut_drop_indicator'),
      position: _previewDropOffset!,
      width: _desktopShortcutWidth,
      height: _desktopShortcutHeight,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
                border: Border.all(
                  color: Colors.white.withValues(alpha: .55),
                ),
              ),
              child: Icon(
                Icons.add_rounded,
                color: Colors.white.withValues(alpha: .72),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Offset _effectiveOffsetFor(
    DashboardShortcutItemViewModel item,
    DashboardDesktopLayoutResult? previewLayout,
    Size desktopSize,
  ) {
    if (item.shortcutId == _draggingShortcutId) {
      return _draggingPointerOffset ?? _offsetForItem(item, desktopSize);
    }

    Offset? sharedPreviewOffset;
    if (previewLayout != null) {
      for (final shortcut in previewLayout.shortcuts) {
        if (shortcut.shortcutId == item.shortcutId && shortcut.isVisible) {
          sharedPreviewOffset = _offsetForShortcut(shortcut, desktopSize);
          break;
        }
      }
    }

    return _previewOffsetsByShortcutId[item.shortcutId] ??
        sharedPreviewOffset ??
        _offsetForItem(item, desktopSize);
  }

  DashboardPreferences _buildPreviewPreferences(BuildContext context) {
    final preferences = context.read<DashboardPreferencesCubit>().state;
    return preferences.copyWith(
      shortcuts: [
        for (final item in widget.items)
          DashboardShortcutPreference(
            shortcutId: item.shortcutId,
            userLabel: item.userLabel,
            isVisible: true,
            position: item.position,
            gridColumn: item.gridColumn,
            gridRow: item.gridRow,
            exactDx: item.exactDx,
            exactDy: item.exactDy,
          ),
      ],
    );
  }
}

/// Pojedyncza ikona skrótu na pulpicie z obsługą przeciągania.
class _DraggableDesktopShortcut extends StatefulWidget {
  /// Tworzy przeciąganą ikonę pulpitu.
  const _DraggableDesktopShortcut({
    required this.item,
    required this.desktopSize,
    required this.position,
    required this.isDragging,
    required this.animationDuration,
    required this.animationCurve,
    required this.onPressed,
    required this.onRenamePressed,
    required this.onRemovePressed,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDragCancel,
    super.key,
  });

  /// Dane pojedynczego skrótu.
  final DashboardShortcutItemViewModel item;

  /// Rozmiar dostępnego obszaru pulpitu.
  final Size desktopSize;

  /// Aktualna pozycja skrótu.
  final Offset position;

  /// Czy ten skrót jest przeciągany.
  final bool isDragging;

  /// Czas animacji reflow.
  final Duration animationDuration;

  /// Krzywa animacji reflow.
  final Curve animationCurve;

  /// Akcja otwarcia skrótu.
  final VoidCallback onPressed;

  /// Akcja zmiany nazwy skrótu.
  final VoidCallback onRenamePressed;

  /// Akcja usunięcia skrótu z pulpitu.
  final VoidCallback onRemovePressed;

  /// Start przeciągania.
  final VoidCallback onDragStart;

  /// Aktualizacja przeciągania.
  final ValueChanged<Offset> onDragUpdate;

  /// Koniec przeciągania.
  final Future<void> Function() onDragEnd;

  /// Anulowanie przeciągania.
  final VoidCallback onDragCancel;

  @override
  State<_DraggableDesktopShortcut> createState() =>
      _DraggableDesktopShortcutState();
}

/// Stan interakcji pojedynczej ikony skrótu.
class _DraggableDesktopShortcutState extends State<_DraggableDesktopShortcut> {
  static const _dragThreshold = 3.0;

  var _dragDistance = 0.0;
  int? _activePointer;
  bool _dragStarted = false;
  bool _isHovered = false;

  void _handlePointerDown(PointerDownEvent event) {
    if (event.buttons != 1) {
      return;
    }
    _activePointer = event.pointer;
    _dragStarted = false;
    _dragDistance = 0;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_activePointer != event.pointer) {
      return;
    }

    _dragDistance += event.delta.distance;
    if (!_dragStarted) {
      if (_dragDistance <= _dragThreshold) {
        return;
      }
      _dragStarted = true;
      widget.onDragStart();
    }

    widget.onDragUpdate(event.delta);
  }

  Future<void> _handlePointerUp(PointerUpEvent event) async {
    if (_activePointer != event.pointer) {
      return;
    }

    if (_dragStarted) {
      await widget.onDragEnd();
    }

    _activePointer = null;
    _dragStarted = false;
    setState(() {
      _dragDistance = 0.0;
    });
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_activePointer != event.pointer) {
      return;
    }

    if (_dragStarted) {
      widget.onDragCancel();
    }

    _activePointer = null;
    _dragStarted = false;
    setState(() {
      _dragDistance = 0.0;
    });
  }

  Future<void> _openContextMenu(
    BuildContext context,
    Offset globalPosition,
  ) async {
    await AppContextMenu.show(
      context,
      globalPosition: globalPosition,
      style: AppContextMenuStyle.glass,
      actions: [
        AppContextMenuAction(
          label: context.l10n.dashboardShortcutsPanelRenameAction,
          icon: Icons.edit_outlined,
          onTap: (_) => widget.onRenamePressed(),
        ),
        AppContextMenuAction(
          label: context.l10n.dashboardShortcutsPanelRemoveAction,
          icon: Icons.delete_outline_rounded,
          isDestructive: true,
          separatorBefore: true,
          onTap: (_) => widget.onRemovePressed(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final shortcut = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapUp: (details) =>
          _openContextMenu(context, details.globalPosition),
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _handlePointerDown,
        onPointerMove: _handlePointerMove,
        onPointerUp: _handlePointerUp,
        onPointerCancel: _handlePointerCancel,
        child: MouseRegion(
          cursor: SystemMouseCursors.grab,
          onEnter: (_) {
            if (_isHovered) {
              return;
            }
            setState(() => _isHovered = true);
          },
          onExit: (_) {
            if (!_isHovered) {
              return;
            }
            setState(() => _isHovered = false);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            decoration: _isHovered
                ? BoxDecoration(
                    borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .14),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  )
                : null,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (_dragDistance > _dragThreshold) {
                    return;
                  }
                  widget.onPressed();
                },
                borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: const .only(
                    left: Sizes.p4,
                    right: Sizes.p4,
                    top: Sizes.p4,
                    bottom: Sizes.p2,
                  ),
                  child: Column(
                    children: [
                      DashboardShortcutIcon(
                        shortcutId: widget.item.shortcutId,
                        icon: widget.item.icon,
                        size: 42,
                        iconSize: 22,
                      ),
                      Gaps.h2,
                      Expanded(
                        child: Align(
                          alignment: .topCenter,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: .topCenter,
                            child: SizedBox(
                              width: 74,
                              child: Container(
                                padding: const .symmetric(
                                  horizontal: Sizes.p4,
                                  vertical: Sizes.p2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .28),
                                  borderRadius: const BorderRadius.all(
                                    .circular(Sizes.p4),
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: .2),
                                    width: 0.5,
                                  ),
                                ),
                                child: AppText(
                                  widget.item.displayLabel(context.l10n),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: context.text.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: .w700,
                                    shadows: [
                                      const Shadow(
                                        color: Colors.black54,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
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
              ),
            ),
          ),
        ),
      ),
    );

    final tooltip = widget.item.displayLabel(context.l10n).trim();
    final wrappedShortcut = tooltip.isEmpty
        ? shortcut
        : AppTooltip(message: tooltip, child: shortcut);

    return DashboardDesktopItemWrapper(
      position: widget.position,
      width: _desktopShortcutWidth,
      height: _desktopShortcutHeight,
      isDragging: widget.isDragging,
      animationDuration: widget.animationDuration,
      animationCurve: widget.animationCurve,
      child: wrappedShortcut,
    );
  }
}
