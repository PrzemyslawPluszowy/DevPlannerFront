import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';

/// Modal wyboru członka workspace i przypisania mu roli w projekcie.
class AddProjectMemberDialog extends StatefulWidget {
  const AddProjectMemberDialog({
    required this.availableMembers,
    super.key,
  });

  /// Członkowie workspace, którzy mogą zostać dodani do projektu.
  final List<WorkspaceMemberResponse> availableMembers;

  @override
  State<AddProjectMemberDialog> createState() => _AddProjectMemberDialogState();
}

class _AddProjectMemberDialogState extends State<AddProjectMemberDialog> {
  WorkspaceMemberResponse? _selectedMember;
  ProjectRole _selectedRole = ProjectRole.member;

  @override
  void initState() {
    super.initState();
    if (widget.availableMembers.isNotEmpty) {
      _selectedMember = widget.availableMembers.first;
    }
  }

  String _formatMemberLabel(
    BuildContext context,
    WorkspaceMemberResponse member,
  ) {
    final authUser = switch (context.watch<AuthCubit?>()?.state) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };
    if (authUser != null && authUser.coreUserId == member.coreUserId) {
      if (authUser.displayName.isNotEmpty) {
        return '${authUser.displayName} (Ja)';
      }
    }
    if (member.readyUserId != null) {
      return 'Użytkownik Ready #${member.readyUserId} (${member.role.name})';
    }
    return 'Użytkownik Core (${member.coreUserId.substring(0, 8)}...)';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return WorkspaceCreationModalWrapper(
      title: l10n.projectSettingsAddMemberDialogTitle,
      subtitle:
          'Wybierz osobę z przestrzeni roboczej i przypisz rolę w projekcie.',
      icon: Icons.person_add_rounded,
      submitLabel: l10n.projectSettingsAddMemberButton,
      cancelLabel: l10n.tasksListCancelButton,
      maxWidth: 440,
      onSubmit: () {
        if (_selectedMember != null) {
          Navigator.of(context).pop((
            workspaceMemberId: _selectedMember!.id,
            role: _selectedRole,
          ));
        }
      },
      body: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.projectSettingsSelectWorkspaceUser,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h6,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<WorkspaceMemberResponse>(
                value: _selectedMember,
                isExpanded: true,
                dropdownColor: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                elevation: 3,
                menuMaxHeight: 260,
                style: context.text.bodySmall?.copyWith(fontSize: 13),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                items: [
                  for (final member in widget.availableMembers)
                    DropdownMenuItem(
                      value: member,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: colors.primaryContainer,
                            child: Icon(
                              Icons.person_rounded,
                              size: 14,
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                          Gaps.w8,
                          Expanded(
                            child: Text(
                              _formatMemberLabel(context, member),
                              style: context.text.bodySmall?.copyWith(
                                fontSize: 12.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                onChanged: (val) => setState(() => _selectedMember = val),
              ),
            ),
          ),
          Gaps.h16,
          Text(
            l10n.projectSettingsSelectRole,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h6,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ProjectRole>(
                value: _selectedRole,
                isExpanded: true,
                dropdownColor: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                elevation: 3,
                menuMaxHeight: 260,
                style: context.text.bodySmall?.copyWith(fontSize: 13),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                items: [
                  DropdownMenuItem(
                    value: ProjectRole.admin,
                    child: Text(
                      l10n.projectSettingsMemberRoleAdmin,
                      style: context.text.bodySmall?.copyWith(fontSize: 12.5),
                    ),
                  ),
                  DropdownMenuItem(
                    value: ProjectRole.member,
                    child: Text(
                      l10n.projectSettingsMemberRoleMember,
                      style: context.text.bodySmall?.copyWith(fontSize: 12.5),
                    ),
                  ),
                  DropdownMenuItem(
                    value: ProjectRole.observer,
                    child: Text(
                      l10n.projectSettingsMemberRoleObserver,
                      style: context.text.bodySmall?.copyWith(fontSize: 12.5),
                    ),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedRole = val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
