import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/application/dashboard_shortcuts_cubit.dart';
import 'package:ready_next/features/dashboard/application/dashboard_shortcuts_state.dart';
import 'package:ready_next/features/dashboard/presentation/shortcuts/dashboard_shortcuts_catalog.dart';
import 'package:ready_next/features/dashboard/presentation/shortcuts/dashboard_shortcuts_panel.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Panel boczny konfiguracji skrótów dashboardu (dostępnych modułów).
class DashboardShortcutsMenuPanel extends StatelessWidget {
  /// Tworzy panel konfiguracji skrótów.
  const DashboardShortcutsMenuPanel({
    required this.onClose,
    required this.desktopSize,
    super.key,
  });

  /// Akcja zamknięcia panelu.
  final VoidCallback onClose;

  /// Rozmiar pulpitu.
  final Size desktopSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardShortcutsCubit, DashboardShortcutsState>(
      builder: (context, state) {
        return switch (state) {
          DashboardShortcutsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          DashboardShortcutsReady() => _DashboardShortcutsWorkspace(
            state: state,
            desktopSize: desktopSize,
            onClose: onClose,
          ),
        };
      },
    );
  }
}

/// Obszar roboczy konfiguracji skrótów dashboardu.
class _DashboardShortcutsWorkspace extends StatelessWidget {
  /// Tworzy obszar roboczy.
  const _DashboardShortcutsWorkspace({
    required this.state,
    required this.desktopSize,
    required this.onClose,
  });

  /// Stan skrótów.
  final DashboardShortcutsReady state;

  /// Rozmiar pulpitu.
  final Size desktopSize;

  /// Akcja zamknięcia.
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final sortedItems = [...state.items]
      ..sort(
        (a, b) => a
            .displayLabel(intl)
            .toLowerCase()
            .compareTo(
              b.displayLabel(intl).toLowerCase(),
            ),
      );

    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest.withValues(alpha: .92),
        borderRadius: const BorderRadius.all(.circular(Sizes.p24)),
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: .5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const .all(Sizes.p20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    intl.dashboardShortcutsPickerTitle,
                    style: context.text.titleMedium?.copyWith(
                      fontWeight: .w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                  tooltip: intl.dashboardShortcutsPickerCloseTooltip,
                ),
              ],
            ),
            Gaps.h4,
            AppText(
              intl.dashboardShortcutsPickerInstruction,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            Gaps.h16,
            Expanded(
              child: ListView.separated(
                itemCount: sortedItems.length,
                separatorBuilder: (context, index) => Gaps.h12,
                itemBuilder: (context, index) {
                  final item = sortedItems[index];
                  return _ShortcutListItem(
                    item: item,
                    desktopSize: desktopSize,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wiersz pojedynczego skrótu. Zarządza logiką przełączania i przekazuje ją do kafelka.
class _ShortcutListItem extends StatelessWidget {
  /// Tworzy wiersz skrótu.
  const _ShortcutListItem({
    required this.item,
    required this.desktopSize,
  });

  /// Dane pojedynczego skrótu.
  final DashboardShortcutItemViewModel item;

  /// Rozmiar pulpitu.
  final Size desktopSize;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardShortcutsCubit>();

    Future<void> onToggle() async {
      if (item.isVisible) {
        await cubit.hideShortcut(item.shortcutId);
      } else {
        await cubit.showShortcut(
          item.shortcutId,
          desktopSize: desktopSize,
        );
      }
    }

    return _ShortcutTileBody(
      item: item,
      onToggle: onToggle,
    );
  }
}

/// Wizualna reprezentacja kafelka skrótu w menu z natychmiastowym przeciąganiem ikony.
class _ShortcutTileBody extends StatelessWidget {
  /// Tworzy reprezentację kafelka.
  const _ShortcutTileBody({
    required this.item,
    required this.onToggle,
  });

  /// Dane skrótu.
  final DashboardShortcutItemViewModel item;

  /// Akcja przełączenia widoczności.
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: item.isVisible
            ? context.colors.surfaceContainerLow
            : context.colors.surface,
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        border: Border.all(
          color: item.isVisible
              ? context.colors.outlineVariant
              : context.colors.outlineVariant.withValues(alpha: .5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggle,
          borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
          child: Padding(
            padding: const .all(Sizes.p12),
            child: Row(
              children: [
                // Tylko ikona na lewo jest przeciągalna (Draggable) - bez opóźnień.
                // Kliknięcie ikony przechodzi w górę do InkWell dzięki brakowi GestureDetector.
                Draggable<String>(
                  data: item.shortcutId,
                  dragAnchorStrategy: pointerDragAnchorStrategy,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Opacity(
                      opacity: .9,
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          DashboardShortcutIcon(
                            shortcutId: item.shortcutId,
                            icon: item.icon,
                          ),
                          Gaps.h8,
                          Container(
                            width: 80,
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
                            child: Text(
                              item.displayLabel(intl),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: .4,
                    child: DashboardShortcutIcon(
                      shortcutId: item.shortcutId,
                      icon: item.icon,
                      size: 40,
                      iconSize: 20,
                    ),
                  ),
                  child: DashboardShortcutIcon(
                    shortcutId: item.shortcutId,
                    icon: item.icon,
                    size: 40,
                    iconSize: 20,
                  ),
                ),
                Gaps.w12,
                Expanded(
                  child: Padding(
                    padding: const .symmetric(vertical: Sizes.p4),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        AppText(
                          item.displayLabel(intl),
                          style: context.text.titleSmall?.copyWith(
                            fontWeight: .w700,
                            color: item.isVisible
                                ? context.colors.onSurface
                                : context.colors.onSurface.withValues(
                                    alpha: .7,
                                  ),
                          ),
                        ),
                        Gaps.h4,
                        AppText(
                          item.isVisible
                              ? intl.dashboardShortcutsPickerVisibleLabel
                              : intl.dashboardShortcutsPickerDragHint,
                          style: context.text.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Ignorujemy wskaźnik na Switchu, aby kliknięcie w niego propagowało się do InkWell.
                // Zapobiega to podwójnemu wywoływaniu akcji (konflikt kliknięcia w Switch i InkWell).
                IgnorePointer(
                  child: Switch(
                    value: item.isVisible,
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
