import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/features/settings/application/local_settings_cubit.dart';
import 'package:devplanner/shared/presentation/widgets/app_collapsible_navigation.dart';
import 'package:devplanner/shared/presentation/widgets/app_module_lauout/app_module_layout.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/cubit/workspaces_home_state.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/directory_menu/workspace_directory_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Katalog workspace’ów użytkownika.
///
/// Jest osobnym poziomem nawigacji. Po wybraniu workspace’u URL przejmuje
/// kontekst i otwiera shell zasobów workspace’u.
class WorkspacesHomePage extends StatefulWidget {
  /// Tworzy katalog workspace’ów.
  const WorkspacesHomePage({this.child, super.key});

  final Widget? child;

  @override
  State<WorkspacesHomePage> createState() => _WorkspacesHomePageState();
}

class _WorkspacesHomePageState extends State<WorkspacesHomePage> {
  late final AppCollapsibleNavigationController _panelController;
  late final String _panelPreferenceKey;

  @override
  void initState() {
    super.initState();
    final settings = context.read<LocalSettingsCubit>();
    _panelPreferenceKey = _preferenceKey();
    _panelController = AppCollapsibleNavigationController(
      expanded: settings.isNavigationPanelExpanded(_panelPreferenceKey),
      onChanged: (expanded) => unawaited(
        settings.setNavigationPanelExpanded(
          preferenceKey: _panelPreferenceKey,
          expanded: expanded,
        ),
      ),
    );
  }

  String _preferenceKey() {
    final userId = context.read<AuthSessionPort?>()?.snapshot.user?.userId;
    return 'workspaces.home:${userId ?? 'anonymous'}';
  }

  @override
  void dispose() {
    _panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = WorkspacesHomeCubit(
          repository: context.read<WorkspacesRepository>(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final panelBg = isDark
              ? const Color(0xFF1B1C2A)
              : const Color(0xFFFFFFFF);
          final contentBg = isDark
              ? const Color(0xFF141520)
              : const Color(0xFFF8FAFC);

          return BlocBuilder<WorkspacesHomeCubit, WorkspacesHomeState>(
            builder: (context, state) => AppModuleLayout(
              navigationController: _panelController,
              showSidebarDivider: false,
              scrollContent: false,
              contentLeadingInset: Sizes.p16,
              contentMaxWidth: 1800,
              contentBackgroundColor: contentBg,
              sidebarBuilder: (context, isCompact, outerPadding) =>
                  AppCollapsibleNavigationPanel(
                    controller: _panelController,
                    margin: EdgeInsets.only(
                      right: outerPadding,
                      bottom: 12,
                    ),
                    decoration: BoxDecoration(
                      color: panelBg,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(16),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: .12)
                              : const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                        right: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: .12)
                              : const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                        bottom: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: .12)
                              : const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? .35 : .06,
                          ),
                          blurRadius: 12,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    expandedBuilder: (context) =>
                        const WorkspaceDirectoryMenu(),
                    collapsedBuilder: (context) => const SizedBox.shrink(),
                  ),
              contentBuilder: (context, isCompact, outerPadding) =>
                  widget.child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
