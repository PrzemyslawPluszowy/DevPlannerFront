part of 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_card_subtasks.dart';

class _OptionalTasksBoardListener extends StatelessWidget {
  const _OptionalTasksBoardListener({
    required this.listenWhen,
    required this.listener,
    required this.child,
  });

  final BlocListenerCondition<TasksBoardState> listenWhen;
  final BlocWidgetListener<TasksBoardState> listener;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasksBoardCubit?>();
    if (cubit == null) return child;
    return BlocListener<TasksBoardCubit, TasksBoardState>(
      bloc: cubit,
      listenWhen: listenWhen,
      listener: listener,
      child: child,
    );
  }
}

/// Trzy szkieletowe wiersze ładowania (28 px) o stałej osi tekstu.
class _SubtasksSkeletonRows extends StatelessWidget {
  const _SubtasksSkeletonRows();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final skeletonBg = colors.surfaceContainerHighest.withValues(alpha: .4);

    return Column(
      children: [
        for (final width in [130.0, 160.0, 100.0])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: skeletonBg,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: width,
                  height: 10,
                  decoration: BoxDecoration(
                    color: skeletonBg,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Wiersz podzadania: status 16 px → tytuł 12.5–13/18 → termin → awatar 20 px.
///
/// Posiada pełne tło hover o radius 6 px oraz focus ring (2 px).
class _SubtaskRow extends StatefulWidget {
  const _SubtaskRow({
    required this.task,
    required this.workspaceId,
    required this.projectId,
    this.profile,
    required this.isSaving,
    required this.onStatusChanged,
    super.key,
  });

  final ProjectTaskListItemResponse task;
  final String workspaceId;
  final String projectId;
  final ProjectMemberProfile? profile;
  final bool isSaving;
  final Future<bool> Function(ProjectTaskStatus, String?) onStatusChanged;

  @override
  State<_SubtaskRow> createState() => _SubtaskRowState();
}

class _SubtaskRowState extends State<_SubtaskRow> {
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);

  @override
  void dispose() {
    _isFocused.dispose();
    super.dispose();
  }

  void _showStatusPicker([Offset? globalPosition]) {
    if (widget.isSaving) return;
    final boardState = context.read<TasksBoardCubit>().state;
    if (boardState is! TasksBoardReady || boardState.board.columns.isEmpty) {
      return;
    }
    unawaited(
      _showColumnPicker(
        boardState.board.columns,
        globalPosition ?? AppContextMenu.positionFor(context),
      ),
    );
  }

  Future<void> _showColumnPicker(
    List<KanbanColumnResponse> columns,
    Offset globalPosition,
  ) async {
    final selected = await AppContextMenu.select<KanbanColumnResponse>(
      context,
      globalPosition: globalPosition,
      options: [
        for (final column in columns)
          AppContextMenuOption(
            value: column,
            label: column.displayName,
            icon: TaskStatusVisualHelper.icon(column.status),
            iconColor: TaskStatusVisualHelper.color(column.status),
            selected: column.customStatusId != null
                ? column.customStatusId == widget.task.customStatusId
                : widget.task.customStatusId == null &&
                      column.status == widget.task.status,
          ),
      ],
    );
    if (!mounted || selected == null) return;
    await widget.onStatusChanged(selected.status, selected.customStatusId);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDone = widget.task.status == ProjectTaskStatus.done;

    final rowContent = Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.f10, shift: true):
            _ShowSubtaskContextMenuIntent(),
        SingleActivator(LogicalKeyboardKey.contextMenu):
            _ShowSubtaskContextMenuIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _ShowSubtaskContextMenuIntent:
              CallbackAction<_ShowSubtaskContextMenuIntent>(
                onInvoke: (_) {
                  _showStatusPicker();
                  return null;
                },
              ),
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final router = GoRouter.maybeOf(context);
              if (router == null) return;
              unawaited(
                DevPlannerNavigation(router).go(
                  '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/tasks/${widget.task.id}',
                ),
              );
            },
            onFocusChange: (focused) => _isFocused.value = focused,
            onSecondaryTapUp: widget.isSaving
                ? null
                : (details) => _showStatusPicker(details.globalPosition),
            borderRadius: BorderRadius.circular(6),
            hoverColor: colors.surfaceContainerHighest.withValues(alpha: .5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              child: Row(
                children: [
                  // 1. Ikona statusu / checkbox (16 px)
                  Icon(
                    TaskStatusVisualHelper.icon(widget.task.status),
                    size: 16,
                    color: TaskStatusVisualHelper.color(widget.task.status),
                  ),
                  const SizedBox(width: 6),

                  if (widget.isSaving)
                    const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    )
                  else
                    Semantics(
                      label: context.l10n.tasksContextMenuStatus,
                      button: true,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints.tightFor(
                          width: 24,
                          height: 24,
                        ),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Symbols.more_horiz_rounded, size: 16),
                        onPressed: _showStatusPicker,
                      ),
                    ),

                  // 2. Tytuł podzadania
                  Expanded(
                    child: Text(
                      widget.task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: KanbanCardTokens.subtaskTitle(
                        context,
                        isDone: isDone,
                      ),
                    ),
                  ),

                  // 3. Opcjonalny termin podzadania (jeśli występuje)
                  if (widget.task.dueAtUtc case final dueAt?) ...[
                    const SizedBox(width: 6),
                    Text(
                      _formatSubtaskDueDate(dueAt),
                      style: KanbanCardTokens.metaText(
                        context,
                        weight: FontWeight.w500,
                      ).copyWith(fontSize: 11),
                    ),
                  ],

                  // 4. Awatar wykonawcy (20 px) z inicjałem 10 px
                  if (widget.profile case final profile?) ...[
                    const SizedBox(width: 6),
                    _ChildAssigneeAvatar(
                      profile: profile,
                      userId: widget.task.assignees.firstOrNull?.userId ?? '',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return ValueListenableBuilder<bool>(
      valueListenable: _isFocused,
      builder: (context, isFocused, _) {
        if (!isFocused) return rowContent;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colors.primary, width: 2.0),
          ),
          child: rowContent,
        );
      },
    );
  }

