part of 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';

/// Menu widoczności kolumn osób w widoku „Według osoby”.
///
/// W tym widoku osoba opisuje kolumnę, więc użytkownik nie filtruje kart po
/// wykonawcy (filtr zostawia tylko część kart w kolumnie), a pokazuje albo
/// ukrywa całe kolumny. Wybór jest osobistą preferencją lokalną, zapisywaną przy
/// każdej zmianie, więc wraca po ponownym wejściu na tablicę.
class _KanbanAssigneeColumnsMenu extends StatelessWidget {
  const _KanbanAssigneeColumnsMenu({required this.state});

  final TasksBoardReady state;

  @override
  Widget build(BuildContext context) {
    final groups = state.assigneeBoard?.groups ?? const [];
    final hiddenCount = state.hiddenAssigneeUserIds.length;
    final isActive = hiddenCount > 0 || state.hideEmptyAssigneeColumns;

    return TasksCommandButton(
      key: const ValueKey('board_assignee_columns_menu'),
      icon: Symbols.view_column_rounded,
      label: context.l10n.tasksBoardAssigneeColumns,
      isActive: isActive,
      onTap: () => AppContextMenu.showCustom(
        context,
        globalPosition: AppContextMenu.positionFor(context),
        headerTitle: context.l10n.tasksBoardAssigneeColumns,
        maxWidth: 300,
        maxHeight: 380,
        contentBuilder: (context, dismiss) => _KanbanAssigneeColumnsPanel(
          initialHidden: state.hiddenAssigneeUserIds,
          initialHideEmpty: state.hideEmptyAssigneeColumns,
          entries: [
            for (final group in groups)
              (
                key: TasksBoardAssigneeCommands.keyOf(group),
                label: group.displayName,
                count: group.totalTaskCount,
              ),
          ],
          onToggle: (groupKey, visible) => unawaited(
            context.read<TasksBoardCubit>().setAssigneeColumnVisible(
              groupKey: groupKey,
              visible: visible,
            ),
          ),
          onHideEmptyChanged: (hideEmpty) => unawaited(
            context.read<TasksBoardCubit>().setHideEmptyAssigneeColumns(
              hideEmpty,
            ),
          ),
          onShowAll: () => unawaited(
            context.read<TasksBoardCubit>().showAllAssigneeColumns(),
          ),
          dismiss: dismiss,
        ),
      ),
    );
  }
}

/// Zawartość menu: checkboxy kolumn, ukrywanie pustych i powrót do pełnej listy.
///
/// Panel trzyma lokalny obraz wyboru, żeby kliknięcie odznaczało kolumnę od razu
/// — menu żyje w nakładce, więc nie przebuduje się samo po zmianie stanu Cubita.
class _KanbanAssigneeColumnsPanel extends StatefulWidget {
  const _KanbanAssigneeColumnsPanel({
    required this.initialHidden,
    required this.initialHideEmpty,
    required this.entries,
    required this.onToggle,
    required this.onHideEmptyChanged,
    required this.onShowAll,
    required this.dismiss,
  });

  final Set<String> initialHidden;
  final bool initialHideEmpty;
  final List<({String key, String label, int count})> entries;
  final void Function(String groupKey, bool visible) onToggle;
  final ValueChanged<bool> onHideEmptyChanged;
  final VoidCallback onShowAll;
  final VoidCallback dismiss;

  @override
  State<_KanbanAssigneeColumnsPanel> createState() =>
      _KanbanAssigneeColumnsPanelState();
}

class _KanbanAssigneeColumnsPanelState
    extends State<_KanbanAssigneeColumnsPanel> {
  late Set<String> _hidden = {...widget.initialHidden};
  late bool _hideEmpty = widget.initialHideEmpty;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final allHidden =
        widget.entries.isNotEmpty &&
        widget.entries.every((entry) => _hidden.contains(entry.key));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 4),
            children: [
              for (final entry in widget.entries)
                _KanbanAssigneeColumnsRow(
                  key: ValueKey('assignee_column_toggle_${entry.key}'),
                  label: entry.label,
                  count: entry.count,
                  isVisible: !_hidden.contains(entry.key),
                  onTap: () {
                    final visible = _hidden.contains(entry.key);
                    setState(() {
                      visible
                          ? _hidden.remove(entry.key)
                          : _hidden.add(entry.key);
                    });
                    widget.onToggle(entry.key, visible);
                  },
                ),
              const Divider(height: 1),
              _KanbanAssigneeColumnsRow(
                key: const ValueKey('assignee_column_hide_empty'),
                label: l10n.tasksBoardAssigneeColumnsHideEmpty,
                icon: Symbols.filter_alt_off_rounded,
                isChecked: _hideEmpty,
                onTap: () {
                  setState(() => _hideEmpty = !_hideEmpty);
                  widget.onHideEmptyChanged(_hideEmpty);
                },
              ),
            ],
          ),
        ),
        if (_hidden.isNotEmpty || _hideEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: TextButton(
              key: const ValueKey('assignee_column_show_all'),
              onPressed: () {
                setState(() {
                  _hidden = <String>{};
                  _hideEmpty = false;
                });
                widget.onShowAll();
              },
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                foregroundColor: colors.primary,
              ),
              child: Text(
                allHidden
                    ? l10n.tasksBoardAssigneeColumnsAllHidden
                    : l10n.tasksBoardAssigneeColumnsShowAll,
              ),
            ),
          ),
      ],
    );
  }
}

/// Wiersz menu: checkbox kolumny albo przełącznik ukrywania pustych.
class _KanbanAssigneeColumnsRow extends StatefulWidget {
  const _KanbanAssigneeColumnsRow({
    required this.label,
    required this.onTap,
    this.count,
    this.icon,
    this.isVisible,
    this.isChecked,
    super.key,
  });

  final String label;
  final int? count;
  final IconData? icon;
  final bool? isVisible;
  final bool? isChecked;
  final VoidCallback onTap;

  @override
  State<_KanbanAssigneeColumnsRow> createState() =>
      _KanbanAssigneeColumnsRowState();
}

class _KanbanAssigneeColumnsRowState extends State<_KanbanAssigneeColumnsRow> {
  final ValueNotifier<bool> _hovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final checked = widget.isVisible ?? widget.isChecked ?? false;
    return MouseRegion(
      onEnter: (_) => _hovered.value = true,
      onExit: (_) => _hovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: _hovered,
        builder: (context, hovered, _) => InkWell(
          onTap: widget.onTap,
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: hovered
                ? colors.surfaceContainerHighest.withValues(alpha: .45)
                : Colors.transparent,
            child: Row(
              children: [
                Icon(
                  widget.icon ??
                      (checked
                          ? Symbols.check_box_rounded
                          : Symbols.check_box_outline_blank_rounded),
                  size: 16,
                  color: checked ? colors.primary : colors.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelSmall?.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ),
                if (widget.count case final count?) ...[
                  const SizedBox(width: 8),
                  Text(
                    '$count',
                    style: context.text.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
