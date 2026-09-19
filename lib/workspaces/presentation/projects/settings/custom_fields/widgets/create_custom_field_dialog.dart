import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_type_visual.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/project_custom_field_options_editor.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Modal tworzenia albo edycji definicji pola niestandardowego w projekcie.
class CreateCustomFieldDialog extends StatefulWidget {
  const CreateCustomFieldDialog({this.initialField, super.key});

  final TaskCustomFieldResponse? initialField;

  @override
  State<CreateCustomFieldDialog> createState() =>
      _CreateCustomFieldDialogState();
}

class _CreateCustomFieldDialogState extends State<CreateCustomFieldDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _newOptionController;
  late final ValueNotifier<CustomFieldDraft> _draft;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialField?.name ?? '',
    );
    _newOptionController = TextEditingController();
    _draft = ValueNotifier(
      CustomFieldDraft(
        options: (widget.initialField?.options ?? const <String>[])
            .map(CustomFieldOption.fromRaw)
            .toList(),
        selectedType: widget.initialField?.type ?? TaskCustomFieldType.text,
        isRequired: widget.initialField?.isRequired ?? false,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _newOptionController.dispose();
    _draft.dispose();
    super.dispose();
  }

  void _addOptionsFromInput() {
    final input = _newOptionController.text.trim();
    if (input.isEmpty) return;
    final draft = _draft.value;
    final options = List<CustomFieldOption>.of(draft.options);
    for (final label
        in input.split(RegExp(r'[,;\n]')).map((item) => item.trim())) {
      if (label.isNotEmpty &&
          !options.any(
            (item) => item.label.toLowerCase() == label.toLowerCase(),
          )) {
        options.add(
          CustomFieldOption.create(
            label: label,
            colorHex: draft.selectedColorHex,
            iconName: draft.selectedIconName,
          ),
        );
      }
    }
    _newOptionController.clear();
    _draft.value = draft.copyWith(options: options);
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    _addOptionsFromInput();
    final draft = _draft.value;
    Navigator.of(context).pop((
      name: name,
      type: draft.selectedType,
      isRequired: draft.isRequired,
      options: draft.needsOptions
          ? draft.options.map((option) => option.raw).toList()
          : <String>[],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final editing = widget.initialField != null;
    return ValueListenableBuilder<CustomFieldDraft>(
      valueListenable: _draft,
      builder: (context, draft, _) => WorkspaceCreationModalWrapper(
        maxWidth: 540,
        title: editing
            ? 'Edytuj pole niestandardowe'
            : l10n.projectSettingsAddCustomField,
        subtitle: 'Skonfiguruj nazwę, typ danych oraz opcje dodatkowego pola zadania.',
        icon: Symbols.tune_rounded,
        submitLabel: l10n.tasksListSaveButton,
        cancelLabel: l10n.tasksListCancelButton,
        onSubmit: _submit,
        body: _CustomFieldForm(
          draft: draft,
          isEditing: editing,
          nameController: _nameController,
          newOptionController: _newOptionController,
          onDraftChanged: (value) => _draft.value = value,
          onAddOption: _addOptionsFromInput,
        ),
      ),
    );
  }
}

class _CustomFieldForm extends StatelessWidget {
  const _CustomFieldForm({
    required this.draft,
    required this.isEditing,
    required this.nameController,
    required this.newOptionController,
    required this.onDraftChanged,
    required this.onAddOption,
  });

  final CustomFieldDraft draft;
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController newOptionController;
  final ValueChanged<CustomFieldDraft> onDraftChanged;
  final VoidCallback onAddOption;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        _FormLabel(text: l10n.projectSettingsCustomFieldName),
        Gaps.h6,
        TextField(
          controller: nameController,
          autofocus: true,
          decoration: _CustomFieldFormDecoration.name(context),
        ),
        Gaps.h16,
        _FormLabel(text: l10n.projectSettingsCustomFieldType),
        Gaps.h6,
        Container(
          padding: const .symmetric(horizontal: 10, vertical: Sizes.p2),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: .circular(Sizes.p8),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: .7),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<TaskCustomFieldType>(
              value: draft.selectedType,
              isExpanded: true,
              dropdownColor: colors.surfaceContainerLowest,
              items: [
                for (final type in TaskCustomFieldType.values)
                  DropdownMenuItem(
                    value: type,
                    child: _FieldTypeMenuItem(type: type),
                  ),
              ],
              onChanged: isEditing
                  ? null
                  : (type) {
                      if (type != null) {
                        onDraftChanged(draft.copyWith(selectedType: type));
                      }
                    },
            ),
          ),
        ),
        ProjectCustomFieldOptionsEditor(
          draft: draft,
          newOptionController: newOptionController,
          onDraftChanged: onDraftChanged,
          onAddOption: onAddOption,
        ),
        Gaps.h12,
        InkWell(
          onTap: () =>
              onDraftChanged(draft.copyWith(isRequired: !draft.isRequired)),
          borderRadius: .circular(Sizes.p6),
          child: Row(
            children: [
              Checkbox(
                value: draft.isRequired,
                onChanged: (value) =>
                    onDraftChanged(draft.copyWith(isRequired: value ?? false)),
              ),
              Gaps.w4,
              Text(
                l10n.projectSettingsCustomFieldRequired,
                style: context.text.bodySmall?.copyWith(fontSize: 12.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.text.labelSmall?.copyWith(
      fontWeight: .w700,
      fontSize: 12,
      color: context.colors.onSurfaceVariant,
    ),
  );
}

class _FieldTypeMenuItem extends StatelessWidget {
  const _FieldTypeMenuItem({required this.type});

  final TaskCustomFieldType type;

  @override
  Widget build(BuildContext context) {
    final visual = CustomFieldTypeVisualCatalog.forType(type);
    return Row(
      children: [
        Icon(visual.icon, size: 16, color: visual.color),
        Gaps.w8,
        Text(
          visual.label,
          style: const TextStyle(fontSize: 12.5, fontWeight: .w600),
        ),
        Gaps.w8,
        Expanded(
          child: Text(
            visual.description,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomFieldFormDecoration {
  static InputDecoration name(BuildContext context) => InputDecoration(
    hintText: 'np. Budżet, Klient, Środowisko...',
    hintStyle: context.text.bodySmall?.copyWith(
      fontSize: 12.5,
      color: context.colors.onSurfaceVariant.withValues(alpha: .6),
    ),
    border: OutlineInputBorder(borderRadius: .circular(Sizes.p8)),
    contentPadding: const .symmetric(horizontal: 12, vertical: 10),
  );
}
