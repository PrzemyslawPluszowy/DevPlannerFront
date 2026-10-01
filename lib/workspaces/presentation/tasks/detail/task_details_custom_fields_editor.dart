import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';

class CustomFieldEditor extends StatelessWidget {
  const CustomFieldEditor({
    required this.field,
    required this.value,
    required this.enabled,
    required this.onChanged,
    required this.memberProfiles,
    super.key,
  });

  final TaskCustomFieldDefinitionValueResponse field;
  final dynamic value;
  final bool enabled;
  final ValueChanged<dynamic> onChanged;
  final List<ProjectMemberProfile> memberProfiles;

  @override
  Widget build(BuildContext context) => switch (field.type) {
    TaskCustomFieldType.boolean => SwitchListTile(
      value: value == true,
      onChanged: enabled ? onChanged : null,
      title: Text(field.name),
    ),
    TaskCustomFieldType.singleSelect => TaskDetailsSelectField<String>(
      label: field.name,
      value: value is String ? value as String : null,
      enabled: enabled,
      options: [
        for (final option in field.options ?? const <String>[])
          TaskDetailsSelectOption(
            value: option,
            label: CustomFieldOption.fromRaw(option).label,
            leading: CustomFieldOptionChip(
              option: CustomFieldOption.fromRaw(option),
              compact: true,
            ),
          ),
      ],
      onChanged: onChanged,
    ),
    TaskCustomFieldType.date => DateCustomFieldEditor(
      field: field,
      value: value,
      enabled: enabled,
      onChanged: onChanged,
    ),
    TaskCustomFieldType.multiSelect => MultiSelectCustomFieldEditor(
      field: field,
      value: value,
      enabled: enabled,
      onChanged: onChanged,
    ),
    TaskCustomFieldType.user => TaskDetailsSelectField<String>(
      label: field.name,
      value: value is String ? value as String : '',
      enabled: enabled && memberProfiles.isNotEmpty,
      options: [
        TaskDetailsSelectOption(
          value: '',
          label: context.l10n.taskDetailsNobody,
        ),
        for (final profile in memberProfiles)
          TaskDetailsSelectOption(
            value: profile.userId,
            label: profile.displayName?.trim().isNotEmpty == true
                ? profile.displayName!.trim()
                : context.l10n.taskDetailsProjectMember,
          ),
      ],
      onChanged: (selected) => onChanged(selected.isEmpty ? null : selected),
    ),
    _ => TextFormField(
      initialValue: value?.toString() ?? '',
      enabled: enabled,
      keyboardType: field.type == TaskCustomFieldType.number
          ? TextInputType.number
          : TextInputType.text,
      decoration: InputDecoration(labelText: field.name),
      onChanged: (text) {
        if (field.type != TaskCustomFieldType.number) return onChanged(text);
        final normalized = text.trim();
        onChanged(
          normalized.isEmpty ? null : num.tryParse(normalized) ?? normalized,
        );
      },
    ),
  };
}

