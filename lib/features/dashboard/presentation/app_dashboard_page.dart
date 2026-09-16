import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/application/dashboard_application_export.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_domain_models_export.dart';
import 'package:ready_next/features/dashboard/domain/services/dashboard_desktop_layout_engine.dart';
import 'package:ready_next/features/dashboard/presentation/shortcuts/dashboard_shortcuts_export.dart';
import 'package:ready_next/features/dashboard/presentation/wallpaper_picker/dashboard_wallpaper_picker_sheet.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_collapsed_tray.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_picker_sidebar.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widgets_grid.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu.dart';
import 'package:ready_next/shared/presentation/widgets/app_wallpaper_background.dart';

/// Główny dashboard aplikacji ponad modułami domenowymi.
class AppDashboardPage extends StatelessWidget {
  /// Tworzy główny dashboard aplikacji.
  const AppDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final readyUserId = _resolveReadyUserId(context);
        final view = View.of(context);
        final physicalSize = view.physicalSize;
        final logicalSize = physicalSize / view.devicePixelRatio;

        return MultiBlocProvider(
          key: ValueKey(readyUserId),
          providers: [
            BlocProvider(
              create: (context) {
                final cubit = DashboardPreferencesCubit(
                  repository: context.read<DashboardPreferencesRepository>(),
                  readyUserId: readyUserId,
                  initialDesktopSize: logicalSize,
                );
                unawaited(cubit.load());
                return cubit;
              },
            ),
            BlocProvider(
              create: (context) {
                final cubit = DashboardShortcutsCubit(
                  repository: context.read<DashboardPreferencesRepository>(),
                  readyUserId: readyUserId,
                  permissions: switch (authState) {
                    AuthAuthenticated(:final user) =>
                      user?.permissions ?? const <String>{},
                    _ => const <String>{},
                  },
                );
                unawaited(cubit.load());
                return cubit;
              },
            ),
          ],
          child: const _AppDashboardBody(),
        );
      },
    );
  }

  String _resolveReadyUserId(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final launchContext = context.read<HostLaunchContext>();
    return switch (authState) {
      AuthAuthenticated(:final user) => resolveReadyUserId(
        user: user,
        hostUserId: launchContext.userId,
      ),
      _ => resolveReadyUserId(
        user: null,
        hostUserId: launchContext.userId,
      ),
    };
  }
}

/// Zawartość głównego dashboardu aplikacji.
class _AppDashboardBody extends StatefulWidget {
  /// Tworzy zawartość głównego dashboardu aplikacji.
  const _AppDashboardBody();

  @override
  State<_AppDashboardBody> createState() => _AppDashboardBodyState();
}

