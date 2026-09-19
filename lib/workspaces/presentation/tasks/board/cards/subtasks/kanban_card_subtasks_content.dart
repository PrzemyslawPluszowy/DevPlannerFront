part of 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_card_subtasks.dart';

extension _KanbanCardSubtasksSectionStateContent
    on _KanbanCardSubtasksSectionState {
  Widget _buildExpandedContent(
    BuildContext context,
    KanbanSubtasksState state,
  ) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colors.outlineVariant.withValues(
                alpha: isDark ? .35 : .22,
              ),
            ),
          ),
        ),
        padding: const EdgeInsets.only(left: 8),
        child: switch (state) {
          KanbanSubtasksLoading() => const _SubtasksSkeletonRows(),
          KanbanSubtasksError(:final message) => _buildErrorRow(
            context,
            message,
          ),
          KanbanSubtasksReady() => _buildSubtasksList(context, state),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  Widget _buildErrorRow(BuildContext context, String message) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Symbols.error_outline_rounded, size: 16, color: colors.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              context.l10n.tasksSubtasksError,
              style: KanbanCardTokens.metaText(
                context,
              ).copyWith(color: colors.error),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Semantics(
            label: context.l10n.retry,
            button: true,
            child: IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Symbols.refresh_rounded, size: 16),
              onPressed: () => _cubit.loadInitial(),
              constraints: const BoxConstraints.tightFor(
                width: KanbanCardTokens.minTouchTarget,
                height: KanbanCardTokens.minTouchTarget,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtasksList(BuildContext context, KanbanSubtasksReady state) {
    final colors = context.colors;
    final children = state.subtasks;
    final hasChildren = children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!hasChildren && !_isAddingSubtask.value)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              context.l10n.tasksSubtasksEmpty,
              style: KanbanCardTokens.metaText(context),
            ),
          ),

        // Lista wierszy podzadań o czystej hierarchii
        for (final child in children) ...[
          () {
            final primaryAssigneeId =
                child.assignees.where((a) => a.isPrimary).firstOrNull?.userId ??
                child.assignees.firstOrNull?.userId;
            final profile = primaryAssigneeId == null
                ? null
                : widget.memberProfilesByUserId[primaryAssigneeId];

            return _SubtaskRow(
              key: ValueKey('subtask_row_${child.id}'),
              task: child,
              workspaceId: widget.workspaceId,
              projectId: widget.projectId,
              profile: profile,
              isSaving: state.pendingSubtaskIds.contains(child.id),
              onStatusChanged: (status, customStatusId) => _cubit.updateStatus(
                child.id,
                status,
                customStatusId: customStatusId,
              ),
            );
          }(),
        ],

        if (state.mutationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 4),
            child: Text(
              state.mutationError!,
              style: KanbanCardTokens.metaText(
                context,
              ).copyWith(color: colors.error),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

        // Paginacja
        if (state.isLoadingMore)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  context.l10n.tasksSubtasksLoading,
                  style: KanbanCardTokens.metaText(context),
                ),
              ],
            ),
          )
        else if (state.loadMoreError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state.loadMoreError!,
                    style: KanbanCardTokens.metaText(
                      context,
                    ).copyWith(color: colors.error),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () => _cubit.loadMore(),
                  child: Text(context.l10n.retry),
                ),
              ],
            ),
          )
        else if (state.hasMore) ...[
          () {
            final remaining = state.subtaskTotal - children.length;
            final nextBatchCount = math.min(5, math.max(1, remaining));

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: const ValueKey('subtasks_show_more_button'),
                  onTap: () => _cubit.loadMore(),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 3,
                    ),
                    child: Text(
                      context.l10n.tasksSubtasksShowMoreRemaining(
                        nextBatchCount,
                      ),
                      style: KanbanCardTokens.metaText(
                        context,
                        weight: FontWeight.w500,
                      ).copyWith(color: colors.primary),
                    ),
                  ),
                ),
              ),
            );
          }(),
        ],

        // Formularz dodawania podzadania lub dyskretna akcja tekstowa
        if (_isAddingSubtask.value)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TaskInlineInputField(
                  key: const ValueKey('subtask_inline_input'),
                  controller: _subtaskController,
                  dense: true,
                  isSubmitting: state.isSubmittingSubtask,
                  hintText: context.l10n.tasksAddSubtask,
                  keyboardHint: 'Enter ↵',
                  onCancel: () {
                    if (!state.isSubmittingSubtask) {
                      _isAddingSubtask.value = false;
                      _cubit.clearCreateError();
                    }
                  },
                  onSubmit: _submitNewSubtask,
                ),
                if (state.createError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    state.createError!,
                    style: KanbanCardTokens.metaText(
                      context,
                    ).copyWith(color: colors.error),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const ValueKey('subtasks_add_button'),
                onTap: () => _isAddingSubtask.value = true,
                borderRadius: BorderRadius.circular(6),
                hoverColor: colors.surfaceContainerHighest.withValues(
                  alpha: .5,
                ),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 32),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colors.outlineVariant.withValues(alpha: .4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.add_rounded,
                        size: 14,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          context.l10n.tasksAddSubtask,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: KanbanCardTokens.metaText(
                            context,
                            weight: FontWeight.w600,
                          ).copyWith(color: colors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
