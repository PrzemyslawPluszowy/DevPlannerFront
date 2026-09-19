part of 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';

/// Publiczny komponent nagłówka obszaru zadań w projekcie (dla widoków i testów).
class TasksHeader extends StatelessWidget {
  const TasksHeader({
    required this.state,
    required this.workspaceId,
    required this.projectId,
    required this.view,
    required this.onViewChanged,
    this.currentSnapshot,
    this.onSettingsClosed,
    this.onProjectExited,
    this.commandBar,
    this.bulkBar,
    this.showBulkBar = false,
    super.key,
  });

  final TasksBoardReady state;
  final String workspaceId;
  final String projectId;
  final TasksProjectView view;
  final TaskListViewSnapshot? currentSnapshot;
  final ValueChanged<TasksProjectView> onViewChanged;
  final VoidCallback? onSettingsClosed;

  /// Wywoływane, gdy użytkownik opuścił lub usunął projekt.
  ///
  /// Nawigację wykonuje właściciel trasy, więc nagłówek nie zna routera.
  final VoidCallback? onProjectExited;

  /// Kontrolki wiersza poleceń aktywnego widoku (np. filtry Listy).
  final Widget? commandBar;

  /// Kontekstowy pasek akcji masowych aktywnego widoku.
  final Widget? bulkBar;

  /// Czy wiersz poleceń ma ustąpić miejsca paskowi akcji masowych.
  final bool showBulkBar;

  @override
  Widget build(BuildContext context) => _TasksHeader(
    state: state,
    workspaceId: workspaceId,
    projectId: projectId,
    view: view,
    currentSnapshot: currentSnapshot,
    onViewChanged: onViewChanged,
    onSettingsClosed: onSettingsClosed,
    onProjectExited: onProjectExited,
    commandBar: commandBar,
    bulkBar: bulkBar,
    showBulkBar: showBulkBar,
  );
}

/// Główny, zoptymalizowany nagłówek obszaru zadań w projekcie.
///
/// Posiada czytelną, dwurzędową hierarchię:
/// - Rząd 1: Kontekst projektu (nazwa, licznik), Primary CTA („Dodaj zadanie” + szablon)
///   oraz strefa narzędzi globalnych (obecność, profil użytkownika, panel admina, połączenie).
/// - Rząd 2: Pasek narzędziowy aktywnego widoku lub kontekstowy pasek akcji masowych (Bulk Toolbar)
///   po zaznaczeniu co najmniej jednego zadania.
class _TasksHeader extends StatelessWidget {
  const _TasksHeader({
    required this.state,
    required this.workspaceId,
    required this.projectId,
    required this.view,
    required this.onViewChanged,
    this.currentSnapshot,
    this.onSettingsClosed,
    this.onProjectExited,
    this.commandBar,
    this.bulkBar,
    this.showBulkBar = false,
  });

  final TasksBoardReady state;
  final String workspaceId;
  final String projectId;
  final TasksProjectView view;
  final TaskListViewSnapshot? currentSnapshot;
  final ValueChanged<TasksProjectView> onViewChanged;
  final VoidCallback? onSettingsClosed;
  final VoidCallback? onProjectExited;
  final Widget? commandBar;
  final Widget? bulkBar;
  final bool showBulkBar;

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

    return _TasksHeaderLayout(
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
      onProjectExited: onProjectExited,
      commandBar: commandBar,
      bulkBar: bulkBar,
      showBulkBar: showBulkBar,
    );
  }

  static void _openUserHub(
    BuildContext context, {
    required String workspaceId,
    required String projectId,
    required String projectName,
    required ProjectRole? effectiveRole,
    required VoidCallback? onProjectExited,
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
        onProjectLeft: () => onProjectExited?.call(),
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
    required VoidCallback? onProjectExited,
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
        onProjectDeleted: () => onProjectExited?.call(),
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
