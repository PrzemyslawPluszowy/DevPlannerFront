import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late final ValueNotifier<WorkspaceMemberResponse?> _selectedMember;
  final ValueNotifier<ProjectRole> _selectedRole = ValueNotifier(
    ProjectRole.member,
  );

  @override
  void initState() {
    super.initState();
    if (widget.availableMembers.isNotEmpty) {
      _selectedMember = ValueNotifier(widget.availableMembers.first);
    } else {
      _selectedMember = ValueNotifier(null);
    }
  }

  @override
  void dispose() {
    _selectedMember.dispose();
    _selectedRole.dispose();
    super.dispose();
  }

  String _formatMemberLabel(
    BuildContext context,
    WorkspaceMemberResponse member,
  ) {
    final authUser = context.watch<AuthSessionPort?>()?.snapshot.user;
    if (authUser != null && authUser.userId == member.userId) {
      if (authUser.displayName.isNotEmpty) {
        return '${authUser.displayName} (Ja)';
      }
    }
    return 'Użytkownik (${member.userId.substring(0, 8)}...)';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return ValueListenableBuilder<WorkspaceMemberResponse?>(
      valueListenable: _selectedMember,
      builder: (context, selectedMember, _) =>
          ValueListenableBuilder<ProjectRole>(
            valueListenable: _selectedRole,
            builder: (context, selectedRole, _) =>
                WorkspaceCreationModalWrapper(
                  title: l10n.projectSettingsAddMemberDialogTitle,
                  subtitle: 'Wybierz osobę z przestrzeni roboczej i przypisz rolę w projekcie.',
                  icon: Icons.person_add_rounded,
                  submitLabel: l10n.projectSettingsAddMemberButton,
                  cancelLabel: l10n.tasksListCancelButton,
                  maxWidth: 440,
                  onSubmit: () {
                    if (selectedMember != null) {
                      Navigator.of(context).pop((
                        workspaceMemberId: selectedMember.id,
                        role: selectedRole,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colors.outlineVariant.withValues(alpha: 0.7),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<WorkspaceMemberResponse>(
                            value: selectedMember,
                            isExpanded: true,
                            dropdownColor: colors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8),
                            elevation: 3,
                            menuMaxHeight: 260,
                            style: context.text.bodySmall?.copyWith(
                              fontSize: 13,
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                            ),
                            items: [
                              for (final member in widget.availableMembers)
                                DropdownMenuItem(
                                  value: member,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 11,
                                        backgroundColor:
                                            colors.primaryContainer,
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
                                          style: context.text.bodySmall
                                              ?.copyWith(
                                                fontSize: 12.5,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                            onChanged: (value) => _selectedMember.value = value,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colors.outlineVariant.withValues(alpha: 0.7),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ProjectRole>(
                            value: selectedRole,
                            isExpanded: true,
                            dropdownColor: colors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8),
                            elevation: 3,
                            menuMaxHeight: 260,
                            style: context.text.bodySmall?.copyWith(
                              fontSize: 13,
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: ProjectRole.admin,
                                child: Text(
                                  l10n.projectSettingsMemberRoleAdmin,
                                  style: context.text.bodySmall?.copyWith(
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: ProjectRole.member,
                                child: Text(
                                  l10n.projectSettingsMemberRoleMember,
                                  style: context.text.bodySmall?.copyWith(
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: ProjectRole.observer,
                                child: Text(
                                  l10n.projectSettingsMemberRoleObserver,
                                  style: context.text.bodySmall?.copyWith(
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) _selectedRole.value = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }
}