class DateCustomFieldEditor extends StatefulWidget {
  const DateCustomFieldEditor({
    required this.field,
    required this.value,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final TaskCustomFieldDefinitionValueResponse field;
  final dynamic value;
  final bool enabled;
  final ValueChanged<dynamic> onChanged;

  @override
  State<DateCustomFieldEditor> createState() => _DateCustomFieldEditorState();
}

final class _DateCustomFieldEditorState extends State<DateCustomFieldEditor> {
  Future<void> _selectDate(
    BuildContext buttonContext,
    DateTime? current,
  ) async {
    final sourceCubit = buttonContext.read<TaskDetailsCubit>();
    final fieldId = widget.field.id;
    final originalValue = widget.value;
    final picked = await TaskDatePicker.pick(
      buttonContext,
      initialValue: current,
      globalPosition: AppContextMenu.positionFor(buttonContext),
      allowClear: false,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (!mounted ||
        !buttonContext.mounted ||
        picked == null ||
        picked.value == null) {
      return;
    }
    if (!widget.enabled ||
        !identical(buttonContext.read<TaskDetailsCubit>(), sourceCubit) ||
        widget.field.id != fieldId ||
        widget.value != originalValue) {
      return;
    }
    widget.onChanged(
      TaskDatePicker.asUtcCalendarDate(picked.value)!.toIso8601String(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = switch (widget.value) {
      final String dateValue => DateTime.tryParse(dateValue),
      final DateTime dateValue => dateValue,
      _ => null,
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(widget.field.name),
      subtitle: Text(
        date == null
            ? context.l10n.taskDetailsNoDate
            : DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag())
                  .format(date.toLocal()),
      ),
      trailing: Builder(
        builder: (buttonContext) => IconButton(
          onPressed: !widget.enabled
              ? null
              : () => _selectDate(buttonContext, date),
          icon: const Icon(Symbols.calendar_today),
        ),
      ),
    );
  }
}

class MultiSelectCustomFieldEditor extends StatefulWidget {
  const MultiSelectCustomFieldEditor({
    required this.field,
    required this.value,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final TaskCustomFieldDefinitionValueResponse field;
  final dynamic value;
  final bool enabled;
  final ValueChanged<dynamic> onChanged;

  @override
  State<MultiSelectCustomFieldEditor> createState() =>
      _MultiSelectCustomFieldEditorState();
}

final class _MultiSelectCustomFieldEditorState
    extends State<MultiSelectCustomFieldEditor> {
  late List<CustomFieldOption> _allOptions;
  late Set<String> _selectedValues;
  late List<CustomFieldOption> _visibleOptions;

  @override
  void initState() {
    super.initState();
    _prepareViewModel();
  }

  @override
  void didUpdateWidget(MultiSelectCustomFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.field != widget.field ||
        !_sameValues(
          _selectedFor(oldWidget.value),
          _selectedFor(widget.value),
        )) {
      _prepareViewModel();
    }
  }

  void _prepareViewModel() {
    _allOptions = List.unmodifiable(
      (widget.field.options ?? const <String>[]).map(CustomFieldOption.fromRaw),
    );
    _selectedValues = Set.unmodifiable(_selectedFor(widget.value));
    _visibleOptions = List.unmodifiable(
      _allOptions.where(
        (option) =>
            _selectedValues.contains(option.raw) ||
            _selectedValues.contains(option.label),
      ),
    );
  }

  Set<String> _selectedFor(dynamic value) =>
      (value is List ? value : const <dynamic>[])
          .map((item) => item.toString())
          .toSet();

  bool _sameValues(Set<String> left, Set<String> right) =>
      left.length == right.length && left.containsAll(right);

  Future<void> _openOptions(
    BuildContext buttonContext,
    Set<String> selectedSnapshot,
    List<CustomFieldOption> optionsSnapshot,
  ) async {
    final sourceCubit = buttonContext.read<TaskDetailsCubit>();
    final fieldId = widget.field.id;
    final optionValues = optionsSnapshot.map((option) => option.raw).toList();
    final rawValue = await AppContextMenu.select<String>(
      buttonContext,
      globalPosition: AppContextMenu.positionFor(buttonContext),
      headerTitle: buttonContext.l10n.taskDetailsCustomFieldSelectValues,
      options: [
        for (final option in optionsSnapshot)
          AppContextMenuOption<String>(
            value: option.raw,
            label: option.label,
            selected:
                selectedSnapshot.contains(option.raw) ||
                selectedSnapshot.contains(option.label),
          ),
      ],
    );
    if (!mounted || !buttonContext.mounted || rawValue == null) return;
    final currentSelection = _selectedFor(widget.value);
    final currentOptions = widget.field.options ?? const <String>[];
    if (!widget.enabled ||
        !identical(buttonContext.read<TaskDetailsCubit>(), sourceCubit) ||
        widget.field.id != fieldId ||
        !_sameValues(currentSelection, selectedSnapshot) ||
        currentOptions.length != optionValues.length ||
        !currentOptions.every(optionValues.contains)) {
      return;
    }
    final next = Set<String>.of(currentSelection);
    final option = optionsSnapshot.firstWhere((item) => item.raw == rawValue);
    if (next.contains(option.raw) || next.contains(option.label)) {
      next.remove(option.raw);
      next.remove(option.label);
    } else {
      next.add(option.raw);
    }
    widget.onChanged(next.toList(growable: false));
  }

  void _removeOption(CustomFieldOption option) {
    if (!widget.enabled) return;
    final next = Set<String>.of(_selectedValues)
      ..remove(option.raw)
      ..remove(option.label);
    widget.onChanged(next.toList(growable: false));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.name,
          style: context.text.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final opt in _visibleOptions)
                CustomFieldOptionChip(
                  option: opt,
                  onDelete: widget.enabled ? () => _removeOption(opt) : null,
                ),
              if (widget.enabled)
                Builder(
                  builder: (buttonContext) => Tooltip(
                    message: context.l10n.taskDetailsCustomFieldSelectValues,
                    child: InkWell(
                      key: const ValueKey('custom_field_values_menu'),
                      onTap: () => _openOptions(
                        buttonContext,
                        Set.unmodifiable(_selectedValues),
                        _allOptions,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.3),
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
                            const SizedBox(width: 4),
                            Text(
                              context.l10n.taskDetailsCustomFieldAddValue,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
