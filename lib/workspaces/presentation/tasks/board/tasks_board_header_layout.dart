part of 'tasks_board_page.dart';

/// Układ wizualny nagłówka Kanbana. Otrzymuje wyłącznie dane przygotowane przez
/// cienki komponent koordynujący; nie wykonuje odczytów ani operacji biznesowych.
class _BoardHeaderLayout extends StatelessWidget {
  const _BoardHeaderLayout({
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
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
                              if (view == TasksProjectView.board) ...[
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
                                memberProfiles: state.memberProfilesByUserId,
                              ),
                              const SizedBox(width: Sizes.p6),
                              ProjectMemberFacepile(
                                memberProfilesByUserId:
                                    state.memberProfilesByUserId,
                                presence: state.presence,
                                currentUserId: currentUserId,
                                maxVisible: constraints.maxWidth >= 1350
                                    ? 3
                                    : constraints.maxWidth >= 1050
                                    ? 2
                                    : 1,
                                onTap: () => _BoardHeader._openUserHub(
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
                                    _BoardHeader._openProjectSettings(
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
                        memberProfilesByUserId: state.memberProfilesByUserId,
                        presence: state.presence,
                        currentUserId: currentUserId,
                        maxVisible: isNarrow ? 1 : 2,
                        onTap: () => _BoardHeader._openUserHub(
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
                            _BoardHeader._openProjectSettings(
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
                        if (view == TasksProjectView.board) ...[
                          _KanbanQuickFilterMenu(state: state),
                          const SizedBox(width: Sizes.p6),
                        ],
                        _TaskSavedViewsMenu(
                          compact: true,
                          workspaceId: workspaceId,
                          projectId: projectId,
                          currentSnapshot: currentSnapshot,
                          memberProfiles: state.memberProfilesByUserId,
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
                              if (view == TasksProjectView.board) ...[
                                _KanbanQuickFilterMenu(state: state),
                                const SizedBox(width: Sizes.p6),
                              ],
                              _TaskSavedViewsMenu(
                                compact: true,
                                workspaceId: workspaceId,
                                projectId: projectId,
                                currentSnapshot: currentSnapshot,
                                memberProfiles: state.memberProfilesByUserId,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],

                // Aktywne filtry Kanbanu (jeśli wybrano filtr inny niż wszystkie)
                if (view == TasksProjectView.board &&
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
}
