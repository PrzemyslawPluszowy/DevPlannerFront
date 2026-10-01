import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum TaskDetailsModalTab { work, conversation, files, planAndTime, history }

final class TaskDetailsModalTabs extends StatelessWidget {
  const TaskDetailsModalTabs({
    required this.selected,
    required this.onSelected,
    this.splitConversationSelected = false,
    this.splitConversationAvailable = false,
    this.onSplitConversationChanged,
    super.key,
  });

  final TaskDetailsModalTab selected;
  final ValueChanged<TaskDetailsModalTab> onSelected;
  final bool splitConversationSelected;
  final bool splitConversationAvailable;
  final VoidCallback? onSplitConversationChanged;

  @override
  Widget build(BuildContext context) {
    final items = <_TaskDetailsTabItem>[
      _TaskDetailsTabItem(
        tab: TaskDetailsModalTab.work,
        label: context.l10n.taskDetailsTabWork,
        icon: Symbols.task_alt,
      ),
      _TaskDetailsTabItem(
        tab: TaskDetailsModalTab.conversation,
        label: context.l10n.taskDetailsTabConversation,
        icon: Symbols.chat_bubble_outline_rounded,
      ),
      _TaskDetailsTabItem(
        tab: TaskDetailsModalTab.files,
        label: context.l10n.taskDetailsTabFiles,
        icon: Symbols.attach_file_rounded,
      ),
      _TaskDetailsTabItem(
        tab: TaskDetailsModalTab.planAndTime,
        label: context.l10n.taskDetailsTabPlanAndTime,
        icon: Symbols.calendar_month_rounded,
      ),
      _TaskDetailsTabItem(
        tab: TaskDetailsModalTab.history,
        label: context.l10n.taskDetailsTabHistory,
        icon: Symbols.history_rounded,
      ),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.tasksTheme.commandBarSurface,
        border: Border(
          bottom: BorderSide(color: context.tasksTheme.divider),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final item in items)
                    _TaskDetailsModalTabButton(
                      item: item,
                      selected: item.tab == selected,
                      onPressed: () => onSelected(item.tab),
                    ),
                ],
              ),
            ),
          ),
          if (splitConversationAvailable) ...[
            VerticalDivider(width: 1, color: context.tasksTheme.divider),
            _TaskDetailsConversationLayoutButton(
              selected: splitConversationSelected,
              onPressed: onSplitConversationChanged,
            ),
          ],
        ],
      ),
    );
  }
}

final class _TaskDetailsConversationLayoutButton extends StatelessWidget {
  const _TaskDetailsConversationLayoutButton({
    required this.selected,
    required this.onPressed,
  });

  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = selected
        ? context.l10n.taskDetailsTabbedLayoutShow
        : context.l10n.taskDetailsSplitLayoutShow;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Tooltip(
        message: label,
        child: IconButton(
          key: const ValueKey<String>('task-details-layout-toggle'),
          onPressed: onPressed,
          color: selected
              ? context.colors.primary
              : context.colors.onSurfaceVariant,
          icon: const Icon(Symbols.view_column_rounded),
        ),
      ),
    );
  }
}

final class _TaskDetailsTabItem {
  const _TaskDetailsTabItem({
    required this.tab,
    required this.label,
    required this.icon,
  });

  final TaskDetailsModalTab tab;
  final String label;
  final IconData icon;
}

final class _TaskDetailsModalTabButton extends StatelessWidget {
  const _TaskDetailsModalTabButton({
    required this.item,
    required this.selected,
    required this.onPressed,
  });

  final _TaskDetailsTabItem item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final foreground = selected
        ? context.colors.primary
        : context.colors.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(minHeight: 46),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? context.colors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 17, color: foreground),
              const SizedBox(width: 8),
              Text(
                item.label,
                style: tasks.controlText.copyWith(
                  color: foreground,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
