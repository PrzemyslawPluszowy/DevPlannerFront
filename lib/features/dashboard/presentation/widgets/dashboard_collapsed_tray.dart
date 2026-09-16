import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/application/dashboard_preferences_cubit.dart';
import 'package:ready_next/features/dashboard/application/dashboard_shortcuts_state.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_widget_preference.dart';
import 'package:ready_next/features/dashboard/domain/services/dashboard_desktop_layout_engine.dart';
import 'package:ready_next/features/dashboard/presentation/shortcuts/dashboard_shortcuts_catalog.dart';
import 'package:ready_next/features/dashboard/presentation/shortcuts/dashboard_shortcuts_panel.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_wrapper.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widgets_catalog.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Pływający przycisk (zasobnik), który grupuje widgety i skróty
/// niewieszczące się na aktualnej siatce ekranu (overflowed).
/// Kliknięcie otwiera szklany modal bottom sheet z pełną interakcją.
class DashboardCollapsedTray extends StatelessWidget {
  /// Tworzy zasobnik dla elementów schowanych.
  const DashboardCollapsedTray({
    required this.overflowedWidgets,
    required this.overflowedShortcuts,
    required this.onShortcutPressed,
    super.key,
  });

  /// Lista widgetów, które nie zmieściły się na ekranie.
  final List<DashboardWidgetPreference> overflowedWidgets;

  /// Lista skrótów, które nie zmieściły się na ekranie.
  final List<DashboardShortcutItemViewModel> overflowedShortcuts;

  /// Akcja wywołana przy naciśnięciu skrótu w zasobniku.
  final ValueChanged<DashboardShortcutItemViewModel> onShortcutPressed;

