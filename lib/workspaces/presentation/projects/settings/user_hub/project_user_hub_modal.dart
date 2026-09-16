import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_visibility.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/projects_repository.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/user_hub/cubit/project_user_hub_cubit.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/user_hub/widgets/project_user_preferences_tab_view.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/user_hub/widgets/project_user_profile_tab_view.dart';

/// Wyświetla modal Panelu Użytkownika Projektu (Moje Centrum Projektu).
Future<void> showProjectUserHubModal({
  required BuildContext context,
  required ProjectListItem project,
  ProjectRole? userRole,
  VoidCallback? onProjectLeft,
}) {
  final repository = context.read<ProjectsRepository>();

  return showDialog<void>(
    context: context,
    builder: (ctx) => BlocProvider(
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

enum _UserHubTab {
  profile,
  preferences,
}

class _ProjectUserHubModalState extends State<ProjectUserHubModal> {
  _UserHubTab _currentTab = _UserHubTab.profile;

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

    return CallbackShortcuts(
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
                        color: colors.surfaceContainerLow.withValues(alpha: .5),
                        border: Border(
                          bottom: BorderSide(
                            color: colors.outlineVariant.withValues(alpha: .5),
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
                          _buildCompactTabItem(
                            tab: _UserHubTab.profile,
                            label: l10n.projectUserHubTabProfile,
                            icon: Icons.badge_rounded,
                          ),
                          _buildCompactTabItem(
                            tab: _UserHubTab.preferences,
                            label: l10n.projectUserHubTabPreferences,
                            icon: Icons.tune_rounded,
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
                                _buildTabItem(
                                  tab: _UserHubTab.profile,
                                  label: l10n.projectUserHubTabProfile,
                                  icon: Icons.badge_outlined,
                                  selectedIcon: Icons.badge_rounded,
                                ),
                                _buildTabItem(
                                  tab: _UserHubTab.preferences,
                                  label: l10n.projectUserHubTabPreferences,
                                  icon: Icons.tune_outlined,
                                  selectedIcon: Icons.tune_rounded,
                                ),
                              ],
                            ),
                          ),

                        // Główna treść aktywnej zakładki
                        Expanded(
                          child: switch (_currentTab) {
                            _UserHubTab.profile => ProjectUserProfileTabView(
                              project: widget.project,
                              userRole: widget.userRole,
                            ),
                            _UserHubTab.preferences =>
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
    );
  }

  Widget _buildTabItem({
    required _UserHubTab tab,
    required String label,
    required IconData icon,
    required IconData selectedIcon,
  }) {
    final colors = context.colors;
    final isSelected = _currentTab == tab;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: isSelected ? colors.surfaceContainerLowest : Colors.transparent,
        borderRadius: .circular(Sizes.p8),
        border: Border.all(
          color: isSelected
              ? colors.outlineVariant.withValues(alpha: .8)
              : Colors.transparent,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: .04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: .circular(Sizes.p8),
        child: InkWell(
          borderRadius: .circular(Sizes.p8),
          onTap: () => setState(() => _currentTab = tab),
          child: Padding(
            padding: const .symmetric(
              horizontal: Sizes.p12,
              vertical: Sizes.p10,
            ),
            child: Row(
              children: [
                if (isSelected)
                  Container(
                    width: 3,
                    height: 16,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: .circular(2),
                    ),
                  ),
                Icon(
                  isSelected ? selectedIcon : icon,
                  size: Sizes.p18,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
                Gaps.w8,
                Expanded(
                  child: Text(
                    label,
                    style: context.text.bodyMedium?.copyWith(
                      fontWeight: isSelected ? .w700 : .w500,
                      color: isSelected
                          ? colors.onSurface
                          : colors.onSurfaceVariant,
                      letterSpacing: -.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactTabItem({
    required _UserHubTab tab,
    required String label,
    required IconData icon,
  }) {
    final colors = context.colors;
    final isSelected = _currentTab == tab;

    return Padding(
      padding: const EdgeInsets.only(right: Sizes.p6),
      child: Material(
        color: isSelected
            ? colors.primary.withValues(alpha: .12)
            : colors.surfaceContainerLowest,
        borderRadius: .circular(Sizes.p8),
        child: InkWell(
          onTap: () => setState(() => _currentTab = tab),
          borderRadius: .circular(Sizes.p8),
          child: Container(
            padding: const .symmetric(
              horizontal: Sizes.p10,
              vertical: Sizes.p4,
            ),
            decoration: BoxDecoration(
              borderRadius: .circular(Sizes.p8),
              border: Border.all(
                color: isSelected
                    ? colors.primary.withValues(alpha: .5)
                    : colors.outlineVariant.withValues(alpha: .4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: Sizes.p16,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
                Gaps.w6,
                Text(
                  label,
                  style: context.text.labelSmall?.copyWith(
                    fontWeight: isSelected ? .w700 : .w500,
                    color: isSelected
                        ? colors.primary
                        : colors.onSurfaceVariant,
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
