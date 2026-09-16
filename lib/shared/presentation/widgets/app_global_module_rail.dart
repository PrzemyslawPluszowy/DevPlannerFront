import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/shell/app_shell_metrics.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/settings/application/current_user_avatar_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_global_module_rail_actions.dart';
import 'package:ready_next/shared/presentation/widgets/app_global_module_rail_parts.dart';

/// Lewy rail aplikacji renderowany nad właściwą treścią shellu.
///
/// Jest ostatnim dzieckiem `Stack` w wrapperze, więc rozwinięty panel
/// przykrywa treść bez zmiany jej układu. Elementy listy, konta i akcji są
/// wydzielone do `app_global_module_rail_parts.dart`.
class AppGlobalModuleRail extends StatelessWidget {
  const AppGlobalModuleRail({
    required this.isExpanded,
    required this.router,
    required this.defaultModuleOrder,
    required this.moduleLabels,
    required this.moduleIcons,
    required this.onToggleExpanded,
    required this.onCollapse,
    required this.onShowChangelog,
    super.key,
  });

  static double get collapsedWidth =>
      const AppShellMetrics.standard().collapsedRailWidth;

  /// Szerokość zapewniająca miejsce na ikonę, uchwyt reorder i pełniejsze
  /// nazwy modułów bez stałego ellipsis w trybie desktop.
  static double get expandedWidth =>
      const AppShellMetrics.standard().expandedRailWidth;

  final bool isExpanded;
  final AppRouter router;
  final List<String> defaultModuleOrder;
  final Map<String, String> moduleLabels;
  final Map<String, IconData> moduleIcons;
  final VoidCallback onToggleExpanded;
  final VoidCallback onCollapse;
  final VoidCallback onShowChangelog;

  List<Color> _gradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const [Color(0xFF141522), Color(0xFF0F101A)]
        : const [Color(0xFF1E2138), Color(0xFF161829)];
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    final user = switch (auth) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };
    const foreground = Color(0xFF94A3B8);
    final background = Colors.white.withValues(alpha: .04);
    final activeBackground = const Color(0xFF6366F1).withValues(alpha: .20);
    final hover = Colors.white.withValues(alpha: .08);
    final danger = Colors.redAccent.withValues(alpha: .12);
    final dangerHover = Colors.redAccent.withValues(alpha: .22);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _gradient(context),
        ),
        border: const Border(
          right: BorderSide(color: Color(0x22FFFFFF)),
        ),
        boxShadow: isExpanded
            ? const [
                BoxShadow(
                  blurRadius: 20,
                  color: Color(0x33000000),
                  offset: Offset(4, 0),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            Gaps.h12,
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: Sizes.p8),
                child: IconButton(
                  onPressed: onToggleExpanded,
                  icon: const Icon(Icons.menu_rounded, color: foreground),
                ),
              ),
            ),
            Gaps.h12,
            Expanded(
              child: AppGlobalRailModuleList(
                isExpanded: isExpanded,
                router: router,
                defaultModuleOrder: defaultModuleOrder,
                moduleLabels: moduleLabels,
                moduleIcons: moduleIcons,
                background: background,
                activeBackground: activeBackground,
                hover: hover,
                foreground: foreground,
                onCollapse: onCollapse,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.p10,
              ),
              child: Divider(
                height: Sizes.p16,
                color: Color(0x22FFFFFF),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isExpanded ? Sizes.p10 : Sizes.p4,
              ),
              child: AppGlobalRailAccount(
                isExpanded: isExpanded,
                user: user,
                avatarUrl: switch (context
                    .watch<CurrentUserAvatarCubit>()
                    .state) {
                  CurrentUserAvatarReady(:final avatarUrl) => avatarUrl,
                  CurrentUserAvatarLoading(:final previousAvatarUrl) =>
                    previousAvatarUrl,
                  CurrentUserAvatarFailure(:final previousAvatarUrl) =>
                    previousAvatarUrl,
                  CurrentUserAvatarInitial() => null,
                },
                background: Colors.white.withValues(alpha: .06),
                border: const Color(0x22FFFFFF),
                foreground: foreground,
              ),
            ),
            Gaps.h8,
            AppGlobalRailActionTile(
              isExpanded: isExpanded,
              label: context.l10n.globalActionSettings,
              icon: Icons.tune_rounded,
              background: background,
              hover: hover,
              foreground: foreground,
              onTap: () {
                unawaited(router.navigatePath(AppRoutePaths.settings));
                onCollapse();
              },
            ),
            Gaps.h8,
            AppGlobalRailActionTile(
              isExpanded: isExpanded,
              label: context.l10n.globalActionLogout,
              icon: Icons.logout_rounded,
              background: danger,
              hover: dangerHover,
              foreground: foreground,
              onTap: () async {
                await context.read<AuthCubit>().logout();
              },
            ),
            Gaps.h8,
            _ChangelogButton(
              isExpanded: isExpanded,
              foreground: foreground,
              onPressed: onShowChangelog,
            ),
            Gaps.h8,
          ],
        ),
      ),
    );
  }
}

class _ChangelogButton extends StatelessWidget {
  const _ChangelogButton({
    required this.isExpanded,
    required this.foreground,
    required this.onPressed,
  });

  final bool isExpanded;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.article_outlined, size: Sizes.p16),
        if (isExpanded) ...[
          Gaps.w8,
          Text(
            'changelog',
            style: context.text.labelMedium?.copyWith(
              color: foreground.withValues(alpha: .92),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
    final button = TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foreground,
        visualDensity: VisualDensity.compact,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p8,
          vertical: Sizes.p8,
        ),
      ),
      child: content,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p10),
      child: Align(alignment: Alignment.centerLeft, child: button),
    );
  }
}
