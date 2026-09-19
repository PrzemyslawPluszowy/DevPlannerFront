part of 'tasks_board_page.dart';

/// Publiczny komponent nagłówka obszaru zadań w projekcie (dla widoków i testów).
class TasksBoardHeader extends StatelessWidget {
  const TasksBoardHeader({
    required this.state,
    required this.workspaceId,
    required this.projectId,
    required this.view,
    required this.onViewChanged,
    this.currentSnapshot,
    this.onSettingsClosed,
    super.key,
  });

  final TasksBoardReady state;
  final String workspaceId;
  final String projectId;
  final TasksProjectView view;
  final TaskListViewSnapshot? currentSnapshot;
  final ValueChanged<TasksProjectView> onViewChanged;
  final VoidCallback? onSettingsClosed;

  @override
  Widget build(BuildContext context) => _BoardHeader(
    state: state,
    workspaceId: workspaceId,
    projectId: projectId,
    view: view,
    currentSnapshot: currentSnapshot,
    onViewChanged: onViewChanged,
    onSettingsClosed: onSettingsClosed,
  );
}

/// Główny, zoptymalizowany nagłówek obszaru zadań w projekcie.
///
/// Posiada czytelną, dwurzędową hierarchię:
/// - Rząd 1: Kontekst projektu (nazwa, licznik), Primary CTA („Dodaj zadanie” + szablon)
///   oraz strefa narzędzi globalnych (obecność, profil użytkownika, panel admina, połączenie).
/// - Rząd 2: Pasek narzędziowy aktywnego widoku lub kontekstowy pasek akcji masowych (Bulk Toolbar)
///   po zaznaczeniu co najmniej jednego zadania.
class _BoardHeader extends StatelessWidget {
  const _BoardHeader({
    required this.state,
    required this.workspaceId,
    required this.projectId,
    required this.view,
    required this.onViewChanged,
    this.currentSnapshot,
    this.onSettingsClosed,
  });

  final TasksBoardReady state;
  final String workspaceId;
  final String projectId;
  final TasksProjectView view;
  final TaskListViewSnapshot? currentSnapshot;
  final ValueChanged<TasksProjectView> onViewChanged;
  final VoidCallback? onSettingsClosed;

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthSessionPort?>()?.snapshot.user;
    final currentUserId = authUser?.userId;
    final isSuperAdmin =
        authUser?.permissions.contains('bswfms.custom_modules.RNext-admin') ==
            true ||
        authUser?.permissions.contains('SuperAdmin') == true;
    final role = currentUserId == null
        ? null
        : state.memberProfilesByUserId[currentUserId]?.role;
    final canManage =
        isSuperAdmin || role == ProjectRole.owner || role == ProjectRole.admin;
    final effectiveRole = isSuperAdmin ? ProjectRole.admin : role;

    final taskCount = state.board.columns.fold<int>(
      0,
      (sum, column) => sum + column.totalTaskCount,
    );

    final projectsState = context.watch<WorkspaceProjectsCubit?>()?.state;
    final projectItem = switch (projectsState) {
      WorkspaceProjectsReady(:final items) =>
        items.where((p) => p.id == projectId).firstOrNull,
      _ => null,
    };
    final projectName = projectItem?.name ?? '';

    return _BoardHeaderLayout(
      state: state,
      workspaceId: workspaceId,
      projectId: projectId,
      view: view,
      currentSnapshot: currentSnapshot,
      onViewChanged: onViewChanged,
      onSettingsClosed: onSettingsClosed,
      projectName: projectName,
      taskCount: taskCount,
      currentUserId: currentUserId,
      effectiveRole: effectiveRole,
      canManage: canManage,
    );
  }

  static void _openUserHub(
    BuildContext context, {
    required String workspaceId,
    required String projectId,
    required String projectName,
    required ProjectRole? effectiveRole,
  }) {
    final projectsCubit = context.read<WorkspaceProjectsCubit?>();
    final projectFromList = switch (projectsCubit?.state) {
      WorkspaceProjectsReady(:final items) =>
        items.where((p) => p.id == projectId).firstOrNull,
      _ => null,
    };
    final project =
        projectFromList ??
        ProjectListItem(
          id: projectId,
          workspaceId: workspaceId,
          name: projectName,
          myRole: effectiveRole,
          sortPosition: 0,
        );
    unawaited(
      ProjectUserHubDialogs.show(
        context: context,
        project: project,
        userRole: effectiveRole,
        onProjectLeft: () {
          final router = GoRouter.maybeOf(context);
          if (router != null) {
            unawaited(
              DevPlannerNavigation(router).go(
                '/workspaces/$workspaceId/projects',
              ),
            );
          }
        },
      ).then((_) {
        unawaited(projectsCubit?.load());
      }),
    );
  }

  static void _openProjectSettings(
    BuildContext context, {
    required String workspaceId,
    required String projectId,
    required String projectName,
    required ProjectRole? effectiveRole,
    required VoidCallback? onSettingsClosed,
  }) {
    final projectsCubit = context.read<WorkspaceProjectsCubit?>();
    final tasksBoardCubit = context.read<TasksBoardCubit?>();
    final projectFromList = switch (projectsCubit?.state) {
      WorkspaceProjectsReady(:final items) =>
        items.where((p) => p.id == projectId).firstOrNull,
      _ => null,
    };
    final project =
        projectFromList ??
        ProjectListItem(
          id: projectId,
          workspaceId: workspaceId,
          name: projectName,
          myRole: effectiveRole,
          sortPosition: 0,
        );
    unawaited(
      ProjectSettingsDialogs.show(
        context: context,
        project: project,
        userRole: effectiveRole,
        onProjectDeleted: () {
          final router = GoRouter.maybeOf(context);
          if (router != null) {
            unawaited(
              DevPlannerNavigation(router).go(
                '/workspaces/$workspaceId/projects',
              ),
            );
          }
        },
      ).then((result) {
        if (result != null && result.hasChanges) {
          onSettingsClosed?.call();
          unawaited(projectsCubit?.load());
          unawaited(tasksBoardCubit?.load());
        }
      }),
    );
  }
}
