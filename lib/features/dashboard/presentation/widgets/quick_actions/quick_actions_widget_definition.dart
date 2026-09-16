import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/auth/ready_permissions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_ids.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_tooltip.dart';

/// Definicja widgetu Szybkich Akcji na pulpicie.
class QuickActionsWidgetDefinition extends DashboardWidgetDefinition {
  /// Tworzy definicję widgetu Szybkich Akcji.
  const QuickActionsWidgetDefinition();

  @override
  String get typeId => 'quick_actions';

  @override
  String name(BuildContext context) => context.l10n.dashboardQuickActionsName;

  @override
  String description(BuildContext context) =>
      context.l10n.dashboardQuickActionsDescription;

  @override
  String category(BuildContext context) =>
      context.l10n.dashboardWidgetCategoryGeneral;

  @override
  IconData get icon => Icons.bolt_rounded;

  @override
  List<DashboardWidgetSize> get supportedSizes => const [
    DashboardWidgetSize(8, 4),
    DashboardWidgetSize(12, 4),
  ];

  @override
  Widget build(BuildContext context, DashboardWidgetSize size) {
    return _QuickActionsBody(size: size);
  }
}

class _QuickActionsBody extends StatelessWidget {
  const _QuickActionsBody({required this.size});

  final DashboardWidgetSize size;

  @override
  Widget build(BuildContext context) {
    final permissions = context.select<AuthCubit, Set<String>>(
      (cubit) => switch (cubit.state) {
        AuthAuthenticated(:final user) => user?.permissions ?? const {},
        _ => const {},
      },
    );
    final actions = [
      if (permissions.contains(ReadyPermissions.inventory))
        _ActionItem(
          shortcutId: DashboardShortcutIds.inventory,
          label: context.l10n.dashboardQuickActionsInventoryAction,
          icon: Icons.fact_check_rounded,
          toneColor: context.colors.primary,
          onTap: () => context.router.navigatePath(AppRoutePaths.inventory),
        ),
      if (permissions.contains(ReadyPermissions.bhp))
        _ActionItem(
          shortcutId: DashboardShortcutIds.bhp,
          label: context.l10n.dashboardQuickActionsBhpAction,
          icon: Icons.health_and_safety_rounded,
          toneColor: context.colors.tertiary,
          onTap: () => context.router.navigatePath(AppRoutePaths.bhp),
        ),
      _ActionItem(
        shortcutId: DashboardShortcutIds.settings,
        label: context.l10n.dashboardQuickActionsSettingsAction,
        icon: Icons.settings_rounded,
        toneColor: context.colors.secondary,
        onTap: () => context.router.navigatePath(AppRoutePaths.settings),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 300 ? 3 : 2;
        final rowCount = (actions.length / crossAxisCount).ceil();
        const spacing = Sizes.p12;
        final availableWidth =
            constraints.maxWidth - ((crossAxisCount - 1) * spacing);
        final availableHeight =
            constraints.maxHeight - ((rowCount - 1) * spacing);
        final tileWidth = availableWidth / crossAxisCount;
        final tileHeight = availableHeight / rowCount;
        final childAspectRatio = tileWidth / tileHeight;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _ActionTile(
              action: action,
              isCompact: crossAxisCount == 2,
            );
          },
        );
      },
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.shortcutId,
    required this.label,
    required this.icon,
    required this.toneColor,
    required this.onTap,
  });

  final String shortcutId;
  final String label;
  final IconData icon;
  final Color toneColor;
  final VoidCallback onTap;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.action,
    required this.isCompact,
  });

  final _ActionItem action;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconContainerSize = isCompact ? 46.0 : 52.0;
    final iconSize = isCompact ? 24.0 : 26.0;
    final tooltipMessage = action.label.trim();

    return _QuickActionTileFrame(
      tooltipMessage: tooltipMessage,
      onTap: action.onTap,
      child: Padding(
        padding: const .only(
          left: Sizes.p4,
          right: Sizes.p4,
          top: Sizes.p4,
          bottom: Sizes.p2,
        ),
        child: Column(
          children: [
            _QuickActionIcon(
              shortcutId: action.shortcutId,
              icon: action.icon,
              size: iconContainerSize,
              iconSize: iconSize,
            ),
            const SizedBox(height: Sizes.p4),
            Expanded(
              child: Align(
                alignment: .topCenter,
                child: AppText(
                  action.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelMedium?.copyWith(
                    fontWeight: .w700,
                    color: colors.onSurface,
                    height: 1.05,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gradientowa ikona szybkiej akcji wzorowana na skrótach pulpitu.
class _QuickActionIcon extends StatelessWidget {
  /// Tworzy gradientową ikonę szybkiej akcji.
  const _QuickActionIcon({
    required this.shortcutId,
    required this.icon,
    required this.size,
    required this.iconSize,
  });

  /// Identyfikator używany do doboru gradientu.
  final String shortcutId;

  /// Ikona szybkiej akcji.
  final IconData icon;

  /// Całkowity rozmiar ikonowej kapsuły.
  final double size;

  /// Rozmiar samej ikony.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final gradient = switch (shortcutId) {
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

/// Ramka pojedynczej szybkiej akcji z subtelnym hoverem.
class _QuickActionTileFrame extends StatefulWidget {
  /// Tworzy ramkę pojedynczej szybkiej akcji.
  const _QuickActionTileFrame({
    required this.tooltipMessage,
    required this.onTap,
    required this.child,
  });

  /// Tekst widoczny w podpowiedzi.
  final String tooltipMessage;

  /// Akcja po kliknięciu.
  final VoidCallback onTap;

  /// Zawartość kafelka.
  final Widget child;

  @override
  State<_QuickActionTileFrame> createState() => _QuickActionTileFrameState();
}

/// Stan hover pojedynczej szybkiej akcji.
class _QuickActionTileFrameState extends State<_QuickActionTileFrame> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final surfaceRoles = context.surfaceRoles;

    final tile = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .14),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : const [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return surfaceRoles.pressedOverlay;
            }
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return surfaceRoles.hoverOverlay;
            }
            return null;
          }),
          child: widget.child,
        ),
      ),
    );

    return AppTooltip(
      message: widget.tooltipMessage,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
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
        child: tile,
      ),
    );
  }
}
