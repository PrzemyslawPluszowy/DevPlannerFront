import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/projects/people/project_people_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Zwarty panel desktopowy z tymi samymi tokenami co Lista i Kanban.
final class ProjectPeoplePanel extends StatelessWidget {
  const ProjectPeoplePanel({
    required this.cubit,
    required this.onClose,
    super.key,
  });
  final ProjectPeopleCubit cubit;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Material(
    color: context.tasksTheme.cardSurface,
    child: BlocBuilder<ProjectPeopleCubit, ProjectPeopleState>(
      bloc: cubit,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.projectPeopleTitle,
                        style: context.text.titleMedium,
                      ),
                      if (cubit.request.projectName.isNotEmpty)
                        Text(
                          cubit.request.projectName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.bodySmall,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.projectPeopleRefresh,
                  onPressed: state.isLoading ? null : cubit.refresh,
                  icon: SizedBox(
                    width: 18,
                    height: 18,
                    child: state.isLoading
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : const Icon(Icons.refresh, size: 18),
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.close,
                  onPressed: onClose,
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.tasksTheme.divider),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              key: const ValueKey('project-people-search'),
              onChanged: cubit.search,
              decoration: InputDecoration(
                labelText: context.l10n.projectPeopleSearch,
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              state.presenceIsFresh
                  ? context.l10n.tasksPresenceCount(state.onlineCount)
                  : context.l10n.projectPeoplePresenceUnknown,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
          const _PresenceConnectionWarning(),
          if (state.error case final error?)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    error.message,
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                  TextButton(
                    onPressed: state.isLoading ? null : cubit.refresh,
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            ),
          Expanded(
            child: state.visibleMembers.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        state.isLoading
                            ? context.l10n.projectPeopleLoading
                            : state.query.trim().isEmpty
                            ? context.l10n.projectPeopleEmpty
                            : context.l10n.projectPeopleNoMatches,
                        textAlign: TextAlign.center,
                        style: context.text.bodyMedium,
                      ),
                    ),
                  )
                : ListView.separated(
                    key: const ValueKey('project-people-list'),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.visibleMembers.length,
                    separatorBuilder: (_, _) =>
                        Divider(height: 1, color: context.tasksTheme.divider),
                    itemBuilder: (_, index) => _ProjectPersonRow(
                      member: state.visibleMembers[index],
                      isCurrentUser:
                          state.visibleMembers[index].userId ==
                          cubit.request.ownerUserId,
                      fresh: state.presenceIsFresh,
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}

final class _ProjectPersonRow extends StatelessWidget {
  const _ProjectPersonRow({
    required this.member,
    required this.isCurrentUser,
    required this.fresh,
  });
  final ProjectMemberProfile member;
  final bool isCurrentUser;
  final bool fresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = member.displayName?.trim();
    final displayName = name?.isNotEmpty == true
        ? name!
        : l10n.tasksPresenceAnonymousUser;
    final online = fresh ? member.isOnline : null;
    final status = switch (online) {
      true => l10n.tasksPresenceOnline,
      false => l10n.tasksPresenceOffline,
      null => l10n.projectPeoplePresenceUnknown,
    };
    final role = switch (member.role) {
      ProjectRole.owner => l10n.projectSettingsMemberRoleOwner,
      ProjectRole.admin => l10n.projectSettingsMemberRoleAdmin,
      ProjectRole.member => l10n.projectSettingsMemberRoleMember,
      ProjectRole.observer => l10n.projectSettingsMemberRoleObserver,
    };
    return Semantics(
      label: '$displayName, $status',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: context.colors.surfaceContainerHighest,
              foregroundImage: member.avatarUrl?.isNotEmpty == true
                  ? NetworkImage(member.avatarUrl!)
                  : null,
              child: Text(
                displayName.characters.first.toUpperCase(),
                style: context.text.bodyMedium,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCurrentUser
                        ? '$displayName (${l10n.projectPeopleYou})'
                        : displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodyMedium,
                  ),
                  Text(
                    role,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 7,
                        height: 7,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: online == true
                                ? context.feedback.successForeground
                                : context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          status,
                          style: context.text.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _PresenceConnectionWarning extends StatelessWidget {
  const _PresenceConnectionWarning();

  @override
  Widget build(BuildContext context) {
    final scope = DevPlannerPanelsScope.maybeOf(context);
    final availability = scope?.presenceAvailability;
    if (availability == null) return const SizedBox.shrink();
    return ValueListenableBuilder<bool>(
      valueListenable: availability,
      builder: (context, available, _) => available
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.projectPeopleConnectionUnavailable,
                    style: context.text.bodySmall,
                  ),
                  TextButton(
                    onPressed: scope?.retryPresence,
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            ),
    );
  }
}
