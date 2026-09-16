part of 'tasks_board_page.dart';

/// Cienki adapter wsteczny delegujący do niezależnego modułu widoków [TaskSavedViewsMenu].
class _TaskSavedViewsMenu extends StatelessWidget {
  const _TaskSavedViewsMenu({
    required this.compact,
    required this.workspaceId,
    required this.projectId,
    this.currentSnapshot,
    this.memberProfiles = const {},
  });

  final bool compact;
  final String workspaceId;
  final String projectId;
  final TaskListViewSnapshot? currentSnapshot;
  final Map<String, ProjectMemberProfile> memberProfiles;

  @override
  Widget build(BuildContext context) => TaskSavedViewsMenu(
    compact: compact,
    workspaceId: workspaceId,
    projectId: projectId,
    currentSnapshot: currentSnapshot,
    memberProfiles: memberProfiles,
  );
}
