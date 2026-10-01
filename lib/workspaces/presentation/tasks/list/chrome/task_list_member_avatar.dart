import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Compact profile marker shared by assignee controls in the task list.
class TaskListMemberAvatar extends StatelessWidget {
  const TaskListMemberAvatar({required this.profile, super.key});

  final ProjectMemberProfile? profile;

  @override
  Widget build(BuildContext context) {
    final profile = this.profile;
    if (profile == null) {
      return Icon(
        Symbols.account_circle,
        size: 16,
        color: context.colors.onSurfaceVariant,
      );
    }
    final avatarUrl = profile.avatarUrl?.trim();
    final displayName = profile.displayName?.trim();
    final label = displayName?.isNotEmpty == true ? displayName! : 'U';
    return CircleAvatar(
      radius: 9,
      foregroundImage: avatarUrl?.isNotEmpty == true
          ? NetworkImage(avatarUrl!)
          : null,
      child: avatarUrl?.isNotEmpty == true
          ? null
          : Text(
              label.characters.first.toUpperCase(),
              style: context.tasksTheme.metaText.copyWith(height: 1),
            ),
    );
  }
}
