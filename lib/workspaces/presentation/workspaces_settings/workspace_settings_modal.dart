import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/domain/models/workspace_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/general/cubit/workspace_general_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/general/widgets/workspace_general_tab_view.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/invitations/cubit/workspace_invitations_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/members/cubit/workspace_members_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/members/widgets/workspace_members_tab_view.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/notifications/cubit/workspace_notifications_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/notifications/widgets/workspace_notifications_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dostępne zakładki w panelu ustawień przestrzeni roboczej.
enum WorkspaceSettingsTab {
  general,
  members,
  notifications,
}

/// Główny modal ustawień przestrzeni roboczej (Workspace Settings).
///
/// Oferuje gęsty, nowoczesny układ z bocznym menu nawigacji zakładek,
/// orkiestrujący odczyt i mutacje danych ogólnych, członków, zaproszeń oraz powiadomień.
class WorkspaceSettingsModal extends StatefulWidget {
  const WorkspaceSettingsModal({
    required this.workspace,
    this.userRole = WorkspaceRole.member,
    this.initialTab = WorkspaceSettingsTab.general,
    super.key,
  });

  /// Przestrzeń robocza, której dotyczą ustawienia.
  final WorkspaceListItem workspace;

  /// Rola bieżącego użytkownika w przestrzeni.
  final WorkspaceRole? userRole;

  /// Początkowa zakładka do otwarcia.
  final WorkspaceSettingsTab initialTab;

  /// Wyświetla modal ustawień przestrzeni roboczej w responsywnym dialogu.
  static Future<void> show({
    required BuildContext context,
    required WorkspaceListItem workspace,
    WorkspaceRole? userRole,
    WorkspaceSettingsTab initialTab = WorkspaceSettingsTab.general,
  }) {
    final workspacesRepo = context.read<WorkspacesRepository>();

    return showDialog<void>(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) {
              final cubit = WorkspaceGeneralSettingsCubit(
                workspaceId: workspace.id,
                repository: workspacesRepo,
              );
              unawaited(cubit.load(initialWorkspace: workspace));
              return cubit;
            },
          ),
          BlocProvider(
            create: (_) {
              final cubit = WorkspaceMembersSettingsCubit(
                workspaceId: workspace.id,
                repository: workspacesRepo,
              );
              unawaited(cubit.load());
              return cubit;
            },
          ),
          BlocProvider(
            create: (_) {
              final cubit = WorkspaceInvitationsSettingsCubit(
                workspaceId: workspace.id,
                repository: workspacesRepo,
              );
              unawaited(cubit.load());
              return cubit;
            },
          ),
          BlocProvider(
            create: (_) {
              final cubit = WorkspaceNotificationsSettingsCubit(
                workspaceId: workspace.id,
                repository: workspacesRepo,
              );
              unawaited(cubit.load());
              return cubit;
            },
          ),
        ],
        child: WorkspaceSettingsModal(
          workspace: workspace,
          userRole: userRole,
          initialTab: initialTab,
        ),
      ),
    );
  }

  @override
  State<WorkspaceSettingsModal> createState() => _WorkspaceSettingsModalState();
}

