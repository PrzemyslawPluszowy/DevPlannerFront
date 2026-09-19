part of 'task_list_table.dart';

/// Rozszerzenie budujące główny widok przewijany tabeli zadań wraz z paskiem filtrów i masowych akcji.
extension _TaskListTableViewExtension on _TaskListTableState {
  Widget _buildList(
    BuildContext context,
    ProjectTasksListReady state,
    List<_ListRow> rows,
    List<TaskSavedViewColumn> visibleColumns,
    List<TaskCustomFieldResponse> customFields,
    Map<String, MilestoneResponse> milestones,
    bool canMoveBetweenGroups, {
    TaskListPreferencesCubit? prefCubit,
    TaskListPreferencesReady? prefState,
    TaskListMetadataResult? metadataResult,
  }) {
    final resolvedPrefCubit =
        prefCubit ??
        widget.preferencesCubit ??
        (mounted
            ? () {
                try {
                  return context.read<TaskListPreferencesCubit>();
                } catch (_) {
                  return null;
                }
              }()
            : null);
    final resolvedPrefState =
        prefState ??
        (resolvedPrefCubit?.state is TaskListPreferencesReady
            ? resolvedPrefCubit!.state as TaskListPreferencesReady
            : null);
    final effectiveColumnRefs =
        widget.columnReferences ?? resolvedPrefState?.effectiveVisibleColumns;

    final canManage = TaskPermissionHelper.canManageProject(
      context,
      memberProfiles: widget.memberProfilesByUserId,
    );

    void openColumnSettings({
      TaskColumnsSheetTab initialTab = TaskColumnsSheetTab.user,
    }) {
      if (resolvedPrefCubit != null) {
        unawaited(
          TaskListColumnsSheet.show(
            context,
            cubit: resolvedPrefCubit,
            customFields: customFields,
            canManage: canManage,
            initialTab: initialTab,
          ),
        );
      }
    }

    return FocusableActionDetector(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.keyA, control: true):
            _SelectAllTasksIntent(),
        SingleActivator(LogicalKeyboardKey.keyA, meta: true):
            _SelectAllTasksIntent(),
      },
      actions: {
        _SelectAllTasksIntent: CallbackAction<_SelectAllTasksIntent>(
          onInvoke: (_) {
            context.read<ProjectTasksListCubit>().selectLoadedTasks();
            return null;
          },
        ),
      },
      child: Padding(
        padding: const .only(top: Sizes.p8, bottom: Sizes.p8),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: .stretch,
              children: [
                if (state.filterError case final error?)
                  Padding(
                    padding: const EdgeInsets.only(top: Sizes.p8),
                    child: Row(
                      children: [
                        Icon(Symbols.info_rounded, color: context.colors.error),
                        const SizedBox(width: Sizes.p8),
                        Expanded(
                          child: Text(
                            'Nie zastosowano filtrów: $error',
                            style: context.text.bodySmall?.copyWith(
                              color: context.colors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (metadataResult?.hasError == true)
                  Padding(
                    padding: const EdgeInsets.only(top: Sizes.p8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.p12,
                        vertical: Sizes.p6,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.errorContainer.withValues(
                          alpha: .3,
                        ),
                        borderRadius: BorderRadius.circular(Sizes.p8),
                        border: Border.all(
                          color: context.colors.error.withValues(alpha: .4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Symbols.warning_rounded,
                            color: context.colors.error,
                            size: 18,
                          ),
                          const SizedBox(width: Sizes.p8),
                          Expanded(
                            child: Text(
                              metadataResult!.errorMessage ??
                                  'Błąd pobierania metadanych projektu.',
                              style: context.text.bodySmall?.copyWith(
                                color: context.colors.error,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => updateState(
                              () => _metadata = _loadMetadata(),
                            ),
                            icon: const Icon(Symbols.refresh_rounded, size: 16),
                            label: const Text('Ponów próbę'),
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              foregroundColor: context.colors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: Sizes.p8),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double columnsWidthSum;
                      if (effectiveColumnRefs != null) {
                        columnsWidthSum = effectiveColumnRefs.fold<double>(
                          0,
                          (sum, ref) =>
                              sum +
                              (_columnWidthsById[ref.id] ??
                                  switch (ref) {
                                    SystemColumnReference(:final column) =>
                                      _columnWidths[column] ??
                                          TaskListGrid.width(column),
                                    CustomFieldColumnReference() =>
                                      TaskListGrid.customField,
                                  }),
                        );
                      } else {
                        columnsWidthSum =
                            visibleColumns.fold<double>(
                              0,
                              (sum, column) =>
                                  sum +
                                  (_columnWidths[column] ??
                                      TaskListGrid.width(column)),
                            ) +
                            customFields.length * TaskListGrid.customField;
                      }

                      final requiredTableWidth =
                          TaskListGrid.selection +
                          TaskListGrid.actions +
                          columnsWidthSum;
                      final tableWidth =
                          constraints.maxWidth < requiredTableWidth
                          ? requiredTableWidth
                          : constraints.maxWidth;
                      return ColoredBox(
                        color: context.colors.surface,
                        child: Scrollbar(
                          controller: _horizontalController,
                          child: SingleChildScrollView(
                            controller: _horizontalController,
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: tableWidth,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: rows.isEmpty
                                            ? Center(
                                                child: Text(
                                                  context.l10n.tasksListEmpty,
                                                ),
                                              )
                                            : ListView.builder(
                                                controller: _controller,
                                                padding: EdgeInsets.zero,
                                                itemCount:
                                                    rows.length +
                                                    (state.hasNextPage ? 1 : 0),
                                                itemBuilder: (context, index) {
                                                  if (index == rows.length) {
                                                    return const SizedBox(
                                                      height: 48,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      ),
                                                    );
                                                  }
                                                  return _buildRowItem(
                                                    context,
                                                    state: state,
                                                    row: rows[index],
                                                    visibleColumns:
                                                        visibleColumns,
                                                    effectiveColumnRefs:
                                                        effectiveColumnRefs,
                                                    customFields: customFields,
                                                    milestones: milestones,
                                                    canMoveBetweenGroups:
                                                        canMoveBetweenGroups,
                                                    resolvedPrefState:
                                                        resolvedPrefState,
                                                    resolvedPrefCubit:
                                                        resolvedPrefCubit,
                                                    openColumnSettings:
                                                        openColumnSettings,
                                                  );
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                  _ColumnResizeGuideOverlay(
                                    guideNotifier: _resizeGuideNotifier,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
