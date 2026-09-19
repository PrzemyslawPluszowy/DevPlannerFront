import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/project_custom_field_option_pickers.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Kontrolki opcji dla pola typu pojedynczy albo wielokrotny wybór.
class ProjectCustomFieldOptionsEditor extends StatelessWidget {
  const ProjectCustomFieldOptionsEditor({
    required this.draft,
    required this.newOptionController,
    required this.onDraftChanged,
    required this.onAddOption,
    super.key,
  });

  final CustomFieldDraft draft;
  final TextEditingController newOptionController;
  final ValueChanged<CustomFieldDraft> onDraftChanged;
  final VoidCallback onAddOption;

  @override
  Widget build(BuildContext context) {
    if (!draft.needsOptions) return const SizedBox.shrink();
    final colors = context.colors;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Gaps.h16,
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              context.l10n.projectSettingsCustomFieldOptions,
              style: context.text.labelSmall?.copyWith(
                fontWeight: .w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Text(
              '${draft.options.length} opcji (kolejność)',
              style: context.text.labelSmall?.copyWith(
                fontSize: 11,
                color: colors.onSurfaceVariant.withValues(alpha: .7),
              ),
            ),
          ],
        ),
        Gaps.h6,
        if (draft.options.isNotEmpty) ...[
          _OptionList(draft: draft, onDraftChanged: onDraftChanged),
          Gaps.h8,
        ],
        _NewOptionRow(
          draft: draft,
          controller: newOptionController,
          onDraftChanged: onDraftChanged,
          onAdd: onAddOption,
        ),
      ],
    );
  }
}

class _OptionList extends StatelessWidget {
  const _OptionList({required this.draft, required this.onDraftChanged});

  final CustomFieldDraft draft;
  final ValueChanged<CustomFieldDraft> onDraftChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: .circular(Sizes.p8),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .5)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const .symmetric(horizontal: Sizes.p6, vertical: Sizes.p4),
        itemCount: draft.options.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: colors.outlineVariant.withValues(alpha: .25),
        ),
        itemBuilder: (_, index) => _OptionRow(
          option: draft.options[index],
          index: index,
          optionsCount: draft.options.length,
          onMove: (target) => _move(index, target),
          onDelete: () => _remove(index),
          onColorChanged: (color) => _replace(
            index,
            draft.options[index].copyWith(
              colorHex: color,
              clearColor: color == null,
            ),
          ),
          onIconChanged: (icon) => _replace(
            index,
            draft.options[index].copyWith(
              iconName: icon,
              clearIcon: icon == null,
            ),
          ),
        ),
      ),
    );
  }

  void _move(int from, int target) {
    final options = List<CustomFieldOption>.of(draft.options);
    final option = options.removeAt(from);
    options.insert(target, option);
    onDraftChanged(draft.copyWith(options: options));
  }

  void _remove(int index) {
    final options = List<CustomFieldOption>.of(draft.options)..removeAt(index);
    onDraftChanged(draft.copyWith(options: options));
  }

  void _replace(int index, CustomFieldOption option) {
    final options = List<CustomFieldOption>.of(draft.options);
    options[index] = option;
    onDraftChanged(draft.copyWith(options: options));
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.option,
    required this.index,
    required this.optionsCount,
    required this.onMove,
    required this.onDelete,
    required this.onColorChanged,
    required this.onIconChanged,
  });

  final CustomFieldOption option;
  final int index;
  final int optionsCount;
  final ValueChanged<int> onMove;
  final VoidCallback onDelete;
  final ValueChanged<String?> onColorChanged;
  final ValueChanged<String?> onIconChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .symmetric(vertical: Sizes.p2),
    child: Row(
      children: [
        _MoveButton(
          icon: Icons.arrow_upward_rounded,
          tooltip: 'Przesuń wyżej',
          onPressed: index > 0 ? () => onMove(index - 1) : null,
        ),
        _MoveButton(
          icon: Icons.arrow_downward_rounded,
          tooltip: 'Przesuń niżej',
          onPressed: index < optionsCount - 1 ? () => onMove(index + 1) : null,
        ),
        Gaps.w4,
        Expanded(child: CustomFieldOptionChip(option: option, compact: true)),
        ProjectCustomFieldColorPicker(
          value: option.colorHex,
          onSelected: onColorChanged,
          compact: true,
        ),
        ProjectCustomFieldIconPicker(
          value: option.iconName,
          onSelected: onIconChanged,
          compact: true,
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, size: 14),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 24, height: 24),
          tooltip: 'Usuń opcję',
          onPressed: onDelete,
        ),
      ],
    ),
  );
}

class _MoveButton extends StatelessWidget {
  const _MoveButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    icon: Icon(icon, size: 14),
    visualDensity: VisualDensity.compact,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints.tightFor(width: 22, height: 22),
    tooltip: tooltip,
    onPressed: onPressed,
  );
}

class _NewOptionRow extends StatelessWidget {
  const _NewOptionRow({
    required this.draft,
    required this.controller,
    required this.onDraftChanged,
    required this.onAdd,
  });

  final CustomFieldDraft draft;
  final TextEditingController controller;
  final ValueChanged<CustomFieldDraft> onDraftChanged;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      ProjectCustomFieldColorPicker(
        value: draft.selectedColorHex,
        onSelected: (color) => onDraftChanged(
          draft.copyWith(
            selectedColorHex: color,
            clearSelectedColorHex: color == null,
          ),
        ),
      ),
      Gaps.w6,
      ProjectCustomFieldIconPicker(
        value: draft.selectedIconName,
        onSelected: (icon) => onDraftChanged(
          draft.copyWith(
            selectedIconName: icon,
            clearSelectedIconName: icon == null,
          ),
        ),
      ),
      Gaps.w6,
      Expanded(
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nazwa opcji (np. Wysoki, Pilne)...',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          onSubmitted: (_) => onAdd(),
        ),
      ),
      Gaps.w8,
      FilledButton.tonalIcon(
        onPressed: onAdd,
        icon: const Icon(Symbols.add_rounded, size: 15),
        label: const Text('Dodaj', style: TextStyle(fontSize: 12)),
      ),
    ],
  );
}
