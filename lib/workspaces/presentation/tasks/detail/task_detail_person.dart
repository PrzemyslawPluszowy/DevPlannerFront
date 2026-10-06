import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/workspaces/presentation/projects/people/project_member_presence_dot.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_detail_people_scope.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_collaboration.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

/// Profil osoby z bezpieczną nazwą zastępczą; identyfikator nigdy nie jest copy UI.
final class TaskDetailPerson extends StatelessWidget {
  const TaskDetailPerson({
    required this.userId,
    this.user,
    this.showName = false,
    super.key,
  });
  final String userId;
  final UserReferenceResponse? user;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final people = TaskDetailPeopleScope.maybeOf(context)?.state;
    final profile = people?.members
        .where((person) => person.userId == userId)
        .firstOrNull;
    final profileName = profile?.displayName?.trim();
    final includedName = user?.displayName?.trim();
    final name = profileName?.isNotEmpty == true
        ? profileName!
        : includedName?.isNotEmpty == true
        ? includedName!
        : context.l10n.taskDetailsProjectMember;
    final profileAvatar = profile?.avatarUrl?.trim();
    final avatar = profileAvatar?.isNotEmpty == true
        ? profileAvatar
        : user?.avatarUrl?.trim();
    final picture = CircleAvatar(
      radius: 13,
      foregroundImage: avatar?.isNotEmpty == true
          ? NetworkImage(avatar!)
          : null,
      backgroundColor: TaskCollaboratorAvatarPalette.colorFor(userId),
      child: Text(
        name.characters.first.toUpperCase(),
        style: context.tasksTheme.metaText.copyWith(
          color: context.tasksTheme.onAccent,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    return Tooltip(
      message: name,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          picture,
          const SizedBox(width: 5),
          _TaskPersonPresence(
            isOnline: people?.presenceIsFresh == true
                ? profile?.isOnline
                : null,
          ),
          if (showName) ...[
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.tasksTheme.dataText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Brak działającego wspólnego połączenia nie może potwierdzać statusu online.
final class _TaskPersonPresence extends StatelessWidget {
  const _TaskPersonPresence({required this.isOnline});
  final bool? isOnline;
  @override
  Widget build(BuildContext context) {
    final availability = DevPlannerPanelsScope.maybeOf(context)
        ?.presenceAvailability;
    if (availability == null) {
      return ProjectMemberPresenceDot(isOnline: isOnline);
    }
    return ValueListenableBuilder<bool>(
      valueListenable: availability,
      builder: (context, available, _) =>
          ProjectMemberPresenceDot(isOnline: available ? isOnline : null),
    );
  }
}
