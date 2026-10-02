import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
export 'package:devplanner/workspaces/presentation/tasks/detail/task_details_property_row.dart';

final class TaskDetailsSelectOption<T> {
  const TaskDetailsSelectOption({
    required this.value,
    required this.label,
    this.leading,
    this.icon,
  });

  final T value;
  final String label;
  final Widget? leading;
  final IconData? icon;
}

final class TaskDetailsSelectField<T> extends StatefulWidget {
  const TaskDetailsSelectField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.enabled = true,
    this.selectionScope,
    super.key,
  });

  final String label;
  final T? value;
  final List<TaskDetailsSelectOption<T>> options;
  final ValueChanged<T> onChanged;
  final bool enabled;
  final Object? selectionScope;

  @override
  State<TaskDetailsSelectField<T>> createState() =>
      TaskDetailsSelectFieldState<T>();
}

final class TaskDetailsSelectFieldState<T>
    extends State<TaskDetailsSelectField<T>> {
  bool _focused = false;

  Future<void> _open() async {
    if (!widget.enabled) return;
    final sourceValue = widget.value;
    final sourceScope = widget.selectionScope;
    final selected = await AppContextMenu.select<T>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      headerTitle: widget.label,
      options: [
        for (final option in widget.options)
          AppContextMenuOption<T>(
            value: option.value,
            label: option.label,
            icon: option.icon,
            leading: option.leading,
            selected: option.value == widget.value,
          ),
      ],
    );
    if (!mounted ||
        selected == null ||
        !widget.enabled ||
        widget.value != sourceValue ||
        widget.selectionScope != sourceScope ||
        !widget.options.any((option) => option.value == selected)) {
      return;
    }
    widget.onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final selectedOption = widget.options
        .where((option) => option.value == widget.value)
        .firstOrNull;
    return Focus(
      canRequestFocus: false,
      onFocusChange: (focused) {
        if (_focused != focused) setState(() => _focused = focused);
      },
      child: InkWell(
        onTap: widget.enabled ? _open : null,
        borderRadius: BorderRadius.circular(tasks.controlRadius),
        child: InputDecorator(
          isFocused: _focused,
          isEmpty: selectedOption == null,
          decoration: InputDecoration(
            labelText: widget.label,
            enabled: widget.enabled,
            suffixIcon: Icon(
              Symbols.expand_more_rounded,
              size: 19,
              color: widget.enabled
                  ? colors.onSurfaceVariant
                  : colors.onSurfaceVariant.withValues(alpha: .5),
            ),
          ),
          child: Row(
            children: [
              if (selectedOption?.leading case final leading?) ...[
                leading,
                const SizedBox(width: 8),
              ] else if (selectedOption?.icon case final icon?) ...[
                Icon(icon, size: 16, color: colors.onSurfaceVariant),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  selectedOption?.label ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tasks.dataText.copyWith(
                    color: widget.enabled
                        ? colors.onSurface
                        : colors.onSurfaceVariant,
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

class DateField extends StatefulWidget {
  const DateField({
    required this.label,
    required this.value,
    required this.format,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final String label;
  final DateTime? value;
  final DateFormat format;
  final bool enabled;
  final ValueChanged<DateTime?> onChanged;

  @override
  State<DateField> createState() => _DateFieldState();
}

final class _DateFieldState extends State<DateField> {
  @override
  Widget build(BuildContext context) => InputDecorator(
    decoration: InputDecoration(labelText: widget.label),
    child: Row(
      children: [
        Expanded(
          child: Text(
            widget.value == null
                ? context.l10n.taskDetailsNoDate
                : widget.format.format(widget.value!.toLocal()),
          ),
        ),
        if (widget.value != null)
          IconButton(
            tooltip: context.l10n.taskDetailsClearDate,
            onPressed: widget.enabled ? () => widget.onChanged(null) : null,
            icon: const Icon(Symbols.clear_rounded, size: 18),
          ),
        Builder(
          builder: (buttonContext) => IconButton(
            tooltip: widget.label,
            onPressed: widget.enabled ? () => _pick(buttonContext) : null,
            icon: const Icon(Symbols.calendar_month, size: 19),
          ),
        ),
      ],
    ),
  );

  Future<void> _pick(BuildContext context) async {
    final sourceCubit = context.read<TaskDetailsCubit>();
    final sourceValue = widget.value;
    final localValue = sourceValue?.toLocal();
    final selected = await TaskDatePicker.pick(
      context,
      initialValue: localValue,
      globalPosition: AppContextMenu.positionFor(context),
      allowClear: false,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (!mounted ||
        !context.mounted ||
        selected == null ||
        selected.value == null ||
        sourceCubit.isClosed ||
        !identical(context.read<TaskDetailsCubit>(), sourceCubit) ||
        widget.value != sourceValue ||
        !widget.enabled) {
      return;
    }
    widget.onChanged(
      TaskDatePicker.asUtcTaskInstant(selected.value, sourceValue),
    );
  }
}

class Section extends StatelessWidget {
  const Section({
    required this.title,
    required this.child,
    this.action,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.tasksTheme.dataStrongText.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ?action,
        ],
      ),
      const SizedBox(height: 8),
      child,
    ],
  );
}

class Pill extends StatelessWidget {
  const Pill({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: context.colors.surface.withValues(alpha: .8),
      borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
      border: Border.all(color: context.colors.outlineVariant),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14),
        const SizedBox(width: 5),
        Text(label, style: context.tasksTheme.controlText),
      ],
    ),
  );
}

class TaskDetailsModalLoadingView extends StatelessWidget {
  const TaskDetailsModalLoadingView({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: SizedBox.square(
      dimension: 28,
      child: CircularProgressIndicator(strokeWidth: 2.5),
    ),
  );
}

class TaskDetailsFailureView extends StatelessWidget {
  const TaskDetailsFailureView({required this.failure, super.key});

  final TaskDetailsFailure failure;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.error_outline_rounded,
            size: 42,
            color: context.colors.error,
          ),
          const SizedBox(height: 14),
          Text(failure.message, textAlign: TextAlign.center),
          if (failure.error case final error?) ...[
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: TaskDetailsModalError(error: error),
            ),
          ],
          const SizedBox(height: 18),
          FilledButton.tonalIcon(
            onPressed: () => unawaited(context.read<TaskDetailsCubit>().load()),
            icon: const Icon(Symbols.refresh_rounded),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    ),
  );
}

/// Lokalizowane etykiety statusu i priorytetu szczegółów zadania.
final class TaskDetailsLabeler {
  const TaskDetailsLabeler._();

  static String status(BuildContext context, ProjectTaskStatus value) =>
      switch (value) {
        ProjectTaskStatus.backlog => context.l10n.taskStatusBacklog,
        ProjectTaskStatus.todo => context.l10n.taskStatusTodo,
        ProjectTaskStatus.inProgress => context.l10n.taskStatusInProgress,
        ProjectTaskStatus.blocked => context.l10n.taskStatusBlocked,
        ProjectTaskStatus.done => context.l10n.taskStatusDone,
        ProjectTaskStatus.cancelled => context.l10n.taskStatusCanceled,
      };

  static String priority(BuildContext context, TaskPriority value) =>
      switch (value) {
        TaskPriority.low => context.l10n.tasksPriorityLow,
        TaskPriority.normal => context.l10n.tasksPriorityNormal,
        TaskPriority.high => context.l10n.tasksPriorityHigh,
        TaskPriority.critical => context.l10n.tasksPriorityCritical,
      };
}
