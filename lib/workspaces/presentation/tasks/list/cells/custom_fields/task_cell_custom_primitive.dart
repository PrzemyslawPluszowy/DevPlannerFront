import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_custom_field_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_text_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/task_context_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Komórka pól prostych (tekst, liczba, data, boolean, użytkownik) w tabeli.
class TaskCellCustomPrimitive extends StatelessWidget {
  const TaskCellCustomPrimitive({
    required this.field,
    required this.value,
    required this.profiles,
    super.key,
    this.onChanged,
  });

  /// Definicja pola niestandardowego.
  final TaskCustomFieldResponse field;

  /// Wartość pola w zadaniu.
  final Object? value;

  /// Słownik profili członków projektu do wyświetlania pól typu user.
  final Map<String, ProjectMemberProfile> profiles;

  /// Callback wywoływany przy zmianie wartości pola.
  final Future<bool> Function(TaskCustomFieldResponse field, Object? value)?
  onChanged;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (cellContext) => SizedBox(
      width: TaskListGrid.customField,
      child: InkWell(
        onTap: onChanged == null
            ? null
            : () => unawaited(_editValue(cellContext)),
        child: Padding(
          padding: const .symmetric(horizontal: 10),
          child: Align(
            alignment: field.type == TaskCustomFieldType.number
                ? .centerRight
                : .centerLeft,
            child: _buildContent(context),
          ),
        ),
      ),
    ),
  );

  Widget _buildContent(BuildContext context) {
    if (value == null) {
      return Text(
        '—',
        style: context.text.labelMedium?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      );
    }

    return switch (field.type) {
      TaskCustomFieldType.boolean => _buildBoolean(context),
      TaskCustomFieldType.date => _buildDate(context),
      TaskCustomFieldType.user => _buildUser(context),
      TaskCustomFieldType.number ||
      TaskCustomFieldType.text => _buildText(context),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildBoolean(BuildContext context) {
    final isTrue = value == true || value.toString().toLowerCase() == 'true';
    return Row(
      mainAxisSize: .min,
      children: [
        Icon(
          isTrue ? Symbols.check_circle_rounded : Symbols.cancel,
          size: 16,
          color: isTrue ? const Color(0xFF16803C) : context.colors.outline,
        ),
        const SizedBox(width: 6),
        Text(isTrue ? 'Tak' : 'Nie', style: context.text.labelMedium),
      ],
    );
  }

  Widget _buildDate(BuildContext context) {
    final rawValue = value;
    final date = rawValue is DateTime
        ? rawValue
        : DateTime.tryParse('$rawValue');

    if (date == null) return _buildText(context);

    return Row(
      mainAxisSize: .min,
      children: [
        Icon(
          Symbols.event,
          size: 15,
          color: context.colors.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            DateFormat.yMMMd(
              Localizations.localeOf(context).toLanguageTag(),
            ).format(date.toLocal()),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildUser(BuildContext context) {
    final id = value.toString();
    final profile = profiles[id];
    final label = profile?.displayName?.trim().isNotEmpty == true
        ? profile!.displayName!.trim()
        : id;

    return Row(
      mainAxisSize: .min,
      children: [
        Icon(
          Symbols.person_rounded,
          size: 15,
          color: context.colors.primary,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildText(BuildContext context) {
    final textVal = value?.toString() ?? '';
    return Text(
      textVal.isNotEmpty ? textVal : '—',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.text.labelMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: textVal.isNotEmpty
            ? context.colors.onSurface
            : context.colors.onSurfaceVariant,
      ),
    );
  }

  Future<void> _editValue(BuildContext context) async {
    final menuPos = TaskContextMenu.positionFor(context);

    if (field.type == TaskCustomFieldType.boolean) {
      final res = await TaskCustomFieldPicker.pickBoolean(
        context,
        field: field,
        value: value,
        menuPosition: menuPos,
      );
      if (res == customFieldCancelled || onChanged == null) return;
      await onChanged!(field, res);
      return;
    }

    if (field.type == TaskCustomFieldType.user) {
      final items = <PopupMenuEntry<Object?>>[
        for (final profile in profiles.values)
          TaskContextMenuItem<Object?>(
            value: profile.userId,
            title: profile.displayName?.trim().isNotEmpty == true
                ? profile.displayName!.trim()
                : profile.userId,
            icon: Symbols.person_rounded,
            isSelected: value?.toString() == profile.userId,
          ),
        if (!field.isRequired && value != null) ...[
          const TaskContextMenuDivider(),
          TaskContextMenuItem<Object?>(
            value: customFieldClear,
            title: 'Wyczyść',
            icon: Symbols.close_rounded,
            iconColor: context.colors.error,
          ),
        ],
      ];

      final selected = await TaskContextMenu.show<Object?>(
        context,
        position: menuPos,
        items: items,
      );
      if (selected == null || onChanged == null) return;
      await onChanged!(field, selected == customFieldClear ? null : selected);
      return;
    }

    // Dla pól tekstowych i liczbowych otwieramy modalny edytor
    final answer = await AnchoredTextEditor.edit(
      context,
      title: field.name,
      isNumber: field.type == TaskCustomFieldType.number,
      initialValue: value?.toString() ?? '',
      menuPosition: menuPos,
      allowClear: !field.isRequired,
    );
    if (answer == null || onChanged == null) return;
    if (answer.isEmpty && !field.isRequired) {
      await onChanged!(field, null);
    } else {
      await onChanged!(field, answer);
    }
  }
}
