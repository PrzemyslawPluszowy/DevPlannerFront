import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/projects/people/project_member_presence_dot.dart';
import 'package:flutter/material.dart';

/// Czytelny status bez najechania myszą, wspólny dla Listy i Kanbanu.
final class ProjectMemberPresenceLabel extends StatelessWidget {
  const ProjectMemberPresenceLabel({required this.isOnline, super.key});

  final bool? isOnline;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ProjectMemberPresenceDot(isOnline: isOnline),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          switch (isOnline) {
            true => context.l10n.tasksPresenceOnline,
            false => context.l10n.tasksPresenceOffline,
            null => context.l10n.projectPeoplePresenceUnknown,
          },
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ),
    ],
  );
}
