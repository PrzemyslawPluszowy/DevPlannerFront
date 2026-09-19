part of 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';

/// Układ wizualny nagłówka Kanbana. Otrzymuje wyłącznie dane przygotowane przez
/// cienki komponent koordynujący; nie wykonuje odczytów ani operacji biznesowych.
class _TasksHeaderLayout extends StatelessWidget {
  const _TasksHeaderLayout({
    required this.state,
    required this.workspaceId,
    required this.projectId,
    required this.view,
    required this.onViewChanged,
    required this.projectName,
    required this.taskCount,
    required this.currentUserId,
    required this.effectiveRole,
    required this.canManage,
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
  final String projectName;
  final int taskCount;
  final String? currentUserId;
  final ProjectRole? effectiveRole;
  final bool canManage;
  final VoidCallback? onProjectExited;
  final Widget? commandBar;
  final Widget? bulkBar;
  final bool showBulkBar;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tasksTheme = context.tasksTheme;
    final hasSelection = showBulkBar || state.selectedTaskIds.isNotEmpty;
    final quickFilter = state.userPreference?.quickFilter;
    final showActiveFilter =
        view == TasksProjectView.board &&
        quickFilter != null &&
        quickFilter != KanbanQuickFilter.all;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tasksTheme.sectionGap,
          vertical: tasksTheme.tightGap,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isNarrow = width < 700;
            final showUtilities = width >= 900;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _contextRow(
                  context,
                  tasksTheme: tasksTheme,
                  width: width,
                  isNarrow: isNarrow,
                  showUtilities: showUtilities,
                ),
                SizedBox(height: tasksTheme.tightGap),
                _commandRow(
                  context,
                  tasksTheme: tasksTheme,
                  width: width,
                  isNarrow: isNarrow,
                  hasSelection: hasSelection,
                ),
                if (showActiveFilter) ...[
                  SizedBox(height: tasksTheme.tightGap),
                  _ActiveFilterStrip(
                    filter: quickFilter,
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

  /// Wiersz kontekstu: projekt, licznik, zakładki widoków, obecność, menu i CTA.
  Widget _contextRow(
    BuildContext context, {
    required DevPlannerTasksTheme tasksTheme,
    required double width,
    required bool isNarrow,
    required bool showUtilities,
  }) {
    final colors = context.colors;
    final projectLabel = projectName.isNotEmpty
        ? projectName
        : context.l10n.tasksBoardTitle;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: tasksTheme.contextRowHeight),
      child: Row(
        children: [
          Icon(WorkspaceIcons.tasks, size: 18, color: colors.primary),
          SizedBox(width: tasksTheme.controlGap),
          Flexible(
            child: Text(
              projectLabel,
              style: tasksTheme.projectTitleText.copyWith(
                color: colors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: tasksTheme.controlGap),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: tasksTheme.controlGap,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(tasksTheme.controlRadius),
            ),
            child: Text(
              '$taskCount',
              style: tasksTheme.metaText.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(width: tasksTheme.sectionGap),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _TaskViewSwitcher(view: view, onChanged: onViewChanged),
            ),
          ),
          if (showUtilities) ...[
            ProjectMemberFacepile(
              memberProfilesByUserId: state.memberProfilesByUserId,
              presence: state.presence,
              currentUserId: currentUserId,
              maxVisible: width >= 1350
                  ? 3
                  : width >= 1050
                  ? 2
                  : 1,
              onTap: () => _TasksHeader._openUserHub(
                context,
                workspaceId: workspaceId,
                projectId: projectId,
                projectName: projectName,
                effectiveRole: effectiveRole,
                onProjectExited: onProjectExited,
              ),
            ),
            SizedBox(width: tasksTheme.tightGap),
          ],
          _HeaderMoreMenu(
            state: state,
            canManage: canManage,
            onOpenProjectSettings: () => _TasksHeader._openProjectSettings(
              context,
              workspaceId: workspaceId,
              projectId: projectId,
              projectName: projectName,
              effectiveRole: effectiveRole,
              onSettingsClosed: onSettingsClosed,
              onProjectExited: onProjectExited,
            ),
          ),
          SizedBox(width: tasksTheme.controlGap),
          _HeaderCreateActions(
            state: state,
            isCompact: isNarrow || width < 960,
          ),
        ],
      ),
    );
  }

  /// Wiersz poleceń aktywnego widoku albo jeden kontekstowy pasek akcji masowych.
  Widget _commandRow(
    BuildContext context, {
    required DevPlannerTasksTheme tasksTheme,
    required double width,
    required bool isNarrow,
    required bool hasSelection,
  }) {
    // Wiersz poleceń Listy opisuje kursorowy snapshot Listy, więc montujemy go
    // wyłącznie na widoku Listy; na Kanbanie jego kontrolki nie mają na co
    // działać.
    final listCommandBar = view == TasksProjectView.board ? null : commandBar;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: tasksTheme.commandRowHeight),
      child: hasSelection
          ? (bulkBar ??
                _BulkSelectionToolbar(
                  key: const ValueKey('bulk_toolbar'),
                  state: state,
                  isCompact: isNarrow,
                ))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (view == TasksProjectView.board) ...[
                    _KanbanQuickFilterMenu(
                      state: state,
                      compact: width < 1180,
                    ),
                    SizedBox(width: tasksTheme.controlGap),
                    _KanbanBoardFilters(
                      state: state,
                      compact: width < 1180,
                    ),
                  ],
                  _TaskSavedViewsMenu(
                    compact: width < 1300,
                    workspaceId: workspaceId,
                    projectId: projectId,
                    currentSnapshot: currentSnapshot,
                    memberProfiles: state.memberProfilesByUserId,
                  ),
                  if (listCommandBar case final listCommandBar?) ...[
                    SizedBox(width: tasksTheme.controlGap),
                    listCommandBar,
                  ],
                ],
              ),
            ),
    );
  }
}
