import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Obecność jest rozróżniana kolorem, kształtem i dostępną etykietą.
final class ProjectMemberPresenceDot extends StatelessWidget {
  const ProjectMemberPresenceDot({required this.isOnline, super.key});

  final bool? isOnline;

  @override
  Widget build(BuildContext context) {
    final label = switch (isOnline) {
      true => context.l10n.tasksPresenceOnline,
      false => context.l10n.tasksPresenceOffline,
      null => context.l10n.projectPeoplePresenceUnknown,
    };
    final color = isOnline == true
        ? context.feedback.successForeground
        : context.colors.onSurfaceVariant;
    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        child: SizedBox.square(
          dimension: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline == true ? color : null,
              border: Border.all(color: color, width: 1.5),
            ),
            child: isOnline == null
                ? Center(
                    child: SizedBox.square(
                      dimension: 2,
                      child: ColoredBox(color: color),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