  String _formatSubtaskDueDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
  }
}

class _ShowSubtaskContextMenuIntent extends Intent {
  const _ShowSubtaskContextMenuIntent();
}

/// Dedykowany awatar dziecka o średnicy 20 px (radius 10 px) z inicjałem 10 px.
class _ChildAssigneeAvatar extends StatelessWidget {
  const _ChildAssigneeAvatar({
    required this.profile,
    required this.userId,
  });

  final ProjectMemberProfile profile;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final displayName = profile.displayName?.trim();
    final label = displayName?.isNotEmpty == true
        ? displayName!
        : context.l10n.tasksPresenceAnonymousUser;
    final avatarUrl = profile.avatarUrl?.trim();

    return Semantics(
      label: label,
      child: CircleAvatar(
        radius: KanbanCardTokens.childAvatarRadius,
        foregroundImage: avatarUrl?.isNotEmpty == true
            ? NetworkImage(avatarUrl!)
            : null,
        backgroundColor: KanbanSubtaskAvatarColors.colorFor(userId),
        child: avatarUrl?.isNotEmpty == true
            ? null
            : Text(
                label.characters.first.toUpperCase(),
                style: KanbanCardTokens.childAvatarInitials(context),
              ),
      ),
    );
  }
}

/// Kolory awatarów podzadań są lokalne dla prezentacji karty Kanbana.
final class KanbanSubtaskAvatarColors {
  const KanbanSubtaskAvatarColors._();

  static Color colorFor(String userId) {
    const palette = <Color>[
      Color(0xFF6C5CE7),
      Color(0xFF0984E3),
      Color(0xFF00A884),
      Color(0xFFE17055),
    ];
    return palette[userId.hashCode.abs() % palette.length];
  }
}
