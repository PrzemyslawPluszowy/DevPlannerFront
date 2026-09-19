part of 'task_details_page.dart';

class _CustomFieldEditor extends StatelessWidget {
  const _CustomFieldEditor({
    required this.field,
    required this.value,
    required this.enabled,
    required this.onChanged,
    required this.memberProfiles,
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
    TaskCustomFieldType.singleSelect => DropdownButtonFormField<String>(
      initialValue: field.options?.contains(value) == true
          ? value as String
          : null,
      decoration: InputDecoration(labelText: field.name),
      items: [
        for (final option in field.options ?? const <String>[])
          DropdownMenuItem(
            value: option,
            child: CustomFieldOptionChip(
              option: CustomFieldOption.fromRaw(option),
              compact: true,
            ),
          ),
      ],
      selectedItemBuilder: (context) => [
        for (final option in field.options ?? const <String>[])
          Align(
            alignment: Alignment.centerLeft,
            child: CustomFieldOptionChip(
              option: CustomFieldOption.fromRaw(option),
              compact: true,
            ),
          ),
      ],
      onChanged: enabled ? onChanged : null,
    ),
    TaskCustomFieldType.date => _DateCustomFieldEditor(
      field: field,
      value: value,
      enabled: enabled,
      onChanged: onChanged,
    ),
    TaskCustomFieldType.multiSelect => _MultiSelectCustomFieldEditor(
      field: field,
      value: value,
      enabled: enabled,
      onChanged: onChanged,
    ),
    TaskCustomFieldType.user => DropdownButtonFormField<String>(
      initialValue: memberProfiles.any((profile) => profile.userId == value)
          ? value as String
          : null,
      decoration: InputDecoration(labelText: field.name),
      items: [
        DropdownMenuItem(
          child: Text(context.l10n.taskDetailsNobody),
        ),
        for (final profile in memberProfiles)
          DropdownMenuItem(
            value: profile.userId,
            child: Text(
              profile.displayName?.trim().isNotEmpty == true
                  ? profile.displayName!.trim()
                  : context.l10n.taskDetailsProjectMember,
            ),
          ),
      ],
      onChanged: enabled && memberProfiles.isNotEmpty ? onChanged : null,
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

class _DateCustomFieldEditor extends StatelessWidget {
  const _DateCustomFieldEditor({
    required this.field,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final TaskCustomFieldDefinitionValueResponse field;
  final dynamic value;
  final bool enabled;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    final date = switch (value) {
      final String dateValue => DateTime.tryParse(dateValue),
      final DateTime dateValue => dateValue,
      _ => null,
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(field.name),
      subtitle: Text(
        date == null
            ? context.l10n.taskDetailsNoDate
            : DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag())
                  .format(date.toLocal()),
      ),
      trailing: IconButton(
        onPressed: !enabled
            ? null
            : () async {
                final picked = await DevPlannerModalPickerHost.showDate(
                  context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDate: date ?? DateTime.now(),
                );
                if (picked != null) onChanged(picked.toUtc().toIso8601String());
              },
        icon: const Icon(Symbols.calendar_today),
      ),
    );
  }
}

/// Czyste mapowanie wartości pól własnych na elementy prezentacji.
final class TaskCustomFieldPresentation {
  const TaskCustomFieldPresentation._();

  static IconData icon(TaskCustomFieldType type) => switch (type) {
    TaskCustomFieldType.text => Symbols.text_fields_rounded,
    TaskCustomFieldType.number => Symbols.numbers_rounded,
    TaskCustomFieldType.date => Symbols.event,
    TaskCustomFieldType.boolean => Symbols.toggle_on,
    TaskCustomFieldType.singleSelect ||
    TaskCustomFieldType.multiSelect => Symbols.list_alt_rounded,
    TaskCustomFieldType.user => Symbols.person_outline_rounded,
  };

  static String displayValue(dynamic value) => switch (value) {
    null => '—',
    final List<Object?> values when values.isEmpty => '—',
    final List<Object?> values =>
      values
          .map((item) => CustomFieldOption.fromRaw(item.toString()).label)
          .join(', '),
    true => 'Tak',
    false => 'Nie',
    _ => CustomFieldOption.fromRaw(value.toString()).label,
  };

  static List<TaskCustomFieldDefinitionValueResponse> sorted(
    List<TaskCustomFieldDefinitionValueResponse> fields,
  ) => [...fields]..sort((a, b) => a.position.compareTo(b.position));
}

class _MultiSelectCustomFieldEditor extends StatelessWidget {
  const _MultiSelectCustomFieldEditor({
    required this.field,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final TaskCustomFieldDefinitionValueResponse field;
  final dynamic value;
  final bool enabled;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedValues = (value is List ? value as List : const <dynamic>[])
        .map((e) => e.toString())
        .toSet();

    final allOptions = (field.options ?? const <String>[])
        .map(CustomFieldOption.fromRaw)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.name,
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
              for (final opt in allOptions.where(
                (o) =>
                    selectedValues.contains(o.raw) ||
                    selectedValues.contains(o.label),
              ))
                CustomFieldOptionChip(
                  option: opt,
                  onDelete: enabled
                      ? () {
                          final next = Set<String>.from(selectedValues)
                            ..remove(opt.raw)
                            ..remove(opt.label);
                          onChanged(next.toList(growable: false));
                        }
                      : null,
                ),
              if (enabled)
                Builder(
                  builder: (buttonContext) => Tooltip(
                    message: 'Wybierz wartości',
                    child: InkWell(
                      key: const ValueKey('custom_field_values_menu'),
                      onTap: () async {
                        final rawVal = await AppContextMenu.select<String>(
                          buttonContext,
                          globalPosition: AppContextMenu.positionFor(
                            buttonContext,
                          ),
                          headerTitle: 'Wybierz wartości',
                          options: [
                            for (final opt in allOptions)
                              AppContextMenuOption<String>(
                                value: opt.raw,
                                label: opt.label,
                                selected:
                                    selectedValues.contains(opt.raw) ||
                                    selectedValues.contains(opt.label),
                              ),
                          ],
                        );
                        if (rawVal == null) return;
                        final next = Set<String>.from(selectedValues);
                        final opt = allOptions.firstWhere(
                          (o) => o.raw == rawVal,
                        );
                        if (next.contains(opt.raw) ||
                            next.contains(opt.label)) {
                          next.remove(opt.raw);
                          next.remove(opt.label);
                        } else {
                          next.add(opt.raw);
                        }
                        onChanged(next.toList(growable: false));
                      },
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
                              'Wybierz',
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
