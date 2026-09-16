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
  final _TasksProjectView view;
  final TaskListViewSnapshot? currentSnapshot;
  final ValueChanged<_TasksProjectView> onViewChanged;
  final VoidCallback? onSettingsClosed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final authUser = switch (context.watch<AuthCubit?>()?.state) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };
    final currentUserId = authUser?.coreUserId;
    final isSuperAdmin =
        authUser?.permissions.contains('bswfms.custom_modules.RNext-admin') ==
            true ||
        authUser?.permissions.contains('SuperAdmin') == true;
    final role = currentUserId == null
        ? null
        : state.memberProfilesByCoreUserId[currentUserId]?.role;
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

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Padding(
        padding: const .symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p6,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(1.0);
            final isSingleRow =
                constraints.maxWidth >= 880 && textScale <= 1.15;
            final isCompactCta = constraints.maxWidth <= 768;
            final isNarrow = constraints.maxWidth < 768;
            final hasSelection = state.selectedTaskIds.isNotEmpty;

            return Column(
              mainAxisSize: .min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isSingleRow)
                  // POJEDYNCZY WIERSZ TOOLBARU DLA EKRANÓW DESKTOP/SZEROKICH (≥ 920 px, 44–48 px)
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 36),
                    child: Row(
                      children: [
                        // STREFA 1 (LEWA): Ikona + nazwa projektu + badge licznika
                        Row(
                          mainAxisSize: .min,
                          children: [
                            Icon(
                              WorkspaceIcons.tasks,
                              size: Sizes.p18,
                              color: colors.primary,
                            ),
                            const SizedBox(width: Sizes.p8),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth < 1100
                                    ? 140
                                    : 200,
                              ),
                              child: Text(
                                projectName.isNotEmpty
                                    ? projectName
                                    : l10n.tasksBoardTitle,
                                style: context.text.titleSmall?.copyWith(
                                  fontWeight: .w600,
                                  letterSpacing: -.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: Sizes.p6),
                            Container(
                              padding: const .symmetric(
                                horizontal: Sizes.p6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHigh,
                                borderRadius: .circular(10),
                              ),
                              child: Text(
                                '$taskCount',
                                style: context.text.labelSmall?.copyWith(
                                  fontWeight: .w700,
                                  fontSize: 11,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: Sizes.p8),

                        // STREFA 2 (ŚRODEK): Przełącznik widoków LUB Bulk Toolbar
                        Expanded(
                          child: hasSelection
                              ? _BulkSelectionToolbar(
                                  key: const ValueKey('bulk_toolbar'),
                                  state: state,
                                  isCompact: false,
                                )
                              : _TaskViewSwitcher(
                                  view: view,
                                  onChanged: onViewChanged,
                                ),
                        ),

                        const SizedBox(width: Sizes.p8),

                        // STREFA 3 (PRAWA): Narzędzia, widoki, facepile, menu więcej i CTA
                        Row(
                          mainAxisSize: .min,
                          children: [
                            if (!hasSelection) ...[
                              if (view == _TasksProjectView.board) ...[
                                _KanbanQuickFilterMenu(
                                  state: state,
                                  compact: constraints.maxWidth < 1180,
                                ),
                                const SizedBox(width: Sizes.p6),
                              ],
                              _TaskSavedViewsMenu(
                                compact: constraints.maxWidth < 1300,
                                workspaceId: workspaceId,
                                projectId: projectId,
                                currentSnapshot: currentSnapshot,
                                memberProfiles:
                                    state.memberProfilesByCoreUserId,
                              ),
                              const SizedBox(width: Sizes.p6),
                              ProjectMemberFacepile(
                                memberProfilesByCoreUserId:
                                    state.memberProfilesByCoreUserId,
                                presence: state.presence,
                                currentUserId: currentUserId,
                                maxVisible: constraints.maxWidth >= 1350
                                    ? 3
                                    : constraints.maxWidth >= 1050
                                    ? 2
                                    : 1,
                                onTap: () => _openUserHub(
                                  context,
                                  workspaceId: workspaceId,
                                  projectId: projectId,
                                  projectName: projectName,
                                  effectiveRole: effectiveRole,
                                ),
                              ),
                              const SizedBox(width: Sizes.p4),
                              _HeaderMoreMenu(
                                state: state,
                                canManage: canManage,
                                onOpenProjectSettings: () =>
                                    _openProjectSettings(
                                      context,
                                      workspaceId: workspaceId,
                                      projectId: projectId,
                                      projectName: projectName,
                                      effectiveRole: effectiveRole,
                                      onSettingsClosed: onSettingsClosed,
                                    ),
                              ),
                              const SizedBox(width: Sizes.p6),
                            ],
                            _HeaderCreateActions(
                              state: state,
                              isCompact: constraints.maxWidth < 1000,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else ...[
                  // ZWARTY DWURZĘDOWY UKŁAD (< 1200 px lub powiększony tekst)
                  // WIERSZ 1: Kontekst projektu + Utility + Primary CTA
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: .min,
                          children: [
                            Icon(
                              WorkspaceIcons.tasks,
                              size: Sizes.p18,
                              color: colors.primary,
                            ),
                            const SizedBox(width: Sizes.p6),
                            Flexible(
                              child: Text(
                                projectName.isNotEmpty
                                    ? projectName
                                    : l10n.tasksBoardTitle,
                                style: context.text.titleSmall?.copyWith(
                                  fontWeight: .w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: Sizes.p6),
                            Container(
                              padding: const .symmetric(
                                horizontal: Sizes.p6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHigh,
                                borderRadius: .circular(10),
                              ),
                              child: Text(
                                '$taskCount',
                                style: context.text.labelSmall?.copyWith(
                                  fontWeight: .w700,
                                  fontSize: 11,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Sizes.p6),
                      ProjectMemberFacepile(
                        memberProfilesByCoreUserId:
                            state.memberProfilesByCoreUserId,
                        presence: state.presence,
                        currentUserId: currentUserId,
                        maxVisible: isNarrow ? 1 : 2,
                        onTap: () => _openUserHub(
                          context,
                          workspaceId: workspaceId,
                          projectId: projectId,
                          projectName: projectName,
                          effectiveRole: effectiveRole,
                        ),
                      ),
                      const SizedBox(width: Sizes.p4),
                      _HeaderMoreMenu(
                        state: state,
                        canManage: canManage,
                        onOpenProjectSettings: () => _openProjectSettings(
                          context,
                          workspaceId: workspaceId,
                          projectId: projectId,
                          projectName: projectName,
                          effectiveRole: effectiveRole,
                          onSettingsClosed: onSettingsClosed,
                        ),
                      ),
                      const SizedBox(width: Sizes.p6),
                      _HeaderCreateActions(
                        state: state,
                        isCompact: isCompactCta,
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.p6),

                  // WIERSZ 2: Nawigacja widoków lub Bulk Toolbar
                  if (hasSelection)
                    _BulkSelectionToolbar(
                      key: const ValueKey('bulk_toolbar'),
                      state: state,
                      isCompact: isCompactCta,
                    )
                  else if (!isNarrow)
                    Row(
                      children: [
                        Expanded(
                          child: _TaskViewSwitcher(
                            view: view,
                            onChanged: onViewChanged,
                          ),
                        ),
                        const SizedBox(width: Sizes.p8),
                        if (view == _TasksProjectView.board) ...[
                          _KanbanQuickFilterMenu(state: state),
                          const SizedBox(width: Sizes.p6),
                        ],
                        _TaskSavedViewsMenu(
                          compact: true,
                          workspaceId: workspaceId,
                          projectId: projectId,
                          currentSnapshot: currentSnapshot,
                          memberProfiles: state.memberProfilesByCoreUserId,
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TaskViewSwitcher(
                          view: view,
                          onChanged: onViewChanged,
                        ),
                        const SizedBox(height: Sizes.p4),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: .min,
                            children: [
                              if (view == _TasksProjectView.board) ...[
                                _KanbanQuickFilterMenu(state: state),
                                const SizedBox(width: Sizes.p6),
                              ],
                              _TaskSavedViewsMenu(
                                compact: true,
                                workspaceId: workspaceId,
                                projectId: projectId,
                                currentSnapshot: currentSnapshot,
                                memberProfiles:
                                    state.memberProfilesByCoreUserId,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],

                // Aktywne filtry Kanbanu (jeśli wybrano filtr inny niż wszystkie)
                if (view == _TasksProjectView.board &&
                    state.userPreference?.quickFilter != null &&
                    state.userPreference!.quickFilter !=
                        KanbanQuickFilter.all) ...[
                  const SizedBox(height: Sizes.p4),
                  _ActiveFilterStrip(
                    filter: state.userPreference!.quickFilter,
                    onClear: () => unawaited(
                      context.read<TasksBoardCubit>().setQuickFilter(
                        KanbanQuickFilter.all,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
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
      showProjectUserHubModal(
        context: context,
        project: project,
        userRole: effectiveRole,
        onProjectLeft: () {
          context.go('/workspaces/$workspaceId/projects');
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
      showProjectSettingsModal(
        context: context,
        project: project,
        userRole: effectiveRole,
        onProjectDeleted: () {
          context.go('/workspaces/$workspaceId/projects');
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

/// Zwarte menu Więcej w nagłówku zbierające panel administracyjny i status realtime.
class _HeaderMoreMenu extends StatelessWidget {
  const _HeaderMoreMenu({
    required this.state,
    required this.canManage,
    required this.onOpenProjectSettings,
  });

  final TasksBoardReady state;
  final bool canManage;
  final VoidCallback onOpenProjectSettings;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final connected =
        state.connectionState == WorkspaceSignalRConnectionState.connected;
    final connecting =
        state.connectionState == WorkspaceSignalRConnectionState.connecting ||
        state.connectionState == WorkspaceSignalRConnectionState.reconnecting;
    final statusColor = connected
        ? const Color(0xFF00A884)
        : connecting
        ? const Color(0xFFF59E0B)
        : colors.error;

    return Builder(
      builder: (buttonContext) => Tooltip(
        message: l10n.tasksListMoreOptionsTooltip,
        child: InkWell(
          key: const ValueKey('header_more_menu'),
          onTap: () async {
            final action = await TaskContextMenu.show<String>(
              context,
              position: TaskContextMenu.positionFor(buttonContext),
              items: [
                if (canManage)
                  TaskContextMenuItem<String>(
                    value: 'admin_settings',
                    icon: Symbols.admin_panel_settings_rounded,
                    title: l10n.tasksListAdminPanelButton,
                  ),
                TaskContextMenuItem<String>(
                  value: 'connection',
                  icon: Symbols.wifi_rounded,
                  iconColor: statusColor,
                  title: connected
                      ? l10n.tasksRealtimeConnected
                      : connecting
                      ? l10n.tasksRealtimeConnecting
                      : l10n.tasksRealtimeOffline,
                ),
              ],
            );
            if (action == 'admin_settings') onOpenProjectSettings();
          },
          borderRadius: .circular(Sizes.p8),
          hoverColor: colors.surfaceContainerHighest.withValues(alpha: .4),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            child: Center(
              child: Container(
                height: 32,
                padding: EdgeInsets.symmetric(
                  horizontal: !connected ? Sizes.p6 : Sizes.p8,
                ),
                decoration: BoxDecoration(
                  borderRadius: .circular(Sizes.p8),
                  border: .all(
                    color: colors.outlineVariant.withValues(alpha: .5),
                  ),
                ),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Symbols.more_horiz_rounded,
                      size: 18,
                      color: colors.onSurfaceVariant,
                    ),
                    if (!connected) ...[
                      const SizedBox(width: Sizes.p4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: .circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kontekstowy pasek akcji masowych, zastępujący Rząd 2 po zaznaczeniu zadań.
class _BulkSelectionToolbar extends StatelessWidget {
  const _BulkSelectionToolbar({
    required this.state,
    required this.isCompact,
    super.key,
  });

  final TasksBoardReady state;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final count = state.selectedTaskIds.length;

    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p12,
        vertical: Sizes.p4,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(Sizes.p10),
        border: Border.all(color: colors.primary.withValues(alpha: .3)),
      ),
      child: Row(
        children: [
          Icon(
            Symbols.check_box_rounded,
            color: colors.onPrimaryContainer,
            size: Sizes.p20,
          ),
          const SizedBox(width: Sizes.p8),
          Text(
            l10n.tasksBulkSelected(count),
            style: context.text.labelLarge?.copyWith(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: Sizes.p8),

          // Przewijane akcje masowe
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Akcja masowa: zmiana kolumny / statusu
                  Builder(
                    builder: (buttonContext) => _BulkActionButton(
                      icon: Symbols.drive_file_move_outline,
                      label: isCompact ? null : l10n.tasksBulkMove,
                      isLoading: state.isBulkSaving,
                      onTap: state.isBulkSaving
                          ? null
                          : () async {
                              final column =
                                  await TaskContextMenu.show<
                                    KanbanColumnResponse
                                  >(
                                    context,
                                    position: TaskContextMenu.positionFor(
                                      buttonContext,
                                    ),
                                    items: [
                                      for (final col in state.board.columns)
                                        TaskContextMenuItem<
                                          KanbanColumnResponse
                                        >(
                                          value: col,
                                          title: col.displayName,
                                          icon: Symbols.view_column_rounded,
                                        ),
                                    ],
                                  );
                              if (column != null && context.mounted) {
                                unawaited(
                                  context.read<TasksBoardCubit>().bulkMoveTasks(
                                    column,
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: Sizes.p6),

                  // Akcja masowa: zmiana priorytetu
                  Builder(
                    builder: (buttonContext) => _BulkActionButton(
                      icon: Symbols.flag,
                      label: isCompact ? null : l10n.tasksBulkPriority,
                      isLoading: state.isBulkSaving,
                      onTap: state.isBulkSaving
                          ? null
                          : () async {
                              final priority =
                                  await TaskContextMenu.show<TaskPriority>(
                                    context,
                                    position: TaskContextMenu.positionFor(
                                      buttonContext,
                                    ),
                                    items: [
                                      for (final priority
                                          in TaskPriority.values)
                                        TaskContextMenuItem<TaskPriority>(
                                          value: priority,
                                          title: _boardPriorityLabel(
                                            context,
                                            priority,
                                          ),
                                          icon: Symbols.flag_rounded,
                                          iconColor: _boardPriorityColor(
                                            priority,
                                          ),
                                        ),
                                    ],
                                  );
                              if (priority != null && context.mounted) {
                                unawaited(
                                  context
                                      .read<TasksBoardCubit>()
                                      .bulkUpdatePriority(priority),
                                );
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: Sizes.p6),

                  // Akcja masowa: zmiana terminu
                  _BulkActionButton(
                    icon: Symbols.event,
                    label: isCompact ? null : l10n.tasksBulkDueDate,
                    onTap: state.isBulkSaving
                        ? null
                        : () => _pickBulkDueDate(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: Sizes.p6),

          // Odznaczenie wszystkich
          IconButton(
            tooltip: l10n.tasksBulkClearSelection,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            onPressed: state.isBulkSaving
                ? null
                : () => context.read<TasksBoardCubit?>()?.clearTaskSelection(),
            icon: Icon(
              Symbols.close_rounded,
              color: colors.onPrimaryContainer,
              size: Sizes.p20,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulkActionButton extends StatelessWidget {
  const _BulkActionButton({
    required this.icon,
    this.label,
    this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final String? label;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Sizes.p8),
        child: Container(
          constraints: const BoxConstraints(minHeight: 38, minWidth: 44),
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p10,
            vertical: Sizes.p6,
          ),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: .75),
            borderRadius: BorderRadius.circular(Sizes.p8),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: .5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(icon, size: Sizes.p18, color: colors.onSurface),
              if (label != null) ...[
                const SizedBox(width: Sizes.p6),
                Text(
                  label!,
                  style: context.text.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Pasek z usuwalnym chipem aktywnego filtra.
class _ActiveFilterStrip extends StatelessWidget {
  const _ActiveFilterStrip({
    required this.filter,
    required this.onClear,
  });

  final KanbanQuickFilter filter;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Row(
      children: [
        Icon(
          Symbols.filter_alt_rounded,
          size: Sizes.p16,
          color: colors.onSurfaceVariant,
        ),
        const SizedBox(width: Sizes.p6),
        Text(
          'Aktywny filtr:',
          style: context.text.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: Sizes.p6),
        InputChip(
          label: Text(_quickFilterLabel(context, filter)),
          onDeleted: onClear,
          deleteIconColor: colors.onSecondaryContainer,
          backgroundColor: colors.secondaryContainer,
          labelStyle: context.text.labelSmall?.copyWith(
            color: colors.onSecondaryContainer,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: Sizes.p6),
        TextButton(
          onPressed: onClear,
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
          ),
          child: Text(
            l10n.tasksListClearValue,
            style: context.text.labelSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// Szybkie tworzenie zadania z menu wyboru szablonu.
class _HeaderCreateActions extends StatelessWidget {
  const _HeaderCreateActions({
    required this.state,
    this.isCompact = false,
  });

  final TasksBoardReady state;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEnabled = state.board.columns.isNotEmpty;

    return Semantics(
      button: true,
      label: context.l10n.tasksQuickCreate,
      child: Material(
        color: isEnabled ? colors.primary : colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Sizes.p8),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Główny przycisk szybkiego tworzenia zadania
              Tooltip(
                message: context.l10n.tasksQuickCreate,
                child: InkWell(
                  onTap: isEnabled
                      ? () => unawaited(_showHeaderQuickCreate(context, state))
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? Sizes.p10 : Sizes.p12,
                      vertical: Sizes.p8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Symbols.add_rounded,
                          size: Sizes.p18,
                          color: isEnabled
                              ? colors.onPrimary
                              : colors.onSurfaceVariant.withValues(alpha: .4),
                        ),
                        if (!isCompact) ...[
                          const SizedBox(width: Sizes.p6),
                          Text(
                            context.l10n.tasksQuickCreate,
                            style: context.text.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isEnabled
                                  ? colors.onPrimary
                                  : colors.onSurfaceVariant.withValues(
                                      alpha: .4,
                                    ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Subtelny separator 1 px
              VerticalDivider(
                width: 1,
                thickness: 1,
                indent: 6,
                endIndent: 6,
                color: isEnabled
                    ? colors.onPrimary.withValues(alpha: .25)
                    : colors.outlineVariant.withValues(alpha: .3),
              ),

              // Menu wyboru szablonów / dodatkowych akcji
              Builder(
                builder: (buttonContext) => Tooltip(
                  message: context.l10n.tasksTemplatesUse,
                  child: InkWell(
                    onTap: isEnabled
                        ? () async {
                            final action =
                                await TaskContextMenu.show<_HeaderCreateAction>(
                                  context,
                                  position: TaskContextMenu.positionFor(
                                    buttonContext,
                                  ),
                                  items: [
                                    TaskContextMenuItem<_HeaderCreateAction>(
                                      value: _HeaderCreateAction.fromTemplate,
                                      icon: Symbols.auto_awesome_mosaic_rounded,
                                      title: context.l10n.tasksTemplatesUse,
                                    ),
                                  ],
                                );
                            if (action == _HeaderCreateAction.fromTemplate &&
                                context.mounted) {
                              unawaited(_showTaskTemplatePicker(context));
                            }
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.p6,
                        vertical: Sizes.p8,
                      ),
                      child: Icon(
                        Symbols.arrow_drop_down_rounded,
                        size: Sizes.p20,
                        color: isEnabled
                            ? colors.onPrimary
                            : colors.onSurfaceVariant.withValues(alpha: .4),
                      ),
                    ),
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

enum _HeaderCreateAction { fromTemplate }

Future<void> _showHeaderQuickCreate(
  BuildContext context,
  TasksBoardReady state,
) async {
  final availableColumns = state.board.columns.toList(growable: false);
  if (availableColumns.isEmpty) return;
  final pickerCubit = context.read<TaskTemplatePickerCubit>();
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: pickerCubit,
      child: TaskQuickCreateDialog(
        columns: availableColumns,
        onCreate:
            ({
              required title,
              required column,
              taskTemplateId,
              useDefaultTemplate = true,
            }) => context.read<TasksBoardCubit>().createQuickTask(
              column: column,
              title: title,
              taskTemplateId: taskTemplateId,
              useDefaultTemplate: useDefaultTemplate,
            ),
      ),
    ),
  );
}

class TaskQuickCreateDialog extends StatefulWidget {
  const TaskQuickCreateDialog({
    required this.columns,
    required this.onCreate,
    super.key,
  });

  final List<KanbanColumnResponse> columns;
  final Future<bool> Function({
    required String title,
    required KanbanColumnResponse column,
    String? taskTemplateId,
    bool useDefaultTemplate,
  })
  onCreate;

  @override
  State<TaskQuickCreateDialog> createState() => _TaskQuickCreateDialogState();
}

class _TaskQuickCreateDialogState extends State<TaskQuickCreateDialog> {
  late final TextEditingController _titleController;
  late KanbanColumnResponse _column;
  var _isSubmitting = false;
  String? _selectedTemplateId;
  var _useDefaultTemplate = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _column = widget.columns.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (_isSubmitting || title.isEmpty) return;
    setState(() => _isSubmitting = true);
    final created = await widget.onCreate(
      title: title,
      column: _column,
      taskTemplateId: _selectedTemplateId,
      useDefaultTemplate: _useDefaultTemplate,
    );
    if (!mounted) return;
    if (created) {
      Navigator.of(context).pop();
    } else {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateTaskTitle,
      subtitle: l10n.workspacesCreateTaskSubtitle,
      icon: WorkspaceIcons.tasks,
      accentColor: colors.primary,
      isSubmitting: _isSubmitting,
      submitLabel: l10n.create,
      cancelLabel: l10n.cancel,
      maxWidth: 460,
      onSubmit: _submit,
      body: Column(
        mainAxisSize: .min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.workspacesTaskTitleLabel,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h8,
          TextField(
            controller: _titleController,
            autofocus: true,
            enabled: !_isSubmitting,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: l10n.tasksQuickCreateHint,
              border: const OutlineInputBorder(
                borderRadius: .all(.circular(10)),
              ),
              contentPadding: const .symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p12,
              ),
            ),
            onSubmitted: (_) => _submit(),
          ),
          Gaps.h16,
          Text(
            l10n.tasksListStatus,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h8,
          DropdownButtonFormField<KanbanColumnResponse>(
            initialValue: _column,
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: .all(.circular(10)),
              ),
              contentPadding: .symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p8,
              ),
            ),
            items: [
              for (final column in widget.columns)
                DropdownMenuItem(
                  value: column,
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: () {
                            try {
                              final hex = column.color.replaceFirst('#', '');
                              return Color(int.parse('0xFF$hex'));
                            } catch (_) {
                              return colors.primary;
                            }
                          }(),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: Sizes.p8),
                      Text(column.displayName),
                    ],
                  ),
                ),
            ],
            onChanged: _isSubmitting
                ? null
                : (column) {
                    if (column != null) setState(() => _column = column);
                  },
          ),
          Builder(
            builder: (context) {
              final pickerState = context
                  .watch<TaskTemplatePickerCubit?>()
                  ?.state;
              final templates = switch (pickerState) {
                TaskTemplatePickerReady(:final templates) => templates,
                _ => const <TaskTemplateResponse>[],
              };
              final defaultTemplateId = switch (pickerState) {
                TaskTemplatePickerReady(:final defaultTemplateId) =>
                  defaultTemplateId,
                _ => null,
              };
              if (templates.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: .min,
                children: [
                  Gaps.h16,
                  Text(
                    l10n.tasksTemplateForThisTask,
                    style: context.text.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Gaps.h8,
                  DropdownButtonFormField<String?>(
                    initialValue:
                        _selectedTemplateId ??
                        (_useDefaultTemplate ? defaultTemplateId : null),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: .all(.circular(10)),
                      ),
                      contentPadding: .symmetric(
                        horizontal: Sizes.p12,
                        vertical: Sizes.p8,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        child: Text(l10n.tasksTemplateNoTemplate),
                      ),
                      for (final t in templates)
                        DropdownMenuItem<String?>(
                          value: t.id,
                          child: Row(
                            children: [
                              Icon(
                                t.id == defaultTemplateId
                                    ? Symbols.star_rounded
                                    : Symbols.auto_awesome_mosaic_rounded,
                                size: 16,
                                color: t.id == defaultTemplateId
                                    ? colors.primary
                                    : null,
                              ),
                              const SizedBox(width: Sizes.p8),
                              Expanded(
                                child: Text(
                                  t.id == defaultTemplateId
                                      ? '${t.name} (${l10n.tasksTemplatesDefault})'
                                      : t.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() {
                              _selectedTemplateId = value;
                              _useDefaultTemplate = false;
                            });
                          },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Menu filtrowania Kanbanu.
class _KanbanQuickFilterMenu extends StatelessWidget {
  const _KanbanQuickFilterMenu({
    required this.state,
    this.compact = false,
  });

  final TasksBoardReady state;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final selected = state.userPreference?.quickFilter ?? KanbanQuickFilter.all;
    final isEnabled =
        state.userPreference != null && !state.savingUserPreference;
    final colors = context.colors;

    return Tooltip(
      message: context.l10n.tasksKanbanQuickFilter,
      child: Semantics(
        button: true,
        label: context.l10n.tasksKanbanQuickFilter,
        child: Material(
          color: colors.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
            side: BorderSide(
              color: colors.outlineVariant.withValues(alpha: .6),
            ),
          ),
          child: Builder(
            builder: (buttonContext) => InkWell(
              onTap: isEnabled
                  ? () async {
                      final filter =
                          await TaskContextMenu.show<KanbanQuickFilter>(
                            context,
                            position: TaskContextMenu.positionFor(
                              buttonContext,
                            ),
                            items: [
                              for (final f in KanbanQuickFilter.values)
                                TaskContextMenuItem<KanbanQuickFilter>(
                                  value: f,
                                  title: _quickFilterLabel(context, f),
                                  icon: _quickFilterIcon(f),
                                  iconColor: f == KanbanQuickFilter.blocked
                                      ? colors.error
                                      : f == KanbanQuickFilter.dueSoon
                                      ? const Color(0xFFF59E0B)
                                      : null,
                                  isSelected: f == selected,
                                  trailing: f == selected
                                      ? Icon(
                                          Symbols.check_rounded,
                                          size: 16,
                                          color: colors.primary,
                                        )
                                      : null,
                                ),
                            ],
                          );
                      if (filter != null && context.mounted) {
                        unawaited(
                          context.read<TasksBoardCubit>().setQuickFilter(
                            filter,
                          ),
                        );
                      }
                    }
                  : null,
              borderRadius: BorderRadius.circular(Sizes.p8),
              hoverColor: colors.surfaceContainerHighest.withValues(alpha: .4),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? Sizes.p8 : Sizes.p10,
                    vertical: Sizes.p6,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _quickFilterIcon(selected),
                          size: Sizes.p16,
                          color: selected == KanbanQuickFilter.all
                              ? colors.onSurfaceVariant
                              : colors.primary,
                        ),
                        if (!compact) ...[
                          const SizedBox(width: Sizes.p6),
                          Text(
                            _quickFilterLabel(context, selected),
                            style: context.text.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(width: Sizes.p4),
                          Icon(
                            Symbols.arrow_drop_down_rounded,
                            size: 18,
                            color: colors.onSurfaceVariant,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

IconData _quickFilterIcon(KanbanQuickFilter filter) => switch (filter) {
  KanbanQuickFilter.all => Symbols.filter_list_rounded,
  KanbanQuickFilter.mine => Symbols.person_rounded,
  KanbanQuickFilter.unassigned => Symbols.person_off_rounded,
  KanbanQuickFilter.blocked => Symbols.block_rounded,
  KanbanQuickFilter.dueSoon => Symbols.schedule_rounded,
};

Color _boardPriorityColor(TaskPriority priority) => switch (priority) {
  TaskPriority.low => const Color(0xFF74B9FF),
  TaskPriority.normal => const Color(0xFF00B894),
  TaskPriority.high => const Color(0xFFFDAA2D),
  TaskPriority.critical => const Color(0xFFFF5252),
};

String _quickFilterLabel(BuildContext context, KanbanQuickFilter filter) =>
    switch (filter) {
      KanbanQuickFilter.all => context.l10n.tasksKanbanQuickFilterAll,
      KanbanQuickFilter.mine => context.l10n.tasksKanbanQuickFilterMine,
      KanbanQuickFilter.unassigned =>
        context.l10n.tasksKanbanQuickFilterUnassigned,
      KanbanQuickFilter.blocked => context.l10n.tasksKanbanQuickFilterBlocked,
      KanbanQuickFilter.dueSoon => context.l10n.tasksKanbanQuickFilterDueSoon,
    };

String _boardPriorityLabel(BuildContext context, TaskPriority priority) =>
    switch (priority) {
      TaskPriority.low => context.l10n.tasksPriorityLow,
      TaskPriority.normal => context.l10n.tasksPriorityNormal,
      TaskPriority.high => context.l10n.tasksPriorityHigh,
      TaskPriority.critical => context.l10n.tasksPriorityCritical,
    };

Future<void> _pickBulkDueDate(BuildContext context) async {
  final cubit = context.read<TasksBoardCubit>();
  final selected = await AppModalPickerHost.showDate(
    context,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    initialDate: DateTime.now(),
  );
  if (selected == null) return;
  await cubit.bulkUpdateDueDate(selected);
}
