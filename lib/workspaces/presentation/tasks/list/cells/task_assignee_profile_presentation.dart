import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:flutter/widgets.dart';

/// Nazwa osoby używana wspólnie przez komórki tabeli i picker.
final class TaskAssigneeProfilePresentation {
  const TaskAssigneeProfilePresentation._();

  static String label(BuildContext context, ProjectMemberProfile profile) {
    final name = profile.displayName?.trim();
    return name?.isNotEmpty == true
        ? name!
        : context.l10n.tasksAutomationsUnknownMember;
  }
}
