import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/user_hub/cubit/project_user_hub_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/user_hub/widgets/project_user_hub_navigation_items.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/user_hub/widgets/project_user_preferences_tab_view.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/user_hub/widgets/project_user_profile_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Fasada otwierania Panelu Użytkownika Projektu (Moje Centrum Projektu).
class ProjectUserHubDialogs {
  const ProjectUserHubDialogs._();

  static Future<void> show({
    required BuildContext context,
    required ProjectListItem project,
    ProjectRole? userRole,
    VoidCallback? onProjectLeft,
  }) {
    final repository = context.read<ProjectsRepository>();
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) {
          final cubit = ProjectUserHubCubit(
            workspaceId: project.workspaceId,
            projectId: project.id,
            repository: repository,
          );
          unawaited(cubit.load(initialProject: project));
          return cubit;
        },
        child: ProjectUserHubModal(
          project: project,
          userRole: userRole ?? project.myRole,
          onProjectLeft: onProjectLeft,
        ),
      ),
    );
  }
}

/// Dedykowany modal Panelu Użytkownika Projektu (Moje Centrum Projektu).
class ProjectUserHubModal extends StatefulWidget {
  const ProjectUserHubModal({
    required this.project,
    required this.userRole,
    this.onProjectLeft,
    super.key,
  });

  final ProjectListItem project;
  final ProjectRole? userRole;
  final VoidCallback? onProjectLeft;

  @override
  State<ProjectUserHubModal> createState() => _ProjectUserHubModalState();
}

class _ProjectUserHubModalState extends State<ProjectUserHubModal> {
  final ValueNotifier<ProjectUserHubTab> _currentTab = ValueNotifier(
    ProjectUserHubTab.profile,
  );

  @override
  void dispose() {
    _currentTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 640;

    final dialogWidth = isCompact
        ? (size.width - 16).clamp(320.0, size.width)
        : (size.width * 0.75).clamp(520.0, 920.0);
    final dialogHeight = isCompact
        ? (size.height - 24).clamp(380.0, size.height)
        : (size.height * 0.75).clamp(440.0, 680.0);

    return ValueListenableBuilder<ProjectUserHubTab>(
      valueListenable: _currentTab,
      builder: (context, currentTab, _) => CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): () {
            Navigator.of(context).pop();
          },
        },
        child: Focus(
          autofocus: true,
          child: BlocListener<ProjectUserHubCubit, ProjectUserHubState>(
            listener: (context, state) {
              if (state is ProjectUserHubLeftSuccess) {
                Navigator.of(context).pop();
                final isShared = state.visibility == ProjectVisibility.shared;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isShared
                          ? l10n.projectUserHubLeaveSharedSuccessNotice
                          : l10n.projectUserHubLeavePrivateSuccessNotice,
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                if (!isShared) {
                  widget.onProjectLeft?.call();
                }
              }
            },
            child: Dialog(
              backgroundColor: colors.surface,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: .circular(Sizes.p16),
                side: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: .6),
                ),
              ),
              insetPadding: EdgeInsets.all(isCompact ? Sizes.p8 : Sizes.p24),
              clipBehavior: .antiAlias,
              child: SizedBox(
                width: dialogWidth,
                height: dialogHeight,
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const .symmetric(
                        horizontal: Sizes.p20,
                        vertical: Sizes.p16,
                      ),
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
                          Container(
                            padding: const .all(Sizes.p8),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: .12),
                              borderRadius: .circular(Sizes.p8),
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: colors.primary,
                              size: Sizes.p20,
                            ),
                          ),
                          Gaps.w12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.projectUserHubTitle,
                                  style: context.text.titleMedium?.copyWith(
                                    fontWeight: .w700,
                                    color: colors.onSurface,
                                  ),
                                ),
                                Gaps.h2,
                                Text(
                                  widget.project.name,
                                  style: context.text.bodySmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            tooltip: l10n.close,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),

                    if (isCompact)
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow.withValues(
                            alpha: .5,
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: colors.outlineVariant.withValues(
                                alpha: .5,
                              ),
                            ),
                          ),
                        ),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const .symmetric(
                            horizontal: Sizes.p8,
                            vertical: Sizes.p6,
                          ),
                          children: [
                            ProjectUserHubCompactNavigationItem(
                              tab: ProjectUserHubTab.profile,
                              selectedTab: currentTab,
                              label: l10n.projectUserHubTabProfile,
                              icon: Icons.badge_rounded,
                              onSelected: (tab) => _currentTab.value = tab,
                            ),
                            ProjectUserHubCompactNavigationItem(
                              tab: ProjectUserHubTab.preferences,
                              selectedTab: currentTab,
                              label: l10n.projectUserHubTabPreferences,
                              icon: Icons.tune_rounded,
                              onSelected: (tab) => _currentTab.value = tab,
                            ),
                          ],
                        ),
                      ),

                    // Zawartość z bocznym menu zakładek
                    Expanded(
                      child: Row(
                        children: [
                          // Boczne menu zakładek (desktop / non-compact)
                          if (!isCompact)
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
                              child: ListView(
                                padding: const .symmetric(
                                  vertical: Sizes.p12,
                                  horizontal: Sizes.p8,
                                ),
                                children: [
                                  ProjectUserHubNavigationItem(
                                    tab: ProjectUserHubTab.profile,
                                    selectedTab: currentTab,
                                    label: l10n.projectUserHubTabProfile,
                                    icon: Icons.badge_outlined,
                                    selectedIcon: Icons.badge_rounded,
                                    onSelected: (tab) =>
                                        _currentTab.value = tab,
                                  ),
                                  ProjectUserHubNavigationItem(
                                    tab: ProjectUserHubTab.preferences,
                                    selectedTab: currentTab,
                                    label: l10n.projectUserHubTabPreferences,
                                    icon: Icons.tune_outlined,
                                    selectedIcon: Icons.tune_rounded,
                                    onSelected: (tab) =>
                                        _currentTab.value = tab,
                                  ),
                                ],
                              ),
                            ),

                          // Główna treść aktywnej zakładki
                          Expanded(
                            child: switch (currentTab) {
                              ProjectUserHubTab.profile =>
                                ProjectUserProfileTabView(
                                  project: widget.project,
                                  userRole: widget.userRole,
                                ),
                              ProjectUserHubTab.preferences =>
                                ProjectUserPreferencesTabView(
                                  project: widget.project,
                                ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
