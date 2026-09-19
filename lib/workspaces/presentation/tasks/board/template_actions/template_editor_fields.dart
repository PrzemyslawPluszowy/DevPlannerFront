part of '../tasks_board_page.dart';

class _TemplateStringItemsEditor extends StatefulWidget {
  const _TemplateStringItemsEditor({
    required this.title,
    required this.addLabel,
    required this.items,
    required this.enabled,
    required this.maxItemLength,
    required this.onChanged,
  });

  final String title;
  final String addLabel;
  final List<String> items;
  final bool enabled;
  final int maxItemLength;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_TemplateStringItemsEditor> createState() =>
      _TemplateStringItemsEditorState();
}

class _TemplateStringItemsEditorState
    extends State<_TemplateStringItemsEditor> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final value = _controller.text.trim();
    if (value.isEmpty || value.length > widget.maxItemLength) return;
    widget.onChanged([...widget.items, value]);
    _controller.clear();
  }

  Future<void> _edit(int index) async {
    final controller = TextEditingController(text: widget.items[index]);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => WorkspaceCreationModalWrapper(
        title: widget.title,
        icon: Symbols.edit_rounded,
        accentColor: context.colors.primary,
        submitLabel: context.l10n.save,
        cancelLabel: context.l10n.cancel,
        maxWidth: 440,
        onSubmit: () {
          final value = controller.text.trim();
          if (value.isNotEmpty && value.length <= widget.maxItemLength) {
            Navigator.of(dialogContext).pop(value);
          }
        },
        body: TextField(
          controller: controller,
          autofocus: true,
          maxLength: widget.maxItemLength,
          maxLines: 2,
          onSubmitted: (_) {
            final value = controller.text.trim();
            if (value.isNotEmpty && value.length <= widget.maxItemLength) {
              Navigator.of(dialogContext).pop(value);
            }
          },
        ),
      ),
    );
    controller.dispose();
    if (result == null || !mounted) return;
    final updated = List<String>.of(widget.items)..[index] = result;
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.title,
        style: context.text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 6),
      for (var index = 0; index < widget.items.length; index++)
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Material(
            color: context.colors.surfaceContainerLow.withValues(alpha: .65),
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            child: ListTile(
              dense: true,
              minTileHeight: 38,
              contentPadding: const EdgeInsets.only(left: 10, right: 2),
              leading: Icon(
                Symbols.drag_indicator_rounded,
                size: 17,
                color: context.colors.onSurfaceVariant,
              ),
              title: Text(widget.items[index], style: context.text.bodySmall),
              trailing: widget.enabled
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: context.l10n.edit,
                          visualDensity: VisualDensity.compact,
                          onPressed: () => unawaited(_edit(index)),
                          icon: const Icon(Symbols.edit_rounded, size: 16),
                        ),
                        IconButton(
                          tooltip: context.l10n.delete,
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            final updated = List<String>.of(widget.items)
                              ..removeAt(index);
                            widget.onChanged(updated);
                          },
                          icon: const Icon(Symbols.close_rounded, size: 16),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
      if (widget.enabled)
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLength: widget.maxItemLength,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: widget.addLabel,
                  counterText: '',
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: 6),
            IconButton.filledTonal(
              tooltip: widget.addLabel,
              onPressed: _add,
              icon: const Icon(Symbols.add_rounded, size: 18),
            ),
          ],
        ),
    ],
  );
}

/// Typowany edytor wartości pola projektu. Korzysta z tych samych reprezentacji
/// opcji i użytkowników co komórki listy zadań zamiast przyjmować surowy tekst.
class _TemplateCustomFieldEditor extends StatelessWidget {
  const _TemplateCustomFieldEditor({
    required this.field,
    required this.value,
    required this.members,
    required this.enabled,
    required this.onChanged,
  });

