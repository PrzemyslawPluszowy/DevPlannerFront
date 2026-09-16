import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_type_visual.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';

/// Modal tworzenia lub edycji definicji pola niestandardowego w projekcie.
class CreateCustomFieldDialog extends StatefulWidget {
  const CreateCustomFieldDialog({
    this.initialField,
    super.key,
  });

  /// Pole do edycji lub null przy tworzeniu nowego.
  final TaskCustomFieldResponse? initialField;

  @override
  State<CreateCustomFieldDialog> createState() =>
      _CreateCustomFieldDialogState();
}

class _CreateCustomFieldDialogState extends State<CreateCustomFieldDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _newOptionController;
  late final List<CustomFieldOption> _options;
  late TaskCustomFieldType _selectedType;
  late bool _isRequired;

  String? _selectedColorHex;
  String? _selectedIconName;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialField?.name ?? '',
    );
    _newOptionController = TextEditingController();
    _options = (widget.initialField?.options ?? const <String>[])
        .map(CustomFieldOption.fromRaw)
        .toList();
    _selectedType = widget.initialField?.type ?? TaskCustomFieldType.text;
    _isRequired = widget.initialField?.isRequired ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _newOptionController.dispose();
    super.dispose();
  }

  bool get _needsOptions =>
      _selectedType == TaskCustomFieldType.singleSelect ||
      _selectedType == TaskCustomFieldType.multiSelect;

  void _addOption() {
    final text = _newOptionController.text.trim();
    if (text.isEmpty) return;

    // Obsługa wklejania wielu wartości rozdzielonych przecinkiem lub nową linią.
    final splitted = text
        .split(RegExp(r'[,;\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);

    setState(() {
      for (final item in splitted) {
        if (!_options.any((o) => o.label.toLowerCase() == item.toLowerCase())) {
          _options.add(
            CustomFieldOption.create(
              label: item,
              colorHex: _selectedColorHex,
              iconName: _selectedIconName,
            ),
          );
        }
      }
      _newOptionController.clear();
    });
  }

  void _removeOption(int index) {
    if (index >= 0 && index < _options.length) {
      setState(() {
        _options.removeAt(index);
      });
    }
  }

  void _moveOption(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= _options.length ||
        newIndex < 0 ||
        newIndex >= _options.length ||
        oldIndex == newIndex) {
      return;
    }
    setState(() {
      final item = _options.removeAt(oldIndex);
      _options.insert(newIndex, item);
    });
  }

  void _updateOptionColor(int index, String? hex) {
    setState(() {
      _options[index] = _options[index].copyWith(
        colorHex: hex,
        clearColor: hex == null,
      );
    });
  }

  void _updateOptionIcon(int index, String? iconName) {
    setState(() {
      _options[index] = _options[index].copyWith(
        iconName: iconName,
        clearIcon: iconName == null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isEditing = widget.initialField != null;

    return WorkspaceCreationModalWrapper(
      maxWidth: 540,
      title: isEditing
          ? 'Edytuj pole niestandardowe'
          : l10n.projectSettingsAddCustomField,
      subtitle:
          'Skonfiguruj nazwę, typ danych oraz opcje dodatkowego pola zadania.',
      icon: Symbols.tune_rounded,
      submitLabel: l10n.tasksListSaveButton,
      cancelLabel: l10n.tasksListCancelButton,
      onSubmit: _handleSubmit,
      body: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.projectSettingsCustomFieldName,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h6,
          TextField(
            controller: _nameController,
            autofocus: true,
            style: context.text.bodySmall?.copyWith(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'np. Budżet, Klient, Środowisko...',
              hintStyle: context.text.bodySmall?.copyWith(
                fontSize: 12.5,
                color: colors.onSurfaceVariant.withValues(alpha: .6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          Gaps.h16,
          Text(
            l10n.projectSettingsCustomFieldType,
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
              child: DropdownButton<TaskCustomFieldType>(
                value: _selectedType,
                isExpanded: true,
                dropdownColor: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                elevation: 3,
                menuMaxHeight: 320,
                icon: const Icon(Symbols.keyboard_arrow_down_rounded, size: 18),
                selectedItemBuilder: (context) => [
                  for (final type in TaskCustomFieldType.values)
                    _buildSelectedDropdownItem(customFieldTypeVisual(type)),
                ],
                items: [
                  for (final type in TaskCustomFieldType.values)
                    DropdownMenuItem(
                      value: type,
                      child: _buildDropdownItemRow(
                        customFieldTypeVisual(type),
                        colors,
                      ),
                    ),
                ],
                onChanged: isEditing
                    ? null
                    : (val) {
                        if (val != null) setState(() => _selectedType = val);
                      },
              ),
            ),
          ),
          if (_needsOptions) ...[
            Gaps.h16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    l10n.projectSettingsCustomFieldOptions,
                    style: context.text.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_options.length} opcji (kolejność)',
                  style: context.text.labelSmall?.copyWith(
                    fontSize: 11,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            Gaps.h6,
            // Lista opcji z możliwością zmiany kolejności, edycji koloru i ikony
            if (_options.isNotEmpty) ...[
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  itemCount: _options.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: colors.outlineVariant.withValues(alpha: 0.25),
                  ),
                  itemBuilder: (ctx, index) {
                    final opt = _options[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_upward_rounded,
                              size: 14,
                            ),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 22,
                              height: 22,
                            ),
                            tooltip: 'Przesuń wyżej',
                            onPressed: index > 0
                                ? () => _moveOption(index, index - 1)
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_downward_rounded,
                              size: 14,
                            ),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 22,
                              height: 22,
                            ),
                            tooltip: 'Przesuń niżej',
                            onPressed: index < _options.length - 1
                                ? () => _moveOption(index, index + 1)
                                : null,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CustomFieldOptionChip(
                                option: opt,
                                compact: true,
                              ),
                            ),
                          ),
                          _buildOptionColorButton(opt, index, colors),
                          _buildOptionIconButton(opt, index, colors),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 14),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 24,
                              height: 24,
                            ),
                            tooltip: 'Usuń opcję',
                            onPressed: () => _removeOption(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Gaps.h8,
            ],
            // Wiersz wprowadzania nowej opcji wraz z wyborem koloru i ikony
            Row(
              children: [
                _buildNewOptionColorPicker(colors),
                const SizedBox(width: 6),
                _buildNewOptionIconPicker(colors),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: _newOptionController,
                    style: context.text.bodySmall?.copyWith(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Nazwa opcji (np. Wysoki, Pilne)...',
                      hintStyle: context.text.bodySmall?.copyWith(
                        fontSize: 12,
                        color: colors.onSurfaceVariant.withValues(alpha: .6),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colors.outlineVariant.withValues(alpha: 0.7),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _addOption(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: _addOption,
                  icon: const Icon(Symbols.add_rounded, size: 15),
                  label: const Text('Dodaj', style: TextStyle(fontSize: 12)),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
          Gaps.h12,
          InkWell(
            onTap: () => setState(() => _isRequired = !_isRequired),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _isRequired,
                      onChanged: (val) =>
                          setState(() => _isRequired = val ?? false),
                    ),
                  ),
                  Gaps.w8,
                  Text(
                    l10n.projectSettingsCustomFieldRequired,
                    style: context.text.bodySmall?.copyWith(fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewOptionColorPicker(ColorScheme colors) {
    final currentColor = parseHexColor(_selectedColorHex);
    return PopupMenuButton<String?>(
      tooltip: 'Wybierz kolor nowej opcji',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (ctx) => [
        const PopupMenuItem<String?>(
          height: 32,
          child: Row(
            children: [
              Icon(Symbols.format_color_reset_rounded, size: 16),
              SizedBox(width: 8),
              Text('Domyślny kolor', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        for (final (hex, name, color) in customFieldOptionColors)
          PopupMenuItem<String?>(
            value: hex,
            height: 32,
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
      ],
      onSelected: (hex) => setState(() => _selectedColorHex = hex),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color:
              currentColor?.withValues(alpha: 0.18) ??
              colors.surfaceContainerHigh,
          shape: BoxShape.circle,
          border: Border.all(
            color: currentColor ?? colors.outlineVariant,
            width: currentColor != null ? 1.5 : 1,
          ),
        ),
        child: Icon(
          Symbols.palette_rounded,
          size: 16,
          color: currentColor ?? colors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildNewOptionIconPicker(ColorScheme colors) {
    final currentIcon = customFieldOptionIcon(_selectedIconName);
    return PopupMenuButton<String?>(
      tooltip: 'Wybierz ikonę nowej opcji',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (ctx) => [
        const PopupMenuItem<String?>(
          height: 32,
          child: Row(
            children: [
              Icon(Symbols.block_rounded, size: 16),
              SizedBox(width: 8),
              Text('Bez ikony', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        for (final (name, label, icon) in customFieldOptionIcons)
          PopupMenuItem<String?>(
            value: name,
            height: 32,
            child: Row(
              children: [
                Icon(icon, size: 16),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
      ],
      onSelected: (name) => setState(() => _selectedIconName = name),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedIconName != null
                ? colors.primary
                : colors.outlineVariant,
            width: _selectedIconName != null ? 1.5 : 1,
          ),
        ),
        child: Icon(
          currentIcon ?? Symbols.category_rounded,
          size: 16,
          color: _selectedIconName != null
              ? colors.primary
              : colors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildOptionColorButton(
    CustomFieldOption opt,
    int index,
    ColorScheme colors,
  ) {
    final currentColor = opt.color;
    return PopupMenuButton<String?>(
      tooltip: 'Zmień kolor opcji',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (ctx) => [
        const PopupMenuItem<String?>(
          height: 32,
          child: Row(
            children: [
              Icon(Symbols.format_color_reset_rounded, size: 16),
              SizedBox(width: 8),
              Text('Domyślny kolor', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        for (final (hex, name, color) in customFieldOptionColors)
          PopupMenuItem<String?>(
            value: hex,
            height: 32,
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
      ],
      onSelected: (hex) => _updateOptionColor(index, hex),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: currentColor ?? colors.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: Border.all(
              color: currentColor != null
                  ? currentColor.withValues(alpha: 0.8)
                  : colors.outlineVariant,
            ),
          ),
          child: currentColor == null
              ? Icon(
                  Symbols.palette_rounded,
                  size: 11,
                  color: colors.onSurfaceVariant,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildOptionIconButton(
    CustomFieldOption opt,
    int index,
    ColorScheme colors,
  ) {
    final currentIcon = opt.icon;
    return PopupMenuButton<String?>(
      tooltip: 'Zmień ikonę opcji',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (ctx) => [
        const PopupMenuItem<String?>(
          height: 32,
          child: Row(
            children: [
              Icon(Symbols.block_rounded, size: 16),
              SizedBox(width: 8),
              Text('Bez ikony', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        for (final (name, label, icon) in customFieldOptionIcons)
          PopupMenuItem<String?>(
            value: name,
            height: 32,
            child: Row(
              children: [
                Icon(icon, size: 16),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
      ],
      onSelected: (name) => _updateOptionIcon(index, name),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Icon(
          currentIcon ?? Symbols.category_rounded,
          size: 16,
          color: currentIcon != null ? colors.primary : colors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildSelectedDropdownItem(CustomFieldTypeVisual visual) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: visual.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(visual.icon, size: 15, color: visual.color),
          ),
          const SizedBox(width: 8),
          Text(
            visual.label,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItemRow(
    CustomFieldTypeVisual visual,
    ColorScheme colors,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: visual.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(visual.icon, size: 15, color: visual.color),
        ),
        const SizedBox(width: 8),
        Text(
          visual.label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            visual.description,
            style: TextStyle(
              fontSize: 11.5,
              color: colors.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (_newOptionController.text.trim().isNotEmpty) {
      _addOption();
    }

    Navigator.of(context).pop((
      name: name,
      type: _selectedType,
      isRequired: _isRequired,
      options: _needsOptions ? _options.map((o) => o.raw).toList() : <String>[],
    ));
  }
}
