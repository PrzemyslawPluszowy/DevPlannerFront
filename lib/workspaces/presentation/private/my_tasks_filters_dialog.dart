import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/private/my_tasks_filters.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Dialog filtrów zadań, wydzielony z routingu dla małego rozmiaru widżetów.
class MyTasksFiltersDialog extends StatefulWidget {
  const MyTasksFiltersDialog({required this.initial, super.key});

  final MyTasksFilters initial;

  @override
  State<MyTasksFiltersDialog> createState() => _MyTasksFiltersDialogState();
}

class _MyTasksFiltersDialogState extends State<MyTasksFiltersDialog> {
  late final ValueNotifier<MyTasksFilters> _filters;
  final ValueNotifier<String?> _error = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _filters = ValueNotifier(widget.initial);
  }

  @override
  void dispose() {
    _filters.dispose();
    _error.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return WorkspaceCreationModalWrapper(
      title: l10n.myTasksFiltersTitle,
      subtitle: l10n.myTasksFiltersSubtitle,
      icon: Symbols.filter_alt_rounded,
      submitLabel: l10n.myTasksApply,
      cancelLabel: l10n.cancel,
      maxWidth: 420,
      onSubmit: _apply,
      body: ValueListenableBuilder(
        valueListenable: _filters,
        builder: (context, filters, _) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.myTasksStatus,
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ProjectTaskStatus?>(
                  value: filters.status,
                  isExpanded: true,
                  dropdownColor: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  elevation: 3,
                  menuMaxHeight: 260,
                  style: context.text.bodySmall?.copyWith(fontSize: 13),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                  items: [
                    DropdownMenuItem(
                      child: Text(
                        l10n.myTasksAll,
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                    for (final status in ProjectTaskStatus.values)
                      DropdownMenuItem(
                        value: status,
                        child: Text(
                          MyTasksFilters.statusLabel(l10n, status),
                          style: const TextStyle(fontSize: 12.5),
                        ),
                      ),
                  ],
                  onChanged: (value) => _filters.value = filters.copyWith(
                    status: value,
                    clearStatus: value == null,
                  ),
                ),
              ),
            ),
            Gaps.h12,
            Text(
              l10n.myTasksPriority,
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<TaskPriority?>(
                  value: filters.priority,
                  isExpanded: true,
                  dropdownColor: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  elevation: 3,
                  menuMaxHeight: 260,
                  style: context.text.bodySmall?.copyWith(fontSize: 13),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                  items: [
                    DropdownMenuItem(
                      child: Text(
                        l10n.myTasksAll,
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                    for (final priority in TaskPriority.values)
                      DropdownMenuItem(
                        value: priority,
                        child: Text(
                          MyTasksFilters.priorityLabel(l10n, priority),
                          style: const TextStyle(fontSize: 12.5),
                        ),
                      ),
                  ],
                  onChanged: (value) => _filters.value = filters.copyWith(
                    priority: value,
                    clearPriority: value == null,
                  ),
                ),
              ),
            ),
            Gaps.h12,
            Text(
              l10n.myTasksInvolvement,
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<TaskInvolvementFilter?>(
                  value: filters.involvement,
                  isExpanded: true,
                  dropdownColor: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  elevation: 3,
                  menuMaxHeight: 260,
                  style: context.text.bodySmall?.copyWith(fontSize: 13),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                  items: [
                    DropdownMenuItem(
                      child: Text(
                        l10n.myTasksAny,
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                    for (final involvement in TaskInvolvementFilter.values)
                      DropdownMenuItem(
                        value: involvement,
                        child: Text(
                          MyTasksFilters.involvementLabel(l10n, involvement),
                          style: const TextStyle(fontSize: 12.5),
                        ),
                      ),
                  ],
                  onChanged: (value) => _filters.value = filters.copyWith(
                    involvement: value,
                    clearInvolvement: value == null,
                  ),
                ),
              ),
            ),
            Gaps.h12,
            _DateFilterField(
              label: l10n.myTasksDueFrom,
              value: filters.dueFromUtc,
              onChanged: (value) => _filters.value = filters.copyWith(
                dueFromUtc: value,
                clearDueFromUtc: value == null,
              ),
            ),
            Gaps.h8,
            _DateFilterField(
              label: l10n.myTasksDueTo,
              value: filters.dueToUtc,
              onChanged: (value) => _filters.value = filters.copyWith(
                dueToUtc: value,
                clearDueToUtc: value == null,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _error,
              builder: (context, error, _) => error == null
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Gaps.h8,
                        Text(
                          error,
                          style: TextStyle(color: colors.error, fontSize: 12),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _apply() {
    final filters = _filters.value;
    if (filters.dueFromUtc != null &&
        filters.dueToUtc != null &&
        filters.dueToUtc!.isBefore(filters.dueFromUtc!)) {
      _error.value = context.l10n.myTasksInvalidDueRange;
      return;
    }
    Navigator.of(context).pop(filters);
  }
}

class _DateFilterField extends StatelessWidget {
  const _DateFilterField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.text.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: colors.onSurfaceVariant,
          ),
        ),
        Gaps.h4,
        InkWell(
          onTap: () async {
            final date = await DevPlannerModalPickerHost.showDate(
              context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: value ?? DateTime.now(),
            );
            if (date != null) onChanged(date);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Symbols.calendar_today_rounded,
                  size: 15,
                  color: colors.onSurfaceVariant,
                ),
                Gaps.w8,
                Expanded(
                  child: Text(
                    value == null
                        ? context.l10n.myTasksAnyDueDate
                        : MaterialLocalizations.of(context)
                              .formatMediumDate(value!),
                    style: TextStyle(
                      fontSize: 12.5,
                      color: value == null
                          ? colors.onSurfaceVariant.withValues(alpha: .7)
                          : colors.onSurface,
                    ),
                  ),
                ),
                if (value != null)
                  IconButton(
                    tooltip: context.l10n.myTasksClear,
                    onPressed: () => onChanged(null),
                    icon: const Icon(Symbols.close_rounded, size: 14),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