/// Stan głównego dashboardu aplikacji z obsługą animacji panelu bocznego.
class _AppDashboardBodyState extends State<_AppDashboardBody>
    with TickerProviderStateMixin {
  static const double _desktopResizeNormalizationThreshold = 1;

  late AnimationController _shortcutsPanelController;
  late Animation<Offset> _shortcutsPanelOffset;
  late Animation<double> _shortcutsPanelOpacity;

  late AnimationController _widgetsPanelController;
  late Animation<Offset> _widgetsPanelOffset;
  late Animation<double> _widgetsPanelOpacity;
  late ValueNotifier<DashboardDesktopLayoutResult?> _previewController;
  Size? _lastQueuedDesktopNormalizationSize;
  Timer? _normalizationDebounceTimer;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      unawaited(BrowserContextMenu.disableContextMenu());
    }

    _shortcutsPanelController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shortcutsPanelOffset =
        Tween<Offset>(
          begin: const Offset(
            1.0,
            0.0,
          ), // Zaczyna się całkowicie za prawą krawędzią
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _shortcutsPanelController,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    _shortcutsPanelOpacity =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _shortcutsPanelController,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        );

    _widgetsPanelController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _widgetsPanelOffset =
        Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _widgetsPanelController,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    _widgetsPanelOpacity =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _widgetsPanelController,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        );

    _previewController = ValueNotifier<DashboardDesktopLayoutResult?>(null);
  }

  @override
  void dispose() {
    if (kIsWeb) {
      unawaited(BrowserContextMenu.enableContextMenu());
    }
    _normalizationDebounceTimer?.cancel();
    _shortcutsPanelController.dispose();
    _widgetsPanelController.dispose();
    _previewController.dispose();
    super.dispose();
  }

  Size _desktopSize = Size.zero;
  bool _isShortcutsMenuOpen = false;
  bool _isWidgetsMenuOpen = false;

  void _openShortcutsMenu() {
    setState(() {
      _isShortcutsMenuOpen = true;
    });
    _shortcutsPanelController.forward();
  }

  void _closeShortcutsMenu() {
    unawaited(
      _shortcutsPanelController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _isShortcutsMenuOpen = false;
          });
        }
      }),
    );
  }

  void _openWidgetsMenu() {
    setState(() {
      _isWidgetsMenuOpen = true;
    });
    _widgetsPanelController.forward();
  }

  void _closeWidgetsMenu() {
    unawaited(
      _widgetsPanelController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _isWidgetsMenuOpen = false;
          });
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DashboardPreferencesCubit, DashboardPreferences>(
        listenWhen: (previous, current) =>
            previous.shortcuts != current.shortcuts,
        listener: (context, state) {
          unawaited(context.read<DashboardShortcutsCubit>().load());
        },
        child: BlocBuilder<DashboardPreferencesCubit, DashboardPreferences>(
          builder: (context, preferences) {
            final wallpaper = appWallpaperProviderFromPath(
              preferences.selectedWallpaperPath,
            );

            return BlocBuilder<
              DashboardShortcutsCubit,
              DashboardShortcutsState
            >(
              builder: (context, shortcutsState) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final safePadding = MediaQuery.paddingOf(context);
                    final effectiveWidth = math.max(
                      0.0,
                      constraints.maxWidth - safePadding.horizontal,
                    );
                    final effectiveHeight = math.max(
                      0.0,
                      constraints.maxHeight - safePadding.vertical,
                    );
                    _desktopSize = Size(effectiveWidth, effectiveHeight);
                    _scheduleDesktopLayoutNormalization(_desktopSize);

                    final cubit = context.read<DashboardPreferencesCubit>();
                    final overflowedWidgets =
                        cubit.activeLayout?.overflowedWidgets ?? const [];
                    final overflowedShortcutsPref =
                        cubit.activeLayout?.overflowedShortcuts ?? const [];
                    final shortcutItems = switch (shortcutsState) {
                      DashboardShortcutsReady(:final items) => items,
                      DashboardShortcutsLoading() =>
                        const <DashboardShortcutItemViewModel>[],
                    };

                    // Mapujemy preferencje schowanych skrótów na ich widoki modeli na podstawie stanu Cubit
                    final overflowedShortcutIds = overflowedShortcutsPref
                        .map((s) => s.shortcutId)
                        .toSet();
                    final overflowedShortcuts = shortcutItems
                        .where(
                          (item) =>
                              overflowedShortcutIds.contains(item.shortcutId),
                        )
                        .toList();

                    // Obliczamy widoczne skróty do wyświetlenia na ekranie z nowymi koordynatami
                    final visibleShortcutIds = preferences.shortcuts
                        .where((s) => s.isVisible)
                        .map((s) => s.shortcutId)
                        .toSet();
                    final normalizedShortcutsMap = {
                      for (final s in preferences.shortcuts) s.shortcutId: s,
                    };
                    final visibleShortcuts = shortcutItems
                        .where(
                          (item) =>
                              visibleShortcutIds.contains(item.shortcutId),
                        )
                        .map((item) {
                          final normalized =
                              normalizedShortcutsMap[item.shortcutId];
                          if (normalized == null) {
                            return item;
                          }
                          return item.copyWith(
                            gridColumn: normalized.gridColumn,
                            gridRow: normalized.gridRow,
                            isVisible: true,
                          );
                        })
                        .toList();

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onSecondaryTapUp: (details) =>
                          _openContextMenu(context, details.globalPosition),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: AppWallpaperBackground(wallpaper: wallpaper),
                          ),
                          Positioned.fill(
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: DashboardWidgetsGrid(
                                    widgets: preferences.widgets,
                                    previewController: _previewController,
                                  ),
                                ),
                                DashboardShortcutsPanel(
                                  items: visibleShortcuts,
                                  previewController: _previewController,
                                  onShortcutPressed: (shortcut) =>
                                      _openShortcut(context, shortcut),
                                  onShortcutRenamePressed: (shortcut) =>
                                      _renameShortcut(context, shortcut),
                                  onShortcutRemovePressed: (shortcut) =>
                                      _removeShortcut(context, shortcut),
                                ),
                              ],
                            ),
                          ),
                          // Zasobnik ze schowanymi elementami (modal i pływający przycisk)
                          if (overflowedWidgets.isNotEmpty ||
                              overflowedShortcuts.isNotEmpty)
                            DashboardCollapsedTray(
                              overflowedWidgets: overflowedWidgets,
                              overflowedShortcuts: overflowedShortcuts,
                              onShortcutPressed: (shortcut) =>
                                  _openShortcut(context, shortcut),
                            ),
                          if (_isShortcutsMenuOpen)
                            Positioned(
                              top: Sizes.p24,
                              right: Sizes.p24,
                              bottom: Sizes.p24,
                              child: SlideTransition(
                                position: _shortcutsPanelOffset,
                                child: FadeTransition(
                                  opacity: _shortcutsPanelOpacity,
                                  child: TapRegion(
                                    groupId: 'dashboard_sidebars',
                                    onTapOutside: (event) {
                                      if (_isShortcutsMenuOpen) {
                                        _closeShortcutsMenu();
                                      }
                                    },
                                    child: GestureDetector(
                                      onTap: () {}, // Blokuje bąbelkowanie kliknięcia do tła pulpitu
                                      behavior: HitTestBehavior.opaque,
                                      child: DashboardShortcutsMenuPanel(
                                        onClose: _closeShortcutsMenu,
                                        desktopSize: _desktopSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_isWidgetsMenuOpen)
                            Positioned(
                              top: Sizes.p24,
                              right: Sizes.p24,
                              bottom: Sizes.p24,
                              child: SlideTransition(
                                position: _widgetsPanelOffset,
                                child: FadeTransition(
                                  opacity: _widgetsPanelOpacity,
                                  child: TapRegion(
                                    groupId: 'dashboard_sidebars',
                                    onTapOutside: (event) {
                                      if (_isWidgetsMenuOpen) {
                                        _closeWidgetsMenu();
                                      }
                                    },
                                    child: GestureDetector(
                                      onTap: () {},
                                      behavior: HitTestBehavior.opaque,
                                      child: DashboardWidgetPickerSidebar(
                                        desktopSize: _desktopSize,
                                        onClose: _closeWidgetsMenu,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _scheduleDesktopLayoutNormalization(Size desktopSize) {
    final previousSize = _lastQueuedDesktopNormalizationSize;
    if (previousSize != null &&
        (previousSize.width - desktopSize.width).abs() <
            _desktopResizeNormalizationThreshold &&
        (previousSize.height - desktopSize.height).abs() <
            _desktopResizeNormalizationThreshold) {
      return;
    }

    _lastQueuedDesktopNormalizationSize = desktopSize;
    _normalizationDebounceTimer?.cancel();

    if (previousSize == null) {
      // Pierwsza normalizacja przy montowaniu widżetu wykonywana jest natychmiastowo.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        unawaited(
          context
              .read<DashboardPreferencesCubit>()
              .normalizeLayoutForDesktopSize(
                desktopSize,
              ),
        );
      });
    } else {
      // Kolejne normalizacje podczas płynnego skalowania okna są debouncowane o 150 ms.
      _normalizationDebounceTimer = Timer(
        const Duration(milliseconds: 150),
        () {
          if (!mounted) {
            return;
          }
          unawaited(
            context
                .read<DashboardPreferencesCubit>()
                .normalizeLayoutForDesktopSize(
                  desktopSize,
                ),
          );
        },
      );
    }
  }

  Future<void> _openContextMenu(
    BuildContext context,
    Offset globalPosition,
  ) async {
    final cubit = context.read<DashboardPreferencesCubit>();
    final preferences = cubit.state;

    await AppContextMenu.show(
      context,
      globalPosition: globalPosition,
      style: AppContextMenuStyle.glass,
      actions: [
        AppContextMenuAction(
          label: context.l10n.dashboardContextMenuChangeWallpaper,
          icon: Icons.wallpaper_rounded,
          onTap: (context) async {
            final wallpaperPath = await showDashboardWallpaperPickerSheet(
              context,
              preferences: preferences,
            );
            if (!context.mounted || wallpaperPath == null) {
              return;
            }
            await cubit.setWallpaper(wallpaperPath);
          },
        ),
        AppContextMenuAction(
          label: context.l10n.dashboardContextMenuManageShortcuts,
          icon: Icons.apps_rounded,
          onTap: (_) => _openShortcutsMenu(),
        ),
        AppContextMenuAction(
          label: context.l10n.dashboardContextMenuAddWidget,
          icon: Icons.add_to_photos_rounded,
          onTap: (_) => _openWidgetsMenu(),
        ),
        AppContextMenuAction(
          label: context.l10n.dashboardContextMenuAutoArrange,
          icon: Icons.auto_awesome_mosaic_rounded,
          separatorBefore: true,
          onTap: (_) => cubit.autoArrange(),
        ),
        AppContextMenuAction(
          label: context.l10n.dashboardContextMenuSnapToGrid,
          icon: Icons.grid_on_rounded,
          selected: preferences.snapToGrid,
          onTap: (_) => cubit.toggleSnapToGrid(),
        ),
      ],
    );
  }

  Future<void> _openShortcut(
    BuildContext context,
    DashboardShortcutItemViewModel shortcut,
  ) async {
    if (!context.mounted) {
      return;
    }
    await context.router.navigatePath(shortcut.routePath);
  }

  Future<void> _renameShortcut(
    BuildContext context,
    DashboardShortcutItemViewModel shortcut,
  ) async {
    final nextLabel = await showDashboardShortcutRenameDialog(
      context,
      originalLabel: shortcut.originalLabel(context.l10n),
      currentUserLabel: shortcut.userLabel,
    );
    if (!context.mounted || nextLabel == null) {
      return;
    }

    if (nextLabel.trim() == shortcut.originalLabel(context.l10n)) {
      await context.read<DashboardShortcutsCubit>().resetUserLabel(
        shortcut.shortcutId,
      );
    } else {
      await context.read<DashboardShortcutsCubit>().setUserLabel(
        shortcut.shortcutId,
        nextLabel,
      );
    }
  }

  Future<void> _removeShortcut(
    BuildContext context,
    DashboardShortcutItemViewModel shortcut,
  ) async {
    if (!context.mounted) {
      return;
    }
    await context.read<DashboardShortcutsCubit>().hideShortcut(
      shortcut.shortcutId,
    );
  }
}
