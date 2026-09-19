import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_custom_field_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/task_context_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Komórka wyboru pojedynczego lub wielokrotnego pola niestandardowego w tabeli.
///
/// Gwarantuje jednoliniowy układ komórki: pierwsza wybrana opcja jako kolorowy chip z ikoną,
/// a kolejne wartości reprezentowane jako zwięzły badge (+1, +2) z pełnym dymkiem (Tooltip).
class TaskCellCustomSelect extends StatelessWidget {
  const TaskCellCustomSelect({
    required this.field,
    required this.value,
    super.key,
    this.onChanged,
    this.canManage = false,
    this.onConfigureField,
  });

  /// Definicja pola niestandardowego zawierająca opcje, kolory i ikony.
  final TaskCustomFieldResponse field;

  /// Aktualna wartość pola w zadaniu (String lub `List<Object?>`).
  final Object? value;

  /// Callback wywoływany przy zmianie wartości pola.
  final Future<bool> Function(TaskCustomFieldResponse field, Object? value)?
  onChanged;

  /// Czy użytkownik posiada uprawnienia zarządcze w projekcie.
  final bool canManage;

  /// Callback konfiguracji pola.
  final VoidCallback? onConfigureField;

  @override
  Widget build(BuildContext context) {
    final values = _extractValues(value);

    return Builder(
      builder: (cellContext) => SizedBox(
        width: TaskListGrid.customField,
        child: InkWell(
          onTap: onChanged == null
              ? null
              : () => unawaited(_openPicker(cellContext)),
          child: Padding(
            padding: const .symmetric(horizontal: 10),
            child: Align(
              alignment: .centerLeft,
              child: values.isEmpty
                  ? TaskCellEmptyPlaceholder(
                      icon: Symbols.tune_rounded,
                      tooltip: onChanged != null ? 'Wybierz opcję' : null,
                      isInteractive: onChanged != null,
                    )
                  : _buildSelectedPills(context, values),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedPills(BuildContext context, List<String> values) {
    final tooltipMessage = values
        .map((v) => _resolveOption(v).label)
        .join(', ');

    if (values.length == 1) {
      return Tooltip(
        message: tooltipMessage,
        child: Row(
          mainAxisSize: .min,
          children: [
            Flexible(
              child: CustomFieldOptionChip(
                option: _resolveOption(values.first),
                compact: true,
              ),
            ),
          ],
        ),
      );
    }

    return Tooltip(
      message: tooltipMessage,
      child: Row(
        mainAxisSize: .min,
        children: [
          Flexible(
            child: CustomFieldOptionChip(
              option: _resolveOption(values.first),
              compact: true,
            ),
          ),
          const SizedBox(width: 4),
          _CustomFieldCountChip(label: '+${values.length - 1}'),
        ],
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final menuPos = TaskContextMenu.positionFor(context);
    final isMulti = field.type == TaskCustomFieldType.multiSelect;

    final result = isMulti
        ? await TaskCustomFieldPicker.pickMultiSelect(
            context,
            field: field,
            value: value,
            menuPosition: menuPos,
            canManage: canManage,
            onConfigureField: onConfigureField,
          )
        : await TaskCustomFieldPicker.pickSingleSelect(
            context,
            field: field,
            value: value,
            menuPosition: menuPos,
            canManage: canManage,
            onConfigureField: onConfigureField,
          );

    if (result == customFieldCancelled || onChanged == null) return;
    await onChanged!(field, result);
  }

  List<String> _extractValues(Object? raw) {
    if (raw == null) return const [];
    if (raw is List) {
      return raw
          .cast<Object?>()
          .where((e) => e != null && e.toString().trim().isNotEmpty)
          .map<String>((item) => item.toString())
          .toList(growable: false);
    }
    final str = raw.toString().trim();
    return str.isEmpty ? const [] : <String>[str];
  }

  CustomFieldOption _resolveOption(String rawVal) {
    for (final optRaw in field.options ?? const <String>[]) {
      final parsed = CustomFieldOption.fromRaw(optRaw);
      if (optRaw == rawVal ||
          parsed.label.toLowerCase() == rawVal.toLowerCase()) {
        return parsed;
      }
    }
    return CustomFieldOption.fromRaw(rawVal);
  }
}

class _CustomFieldCountChip extends StatelessWidget {
  const _CustomFieldCountChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Padding(
      padding: const .symmetric(horizontal: 6, vertical: 3),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.labelSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
  );
}
