import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Krok 3 kreatora: widoczność projektu i początkowi członkowie.
class ProjectSetupAccessStep extends StatelessWidget {
  /// Tworzy krok dostępu.
  const ProjectSetupAccessStep({required this.state, super.key});

  /// Bieżący stan kreatora.
  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    final draft = state.draft;
    final isPrivate = draft.visibility == ProjectVisibility.private;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupChoiceCard(
          title: l10n.projectSetupAccessSharedTitle,
          description: l10n.projectSetupAccessSharedDescription,
          icon: Symbols.public,
          selected: !isPrivate,
          onSelected: () => cubit.setVisibility(ProjectVisibility.shared),
        ),
        Gaps.h8,
        ProjectSetupChoiceCard(
          title: l10n.projectSetupAccessPrivateTitle,
          description: l10n.projectSetupAccessPrivateDescription,
          icon: Symbols.lock,
          selected: isPrivate,
          onSelected: () => cubit.setVisibility(ProjectVisibility.private),
        ),
        if (isPrivate) ...[
          Gaps.h20,
          ProjectSetupSectionLabel(l10n.projectSetupAccessMembersLegend),
          Gaps.h8,
          _MemberList(state: state),
          ProjectSetupFieldError(
            error: state.fieldErrors[ProjectSetupField.members],
          ),
        ],
      ],
    );
  }
}

class _MemberList extends StatelessWidget {
  const _MemberList({required this.state});

  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<ProjectSetupWizardCubit>();
    final currentUserId = context
        .read<AuthSessionPort?>()
        ?.snapshot
        .user
        ?.userId;
    switch (state.members.status) {
      case ProjectSetupMembersStatus.unavailable:
        return _Note(
          title: l10n.projectSetupAccessMembersUnavailable,
          description: l10n.projectSetupAccessMembersUnavailableReason,
        );
      case ProjectSetupMembersStatus.loading:
        return _Note(
          title: l10n.projectSetupAccessMembersLoading,
          description: null,
        );
      case ProjectSetupMembersStatus.failed:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Note(
              title:
                  state.members.error?.message ??
                  l10n.projectSetupAccessMembersUnavailable,
              description: null,
              isError: true,
            ),
            Gaps.h8,
            FilledButton.tonal(
              onPressed: cubit.retryMembers,
              child: Text(l10n.projectSetupAccessMembersRetry),
            ),
          ],
        );
      case ProjectSetupMembersStatus.ready:
        final others = [
          for (final member in state.members.members)
            if (member.userId != currentUserId) member,
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CreatorRow(
              label: _creatorLabel(context, currentUserId),
            ),
            if (others.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: Sizes.p8),
                child: Text(
                  l10n.projectSetupAccessMembersEmpty,
                  style: context.text.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            for (final member in others)
              _MemberRow(
                member: member,
                selected: state.draft.members.any(
                  (selection) => selection.userId == member.userId,
                ),
                role: _roleOf(state.draft, member.userId),
                onToggle: () => cubit.toggleMember(member.userId),
                onRoleChanged: (role) =>
                    cubit.setMemberRole(member.userId, role),
              ),
          ],
        );
    }
  }

  static ProjectRole _roleOf(ProjectSetupDraft draft, String userId) {
    for (final member in draft.members) {
      if (member.userId == userId) return member.role;
    }
    return ProjectRole.member;
  }

  static String _creatorLabel(BuildContext context, String? userId) {
    final displayName = context
        .read<AuthSessionPort?>()
        ?.snapshot
        .user
        ?.displayName;
    if (displayName != null && displayName.trim().isNotEmpty) {
      return '${displayName.trim()} · ${context.l10n.projectSetupAccessCreatorBadge}';
    }
    if (userId != null && userId.length >= 8) {
      return context.l10n.projectSetupAccessMemberLabel(userId.substring(0, 8));
    }
    return context.l10n.projectSetupAccessCreatorBadge;
  }
}

class _CreatorRow extends StatelessWidget {
  const _CreatorRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      padding: const EdgeInsets.all(Sizes.p10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Icon(Symbols.workspace_premium, size: 16, color: colors.primary),
          Gaps.w8,
          Expanded(
            child: Text(
              label,
              style: context.text.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            context.l10n.projectSettingsMemberRoleOwner,
            style: context.text.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.w4,
          Tooltip(
            message: context.l10n.projectSetupAccessPrivateDescription,
            child: Icon(Symbols.lock, size: 14, color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    required this.selected,
    required this.role,
    required this.onToggle,
    required this.onRoleChanged,
  });

  final WorkspaceMemberResponse member;
  final bool selected;
  final ProjectRole role;
  final VoidCallback onToggle;
  final ValueChanged<ProjectRole> onRoleChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final label = l10n.projectSetupAccessMemberLabel(
      member.userId.length >= 8 ? member.userId.substring(0, 8) : member.userId,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p10,
        vertical: Sizes.p4,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: selected ? colors.primary : colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: selected,
            onChanged: (_) => onToggle(),
          ),
          Expanded(
            child: Text(label, style: context.text.bodySmall),
          ),
          if (selected)
            DropdownButton<ProjectRole>(
              value: role,
              underline: const SizedBox.shrink(),
              style: context.text.bodySmall,
              items: [
                DropdownMenuItem(
                  value: ProjectRole.admin,
                  child: Text(l10n.projectSettingsMemberRoleAdmin),
                ),
                DropdownMenuItem(
                  value: ProjectRole.member,
                  child: Text(l10n.projectSettingsMemberRoleMember),
                ),
                DropdownMenuItem(
                  value: ProjectRole.observer,
                  child: Text(l10n.projectSettingsMemberRoleObserver),
                ),
              ],
              onChanged: (value) {
                if (value != null) onRoleChanged(value);
              },
            ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({
    required this.title,
    required this.description,
    this.isError = false,
  });

  final String title;
  final String? description;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: isError ? colors.errorContainer : colors.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.text.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isError ? colors.onErrorContainer : colors.onSurface,
            ),
          ),
          if (description case final value?) ...[
            Gaps.h2,
            Text(
              value,
              style: context.text.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