class _WorkspaceSettingsModalState extends State<WorkspaceSettingsModal> {
  late final ValueNotifier<WorkspaceSettingsTab> _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = ValueNotifier(widget.initialTab);
  }

  @override
  void dispose() {
    _currentTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final size = MediaQuery.sizeOf(context);
    final dialogWidth = (size.width * .85).clamp(700.0, 1060.0);
    final dialogHeight = (size.height * .85).clamp(500.0, 760.0);

    return ValueListenableBuilder(
      valueListenable: _currentTab,
      builder: (context, currentTab, _) => Dialog(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(Sizes.p16),
          side: BorderSide(
            color: colors.outlineVariant.withValues(alpha: .5),
          ),
        ),
        insetPadding: const .all(Sizes.p24),
        child: ClipRRect(
          borderRadius: .circular(Sizes.p16),
          child: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: Column(
              children: [
                // 1. Topbar
                Container(
                  height: 56,
                  padding: const .symmetric(horizontal: Sizes.p20),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLowest,
                    border: Border(
                      bottom: BorderSide(
                        color: colors.outlineVariant.withValues(alpha: .5),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings_rounded,
                        size: Sizes.p20,
                        color: colors.primary,
                      ),
                      Gaps.w12,
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              l10n.workspaceSettingsTitle,
                              style: context.text.titleMedium?.copyWith(
                                fontWeight: .w700,
                                color: colors.onSurface,
                              ),
                            ),
                            Gaps.w8,
                            Text(
                              '•',
                              style: TextStyle(color: colors.outline),
                            ),
                            Gaps.w8,
                            Flexible(
                              child: Text(
                                widget.workspace.name,
                                style: context.text.titleSmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: Sizes.p20),
                        tooltip: 'Zamknij',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                // 2. Ciało modalu (Sidebar + Content)
                Expanded(
                  child: Row(
                    crossAxisAlignment: .stretch,
                    children: [
                      // Lewy pasek zakładek
                      Container(
                        width: 220,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow.withValues(
                            alpha: .5,
                          ),
                          border: Border(
                            right: BorderSide(
                              color: colors.outlineVariant.withValues(
                                alpha: .5,
                              ),
                            ),
                          ),
                        ),
                        padding: const .symmetric(
                          horizontal: Sizes.p12,
                          vertical: Sizes.p16,
                        ),
                        child: Column(
                          children: [
                            _SidebarTabButton(
                              icon: Icons.tune_rounded,
                              label: l10n.workspaceSettingsTabGeneral,
                              isSelected:
                                  currentTab == WorkspaceSettingsTab.general,
                              onTap: () => _currentTab.value =
                                  WorkspaceSettingsTab.general,
                            ),
                            Gaps.h4,
                            _SidebarTabButton(
                              icon: Icons.people_outline_rounded,
                              label: l10n.workspaceSettingsTabMembers,
                              isSelected:
                                  currentTab == WorkspaceSettingsTab.members,
                              onTap: () => _currentTab.value =
                                  WorkspaceSettingsTab.members,
                            ),
                            Gaps.h4,
                            _SidebarTabButton(
                              icon: Icons.notifications_none_rounded,
                              label: l10n.workspaceSettingsTabNotifications,
                              isSelected:
                                  currentTab ==
                                  WorkspaceSettingsTab.notifications,
                              onTap: () => _currentTab.value =
                                  WorkspaceSettingsTab.notifications,
                            ),
                          ],
                        ),
                      ),
                      // Prawa treść wybranej zakładki
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: KeyedSubtree(
                            key: ValueKey(currentTab),
                            child: switch (currentTab) {
                              WorkspaceSettingsTab.general =>
                                WorkspaceGeneralTabView(
                                  workspace: widget.workspace,
                                  userRole: widget.userRole,
                                ),
                              WorkspaceSettingsTab.members =>
                                WorkspaceMembersTabView(
                                  userRole: widget.userRole,
                                ),
                              WorkspaceSettingsTab.notifications =>
                                const WorkspaceNotificationsTabView(),
                            },
                          ),
                        ),
                      ),
                    ],
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

class _SidebarTabButton extends StatelessWidget {
  const _SidebarTabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSelected
          ? colors.primaryContainer.withValues(alpha: .25)
          : Colors.transparent,
      borderRadius: .circular(Sizes.p8),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(Sizes.p8),
        child: Container(
          padding: const .symmetric(
            horizontal: Sizes.p12,
            vertical: Sizes.p10,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: Sizes.p18,
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
              ),
              Gaps.w12,
              Expanded(
                child: Text(
                  label,
                  style: context.text.bodyMedium?.copyWith(
                    fontWeight: isSelected ? .w700 : .w500,
                    color: isSelected ? colors.primary : colors.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