  @override
  Widget build(BuildContext context) {
    final totalCount = overflowedWidgets.length + overflowedShortcuts.length;
    if (totalCount == 0) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      bottom: Sizes.p24,
      right: Sizes.p24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(.circular(30)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: .4)
                      : Colors.white.withValues(alpha: .5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showTraySheet(context),
                    borderRadius: const BorderRadius.all(.circular(30)),
                    child: Center(
                      child: Icon(
                        Icons.layers_rounded,
                        size: 28,
                        color: isDark ? Colors.white : colors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const .all(Sizes.p4),
              decoration: BoxDecoration(
                color: colors.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.error.withValues(alpha: .4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 22,
                minHeight: 22,
              ),
              child: Center(
                child: Text(
                  totalCount.toString(),
                  style: context.text.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: .bold,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTraySheet(BuildContext context) {
    final intl = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final preferencesCubit = context.read<DashboardPreferencesCubit>();

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: .4),
        isScrollControlled: true,
        builder: (context) {
          return BlocProvider.value(
            value: preferencesCubit,
            child: BlocBuilder<DashboardPreferencesCubit, DashboardPreferences>(
              builder: (context, state) {
                final currentOverflowedWidgets =
                    context
                        .read<DashboardPreferencesCubit>()
                        .activeLayout
                        ?.overflowedWidgets ??
                    overflowedWidgets;

                return ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Sizes.p24),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      color: isDark
                          ? Colors.black.withValues(alpha: .65)
                          : Colors.white.withValues(alpha: .75),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                        maxWidth: 600,
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: .min,
                          children: [
                            Gaps.h12,
                            Container(
                              width: 44,
                              height: 5,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: .3)
                                    : Colors.black.withValues(alpha: .2),
                                borderRadius: const BorderRadius.all(
                                  .circular(99),
                                ),
                              ),
                            ),
                            Gaps.h16,
                            Padding(
                              padding: const .symmetric(horizontal: Sizes.p24),
                              child: Column(
                                children: [
                                  AppText(
                                    intl.dashboardCollapsedTrayTitle,
                                    style: context.text.titleLarge?.copyWith(
                                      fontWeight: .bold,
                                    ),
                                  ),
                                  Gaps.h4,
                                  AppText(
                                    intl.dashboardCollapsedTraySubtitle,
                                    textAlign: .center,
                                    style: context.text.bodyMedium?.copyWith(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gaps.h16,
                            const Divider(height: 1),
                            Flexible(
                              child: ListView(
                                padding: const .symmetric(vertical: Sizes.p16),
                                shrinkWrap: true,
                                children: [
                                  if (overflowedShortcuts.isNotEmpty) ...[
                                    Padding(
                                      padding: const .symmetric(
                                        horizontal: Sizes.p24,
                                        vertical: Sizes.p8,
                                      ),
                                      child: AppText(
                                        intl.dashboardCollapsedTrayShortcuts(
                                          overflowedShortcuts.length,
                                        ),
                                        style: context.text.titleMedium
                                            ?.copyWith(
                                              fontWeight: .bold,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const .symmetric(
                                        horizontal: Sizes.p16,
                                      ),
                                      child: Wrap(
                                        spacing: Sizes.p8,
                                        runSpacing: Sizes.p8,
                                        alignment: WrapAlignment.center,
                                        children: [
                                          for (final shortcut
                                              in overflowedShortcuts)
                                            _buildShortcutTile(
                                              context,
                                              shortcut,
                                            ),
                                        ],
                                      ),
                                    ),
                                    Gaps.h16,
                                  ],
                                  if (currentOverflowedWidgets.isNotEmpty) ...[
                                    Padding(
                                      padding: const .symmetric(
                                        horizontal: Sizes.p24,
                                        vertical: Sizes.p8,
                                      ),
                                      child: AppText(
                                        intl.dashboardCollapsedTrayWidgets(
                                          currentOverflowedWidgets.length,
                                        ),
                                        style: context.text.titleMedium
                                            ?.copyWith(
                                              fontWeight: .bold,
                                            ),
                                      ),
                                    ),
                                    for (final widgetPref
                                        in currentOverflowedWidgets)
                                      _buildWidgetCard(context, widgetPref),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildShortcutTile(
    BuildContext context,
    DashboardShortcutItemViewModel shortcut,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          onShortcutPressed(shortcut);
        },
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        child: Padding(
          padding: const .all(Sizes.p8),
          child: Column(
            mainAxisSize: .min,
            children: [
              DashboardShortcutIcon(
                shortcutId: shortcut.shortcutId,
                icon: shortcut.icon,
              ),
              Gaps.h4,
              SizedBox(
                width: 76,
                child: AppText(
                  shortcut.displayLabel(context.l10n),
                  maxLines: 1,
                  overflow: .ellipsis,
                  textAlign: .center,
                  style: context.text.labelMedium?.copyWith(
                    fontWeight: .w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetCard(
    BuildContext context,
    DashboardWidgetPreference widgetPref,
  ) {
    final permissions = context.select<AuthCubit, Set<String>>(
      (cubit) => switch (cubit.state) {
        AuthAuthenticated(:final user) => user?.permissions ?? const {},
        _ => const {},
      },
    );
    final definition = DashboardWidgetsCatalog.getById(
      widgetPref.widgetTypeId,
      permissions,
    );
    if (definition == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.colors;

    return Container(
      margin: const .symmetric(horizontal: Sizes.p24, vertical: Sizes.p8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: .06)
            : Colors.black.withValues(alpha: .04),
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: .12)
              : Colors.black.withValues(alpha: .08),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const .symmetric(
              horizontal: Sizes.p16,
              vertical: Sizes.p8,
            ),
            child: Row(
              children: [
                Icon(
                  definition.icon,
                  size: 20,
                  color: colors.primary,
                ),
                Gaps.w8,
                Expanded(
                  child: AppText(
                    definition.name(context),
                    style: context.text.titleSmall?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: colors.error,
                  onPressed: () async {
                    await context
                        .read<DashboardPreferencesCubit>()
                        .removeWidget(
                          widgetPref.id,
                        );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Container(
            height: 180,
            padding: const .all(Sizes.p12),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
              child: FittedBox(
                child: SizedBox(
                  width: DashboardDesktopGeometry.widgetWidthPx(
                    widgetPref.width,
                  ),
                  height: DashboardDesktopGeometry.widgetHeightPx(
                    widgetPref.height,
                  ),
                  child: IgnorePointer(
                    child: DashboardWidgetWrapper(
                      name: definition.name(context),
                      icon: definition.icon,
                      frameStyle: definition.frameStyle,
                      supportedSizes: definition.supportedSizes,
                      currentSize: DashboardWidgetSize(
                        widgetPref.width,
                        widgetPref.height,
                      ),
                      onRemove: () {},
                      onResize: (_) {},
                      child: definition.build(
                        context,
                        DashboardWidgetSize(
                          widgetPref.width,
                          widgetPref.height,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