  final TaskCustomFieldResponse field;
  final Object? value;
  final List<ProjectMemberProfile> members;
  final bool enabled;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final currentValue = value;
    return switch (field.type) {
      TaskCustomFieldType.boolean => _TemplateDomainPickerField(
        label: field.name,
        value: value == null
            ? null
            : value == true
            ? context.l10n.yes
            : context.l10n.no,
        icon: value == true
            ? Symbols.check_circle_rounded
            : Symbols.cancel_rounded,
        color: value == true
            ? const Color(0xFF4CAF50)
            : const Color(0xFF757575),
        valueWidget: value == null
            ? null
            : _TemplateValueBadge(
                label: value == true ? context.l10n.yes : context.l10n.no,
                icon: value == true
                    ? Symbols.check_circle_rounded
                    : Symbols.cancel_rounded,
                color: value == true
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF757575),
              ),
        enabled: enabled,
        onTap: (anchorContext) async {
          final selected = await TaskCustomFieldPicker.pickBoolean(
            anchorContext,
            field: field,
            value: value,
            position: AppContextMenu.positionFor(anchorContext),
          );
          if (selected != customFieldCancelled) onChanged(selected);
        },
      ),
      TaskCustomFieldType.singleSelect => _TemplateDomainPickerField(
        label: field.name,
        value: currentValue == null
            ? null
            : CustomFieldOption.fromRaw(currentValue.toString()).label,
        icon: Symbols.label_rounded,
        valueWidget: currentValue == null
            ? null
            : _TemplateCustomOptionValue(raw: currentValue.toString()),
        enabled: enabled,
        onTap: (anchorContext) async {
          final selected = await TaskCustomFieldPicker.pickSingleSelect(
            anchorContext,
            field: field,
            value: value,
            position: AppContextMenu.positionFor(anchorContext),
          );
          if (selected != customFieldCancelled) onChanged(selected);
        },
      ),
      TaskCustomFieldType.multiSelect => _TemplateDomainPickerField(
        label: field.name,
        value: currentValue is List && currentValue.isNotEmpty
            ? currentValue
                  .map(
                    (item) => CustomFieldOption.fromRaw(item.toString()).label,
                  )
                  .join(', ')
            : null,
        icon: Symbols.sell_rounded,
        valueWidget: currentValue is List && currentValue.isNotEmpty
            ? _TemplateMultiOptionValue(values: currentValue)
            : null,
        enabled: enabled,
        onTap: (anchorContext) async {
          final selected = await TaskCustomFieldPicker.pickMultiSelect(
            anchorContext,
            field: field,
            value: value,
            position: AppContextMenu.positionFor(anchorContext),
          );
          if (selected != customFieldCancelled) onChanged(selected);
        },
      ),
      TaskCustomFieldType.date => _TemplateCustomDateField(
        field: field,
        value: value,
        enabled: enabled,
        onChanged: onChanged,
      ),
      TaskCustomFieldType.user => DropdownButtonFormField<String>(
        initialValue: members.any((member) => member.userId == currentValue)
            ? currentValue! as String
            : null,
        decoration: InputDecoration(labelText: field.name),
        items: [
          if (!field.isRequired)
            DropdownMenuItem(
              child: Text(context.l10n.taskDetailsNobody),
            ),
          for (final member in members)
            DropdownMenuItem(
              value: member.userId,
              child: Text(_TemplateEditorHelpers.memberLabel(context, member)),
            ),
        ],
        onChanged: enabled ? onChanged : null,
      ),
      TaskCustomFieldType.number || TaskCustomFieldType.text => TextFormField(
        initialValue: value?.toString() ?? '',
        enabled: enabled,
        keyboardType: field.type == TaskCustomFieldType.number
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(labelText: field.name),
        validator: (raw) {
          final normalized = raw?.trim() ?? '';
          if (field.isRequired && normalized.isEmpty) {
            return context.l10n.tasksTemplatesNameRequired;
          }
          if (field.type == TaskCustomFieldType.number &&
              normalized.isNotEmpty &&
              num.tryParse(normalized) == null) {
            return context.l10n.taskDetailsInvalidNumber;
          }
          return null;
        },
        onChanged: (raw) {
          final normalized = raw.trim();
          onChanged(
            normalized.isEmpty
                ? null
                : field.type == TaskCustomFieldType.number
                ? num.tryParse(normalized) ?? normalized
                : normalized,
          );
        },
      ),
    };
  }
}

class _TemplateCustomDateField extends StatelessWidget {
  const _TemplateCustomDateField({
    required this.field,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final TaskCustomFieldResponse field;
  final Object? value;
  final bool enabled;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final currentValue = value;
    final date = currentValue is DateTime
        ? currentValue
        : DateTime.tryParse(value?.toString() ?? '');
    return _TemplateDateField(
      label: field.name,
      value: date,
      enabled: enabled,
      onPick: (anchorContext) async {
        final box = anchorContext.findRenderObject() as RenderBox?;
        if (box == null) return;
        final picked = await TaskDatePicker.pick(
          anchorContext,
          initialValue: date,
          globalPosition: box.localToGlobal(Offset(0, box.size.height)),
        );
        if (picked != null) {
          onChanged(
            TaskDatePicker.asUtcCalendarDate(picked.value)?.toIso8601String(),
          );
        }
      },
      onClear: () => onChanged(null),
    );
  }
}
